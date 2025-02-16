//
//  MediaControls.h
//  Browser
//
//  Created by Leonardo Larrañaga on 2/16/25.
//

#ifndef MediaControls_h
#define MediaControls_h

#import <WebKit/WKWebViewPrivate.h>

typedef NS_OPTIONS(NSInteger, WKMediaMutedState) {
    WKMediaNoneMuted = 0,
    WKMediaAudioMuted = 1 << 0,
    WKMediaCaptureDevicesMuted = 1 << 1,
};

@interface MediaControls : NSObject

+ (void)setPageMuted:(WKMediaMutedState)mutedState forWebView:(WKWebView *)webView;
+ (WKMediaMutedState)getPageMutedStateForWebView:(WKWebView *)webView;

+ (BOOL)hasActiveNowPlayingSessionForWebView:(WKWebView *)webView;

@end


#endif /* MediaControls_h */
