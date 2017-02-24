#import "SEGADTracker.h"
#import <iAd/iAd.h>
#import <Analytics/SEGAnalyticsUtils.h>


@implementation SEGADTracker

+ (id<SEGMiddleware>)middleware
{
    return [[SEGADTracker alloc] init];
}

- (void)context:(SEGContext *_Nonnull)context next:(SEGMiddlewareNext _Nonnull)next
{
    if (context.eventType != SEGEventTypeTrack) {
        next(context);
        return;
    }

    if (![context.payload isKindOfClass:[SEGTrackPayload class]]) {
        next(context);
        return;
    }

    SEGTrackPayload *track = context.payload;
    if (![track.event isEqualToString:@"Application Installed"]) {
        next(context);
        return;
    }

    if (![[ADClient sharedClient] respondsToSelector:@selector(requestAttributionDetailsWithBlock:)]) {
        next(context);
        return;
    }

    [[ADClient sharedClient] requestAttributionDetailsWithBlock:^(NSDictionary *details, NSError *error) {
        if (error) {
            SEGLog(@"requestAttributionDetailsWithBlock returned error: %@", error);
            next(context);
            return;
        }

        NSDictionary *attributionInfo = details[@"Version3.1"];
        if (!attributionInfo) {
            SEGLog(@"no details for version 3.1: %@", details);
            next(context);
            return;
        }

        NSDictionary *attributionProperties = @{
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
        };

        NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithCapacity:attributionProperties.count + track.properties.count];
        [properties addEntriesFromDictionary:attributionProperties];
        [properties addEntriesFromDictionary:track.properties];

        SEGContext *newContext = [context modify:^(id<SEGMutableContext> _Nonnull ctx) {
            ctx.payload = [[SEGTrackPayload alloc] initWithEvent:track.event
                                                      properties:properties
                                                         context:track.context
                                                    integrations:track.integrations];
        }];

        next(newContext);
    }];
}

@end
