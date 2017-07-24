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

    SEGTrackPayload *track =(SEGTrackPayload *)context.payload;
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

        NSDictionary *attributionContext = @{
            @"campaign" : @{
                @"source" : @"iAd",
                @"name" : attributionInfo[@"iad-campaign-name"] ?: @"unknown",
                @"content" : attributionInfo[@"iad-keyword"] ?: @"unknown",
                @"ad_creative" : attributionInfo[@"iad-org-name"] ?: @"unknown",
                @"ad_group" : attributionInfo[@"iad-adgroup-name"] ?: @"unknown",
                @"id" : attributionInfo[@"iad-campaign-id"] ?: @"unknown",
                @"ad_group_id" : attributionInfo[@"iad-adgroup-id"] ?: @"unknown",
                @"provider" : @"Apple",
                @"click_date" : attributionInfo[@"iad-click-date"] ?: @"unknown",
                @"conversion_date" : attributionInfo[@"iad-conversion-date"] ?: @"unknown"
            }
        };

        NSMutableDictionary *mergeContext = [NSMutableDictionary dictionaryWithCapacity:attributionContext.count + track.context.count];
        [mergeContext addEntriesFromDictionary:attributionContext];
        [mergeContext addEntriesFromDictionary:track.context];
        
        SEGContext *newContext = [context modify:^(id<SEGMutableContext> _Nonnull ctx) {
            ctx.payload = [[SEGTrackPayload alloc] initWithEvent:track.event
                                                      properties:track.properties
                                                         context:mergeContext
                                                    integrations:track.integrations];
        }];

        next(newContext);
    }];
}

@end
