//
//  dictObj.h
//  OCRDemo1
//
//  Created by wd on 15-4-14.
//  Copyright (c) 2015年 AT. All rights reserved.
//

#ifndef __OCRDemo1__dictObj__
#define __OCRDemo1__dictObj__

#import <Foundation/Foundation.h>

#define DICT_HIGH_MAX_DM    11                             //单个字体高度下限
#define DICT_HIGH_MAX       16                             //单个字体高度上限
//#define DICT_MASK 0x7FF
#define DICT_MASK 0xFFFF                                   //对齐掩码
#define DICT_WIDE_MAX       512                            //单个字体宽度上限
#define DICT_NAME_MAX       16                             //字体最长命名
#define DICT_INFO_MAX       DICT_WIDE_MAX*DICT_HIGH_MAX    //单个字信息最大长度
#define DICT_MAX            16                             //最大字库数量
#define COLORS_MAX          10                             //最大颜色数量

typedef struct {
    NSString*   named;                              //识别字名
    NSString*   code;                               //dm字符串描述
    UInt32* mask;
    short   g_count;                                //二值化总点数
    short   g_breakcount;                           //总跳出点数
    short   p_count;                                //子体总点数
    short   p_breakcount;                           //字体跳出点数
    uint8_t width;                                  //字体宽度
    uint8_t higth;                                  //字体高度
    void*   next;                                   //单链表
    short   info[0];                                //字体每列信息
} DictWord;

@interface NSDictWord : NSObject {
    NSString*   name;
    UInt32      count;
    UInt32      break_count;
    UInt32      width;
    UInt32      higth;
    UInt32*     info;
}

-(id) initWithCode:(NSString*) code;
-(void) dealloc;
@end


typedef struct {
    int         curt_dict;
    //UInt32      lineDif;                            //行间距
    DictWord    dicts[DICT_MAX];
} dictCtx;

extern dictCtx dictBundle;


int initDict(dictCtx* ctx, int index, NSSet* dictSet);
int useDict(dictCtx* ctx, int index);
int delDict(dictCtx* ctx, int index);
void initDictSim(DictWord* dict, float sim);
DictWord* createWord(NSString* str);
void removeWord(DictWord* word);
DictWord* findWord(dictCtx* ctx, NSString* str);


//void init_ocr(void);




#endif /* defined(__OCRDemo1__dictObj__) */
