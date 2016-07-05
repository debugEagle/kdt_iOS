//
//  KDTLicenceManager.m
//
//
//  Created by wd on 16/5/11.
//
//

#import "KDTLicenceManager.h"
#import "ASIHTTPRequest.h"
#import "MobileGestalt.h"
#import "CommonCrypto/CommonDigest.h"
#import "LogManager.h"

@implementation KDTLicenceManager {
    NSDictionary* licence;
    NSString* uuid;
}

+(id) sharedInstance {
    static KDTLicenceManager* _manager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _manager = [[KDTLicenceManager alloc] init];
    });
    return _manager;
}

- (NSString *)md5HexDigest:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}


-(id) init {
    self = [super init];
    if (self) {
        NSString* str = (NSString*)MGCopyAnswer(kMGUniqueDeviceID);
        uuid = [[self md5HexDigest:str] copy];
    }
    return self;
}


static
id _hande(int code, NSDictionary* headers, NSData* data) {
    if (!data || ![data isKindOfClass: [NSData class]])
        return @{};
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (!error && [result isKindOfClass:[NSNumber class]]) {
        return @{@"valid":result};
    }
    [LogManager append:@"出错:%@", error];
    return @{};
}


-(void) updateLicence:(KDTLicenceBlock) block {
    NSString* url = [NSString stringWithFormat:@"http://wx.jomton.com/applogin.php?action=userLogin&uuid=%@",uuid];
    NSLog(@"url:%@", url);
    __block ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setTimeOutSeconds:5];
    [request setRequestMethod:@"GET"];
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];

    [request setCompletionBlock:^{
        NSDictionary* result = _hande(request.responseStatusCode, request.responseHeaders, request.responseData);
        licence = @{@"devInfo": uuid,
                    @"payload": result};
        block(licence);
        [request release];
    }];
    [request setFailedBlock:^{
        licence = @{@"devInfo": uuid,
                    @"payload": @{}};
        block(licence);
        [request release];
    }];
    [request startAsynchronous];
}

@end
