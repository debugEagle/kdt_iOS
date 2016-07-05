//
//  KYGooeyMenu.h
//  KYGooeyMenu
//
//  Created by Kitten Yang on 4/23/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define key_WDSubMenu_id              @"id"
#define key_WDSubMenu_backgroundImage @"backgroundImage"
#define key_WDSubMenu_radius          @"radius"
#define key_WDSubMenu_distance        @"distance"
#define key_WDSubMenu_popCenter       @"popCenter"
#define key_WDSubMenu_view            @"view"

@protocol WDMenuViewDelegate <NSObject>

-(void)MenuDidSelected:(NSString*)key;

@end


typedef enum {
    STUTS_WDMENU_SHOW,
    STUTS_WDMENU_POP,
    STUTS_WDMENU_ROTATE,
}Enum_WDMenuViewStuts;

@interface WDMenuView : UIView {
    UInt32      stuts;
}

@property(nonatomic,retain) UIView *super_view;

@property(nonatomic,retain) UIColor *menu_color;

@property(nonatomic,retain) UIImageView* big_menu_image;

-(id)initWithCenter:(CGPoint)center bigMenuRadius:(CGFloat)big_radius
                                    subMenuRadius:(CGFloat)sub_radius
                                    upView:(UIView *)uper
                                    themeColor:(UIColor *)color;

-(void) addSubMenu:(NSDictionary*)menu_dict;

- (void) setMode:(Enum_WDMenuViewStuts) stuts_mask to:(UInt32)value;
- (bool) inMode:(Enum_WDMenuViewStuts) stuts_mask;

- (void) visible: (BOOL) op;
- (void) visibleChange;

- (void) rotate: (BOOL) op;

@property(nonatomic,retain) id<WDMenuViewDelegate> menu_delegate;

@end
