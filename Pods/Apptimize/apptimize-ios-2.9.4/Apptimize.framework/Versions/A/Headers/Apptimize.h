//
//  Apptimize.h
//  Apptimize (v2.9.4)
//
//  Copyright (c) 2014 Apptimize, Inc. All rights reserved.
//

/*
 Getting Started:
 
 Add your Apptimize App Key to your application's Info.plist e.g.
 ApptimizeAppKey = "AaaaABbbbBCcccCDdddDEeeeEFfffF" // Type: String; Without quotes.
 
 For more information on how to get started using the Apptimize Library see:
 http://apptimize.com/docs/getting-started-ios/step-1-installation-ios/
 */

#import <Availability.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_1
#error "The Apptimize library uses features only available in iOS SDK 5.1 and later."
#endif

#ifndef APPTIMIZE_EXTERN
#define APPTIMIZE_VISIBLE __attribute__((visibility("default")))
#define APPTIMIZE_EXTERN APPTIMIZE_VISIBLE extern
#endif


// Options for runExperiment:withBaseline:variations:options:
APPTIMIZE_EXTERN NSString *const ApptimizeUpdateMetadataTimeoutOption; // @(0) blocks until metadata is available, @(N) blocks for up-to N milliseconds. If this option is omitted, we will not block for metadata.

// Levels for setLogLevel:
APPTIMIZE_EXTERN NSString *const ApptimizeLogLevelVerbose;
APPTIMIZE_EXTERN NSString *const ApptimizeLogLevelDebug;
APPTIMIZE_EXTERN NSString *const ApptimizeLogLevelInfo;
APPTIMIZE_EXTERN NSString *const ApptimizeLogLevelWarn;
APPTIMIZE_EXTERN NSString *const ApptimizeLogLevelError;
APPTIMIZE_EXTERN NSString *const ApptimizeLogLevelOff; // default

/*
 This option controls whether Apptimize will attempt to pair with the development server.
 Info.plist: ApptimizeDevicePairingEnabled (Boolean, default YES)
 */
APPTIMIZE_EXTERN NSString *const ApptimizeDevicePairingOption;

/*
 This option controls the verbosity of the Apptimize library.
 Info.plist: ApptimizeLogLevel (String, [verbose, debug, info, warn, error, off], default "error")
 */
APPTIMIZE_EXTERN NSString *const ApptimizeLogLevelOption;

/*
 This option controls how long (in milliseconds) Apptimize will wait for tests and their associated data to download.
 Info.plist: ApptimizeDelayUntilTestsAreAvailable (Number, milliseconds, default 0)
 */
APPTIMIZE_EXTERN NSString *const ApptimizeDelayUntilTestsAreAvailableOption;

/*
 This option controls whether Apptimize will automatically import events from third-party analytics frameworks.
 Info.plist: ApptimizeEnableThirdPartyEventImporting (Boolean, default YES)
 */
APPTIMIZE_EXTERN NSString *const ApptimizeEnableThirdPartyEventImportingOption;

/*
 This option governs whether Apptimize will automatically log events for button clicks and table cell activations.
 Info.plist: ApptimizeEnableInteractionEventCollection (Boolean, default NO)
 */
APPTIMIZE_EXTERN NSString *const ApptimizeEnableInteractionEventCollectionOption;

/*
 * This notification is posted whenever an Apptimize test runs.
 *
 * The userInfo dictionary for this notification contains the following keys and values:
 * ApptimizeTestNameUserInfoKey     - The name of the test that caused this notification (NSString *)
 * ApptimizeVariantNameUserInfoKey  - The name of the variant that caused this notification (NSString *)
 * ApptimizeTestFirstRunUserInfoKey - Whether this is the first time Apptimize has run this variant during this session (NSNumber *, BOOL)
 */
APPTIMIZE_EXTERN NSString *const ApptimizeTestRunNotification;
APPTIMIZE_EXTERN NSString *const ApptimizeTestNameUserInfoKey;
APPTIMIZE_EXTERN NSString *const ApptimizeVariantNameUserInfoKey;
APPTIMIZE_EXTERN NSString *const ApptimizeTestFirstRunUserInfoKey;


APPTIMIZE_VISIBLE @interface Apptimize : NSObject

/**
 Start Apptimize with the default options.
 @see startApptimizeWithApplicationKey:options:
 */
+ (void)startApptimizeWithApplicationKey:(NSString *)applicationKey;

/**
 Start apptimize with the provided options, where options is a dictionary
 containing ApptimizeDevicePairingOption or ApptimizeLogLevelOption
 and their respective values.
 */
+ (void)startApptimizeWithApplicationKey:(NSString *)applicationKey options:(NSDictionary *)options;

/**
 Run a test. Either the baseline or one of the variation blocks will be called synchronously exactly once
 per call. To run a test, set it up at https://apptimize.com/admin/ and then copy and paste the
 provided code template into your code to use this.
 */
+ (void)runTest:(NSString *)testName withBaseline:(void (^)(void))baselineBlock variations:(NSDictionary *)variations andOptions:(NSDictionary *)options;

/**
 Same as runExperiment:withBaseline:variations:options: passing nil for options.
 @see runExperiment:withBaseline:variations:options:
 */
+ (void)runTest:(NSString *)testName withBaseline:(void (^)(void))baselineBlock andVariations:(NSDictionary *)variations;

/**
 Track an event
 */
+ (void)track:(NSString *)eventName;

/**
 Track an event with an associated numeric value.
 */
+ (void)track:(NSString *)eventName value:(double)value;

/**
 Set the log level of the Apptimize library.
 */
+ (void)setLogLevel:(NSString *)logLevel;

/**
 @return Returns the version number of the Apptimize library in this form: major.minor.build (e.g., 1.2.0)
 */
+ (NSString *)libraryVersion;

/**
 @return Returns the ID used by Apptimize to uniquely identify users of the current app
 */
+ (NSString *)userID;

/**
 * Returns information about all Apptimize A/B tests that this device is
 * enrolled in. Note that this does NOT include information about Apptimize
 * A/B tests that are running but that this device is not enrolled in.
 *
 * @return The NSDictionary whose keys are the names of all tests the device is enrolled in, and whose values are ApptimizeTestInfo objects containing information about the test
 */
+ (NSDictionary *)testInfo;

/**
 Wait for the initial set of tests to become available. This method will block for `timeout` milliseconds (up to 8000) while Apptimize attempts to fetch tests and any related assets. It is meant to be used as part of application initialization, usually during a loading screen.
 */
+ (BOOL)waitForTestsToBecomeAvailable:(NSTimeInterval)timeout;

@end


/*
 User Attributes for Targeting, Filtering and Segmentation.
 
 Attributes will be uploaded with your data so you can filter and segment on them in the Apptimize
 results browser. You can also use them to target users via the Apptimize front-end. If you want to 
 do targeting of users based on these attributes, you should ideally set your attributes before 
 returning from application:didFinishLaunchingWithOptions:
 */
@interface Apptimize (UserAttributes)

/** @name User Attributes */
/**
 Set an NSString user attribute to be used for targeting, filtering and segmentation.
 */
+ (void)setUserAttributeString:(NSString *)attributeValue forKey:(NSString *)attributeName;

/**
 Set an NSInteger user attribute to be used in targeting, filtering and segmentation.
 */
+ (void)setUserAttributeInteger:(NSInteger)attributeValue forKey:(NSString *)attributeName;

/**
 Set a double user attribute to be used for targeting, filtering and segmentation.
 */
+ (void)setUserAttributeDouble:(double)attributeValue forKey:(NSString *)attributeName;

/**
 Remove the user defined attribute for a given for key.
 */
+ (void)removeUserAttributeForKey:(NSString *)attributeName;

/**
 Remove all user defined attributes.
 */
+ (void)removeAllUserAttributes;

/**
 Get the currently set NSString user attribute for a given key.
 */
+ (NSString *)userAttributeStringForKey:(NSString *)attributeName;

/**
 Get the current NSInteger user attribute for a given key.
 */
+ (NSInteger)userAttributeIntegerForKey:(NSString *)attributeName;

/**
 Get the current double user attribute for a given key.
 */
+ (double)userAttributeDoubleForKey:(NSString *)attributeName;

@end

@interface Apptimize (ViewAttributes)

/** @name View Attributes */
/**
 Set an attribute on a view to a value. Apptimize will use these attributes to gather more information about views for visual editing.
 */
+ (void)setValue:(NSString *)value forAttribute:(NSString *)attributeName onView:(UIView *)view;

@end

/** @name Test Information */
/**
 * Information about a single A/B test this device is enrolled in
 */
@protocol ApptimizeTestInfo <NSObject>
/**
 * @return The name of the Apptimize A/B test
 */
- (NSString *)testName;

/**
 * The name of the variant of this test that this device is enrolled in
 */
- (NSString *)enrolledVariantName;

/**
 * Returns the date this Apptimize test was started. Note
 * that this is the time as reported by Apptimize's servers and is not
 * affected by changes in the device's clock.
 *
 * @return The date this Apptimize test was started
 */
- (NSDate *)testStartedDate;

/**
 * Returns the datethis device was enrolled into this A/B
 * test. Note that unlike the return value for testStartedDate
 * this is the time as reported by the device, and not the time as
 * reported by Apptimize's server. This difference is relevant if the
 * device's clock is inaccurate.
 *
 * @return The date this device was enrolled into this A/B test
 */
- (NSDate *)testEnrolledDate;
@end

// Include compatibility aliases and deprecated methods, these should not be used in new code.
#import "Apptimize+Compatibility.h"

#import "Apptimize+Variables.h"

