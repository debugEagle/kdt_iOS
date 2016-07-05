//
//  KDTLicenceManager.h
//  
//
//  Created by wd on 16/5/11.
//
//

#import <Foundation/Foundation.h>

typedef void (^KDTLicenceBlock)(NSDictionary*);

@interface KDTLicenceManager : NSObject

+(id) sharedInstance;

-(void) updateLicence:(KDTLicenceBlock) block;

@end
