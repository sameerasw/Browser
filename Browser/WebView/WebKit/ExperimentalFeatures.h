//
//  ExperimentalFeatures.h
//  Browser
//
//  Created by Leonardo Larrañaga on 2/12/25.
//

#ifndef ExperimentalFeatures_h
#define ExperimentalFeatures_h

#import <Foundation/Foundation.h>
#import <WebKit/WKPreferencesPrivate.h>
#import <WebKit/_WKExperimentalFeature.h>
#import <WebKit/_WKFeature.h>

#import <Foundation/Foundation.h>
#import <WebKit/WKPreferencesPrivate.h>
#import <WebKit/_WKExperimentalFeature.h>

@interface ExperimentalFeatures : NSObject

+ (NSArray<_WKExperimentalFeature *> *)getExperimentalFeatures;
+ (void)toggleExperimentalFeature:(NSString *)featureKey enabled:(BOOL)enabled preferences:(WKPreferences *)preferences;

@end

#endif /* ExperimentalFeatures_h */
