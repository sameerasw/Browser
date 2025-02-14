//
//  DeveloperFeatures.h
//  Browser
//
//  Created by Leonardo Larrañaga on 2/12/25.
//

#ifndef DeveloperFeatures_h
#define DeveloperFeatures_h

#import <WebKit/WebKit.h>

@interface DeveloperFeatures : NSObject

+ (void)toggleWebInspectorForWebView:(WKWebView *)webView;

@end

#endif /* DeveloperFeatures_h */
