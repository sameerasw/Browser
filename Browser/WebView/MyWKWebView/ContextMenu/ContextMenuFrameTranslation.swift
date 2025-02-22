//
//  ContextMenuFrameTranslation.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/21/25.
//

import WebKit

extension MyWKWebView {
    func translationMenuItem() -> NSMenuItem {
        let item = NSMenuItem(title: "Translate Using Google", action: nil, keyEquivalent: "")
        let menu = NSMenu(title: "Translate Using Google")
        item.submenu = menu
        
        let languages = [
            ("Amharic", "am"),
            ("Arabic", "ar"),
            ("Basque", "eu"),
            ("Bengali", "bn"),
            ("English (UK)", "en-GB"),
            ("Portuguese (Brazil)", "pt-BR"),
            ("Bulgarian", "bg"),
            ("Catalan", "ca"),
            ("Cherokee", "chr"),
            ("Croatian", "hr"),
            ("Czech", "cs"),
            ("Danish", "da"),
            ("Dutch", "nl"),
            ("English (US)", "en"),
            ("Estonian", "et"),
            ("Filipino", "fil"),
            ("Finnish", "fi"),
            ("French", "fr"),
            ("German", "de"),
            ("Greek", "el"),
            ("Gujarati", "gu"),
            ("Hebrew", "iw"),
            ("Hindi", "hi"),
            ("Hungarian", "hu"),
            ("Icelandic", "is"),
            ("Indonesian", "id"),
            ("Italian", "it"),
            ("Japanese", "ja"),
            ("Kannada", "kn"),
            ("Korean", "ko"),
            ("Latvian", "lv"),
            ("Lithuanian", "lt"),
            ("Malay", "ms"),
            ("Malayalam", "ml"),
            ("Marathi", "mr"),
            ("Norwegian", "no"),
            ("Polish", "pl"),
            ("Portuguese (Portugal)", "pt-PT"),
            ("Romanian", "ro"),
            ("Russian", "ru"),
            ("Serbian", "sr"),
            ("Chinese (PRC)", "zh-CN"),
            ("Slovak", "sk"),
            ("Slovenian", "sl"),
            ("Spanish", "es"),
            ("Swahili", "sw"),
            ("Swedish", "sv"),
            ("Tamil", "ta"),
            ("Telugu", "te"),
            ("Thai", "th"),
            ("Chinese (Taiwan)", "zh-TW"),
            ("Turkish", "tr"),
            ("Urdu", "ur"),
            ("Ukrainian", "uk"),
            ("Vietnamese", "vi"),
            ("Welsh", "cy")
        ]
        
        for language in languages {
            let item = NSMenuItem(title: language.0, action: #selector(translate(_:)), keyEquivalent: "")
            item.representedObject = language.1
            menu.addItem(item)
        }
        
        return item
    }
    
    @objc func translate(_ sender: NSMenuItem) {
        guard let languageCode = sender.representedObject as? String else { return }
        
        let getTextScript = """
            function getText() {
                const texts = [];
                const walker = document.createTreeWalker(
                    document.body,
                    NodeFilter.SHOW_TEXT,
                    {
                        acceptNode: function(node) {
                            // Skip if node is within a script, style, meta, or other technical tags
                            let parent = node.parentNode;
                            while (parent) {
                                const tag = parent.tagName ? parent.tagName.toLowerCase() : '';
                                if (['script', 'style', 'meta', 'link', 'noscript'].includes(tag)) {
                                    return NodeFilter.FILTER_REJECT;
                                }
                                parent = parent.parentNode;
                            }
                            
                            const trimmedText = node.textContent.trim();
                            
                            // Skip if text is empty, too short, or looks like HTML/CSS
                            if (!trimmedText || 
                                trimmedText.length <= 1 || 
                                trimmedText.startsWith('<') || 
                                trimmedText.includes('{') ||
                                trimmedText.includes('}') ||
                                /^[\\s<>{}\\/]+$/.test(trimmedText)) {
                                return NodeFilter.FILTER_REJECT;
                            }
                            
                            return NodeFilter.FILTER_ACCEPT;
                        }
                    },
                    false
                );
                
                let node;
                while (node = walker.nextNode()) {
                    const text = node.textContent.trim();
                    texts.push(text);
                }
                
                return texts;
            }
            getText();
        """
        
        evaluateJavaScript(getTextScript) { result, error in
            guard let texts = result as? [String] else { return }
            
            let api = URL(string: "https://translate-pa.googleapis.com/v1/translateHtml")!
            
            var request = URLRequest(url: api)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = [
                "Content-Type": "application/json+protobuf",
                "X-goog-api-key": "AIzaSyATBXajvzQLTDHEQbcpq0Ihe0vWDHmO520",
                "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.3 Safari/605.1.15 (Browser)",
                "Accept": "*/*",
                "Origin": "https://www.google.com",
            ]
            
            let requestBody = try? JSONSerialization.data(withJSONObject: [
                [texts, "auto", languageCode],
                "te_lib"
            ])
            request.httpBody = requestBody
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error {
                    return print("❌ Translation failed: \(error)")
                }
                guard let data = data else { return print("❌ Translation failed: \(error?.localizedDescription ?? "Unknown error")") }
                guard let json = try? JSONSerialization.jsonObject(with: data) as? [[Any]] else { return print("❌ Translation failed: Invalid JSON response") }
                guard let translatedTexts = json[0] as? [String] else { return print("❌ Translation failed: Invalid JSON structure: \(json)") }
                
                DispatchQueue.main.async {
                    let replaceScript = """
                        function replaceTexts(translations) {
                            const walker = document.createTreeWalker(
                                document.body,
                                NodeFilter.SHOW_TEXT, {
                                    acceptNode: function(node) {
                                        let parent = node.parentNode;
                                        while (parent) {
                                            const tag = parent.tagName ? parent.tagName.toLowerCase() : '';
                                            if (['script', 'style', 'meta', 'link', 'noscript'].includes(tag)) {
                                                return NodeFilter.FILTER_REJECT;
                                            }
                                            parent = parent.parentNode;
                                        }

                                        const trimmedText = node.textContent.trim();
                                        if (!trimmedText ||
                                            trimmedText.length <= 1 ||
                                            trimmedText.startsWith('<') ||
                                            trimmedText.includes('{') ||
                                            trimmedText.includes('}') ||
                                            /^[\\s<>{}\\/]+$/.test(trimmedText)) {
                                            return NodeFilter.FILTER_REJECT;
                                        }

                                        return NodeFilter.FILTER_ACCEPT;
                                    }
                                },
                                false
                            );

                            let node;
                            let index = 0;
                            while (node = walker.nextNode()) {
                                if (index < translations.length) {
                                    // Preserve original spacing
                                    const originalSpaceBefore = node.textContent.match(/^\\s*/)[0];
                                    const originalSpaceAfter = node.textContent.match(/\\s*$/)[0];
                                    node.textContent = originalSpaceBefore + translations[index] + originalSpaceAfter;
                                    index++;
                                }
                            }
                        }
                        replaceTexts(\(translatedTexts));
                        """
                    
                    self.evaluateJavaScript(replaceScript) { _, error in
                        if error == nil {
                            self.presentActionAlert?("Page Translated! Refresh To Revert", "translate")
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
}
