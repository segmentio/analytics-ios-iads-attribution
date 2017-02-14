# Analytics-iAds-Attribution

[![CI Status](http://img.shields.io/travis/segmentio/analytics-ios-iads-attribution.svg?style=flat)](https://travis-ci.org/segmentio/analytics-ios-iads-attribution)
[![Version](https://img.shields.io/cocoapods/v/Analytics-iAds-Attribution.svg?style=flat)](http://cocoapods.org/pods/Analytics-iAds-Attribution)
[![License](https://img.shields.io/cocoapods/l/Analytics-iAds-Attribution.svg?style=flat)](http://cocoapods.org/pods/Analytics-iAds-Attribution)
[![Platform](https://img.shields.io/cocoapods/p/Analytics-iAds-Attribution.svg?style=flat)](http://cocoapods.org/pods/Analytics-iAds-Attribution)

Records [iAd attribution information](http://searchads.apple.com/help/measure-results/) using [analytics-ios](https://github.com/segmentio/analytics-ios).

When it is able to retrieve iAd information, it will send an `Install Attributed` event using the [Segment mobile spec](https://segment.com/docs/spec/mobile/#install-attributed). The attribution information is transformed to Segment properties
this way:

```obj-c
[analytics track:@"Install Attributed" properties:@{
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

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

Analytics-iAds-Attribution is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Analytics-iAds-Attribution"
```

```obj-c
#import <Analytics-iAds-Attribution/SEGADTracker.h>

// Initialize the analytics client as you would normally.
// https://segment.com/segment-mobile/sources/ios/settings/keys
SEGAnalyticsConfiguration *configuration = [SEGAnalyticsConfiguration configurationWithWriteKey:@"<YOUR_WRITE_KEY>"];
[SEGAnalytics setupWithConfiguration:configuration];

// Instruct the tracker to record iAd attribution information your initialized client.
[SEGADTracker trackWithAnalytics:[SEGAnalytics sharedAnalytics]];
```

## Author

Segment.io, Inc., friends@segment.com

## License

Analytics-iAds-Attribution is available under the MIT license. See the LICENSE file for more info.
