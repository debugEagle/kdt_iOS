//
//  Header.h
//  ocrLib
//
//  Created by wd on 15-8-23.
//
//

#ifndef __OCRDemo1__dictDo__
#define __OCRDemo1__dictDo__

#import "ocrDict.h"
#import <Foundation/Foundation.h>

#define GetR(c) ((c & 0x00ff0000)>>16)
#define GetG(c) ((c & 0x0000ff00)>>8)
#define GetB(c) (c & 0x000000ff)

#define __getColorUseXY(b,w,x,y) b[(w) * (y) + (x)]
#define __getColorUsePt(b,p) b[(p)]

#define IPHONE_DIR_D 0
#define IPHONE_DIR_R 1
#define IPHONE_DIR_L 2
#define IPHONE_DIR_U 3

#define IPHONE_DIR_STD 1        //标准坐标系
#define IPHONE_DIR_USER 0       //自定义坐标系



typedef enum __SearchType {
    IS_OCR,                         //置1为ocr, 置0为findstr
    IS_FAST,                        //置1为fast,置0为low
}SearchType;

#define SEARCH_TYPEIS_IS_OCR(t)  (t & (1<<IS_OCR ))
#define SET_SEARCH_OCR(t)        (t | (1<<IS_OCR ))
#define SEARCH_TYPEIS_IS_FAST(t) (t & (1<<IS_FAST))
#define SET_SEARCH_FAST(t)       (t | (1<<IS_FAST))


//全图信息
typedef struct __MapCtx{
    int         width;
    int         height;
    void*       iosurface;
    UInt8       dir;
    UInt32*     data;     //bitmap
} MapCtx;


typedef struct __MultiColor {
    void*       next;
    uint8_t     range[6];
} MultiColor;

typedef struct __OcrLineResult {
    void*       next;
    UInt32      x;
    UInt32      y;
    NSString*   word;
} OcrLineResult;

typedef struct __OcrResult {
    NSMutableString*    str;
    int                 sum;
    int                 fristX;
    int                 fristY;
} OcrResult;


//按行查找上下文，每次找字都需要构造一个
typedef struct  __LineSearchCtx{
    UInt32                  dir;                        //查找方向
    int                     x;                          //查找区域在全局的坐标,（标准坐标）
    int                     y;                          //
//  UInt32                  tofind_width;               //查找区域在全局的宽度和高度
//  UInt32                  tofind_heith;               //
    UInt32                  global_width;               //全局宽高
    UInt32                  global_height;              //
    
    UInt32                  searchType;
    UInt32                  cur_row;                    //当前列
    UInt32                  line_max;                   //行上限
    UInt32                  row_max;                    //列上限
    
    UInt32*                 data;                       //bitmap
    UInt32                  point;                      //当前点位
    
    UInt32                  lineBreak;                  //换行标识
    UInt32                  lineDif;                    //行间距
    OcrResult               result;                     //ocr结果
    OcrLineResult           session;                    //ocr临时结果
    
    MultiColor              colors_head;
    
    UInt32                  mask;                       //掩码
    UInt32*                 row_info;                   //跳列标记
    UInt32*                 line_info;                  //跳行标记
    UInt32*                 value;
} LineSearchCtx;

//全局上下文，
extern MapCtx ctx;

void initMapCtx(int dir, int width, int height, UInt32* base);

void setRotation(int dir);

UInt32 getColor(int x, int y);

/* 找字: x,y,width,height 坐标系与文字相同,dir指定文字方向.                */
/* colors:@"f0e8e0-202020|e4d9c9-202020" sim:0~1 dict:链表所要找的字    */
/* dir:查找方向  返回值:NSString 返回查找结果                             */
NSString*
findStr(MapCtx* ctx, int searchType, int x, int y, int width, int height,
        NSString* color, float sim, int dir, DictWord* dict, int* retX, int* retY, int* sum);

/* 快速查找，只找到一个字,返回找到的左上角坐标                               */
/* colors:@"f0e8e0-202020|e4d9c9-202020" sim:0~1 dict:所要找的单字      */
/* 返回值:NSString 返回查找结果 */
//NSString*
//findStrFast(MapCtx* ctx, int x, int y, int width, int height,
//        NSString* color, float sim, int dir, DictWord* dict, int* retX, int* retY);

LineSearchCtx*
createLineSearchCtx(void);

UInt32
initLineSearchCtx (MapCtx* gctx, int searchType, LineSearchCtx* lctx, int x, int y, int width, int height,
                                                    NSString* colors, float sim, int dir, DictWord* dict);

void
deallocLineSearchCtx(LineSearchCtx* ctx);

UInt32
lineSearchGetNextPointDif (LineSearchCtx* ctx);

UInt32
lineSearchGetNextLineDif (LineSearchCtx* ctx);

bool
lineSearchUpdateLineInfo(LineSearchCtx* ctx);

void
lineSearchPointTransform (LineSearchCtx* ctx, int* x, int* y, int dir);

void
pointStdToUser(int to, int width, int weight, int* x, int*y);

void
pointUserToStd(int form, int width, int weight, int* x, int*y);



#endif /* defined(__OCRDemo1__dictObj__) */