# Analytics-iAds-Attribution

[![Version](https://img.shields.io/cocoapods/v/Analytics-iAds-Attribution.svg?style=flat)](http://cocoapods.org/pods/Analytics-iAds-Attribution)
[![License](https://img.shields.io/cocoapods/l/Analytics-iAds-Attribution.svg?style=flat)](http://cocoapods.org/pods/Analytics-iAds-Attribution)
[![Platform](https://img.shields.io/cocoapods/p/Analytics-iAds-Attribution.svg?style=flat)](http://cocoapods.org/pods/Analytics-iAds-Attribution)

Records [iAd attribution information](http://searchads.apple.com/help/measure-results/) using [analytics-ios](https://github.com/segmentio/analytics-ios).

When it is able to retrieve iAd information, it will send an `Application Installed` event using the [Segment mobile spec](https://segment.com/docs/spec/mobile/#application-installed). The attribution information is transformed to Segment properties
this way:

```obj-c
[analytics track:@"Application Installed" properties:@{
    @"provider" : @"Apple",
    @"click_date" : attributionInfo[@"iad-click-date"],
    @"conversion_date" : attributionInfo[@"iad-conversion-date"],
    @"campaign" : @{
        @"source" : @"iAd",
        @"name" : attributionInfo[@"iad-campaign-name"],
        @"content" : attributionInfo[@"iad-keyword"],
        @"ad_creative" : attributionInfo[@"iad-org-name"],
        @"ad_group" : attributionInfo[@"iad-adgroup-name"],
        @"id" : attributionInfo[@"iad-campaign-id"],
        @"ad_group_id" : attributionInfo[@"iad-adgroup-id"]
    }
}];
```

https://cloudup.com/cVmP8uJI4XD

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

Analytics-iAds-Attribution is available through [CocoaPods](http://cocoapods.org). This pod requires version 3.6.0 or higher of the `Analytics` pod. To install it, simply add the following line to your Podfile:

```ruby
pod "Analytics"
pod "Analytics-iAds-Attribution"
```

```obj-c
#import <Analytics-iAds-Attribution/SEGADTracker.h>

// Initialize the configuration as you would normally.
// https://segment.com/segment-mobile/sources/ios/settings/keys
SEGAnalyticsConfiguration *configuration = [SEGAnalyticsConfiguration configurationWithWriteKey:@"YOUR_WRITE_KEY"];
...

// Configure the client to automatically track the 'Application Installed' event.
configuration.trackApplicationLifecycleEvents = YES;

// Configure the client with the iAD middleware to attach iAd properties.
configuration.middlewares = @[ [SEGADTracker middleware] ];

[SEGAnalytics setupWithConfiguration:configuration];
```

## Author

Segment.io, Inc., friends@segment.com

## License

Analytics-iAds-Attribution is available under the MIT license. See the LICENSE file for more info.
