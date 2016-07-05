


#import "ASIHTTPRequest.h"
#import "NetStub.h"
#import "conf.h"

@implementation NetStub


+(id) data2json:(NSData*) data error:(NSError**) error {
    NSError *_error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&_error];
    if (_error) {
        *error = _error;
        return data;
    }
    return result;
}


+ (void) Get:(NSURL*) url
     timeOut:(int) timeout
   onSuccess:(SuccessHandler) successHandler
   onFailure:(FailureHandler) failureHanler {
    
    __block ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setTimeOutSeconds:timeout];
    [request setRequestMethod:@"GET"];
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    
    [request setCompletionBlock:^{
        NSError* error = nil;
        id data = [self data2json:request.responseData error:&error];
        successHandler(error, data);
        [request release];
    }];
    [request setFailedBlock:^{
        failureHanler(request.error);
        [request release];
    }];
    [request startAsynchronous];
}

@end


