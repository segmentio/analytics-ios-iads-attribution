#import <Foundation/Foundation.h>
#import <Analytics/SEGMiddleware.h>


@interface SEGADTracker : NSObject <SEGMiddleware>

+ (id<SEGMiddleware>)middleware;

@end
