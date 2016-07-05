

#import "WDMenuView.h"
#import <objc/runtime.h>

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height


@implementation WDMenuView {
    NSMutableArray* menus;      //存放menus
    CGFloat big_menu_radius;
}

-(id)initWithCenter:(CGPoint)center bigMenuRadius:(CGFloat)big_radius
      subMenuRadius:(CGFloat)sub_radius
             upView:(UIView *)uper
         themeColor:(UIColor *)color {
    
    self = [super initWithFrame:CGRectMake(center.x - big_radius, center.y - big_radius, big_radius * 2, big_radius * 2)];
    if (self) {
        self.menu_color = color;
        
        //设置大按钮
        self.backgroundColor = [UIColor clearColor];
        self.super_view = uper;
        [self.super_view addSubview:self];
        
        UIView* edge_view = [[UIView alloc]init];
        edge_view.frame = self.bounds;
        edge_view.backgroundColor = [UIColor blackColor];
        //edge_view.alpha = 0.5f;
        edge_view.backgroundColor = _menu_color;
        edge_view.layer.cornerRadius = big_radius;
        edge_view.layer.masksToBounds = YES;
        [self addSubview:edge_view];
        
        big_menu_radius = big_radius;
        menus = [[NSMutableArray alloc] initWithCapacity:4];
        
        _big_menu_image = [[UIImageView alloc]init];
        _big_menu_image.backgroundColor = [UIColor whiteColor];
        _big_menu_image.alpha  = 1.f;
        _big_menu_image.bounds = CGRectMake(0, 0, big_radius * 2, big_radius * 2);
        _big_menu_image.center = CGPointMake(big_radius, big_radius);
        _big_menu_image.layer.cornerRadius = big_radius;
        _big_menu_image.layer.masksToBounds = YES;

        [self addSubview:_big_menu_image];
        [_big_menu_image release];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigMenuTap:)];
        [self addGestureRecognizer:tapGes];
        [tapGes release];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(locationChange:)];
        pan.delaysTouchesBegan = YES;
        [self addGestureRecognizer:pan];
        [pan release];
        
        
        
        self.hidden = TRUE;
        stuts = 0;
    }
    return self;
}


-(void) UpdateSubMenu {
    WDLog(".");
    CGPoint window_center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    CGPoint org_point = self.center;
    
    double degree = atan2(org_point.x - window_center.x, org_point.y - window_center.y);
    CGFloat fix_degree = M_PI - degree;          //翻转一下,不反转就要改下面了
    
    NSInteger menu_count = [menus count];
    CGFloat per_degree = (180 / (menu_count + 1)) * (M_PI / 180);
    
    [menus enumerateObjectsUsingBlock:^(id sub_menu_info, NSUInteger idx, BOOL *stop) {
        CGFloat sub_menu_radius = [[sub_menu_info objectForKey:key_WDSubMenu_radius] floatValue];
        CGFloat menu_distance = [[sub_menu_info objectForKey:key_WDSubMenu_distance] floatValue];
        
        UIView* view = [sub_menu_info objectForKey:key_WDSubMenu_view];
        view.center = org_point;        //更新子按钮位置到主按钮
        
        CGFloat pop_distance = big_menu_radius + sub_menu_radius + menu_distance;
        CGFloat cos_degree = cosf(per_degree * (idx + 1) + fix_degree);
        CGFloat sin_degree = sinf(per_degree * (idx + 1) + fix_degree);
        
        CGPoint pop_center = CGPointMake(org_point.x + pop_distance * cos_degree, org_point.y + pop_distance * sin_degree);
        [sub_menu_info setObject:[NSValue valueWithCGPoint:pop_center] forKey:key_WDSubMenu_popCenter];
    }];
}

-(void) addSubMenu:(NSMutableDictionary*)menu_dict {
    
    NSMutableDictionary* new_menu = [[NSMutableDictionary alloc]initWithDictionary:menu_dict copyItems:NO];
    
    //bind key
    UIView* view = [[UIView alloc]initWithFrame:CGRectZero];
    view.hidden = TRUE;
    NSString* menu_id = [[new_menu objectForKey:key_WDSubMenu_id] copy];        //重新设置字典的字符串,其他属性可以用原字典的值
    
    objc_setAssociatedObject(view, key_WDSubMenu_id, menu_id, OBJC_ASSOCIATION_COPY);
    [new_menu setObject:menu_id forKey:key_WDSubMenu_id];
    
    //set bounds and radius
    view.center = self.center;
    CGFloat menu_radius = [[new_menu objectForKey:key_WDSubMenu_radius] floatValue];
    view.bounds = CGRectMake(0, 0, menu_radius * 2, menu_radius * 2);
    view.layer.cornerRadius = menu_radius;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor whiteColor];
    
    //init image
    NSString* menu_image = [new_menu objectForKey:key_WDSubMenu_backgroundImage];
    UIImageView* image_view = [[UIImageView alloc]initWithImage: [UIImage imageNamed:menu_image]];
    //image_view.center = view.center;
    image_view.frame = view.bounds;
    [view addSubview:image_view];
    [image_view release];
    
    UITapGestureRecognizer *menu_tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(subMenuTap:)];
    [view addGestureRecognizer:menu_tap];
    [menu_tap release];
    
    [self.super_view insertSubview:view belowSubview:self];     //view retain + 1
    [new_menu setObject:view forKey:key_WDSubMenu_view];        //view retain + 1
    [view release];
    
    [menus addObject:new_menu];                                 //new_menu retain + 1
    [new_menu release];
    
    WDLog("ADD %@", menus);
}


- (void) visible: (BOOL) op {
    BOOL showed = [self inMode:STUTS_WDMENU_SHOW] ? YES : NO;
    if (showed == op) return;
    
    [self setMode:STUTS_WDMENU_SHOW to:op];
    /* 注意这是是 hidden op是反的 */
    op = 1 - op;
    [menus enumerateObjectsUsingBlock:^(id sub_menu_info, NSUInteger idx, BOOL *stop) {
        UIView* view = [sub_menu_info objectForKey:key_WDSubMenu_view];
        view.hidden = op;
    }];
    self.hidden = op;
}


- (void) visibleChange {
    BOOL op = [self inMode:STUTS_WDMENU_SHOW] ? NO : YES;
    [self visible:op];
    [self tapToSwitch:op];
}


- (void) _rotate {
    [UIView animateWithDuration: 2.0f
                          delay: 0.0f
                        options: UIViewAnimationOptionAllowUserInteraction
     | UIViewAnimationOptionBeginFromCurrentState
     | UIViewAnimationOptionCurveLinear
                     animations: ^{
                         _big_menu_image.transform = CGAffineTransformRotate(_big_menu_image.transform, M_PI);
                     }
                     completion: ^(BOOL finished){
                         if (finished && [self inMode:STUTS_WDMENU_ROTATE]) [self _rotate];
                         if (!finished) _big_menu_image.transform = CGAffineTransformIdentity;
                     }];
}

- (void) rotate: (BOOL) op {
    int oop = [self inMode:STUTS_WDMENU_ROTATE];
    [self setMode:STUTS_WDMENU_ROTATE to:op];
    
    if (op && !oop) [self _rotate];
    if (!op) [_big_menu_image.layer removeAllAnimations];
}

- (void) setMode:(Enum_WDMenuViewStuts) stuts_mask to:(UInt32)value {
    (value) ? (stuts |= (1 << stuts_mask)) : (stuts &= ~(1 << stuts_mask));
}


- (bool) inMode:(Enum_WDMenuViewStuts) stuts_mask {
    return stuts & (1 << stuts_mask);
}

#pragma mark -- 点击菜单

-(void)bigMenuTap:(UITapGestureRecognizer *)tapGes{
    if ([self inMode:STUTS_WDMENU_POP]) {
        [self tapToSwitch:NO];
    } else
        [self tapToSwitch:YES];
}

-(void)subMenuTap:(UITapGestureRecognizer *)tapGes{
    WDLog(".");
    UIView* view = tapGes.view;
    NSString* view_id = objc_getAssociatedObject(view, key_WDSubMenu_id);
    [self.menu_delegate MenuDidSelected:view_id];
    [self tapToSwitch:NO];
}


-(void) changeColor {
    self.alpha = .5f;
}


-(void)locationChange:(UIPanGestureRecognizer*)p
{
    //WDLog(".");
    CGPoint panPoint = [p locationInView:[[UIApplication sharedApplication] keyWindow]];
    if(p.state == UIGestureRecognizerStateBegan)
    {
        //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeColor) object:nil];
        //self.alpha = 1.f;
        _big_menu_image.transform = CGAffineTransformIdentity;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tapToSwitchOpenOrClose) object:nil];
        [self setMode:STUTS_WDMENU_POP to:0];
    }
    else if (p.state == UIGestureRecognizerStateEnded)
    {
        //[self performSelector:@selector(changeColor) withObject:nil afterDelay:4.0];
    }
    
    if(p.state == UIGestureRecognizerStateChanged)
    {
        self.center = CGPointMake(panPoint.x, panPoint.y);
        
        [menus enumerateObjectsUsingBlock:^(id sub_menu_info, NSUInteger idx, BOOL *stop) {
            UIView* view = [sub_menu_info objectForKey:key_WDSubMenu_view];
            view.center = CGPointMake(panPoint.x, panPoint.y);
        }];
    }
    else if(p.state == UIGestureRecognizerStateEnded)
    {
        /* 距离上边缘距离 */
        CGFloat y1 = panPoint.y;
        /* 距离下边缘距离 */
        CGFloat y2 = kScreenHeight - panPoint.y;
        
        if (y1 < big_menu_radius || y2 < big_menu_radius) {
            CGPoint dest = {panPoint.x, (y1 < y2 ? big_menu_radius : kScreenHeight - big_menu_radius)};
            
            [UIView animateWithDuration:0.2 animations:^{
                self.center = dest;
            }];
            
            [menus enumerateObjectsUsingBlock:^(id sub_menu_info, NSUInteger idx, BOOL *stop) {
                UIView* view = [sub_menu_info objectForKey:key_WDSubMenu_view];
                [UIView animateWithDuration:0.2 animations:^{
                    view.center = dest;
                }];
            }];
        }
    }
}


-(void) menuShow:(BOOL)b {
    WDLog(".");
    self.hidden = b;
    [menus enumerateObjectsUsingBlock:^(id sub_menu_info, NSUInteger idx, BOOL *stop) {
        UIView* view = [sub_menu_info objectForKey:key_WDSubMenu_view];
        view.hidden = b;
    }];
}

#pragma mark -- 点击大按钮
-(void)tapToSwitch:(BOOL) op{
    WDLog("%d", op);
    
    BOOL opened = [self inMode:STUTS_WDMENU_POP] ? YES : NO;
    
    if (opened == op) {
        return;
    }
    
    [self UpdateSubMenu];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tapToSwitch:) object:NO];
    
    int rotated = [self inMode:STUTS_WDMENU_ROTATE];
    
    if (op) {
        [menus enumerateObjectsUsingBlock:^(id sub_menu_info, NSUInteger idx, BOOL *stop) {
            UIView* view = [sub_menu_info objectForKey:key_WDSubMenu_view];
            CGPoint pop_center = [[sub_menu_info objectForKey:key_WDSubMenu_popCenter] CGPointValue];
            
            [UIView animateWithDuration:0.3f delay:0.1 * idx usingSpringWithDamping:0.4f initialSpringVelocity:0.0 options:
             UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 view.center = pop_center;
                                 _big_menu_image.alpha = 0.8f;
                                 if (!rotated) _big_menu_image.transform = CGAffineTransformMakeRotation(45*(M_PI/180));
                             }
                             completion:^(BOOL finished){_big_menu_image.alpha = 1.f;}
             ];
        }];
        [self setMode:STUTS_WDMENU_POP to:1];
        [self performSelector:@selector(tapToSwitch:) withObject:NO afterDelay:3.0];
        
    } else {
        [menus enumerateObjectsUsingBlock:^(id sub_menu_info, NSUInteger idx, BOOL *stop) {
            UIView* view = [sub_menu_info objectForKey:key_WDSubMenu_view];
            view.center = [[sub_menu_info objectForKey:key_WDSubMenu_popCenter] CGPointValue];
            CGPoint push_center = self.center;
            
            [UIView animateWithDuration:0.3f delay:0.1 * idx usingSpringWithDamping:0.4f initialSpringVelocity:0.0 options:
             UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 view.center = push_center;
                                 _big_menu_image.alpha = 0.8f;
                                 if (!rotated) _big_menu_image.transform = CGAffineTransformIdentity;
                             }
                             completion:^(BOOL finished){_big_menu_image.alpha = 1.f;}
             ];
        }];
        [self setMode:STUTS_WDMENU_POP to:0];
    }
}

@end
