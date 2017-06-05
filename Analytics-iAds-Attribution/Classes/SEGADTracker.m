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

        // We're seeing cases where attributionInfo may contain nil fields, so we don't use the literal syntax.
        NSMutableDictionary *campaign = [NSMutableDictionary dictionary];
        [campaign setObject:@"iAd" forKey:@"source"];
        [campaign setObject:attributionInfo[@"iad-campaign-name"] forKey:@"name"];
        [campaign setObject:attributionInfo[@"iad-keyword"] forKey:@"content"];
        [campaign setObject:attributionInfo[@"iad-org-name"] forKey:@"ad_creative"];
        [campaign setObject:attributionInfo[@"iad-adgroup-name"] forKey:@"ad_group"];
        [campaign setObject:attributionInfo[@"iad-campaign-id"] forKey:@"id"];
        [campaign setObject:attributionInfo[@"iad-adgroup-id"] forKey:@"ad_group_id"];

        NSMutableDictionary *attributionProperties = [NSMutableDictionary dictionary];
        [attributionProperties setObject:@"Apple" forKey:@"provider"];
        [attributionProperties setObject:attributionInfo[@"iad-click-date"] forKey:@"click_date"];
        [attributionProperties setObject:attributionInfo[@"iad-conversion-date"] forKey:@"conversion_date"];
        [attributionProperties setObject:campaign forKey:@"campaign"];

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
