//
//  WKWebViewControllerWKScriptMessageHandler.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 3/24/25.
//
import WebKit

extension WKWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "hoverURL":
            handleHoverURL(message.body)
        case "middleClickLink":
            handleMiddleClickLink(message.body)
        default:
            break
        }
    }

    func addHoverURLListener() {
        guard let hoverURLListenerScriptURL = Bundle.main.url(forResource: "HoverURLListener", withExtension: "js"),
              let script = try? String(contentsOf: hoverURLListenerScriptURL, encoding: .utf8) else { return }

        let controller = configuration.userContentController

        controller.removeScriptMessageHandler(forName: "hoverURL")
        controller.add(self, name: "hoverURL")

        let scriptMessage = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        controller.addUserScript(scriptMessage)
    }

    func addMiddleClickLinkListener() {
        guard let middleClickScriptURL = Bundle.main.url(forResource: "MiddleClickLinkListener", withExtension: "js"),
              let script = try? String(contentsOf: middleClickScriptURL, encoding: .utf8) else { return }

        let controller = configuration.userContentController

        controller.removeScriptMessageHandler(forName: "middleClickLink")
        controller.add(self, name: "middleClickLink")

        let scriptMessage = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        controller.addUserScript(scriptMessage)
    }

    func handleHoverURL(_ body: Any) {
        guard let url = body as? String, !url.isEmpty else { return }
        self.coordinator.setHoverURL(to: url)
    }

    func handleMiddleClickLink(_ body: Any) {
        guard let urlString = body as? String, let url = URL(string: urlString) else { return }
        self.coordinator.openLinkInNewTabAction(url)
    }
}
