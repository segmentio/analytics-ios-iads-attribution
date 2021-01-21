#import <Foundation/Foundation.h>

#if __has_include(<Analytics/SEGAnalytics.h>)
#import <Analytics/SEGMiddleware.h>
#else
#import <Segment/SEGMiddleware.h>
#endif

@interface SEGADTracker : NSObject <SEGMiddleware>

+ (id<SEGMiddleware>)middleware;

@end
