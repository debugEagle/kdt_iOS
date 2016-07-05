//
//  dictObj.c
//  OCRDemo1
//
//  Created by wd on 15-4-14.
//  Copyright (c) 2015年 AT. All rights reserved.
//

#import "OcrDict.h"
#import "stdio.h"

dictCtx dictBundle = {0};
static
void __printByte(int n,int b)
{
    for (int i = 0 ; i<b; i++) {
        printf("%d",n%2);
        n>>=1;
    }
    printf("\n");
}

// 字库信息转二进制
static void __dicthextobyte(NSString * inStr,char * outStr, int* nstrinfo)
{
    int i=0;
    const char* inCStr = [inStr UTF8String];
    while(inCStr[i]!='\0')
    {
        //取字库点阵信息的2/3进行匹
        switch(inCStr[i])
        {
            case '0':
            {
                sprintf(outStr,"%s%s",outStr,"0000");
            }
                break;
            case '1':
            {
                sprintf(outStr,"%s%s",outStr,"0001");
                *nstrinfo += 1;
            }
                break;
            case '2':
            {
                sprintf(outStr,"%s%s",outStr,"0010");
                *nstrinfo += 1;
            }
                break;
            case '3':
            {
                sprintf(outStr,"%s%s",outStr,"0011");
                *nstrinfo += 2;
            }
                break;
            case '4':
            {
                sprintf(outStr,"%s%s",outStr,"0100");
                *nstrinfo += 1;
            }
                break;
            case '5':
            {
                sprintf(outStr,"%s%s",outStr,"0101");
                *nstrinfo += 2;
            }
                break;
            case '6':
            {
                sprintf(outStr,"%s%s",outStr,"0110");
                *nstrinfo += 2;
            }
                break;
            case '7':
            {
                sprintf(outStr,"%s%s",outStr,"0111");
                *nstrinfo += 3;
            }
                break;
            case '8':
            {
                sprintf(outStr,"%s%s",outStr,"1000");
                *nstrinfo += 1;
            }
                break;
            case '9':
            {
                sprintf(outStr,"%s%s",outStr,"1001");
                *nstrinfo += 2;
            }
                break;
            case 'A':
            {
                sprintf(outStr,"%s%s",outStr,"1010");
                *nstrinfo += 2;
            }
                break;
            case 'B':
            {
                sprintf(outStr,"%s%s",outStr,"1011");
                *nstrinfo += 3;
            }
                break;
            case 'C':
            {
                sprintf(outStr,"%s%s",outStr,"1100");
                *nstrinfo += 2;
            }
                break;
            case 'D':
            {
                sprintf(outStr,"%s%s",outStr,"1101");
                *nstrinfo += 3;
            }
                break;
            case 'E':
            {
                sprintf(outStr,"%s%s",outStr,"1110");
                *nstrinfo += 3;
            }
                break;
            case 'F':
            {
                sprintf(outStr,"%s%s",outStr,"1111");
                *nstrinfo += 4;
            }
                break;
        }
        i++;
    }
}

@implementation NSDictWord


-(id) initWithCode:(NSString *)code {
    self = [super init];
    if (self) {
        NSArray *wordArray = [code componentsSeparatedByString:@"$"];
        if ([wordArray count] != 4){
            [self release];
            return nil;
        }
        int pt_count = 0;
        char strBtye[DICT_INFO_MAX] = {0};
        short strInfo[DICT_WIDE_MAX] = {0};
        
        NSString* strHexWord = [wordArray objectAtIndex:0];
        
        __dicthextobyte(strHexWord, strBtye, &pt_count);
        
        int strWidth = ((int)[strHexWord length]*4) / DICT_HIGH_MAX;           //字体宽度
        int strHigth = [[wordArray objectAtIndex:3] intValue];                 //字体高度
        
        for(int i = 0; i < strWidth; i++)
        {
            char f_strToHash[DICT_HIGH_MAX + 1] = {0};                         //+ NULL
            strncpy(f_strToHash, &strBtye[i * DICT_HIGH_MAX], DICT_HIGH_MAX);
            short hash = (short)strtol(f_strToHash, NULL, 2);
            strInfo[i] = hash;
        }
        
        //申请字体内存
        UInt32* new_info = sizeof(short) * strWidth;
        memcpy(new_info,strInfo,sizeof(short) * strWidth);
        name = [[wordArray objectAtIndex:0] copy];
        count = pt_count;
        break_count = 0;
        width = strWidth;
        higth = strHigth;
        info = new_info;
    }
    return self;
}


-(void) dealloc{
    [name release];
    [super dealloc];
}

@end

static
UInt32 __getMask(int l){
    UInt32 mask = -1;
    while (l--) {
        mask <<= 1;
    }
    printf("mask:%08x\n",(unsigned int)mask);
    return mask;
}

DictWord* createWord(NSString* str){
    
    NSArray *wordArray = [str componentsSeparatedByString:@"$"];
    if ([wordArray count] != 4)
        return nil;
    
    int pt_count = 0;
    char strBtye[DICT_INFO_MAX] = {0};
    short strInfo[DICT_WIDE_MAX] = {0};
    
    NSString* strHexWord = [wordArray objectAtIndex:0];
    NSString* flag = [wordArray objectAtIndex:2];
    
    int word_align = DICT_HIGH_MAX_DM;
    int word_hight = DICT_HIGH_MAX_DM;
    
    if ([flag length] == 1) {
        word_align = DICT_HIGH_MAX;
        word_hight = [[wordArray objectAtIndex:3] intValue];                //字体高度
    }
    
    int word_width = ((int)[strHexWord length] * 4) / word_align;           //字体宽度
    
    __dicthextobyte(strHexWord, strBtye, &pt_count);                        //01串
    
    for(int i = 0; i < word_width; i++)
    {
        char f_strToHash[DICT_HIGH_MAX + 1] = {0};                          // + NULL
        strncpy(f_strToHash, &strBtye[i * word_align], word_align);
        short hash = (short)strtol(f_strToHash, NULL, 2);
        strInfo[i] = hash << (DICT_HIGH_MAX - word_hight);
    }

    //申请字体内存
    DictWord* pword = (DictWord*)malloc(sizeof(DictWord) + sizeof(short) * word_width);
    pword->named =  [[wordArray objectAtIndex:1] copy];
    pword->code = [str copy];
    
    pword->g_count = word_width * word_hight;
    pword->g_breakcount = 0;                    //每次找字根据相似度,更新值
    pword->p_count = pt_count;
    pword->p_breakcount = 0;                    //每次找字根据相似度,更新值
    pword->mask = __getMask(DICT_HIGH_MAX - word_hight);
    
    pword->width = word_width;
    pword->higth = word_hight;
    pword->next = NULL;
    memcpy(pword->info,strInfo,sizeof(short)*word_width);
    
    NSLog(@"%@",str);
    return pword;
}

void removeWord(DictWord* word){
    DictWord* idt = word;
    while (idt != NULL) {
        [idt->code  release];
        [idt->named release];
        printf("remove word %s\n",[idt->named UTF8String]);
        DictWord* next = idt->next;
        free(idt);
        idt = next;
    }
}

DictWord* findWord(dictCtx* ctx, NSString* str){
    DictWord* pitor = ctx->dicts[ctx->curt_dict].next;
    DictWord* next = NULL;
    while (pitor != NULL) {
        if ([pitor->named isEqualToString:str]){
            DictWord* new_word = createWord(pitor->code);
            new_word->next = next;
            next = new_word;
        }
        pitor = (DictWord*)pitor->next;
    }
    return next;
}



int useDict(dictCtx* ctx, int index) {
    if (index < 0 || index > (DICT_MAX - 1))      //index 不是一个有效的字典号
        return -1;
    if (ctx->dicts[index].next == NULL)
        return -1;
    ctx->curt_dict = index;
    return 0;
}

int delDict(dictCtx* ctx, int index) {
    if (index < 0 || index > (DICT_MAX - 1)) {      //index 不是一个有效的字典号
        return -2;
    }
    if (ctx->dicts[index].next != NULL) {
        removeWord(ctx->dicts[index].next);
        ctx->dicts[index].next = NULL;
        printf("删除了字典 %d\n",index);
    }else
        printf("字典还未设置 %d\n",index);
    return 0;
}


void initDictSim(DictWord* dict, float sim){
    DictWord* pitor = dict;
    while (pitor != NULL) {
        pitor->g_breakcount = pitor->g_count * (1-sim);
        pitor->p_breakcount = pitor->p_count * (1-sim);
        printf("%s: point[%d,%d] globle[%d,%d]\n",[pitor->named UTF8String],
               pitor->p_breakcount, pitor->p_count,
               pitor->g_breakcount, pitor->g_count);
        pitor = (DictWord*)pitor->next;
    }
}


int initDict(dictCtx* ctx, int index, NSSet* dictSet) {
    //NSLog(@"set:%@",dictSet);
    
    if (ctx->dicts[index].next != NULL) {                 //index 已经被设置过了
        removeWord(ctx->dicts[index].next);
        ctx->dicts[index].next = NULL;
    }
    
    DictWord* dict = &ctx->dicts[index];
    
    NSEnumerator *enumerator = [dictSet objectEnumerator];
    
    for (id object in enumerator) {
        
        if (![object isKindOfClass:[NSString class]]){
            //NSLog(@"%@ ;%@",object, [object class]);
            continue;
        }
        DictWord* word = createWord((NSString*)object);
        if (!word) continue;            //字体不符合要求 未创建成功
        // 加入链表
        word->next = dict->next;        // 第一次时dict.next = NULL 头插
        dict->next = word;
    }
    return 0;
}

#warning 1
//void init_ocr(void) {
//    for (int i = 0; i < DICT_MAX - 1; i ++) {
//        DictWord* word = &dictBundle.dicts[i];
//        if (word->next != NULL) {
//            removeWord(word->next);
//            word->next = NULL;
//        }
//    }
//    dictBundle.curt_dict = 0;
//}
