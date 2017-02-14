# Analytics-iAds-Attribution

[![CI Status](http://img.shields.io/travis/segmentio/analytics-ios-iads-attribution.svg?style=flat)](https://travis-ci.org/segmentio/analytics-ios-iads-attribution)
[![Version](https://img.shields.io/cocoapods/v/Analytics-iAds-Attribution.svg?style=flat)](http://cocoapods.org/pods/Analytics-iAds-Attribution)
[![License](https://img.shields.io/cocoapods/l/Analytics-iAds-Attribution.svg?style=flat)](http://cocoapods.org/pods/Analytics-iAds-Attribution)
[![Platform](https://img.shields.io/cocoapods/p/Analytics-iAds-Attribution.svg?style=flat)](http://cocoapods.org/pods/Analytics-iAds-Attribution)

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

// Initialize the analytics client as normally.
// https://segment.com/segment-mobile/sources/ios/settings/keys
SEGAnalyticsConfiguration *configuration = [SEGAnalyticsConfiguration configurationWithWriteKey:@"H18ZaUENQGcg4t7mJnYt1XrgG5vNkULh"];
[SEGAnalytics setupWithConfiguration:configuration];

// Instruct the iAD tracker to use your initialized client.
[SEGADTracker trackWithAnalytics:[SEGAnalytics sharedAnalytics]];
```

## Author

Segment.io, Inc., friends@segment.com

## License

Analytics-iAds-Attribution is available under the MIT license. See the LICENSE file for more info.
