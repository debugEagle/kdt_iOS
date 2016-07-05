//
//  Graphics.cpp
//  KDTPower
//
//  Created by wd on 16-3-14.
//
//

#include "Graphics.h"
#include "conf.h"
#include "Com.h"
#include "OcrLua.h"

#import <UIKit/UIKit.h>


typedef struct {
    Com::env        env;
    UInt32        status;
    IOSurfaceRef    surface;
    UInt32*       bitmap;
} GraphicsCtx;


static GraphicsCtx _ctx;


typedef struct {
    int            x;       //相对首点偏移
    int            y;
    int            pos;
    UInt32       range[6];       //颜色范围
} KDTPoint;


typedef struct {
    int           x;
    int           y;
    UInt32      width;
    UInt32      height;
    double        sim;
} FindRegion;


typedef struct {
    UInt32        width;    //多点区域大小
    UInt32        height;
    UInt32        count;    //多点数量
    KDTPoint        first;    //首点
    KDTPoint        points[0];
} FindCtx;


NS_INLINE
UInt32 __overstep(UInt32 x, UInt32 y) {
    return x >= _ctx.env.width || y >= _ctx.env.height;
}


NS_INLINE
UInt32 __getColor(int x, int y) {
    return _ctx.bitmap[_ctx.env.width * y + x];
}


static
bool __randerDisplay(void){
    if (Com::inState(_ctx.status, Graphics::kGraphicsRanderlock)) {
        NSLog(@"Graphics lock!");
        return false;
    }
    IOSurfaceLock(_ctx.surface, 0, nil);
    CARenderServerRenderDisplay(0, CFSTR("LCD"), _ctx.surface, 0, 0);
    IOSurfaceUnlock(_ctx.surface, 0, 0);
    return true;
}

void Graphics::init() {
    NSLog(@"Graphics::init");
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    float scale = [UIScreen mainScreen].scale;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        _ctx.env.width = screenSize.width * scale;
        _ctx.env.height = screenSize.height * scale;
    } else {
        _ctx.env.width = screenSize.height * scale;
        _ctx.env.height = screenSize.width * scale;
    }
    _ctx.env.rotation = 0;
    
    NSInteger width = _ctx.env.width;
    NSInteger height = _ctx.env.height;
    NSInteger bytesPerElement = 4;
    NSInteger bytesPerRow = bytesPerElement * width;
    
    NSDictionary *properties = @{
                                 (__bridge NSString *)kIOSurfaceIsGlobal:@YES,
                                 (__bridge NSString *)kIOSurfaceBytesPerElement:@(bytesPerElement),
                                 (__bridge NSString *)kIOSurfaceBytesPerRow:@(bytesPerRow),
                                 (__bridge NSString *)kIOSurfaceWidth:@(width),
                                 (__bridge NSString *)kIOSurfaceHeight:@(height),
                                 (__bridge NSString *)kIOSurfacePixelFormat:@(0x42475241),//'ARGB'
                                 (__bridge NSString *)kIOSurfaceAllocSize:@(width * height * bytesPerElement)
                                 };
    
    _ctx.surface = IOSurfaceCreate((__bridge CFDictionaryRef)properties);       //创建新的iosurface
    if (!_ctx.surface) {
        NSLog(@"IOSurfaceCreate error,surface");
        exit(1);
    }
    _ctx.bitmap = (UInt32*)IOSurfaceGetBaseAddress(_ctx.surface);          //获取iosurface的基址
    __randerDisplay();
    
    /* 初始化ocr */
    initMapCtx(0, _ctx.env.width, _ctx.env.height, _ctx.bitmap);
    
    NSLog(@"surface engine is done! :%p\n", _ctx.bitmap);
}

bool Graphics::randerDisplay() {
    return __randerDisplay();
}


void Graphics::setRotation(int r) {
    _ctx.env.rotation = r;
    /* 改变ocr内部的dir */
    ::setRotation(r);
}

bool Graphics::keepStatus() {
    return Com::inState(_ctx.status, Graphics::kGraphicsRanderlock);
}

void Graphics::keepScreen(bool b) {
    Com::setState(&_ctx.status, Graphics::kGraphicsRanderlock, b);
    if (b) {
        __randerDisplay();
    }
}


void Graphics::getScreenSize(int* width, int* height) {
    *width = _ctx.env.width;
    *height = _ctx.env.height;
}


UInt32 Graphics::getColor(int x, int y) {
    __randerDisplay();
    Com::transform(&_ctx, &x, &y, IPHONE_DIR_STD);
    return __getColor(x, y);
}


static
void _rotation(int* x, int* y) {
    int orgX = *x;
    int orgY = *y;
    int rotation = _ctx.env.rotation;
    switch (rotation) {
        case 0:
            break;
        case 1:                 //Home 键在右边
            *x = -orgY;
            *y = orgX;
            break;
        case 2:                 //Home 键在左边
            *x = orgY;
            *y = -orgX;
            break;
        case 3:
            break;
        default:
            break;
    }
    
}

static
FindCtx* __dealArg(int color, NSString* otherPoint,FindRegion* rect){
    if (rect->sim <= 0 || rect->sim > 1.0)
        return nil;
    
    UInt32 sim = (UInt32)lround((1.0 - rect->sim) * 255);
    
    if (rect->height > _ctx.env.height || rect->width > _ctx.env.width)
        return nil;
    
    NSArray* points = [otherPoint componentsSeparatedByString:@","];
    UInt32 count = (UInt32)points.count;
    if (!count)
        return nil;
    
    size_t size = sizeof(FindCtx) + sizeof(KDTPoint) * count;
    FindCtx* ret = (FindCtx*)malloc(size);
    memset(ret, 0, size);
    
    int x1 = 0;
    int y1 = 0;
    int x2 = 0;
    int y2 = 0;
    int max = 0;
    int min = 0;
    
    min = GetR(color) - sim;
    max = GetR(color) + sim;
    ret->first.range[0] = (min < 0 ? 0 : min);
    ret->first.range[1] = (max > 255 ? 255 : max);
    
    min = GetG(color) - sim;
    max = GetG(color) + sim;
    ret->first.range[2] = (min < 0 ? 0 : min);
    ret->first.range[3] = (max > 255 ? 255 : max);
    
    min = GetB(color) - sim;
    max = GetB(color) + sim;
    ret->first.range[4] = (min < 0 ? 0 : min);
    ret->first.range[5] = (max > 255 ? 255 : max);
    
    ret->count = count;
    
    for (int i = 0; i < count; i++) {
        NSString* tmp = [points objectAtIndex:i];
        NSArray* point = [tmp componentsSeparatedByString:@"|"];
        if (point.count != 3) goto fail;
        
        int x = [[point objectAtIndex:0] intValue];
        int y = [[point objectAtIndex:1] intValue];
        
        _rotation(&x, &y);         //旋转
        
        UInt32 color = (UInt32)strtoul([[point objectAtIndex:2] UTF8String], 0, 16);
        
        min = GetR(color) - sim;
        max = GetR(color) + sim;
        ret->points[i].range[0] = (min < 0 ? 0 : min);
        ret->points[i].range[1] = (max > 255 ? 255 : max);
        
        min = GetG(color) - sim;
        max = GetG(color) + sim;
        ret->points[i].range[2] = (min < 0 ? 0 : min);
        ret->points[i].range[3] = (max > 255 ? 255 : max);
        
        min = GetB(color) - sim;
        max = GetB(color) + sim;
        ret->points[i].range[4] = (min < 0 ? 0 : min);
        ret->points[i].range[5] = (max > 255 ? 255 : max);
        
        ret->points[i].pos = _ctx.env.width * y + x;
        
        x1 = x < x1 ? x : x1;
        x2 = x > x2 ? x : x2;
        y1 = y < y1 ? y : y1;
        y2 = y > y2 ? y : y2;
    }
    
    ret->width = x2 - x1 + 1;
    ret->height = y2 - y1 + 1;
    
    NSLog(@"ret->width:%ld\n",ret->width);
    NSLog(@"ret->height:%ld\n",ret->height);
    
    ret->first.x = -x1;
    ret->first.y = -y1;
    
    NSLog(@"ret->first.x:%d\n",ret->first.x);
    NSLog(@"ret->first.y:%d\n",ret->first.y);
    
    if (ret->width > rect->width || ret->height > rect->height)
        goto fail;
    
    return ret;
fail:
    free(ret);
    return nil;
}

static
bool __checkRGB(UInt32 c, KDTPoint* p){
    UInt32 rgb = GetR(c);
    if (rgb < p->range[0] || rgb > p->range[1]) {
        return false;
    }
    rgb = GetG(c);
    if (rgb < p->range[2] || rgb > p->range[3]) {
        return false;
    }
    rgb = GetB(c);
    if (rgb < p->range[4] || rgb > p->range[5]) {
        return false;
    }
    return true;
}

static
int __findColorEx(FindCtx* ctx,UInt32 first){
    UInt32*  base = _ctx.bitmap;
    for (int i = 0 ; i < ctx->count ; i++) {
        if (!__checkRGB(base[first + ctx->points[i].pos],&ctx->points[i])) {
            return 0;
        }
    }
    return 1;
}


NSString*
Graphics::findColorEx(int fistColor, NSString* otherPoint, int x1, int y1, int x2, int y2, double sim, int dir, int* retX, int* retY) {
    UInt32  x,y;
    UInt32  imax;
    UInt32  jmax;
    UInt32  iorg;
    UInt32  fpt;
    int       ichange;
    int       jchange;
    
    --x2;--y2;      //不包括(x2,y2)
    
    *retX = -1;
    *retY = -1;
    
    Com::transform(&_ctx, &x1, &y1, IPHONE_DIR_STD);
    Com::transform(&_ctx, &x2, &y2, IPHONE_DIR_STD);
    
    NSLog(@"%d,%d", x1, y1);
    NSLog(@"%d,%d", x2, y2);
    
    if (__overstep(x1, y1) || __overstep(x2, y2)) {
        return @"查找范围越界";
    }
    
    FindRegion region = {0};
    
    region.x = x1 < x2 ? x1 : x2;
    region.y = y1 < y2 ? y1 : y2;
    region.width = abs(x2 - x1) + 1;                //宽高＋1
    region.height = abs(y2 - y1) + 1;
    region.sim = sim;
    
    NSLog(@"x,y:%d,%d",region.x,region.y);
    NSLog(@"width,height:%ld,%ld",region.width,region.height);
    
    FindCtx* find = __dealArg(fistColor, otherPoint, &region);
    if (!find) return @"无效的查找范围或相似度";
    
    switch (dir) {          //找色方向
        case 1:
            x = region.x + region.width - find->width + find->first.x;
            y = region.y + find->first.y;
            imax = iorg = region.height - find->height;
            jmax = region.width - find->width;
            ichange = _ctx.env.width;
            jchange = -1;
            break;
        case 2:
            x = region.x + region.width - find->width + find->first.x;
            y = region.y + region.height - find->height + find->first.y;
            imax = iorg = region.width - find->width;
            jmax = region.height - find->height;
            ichange = -1;
            jchange = -(_ctx.env.width);
            break;
        case 3:
            x = region.x + find->first.x;
            y = region.y + region.height - find->height + find->first.y;
            imax = iorg = region.height - find->height;
            jmax = region.width - find->width;
            ichange = -(_ctx.env.width);
            jchange = 1;
            break;
        case 0:
        default :
            x = region.x + find->first.x;
            y = region.y + find->first.y;
            imax = iorg = region.width - find->width;
            jmax = region.height - find->height;
            ichange = 1;
            jchange = _ctx.env.width;
            break;
    }
    
    fpt = _ctx.env.width * y + x;
    
    __randerDisplay();
    
    UInt32  arg_list[17];
    arg_list[0] = imax;                         //imax
    arg_list[1] = jmax;                         //jmax
    arg_list[2] = ichange;                      //ichange
    arg_list[3] = jchange;                      //jchange
    arg_list[4] = iorg;                         //iorg
    arg_list[5] = fpt;                          //fpt
    arg_list[6] = (UInt32)_ctx.bitmap;                  //base
    arg_list[7] = 0;                            //color
    arg_list[8] = find->first.range[0];         //minR
    arg_list[9] = find->first.range[1];         //maxR
    arg_list[10] = find->first.range[2];        //minG
    arg_list[11] = find->first.range[3];        //maxG
    arg_list[12] = find->first.range[4];        //minB
    arg_list[13] = find->first.range[5];        //maxB
    arg_list[14] = (UInt32)find;              //find
    arg_list[15] = 0;                           //result
    arg_list[16] = 0;
    
    UInt32* args = arg_list;
    
    char buff[256];
    
    sprintf(buff, "imax:%d\n",(unsigned int)imax);
    sprintf(buff, "jmax:%d\n",(unsigned int)jmax);
    
    asm volatile(
                 "stmfd sp!,{r0-r6,r8-r11}\n"
                 "ldr r2, [%0] \n"                        // r2 = imax
                 "ldr r3, [%0, #8] \n"                    // r3 = ichange
                 "ldr r4, [%0, #20] \n"                   // r4 = fpt
                 "ldr r5, [%0, #24] \n"                   // r5 = base
                 "ldr r6, [%0, #28] \n"                   // r6 = color
                 
                 "ldr r0, [%0, #32] \n"
                 "vmov s0, r0\n"
                 "ldr r0, [%0, #36] \n"
                 "vmov s1, r0\n"
                 "ldr r0, [%0, #40] \n"                   //  fisrt rgb 存入浮点寄存器
                 "vmov s2, r0\n"
                 "ldr r0, [%0, #44] \n"
                 "vmov s3, r0\n"
                 "ldr r0, [%0, #48] \n"
                 "vmov s4, r0\n"
                 "ldr r0, [%0, #52] \n"
                 "vmov s5, r0\n"
                 
                 
                 "1:\n"                                 //          loop
                 
                 "cmp r2, #0\n"                         //
                 "blt 2f \n"                            //          [0,imax]
                 
                 
                 "add r2, #-1\n"                        //          --imax
                 
                 "mov r0, r4, lsl#2\n"                  //          color = base[fpt]
                 "ldr r6, [r5, r0]\n"
                 
                 "ldr r0, [%0, #64]\n"
                 "add r0, #1\n"
                 "str r0, [%0, #64]\n"
                 
                 "add r4, r3\n"                         //          findpoint += ichange;
                 
                 "and r0, r6, #0xff\n"                  //          r0 = color & oxff
                 "vmov r1, s4\n"
                 "cmp r0, r1\n"
                 "bcc 1b\n"                             //          r0 < minB
                 "vmov r1, s5\n"
                 "cmp r0, r1\n"
                 "bhi 1b\n"                             //          r0 > maxB
                 
                 "mov r6, r6,asr#8\n"
                 "and r0, r6, #0xff\n"                  //          r0 = color & oxff00
                 "vmov r1, s2\n"
                 "cmp r0, r1\n"
                 "bcc 1b\n"                             //          r0 < minG
                 "vmov r1, s3\n"
                 "cmp r0, r1\n"
                 "bhi 1b\n"                             //          r0 > maxG
                 
                 "mov r6, r6,asr#8\n"
                 "and r0, r6, #0xff\n"                  //          r0 = color & ox0000ff0000
                 "vmov r1, s0\n"
                 "cmp r0, r1\n"
                 "bcc 1b\n"                             //          r0 < minR
                 "vmov r1, s1\n"
                 "cmp r0, r1\n"
                 "bhi 1b\n"                             //          r0 > maxR
                 
                 "ldr r0, [%0, #56]\n"
                 "sub r1, r4, r3\n"
                 "stmfd sp!,{r2-r6}\n"
                 "bl %1\n"                              //          __findColorEx(find,fpt)
                 "ldmfd sp!,{r2-r6}\n"
                 "cmp r0, #0\n"
                 "beq 1b\n"
                 
                 "mov r0, #1\n"
                 "str r0, [%0, #60]\n"                  //          result = 1
                 "sub r1, r4, r3\n"
                 "str r1, [%0, #20]\n"                  //          save the fpt
                 "b 3f\n"
                 
                 "2:\n"
                 "ldr r0, [%0, #4]\n"
                 "cmp r0, #0\n"
                 "beq 3f \n"                            //          (0,jmax]
                 
                 "add r0, #-1 \n"                       //          --jmax
                 "str r0, [%0, #4]\n"
                 
                 "ldr r0, [%0, #12]\n"
                 "add r4, r0\n"                         //          fpt += jchange;
                 
                 
                 "mvn r0, r3\n"                         //          ichange *= -1;
                 "add r3, r0, #1\n"
                 
                 "add r4, r3\n"                         //          fix fpt
                 
                 "ldr r0, [%0, #16]\n"                  //          imax = iorg;
                 "mov r2, r0\n"
                 
                 "b 1b \n"
                 
                 "3: \n"
                 "ldmfd sp!,{r0-r6,r8-r11}"
                 :
                 :"r"(args),"g"(__findColorEx)
                 :"r0","r1","r2","r3","r4","r5","r6","s0","s1","s2","s3","s4","s5"
                 );
    
    if (arg_list[15]) {
        *retX = arg_list[5] % _ctx.env.width;
        *retY = arg_list[5] / _ctx.env.width;
        Com::transform(&_ctx, retX, retY, IPHONE_DIR_USER);
    }

    free(find);
    return nil;
}






