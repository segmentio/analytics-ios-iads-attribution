#import "SEGADTracker.h"
#import <iAd/iAd.h>
#import <Analytics/SEGAnalyticsUtils.h>


@implementation SEGADTracker

+ (void)trackWithAnalytics:(SEGAnalytics *)analytics
{
    if ([[ADClient sharedClient] respondsToSelector:@selector(requestAttributionDetailsWithBlock:)]) {
        [[ADClient sharedClient] requestAttributionDetailsWithBlock:^(NSDictionary *details, NSError *error) {
            if (error) {
                SEGLog(@"requestAttributionDetailsWithBlock returned error: %@", error);
                return;
            }

            NSDictionary *attributionInfo = details[@"Version3.1"];
            if (!attributionInfo) {
                SEGLog(@"no details for version 3.1: %@", details);
                return;
            }

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
        }];
    }
}

@end
