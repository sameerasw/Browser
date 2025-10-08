//
//  MiddleClickLinkListener.js
//  Browser
//
//  Created for middle click link opening functionality.
//

// Flag to prevent multiple middle click events
let middleClickHandled = false;

document.addEventListener('auxclick', (event) => {
    // auxclick event fires for middle mouse button (button 1)
    if (event.button === 1 && !middleClickHandled) {
        const target = event.target.closest('a');
        if (target && target.href) {
            // Prevent default middle click behavior
            event.preventDefault();
            event.stopPropagation();
            event.stopImmediatePropagation();
            
            // Set flag to prevent multiple triggers
            middleClickHandled = true;
            
            // Send message to Swift with the link URL
            window.webkit.messageHandlers.middleClickLink.postMessage(target.href);
            
            // Reset flag after a short delay
            setTimeout(() => {
                middleClickHandled = false;
            }, 100);
        }
    }
});