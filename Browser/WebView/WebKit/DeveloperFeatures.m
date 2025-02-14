//
//  DeveloperFeatures.m
//  Browser
//
//  Created by Leonardo Larrañaga on 2/12/25.
//

#import "DeveloperFeatures.h"
#import <WebKit/WKWebViewPrivate.h>
#import <WebKit/_WKInspector.h>

#pragma GCC diagnostic ignored "-Wundeclared-selector"

@implementation DeveloperFeatures

+ (void)toggleWebInspectorForWebView:(WKWebView *)webView {
    _WKInspector *inspector = [webView _inspector];
    if (inspector) {
        if ([inspector isVisible]) {
            [inspector hide];
        } else {
            [inspector show];
        }
    }
}

@end
