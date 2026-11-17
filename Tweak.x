#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PSUIPrefsListController : UIViewController
@end

static NSString *nsDomainString = @"com.nowme.setora";
static NSString *nsNotificationString = @"com.nowme.setora/preferences.changed";
static BOOL enabled;
static NSString *customTitle;
static NSString *textColorHex;

static id STRPreferenceValue(NSString *key) {
	CFPreferencesAppSynchronize((__bridge CFStringRef)nsDomainString);
	CFPropertyListRef value = CFPreferencesCopyAppValue((__bridge CFStringRef)key, (__bridge CFStringRef)nsDomainString);
	if (value) return CFBridgingRelease(value);

	NSDictionary *storedPreferences = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.nowme.setora.plist"];
	return storedPreferences[key];
}

static UIColor *STRColorFromHex(NSString *hex) {
	if (![hex isKindOfClass:[NSString class]]) return nil;
	NSString *value = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@"#" withString:@""];
	if (value.length != 6) return nil;
	unsigned int rgb = 0;
	if (![[NSScanner scannerWithString:value] scanHexInt:&rgb]) return nil;
	return [UIColor colorWithRed:((rgb >> 16) & 0xFF) / 255.0
		green:((rgb >> 8) & 0xFF) / 255.0
		blue:(rgb & 0xFF) / 255.0 alpha:1.0];
}

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	NSNumber *enabledValue = STRPreferenceValue(@"enabled");
	enabled = enabledValue ? [enabledValue boolValue] : YES;
	customTitle = STRPreferenceValue(@"customTitle");
	textColorHex = STRPreferenceValue(@"textColor");
}

%hook PSUIPrefsListController

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	if (!enabled || customTitle.length == 0) return;
	self.title = customTitle;
	self.navigationItem.title = customTitle;
}

%end

%hook UITableViewCell

- (void)layoutSubviews {
	%orig;
	if (!enabled) return;
	UIColor *color = STRColorFromHex(textColorHex);
	if (!color) return;
	self.textLabel.textColor = color;
	self.detailTextLabel.textColor = color;
}

%end

%ctor {
	notificationCallback(NULL, NULL, NULL, NULL, NULL);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (__bridge CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
}
