#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <Foundation/NSUserDefaults+Private.h>
#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>

static NSString * nsDomainString = @"com.nowme.setora";
static NSString * nsNotificationString = @"com.nowme.setora/preferences.changed";
static BOOL enabled;
static NSString *customTitle;
static NSString *textColorHex;

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
	NSNumber * enabledValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled" inDomain:nsDomainString];
	enabled = (enabledValue)? [enabledValue boolValue] : YES;
	customTitle = [[NSUserDefaults standardUserDefaults] objectForKey:@"customTitle" inDomain:nsDomainString];
	textColorHex = [[NSUserDefaults standardUserDefaults] objectForKey:@"textColor" inDomain:nsDomainString];
}

%hook PSListController

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	if (!enabled || customTitle.length == 0) return;
	if (self.navigationController.viewControllers.firstObject == self) {
		self.title = customTitle;
		self.navigationItem.title = customTitle;
	}
}

%end

%hook UITableViewCell

- (void)didMoveToWindow {
	%orig;
	if (!enabled || !self.window) return;
	UIColor *color = STRColorFromHex(textColorHex);
	if (!color) return;
	self.textLabel.textColor = color;
	self.detailTextLabel.textColor = color;
}

%end

%ctor {
	// Set variables on start up
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	// Register for 'PostNotification' notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);

	// Add any personal initializations

}
