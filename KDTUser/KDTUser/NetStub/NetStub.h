

#import <Foundation/Foundation.h>

typedef void(^SuccessHandler)(NSError *error, id json);
typedef void(^FailureHandler)(NSError *error);

@interface NetStub : NSObject

+ (void) Get:(NSURL*) url
     timeOut:(int) timeout
   onSuccess:(SuccessHandler) successHandler
   onFailure:(FailureHandler) failureHanler;

@end
