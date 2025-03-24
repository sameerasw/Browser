//
//  HoverURLListener.js
//  Browser
//
//  Created by Leonardo Larrañaga on 3/24/25.
//

document.addEventListener('mouseover', (event) => {
    const target = event.target.closest('a');
    if (target) {
        window.webkit.messageHandlers.hoverURL.postMessage(target.href)
    }
})