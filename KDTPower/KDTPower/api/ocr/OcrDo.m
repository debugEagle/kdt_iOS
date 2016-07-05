//
//  ocrDo.m
//  ocrLib
//
//  Created by wd on 15-8-23.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ocrDo.h"


MapCtx ctx = {0};

typedef void* IOSurfaceRef;
IOSurfaceRef IOSurfaceCreate(CFDictionaryRef properties);
size_t IOSurfaceGetBytesPerRow(IOSurfaceRef);

void *IOSurfaceGetBaseAddress(IOSurfaceRef buffer);

extern void CARenderServerRenderDisplay(kern_return_t a, CFStringRef b, IOSurfaceRef surface, int x, int y);
typedef	kern_return_t		IOReturn;
IOReturn IOSurfaceLock(IOSurfaceRef buffer, UInt32 options, UInt32 *seed);
IOReturn IOSurfaceUnlock(IOSurfaceRef buffer, UInt32 options, UInt32 *seed);

extern const CFStringRef kIOSurfaceIsGlobal;
extern const CFStringRef kIOSurfacePixelFormat;
extern const CFStringRef kIOSurfaceBytesPerElement;
extern const CFStringRef kIOSurfaceBytesPerRow;
extern const CFStringRef kIOSurfaceWidth;
extern const CFStringRef kIOSurfaceAllocSize;
extern const CFStringRef kIOSurfaceHeight;


void initMapCtx(int dir, int width, int height, UInt32* base) {
    ctx.height = height;
    ctx.width = width;
    ctx.data = base;
    ctx.dir = dir;
}


void setRotation(int dir) {
    ctx.dir = dir;
}


static inline
bool _comparaPt(LineSearchCtx* ctx, int c) {
    MultiColor* idt = &ctx->colors_head;
    
    while ((idt = idt->next)) {
        uint8_t rgb = 0;
        
        rgb = GetR(c);
        if (rgb < idt->range[0] || rgb > idt->range[1])
            continue;
        
        rgb = GetG(c);
        if (rgb < idt->range[2] || rgb > idt->range[3])
            continue;
        
        rgb = GetB(c);
        if (rgb < idt->range[4] || rgb > idt->range[5])
            continue;
        
        return true;
    }
    return false;
}


void lineSearchPointTransform (LineSearchCtx* ctx, int* x, int* y, int dir) {
    int orgX = *x;
    int orgY = *y;
    
    int width = ctx->global_width;
    int height = ctx->global_height;
    
    switch (ctx->dir) {
        case IPHONE_DIR_D:
            break;
        case IPHONE_DIR_R:
            if (dir == IPHONE_DIR_STD) {
                *x = width - orgY - 1;
                *y = orgX;
            }
            if (dir == IPHONE_DIR_USER) {
                *x = orgY;
                *y = width - orgX - 1;
            }
            break;
        case IPHONE_DIR_L:
            if (dir == IPHONE_DIR_STD) {
                *x = orgY;
                *y = height - orgX - 1;
            }
            if (dir == IPHONE_DIR_USER) {
                *x = height - orgY - 1;
                *y = orgX;
            }
            break;
        case IPHONE_DIR_U:
            *x = width - orgX - 1;
            *y = height - orgY - 1;
            break;
        default:
            break;
    }
}



void
pointStdToUser(int to, int width, int height, int* x, int*y) {
    int orgX = *x;
    int orgY = *y;
    switch (to) {
        case IPHONE_DIR_D:
            break;
        case IPHONE_DIR_R:
            *x = orgY;
            *y = width - orgX - 1;
            break;
        case IPHONE_DIR_L:
            *x = height - orgY - 1;
            *y = orgX;
            break;
        case IPHONE_DIR_U:
            *x = width - orgX - 1;
            *y = height - orgY - 1;
            break;
        default:
            break;
    }
}

void
pointUserToStd(int form, int width, int height, int* x, int*y){
    int orgX = *x;
    int orgY = *y;
    switch (form) {
        case IPHONE_DIR_D:
            break;
        case IPHONE_DIR_R:
            *x = width - orgY - 1;
            *y = orgX;
            break;
        case IPHONE_DIR_L:
            *x = orgY;
            *y = height - orgX - 1;
            break;
        case IPHONE_DIR_U:
            *x = width - orgX - 1;
            *y = height - orgY - 1;
            break;
        default:
            break;
    }
}



//获得 二进制数字 1的个数
static inline
int _get1Sum(UInt16 i) {
    int sum = 0;
    while (i) {
        if (i & 1)
            ++sum;
        i>>=1;
    }
    return sum;
}

static
void __printByte(int n,int b)
{
    for (int i = 0 ; i<b; i++) {
        printf("%d",n&1);
        n>>=1;
    }
    printf("\n");
}

static inline
bool __findWord(LineSearchCtx* lctx, DictWord* word, int line){
    if ((lctx->line_max - line) < word->width)    //查找宽度小于字体宽度
        return false;
    
    int word_wide = word->width;
    int g_break_conut = 0;                            //当前跳出点数
    int g_guard = word->g_breakcount;                 //跳出点数
    int p_break_count = 0;
    int p_guard = word->p_breakcount;
    UInt32 word_mask = word->mask;
    
    UInt16 value = 0;
    UInt16 word_info = 0;
    UInt16 line_info = 0;
    
    for (int i = 0; i < word_wide; i++, line++) {
        
        word_info = word->info[i];
        line_info = lctx->value[line] & word_mask;
        
        //value = lctx->value[line] ^  word->info[i];
        value = line_info ^  word_info;
        g_break_conut += _get1Sum(value);
        p_break_count += _get1Sum(value & word_info);
        
        if (p_break_count > p_guard)
            return false;
        if (g_break_conut > g_guard)
            return false;
        
        //__printByte(word_info,16);
        //__printByte(line_info,16);
        //printf("%d,%d\n\n",p_break_count, g_break_conut);
    }
    printf("point[%d,%d] globle[%d,%d]\n", p_break_count, p_guard, g_break_conut, g_guard);
    return true;
}

//static inline
//bool __findWord(LineSearchCtx* lctx, DictWord* word, int line){
//    if ((lctx->line_max - line) < word->width)    //查找宽度小于字体宽度
//        return false;
//
//    int word_wide = word->width;
//    int break_conut = 0;            //跳出点数
//    bool is_fast = SEARCH_TYPEIS_IS_FAST(lctx->searchType);
//    UInt16 value = 0;
//    for (int i = 0; i < word_wide; i++, line++) {
//        if (is_fast)
//            value = (lctx->value[line] & word->info[i]) ^  word->info[i];
//        else
//            value = lctx->value[line] ^  word->info[i];
//        break_conut += _get1Sum(value);                                             //获得不相同的点数
//        if (break_conut > word->breakcount)                                         //超过设置的跳出点数
//            return false;
//    }
//    printf("%d,%d:", break_conut, word->count);
//    return true;
//}


/* idt 跳过字符高度 */
static
void _jumpWordHeight(LineSearchCtx* ctx, UInt32 idt, DictWord* word) {
    UInt32 word_width = word->width;
    UInt32 height_limit = ctx->cur_row + word->higth;
    printf("_jumpWordHeight %d\n",(unsigned int)height_limit);
    for (UInt32 i = 0; i < word_width; i++) {
        ctx->row_info[idt+i] = height_limit;
    }
}

/* idt 跳过字符宽度,返回跳过后的idt,如果下一个idt为0,返回0 */
static
UInt32 _jumpWordWidth(LineSearchCtx* ctx, UInt32 idt, DictWord* word) {
    UInt32 word_width = word->width;
    UInt32 dif = 0;
    UInt32 old = idt;
    do {
        dif = idt - old;
        if (dif > word_width)
            return idt;
    } while ((idt = ctx->line_info[idt]));
    return idt;
}


static
void __initColors(LineSearchCtx* ctx, NSString* colorStr) {
    
    @autoreleasepool{
        
        MultiColor* idt = &ctx->colors_head;
        
        NSArray* colors = [colorStr componentsSeparatedByString:@"|"];
        size_t count = [colors count];
        
        if (count > COLORS_MAX)
            count = COLORS_MAX;
        
        for (size_t i = 0; i < count; i++) {
            
            MultiColor* new = malloc(sizeof(MultiColor));
            memset(new, 0, sizeof(MultiColor));             //最后一个颜色 next == NULL
            
            NSArray* its = [[colors objectAtIndex:i] componentsSeparatedByString:@"-"];
            
            UInt32 main_color,ps_color;
            
            if ([its count] != 2) {
                main_color = (UInt32)strtoul([[its objectAtIndex:0] UTF8String],0,16);
                ps_color = 0;
            }
            else{
                main_color = (UInt32)strtoul([[its objectAtIndex:0] UTF8String],0,16);
                ps_color = (UInt32)strtoul([[its objectAtIndex:1] UTF8String],0,16);
            }
            
            int max = 0;
            int min = 0;
            
            min = GetR(main_color) - GetR(ps_color);
            max = GetR(main_color) + GetR(ps_color);
            new->range[0] = (min < 0 ? 0:min);
            new->range[1] = (max > 255 ? 255:max);
            printf("min:%08x max:%08x\n",new->range[0],new->range[1]);
            
            min = GetG(main_color) - GetG(ps_color);
            max = GetG(main_color) + GetG(ps_color);
            new->range[2] = (min < 0 ? 0:min);
            new->range[3] = (max > 255 ? 255:max);
            printf("min:%08x max:%08x\n",new->range[2],new->range[3]);
            
            min = GetB(main_color) - GetB(ps_color);
            max = GetB(main_color) + GetB(ps_color);
            new->range[4] = (min < 0 ? 0:min);
            new->range[5] = (max > 255 ? 255:max);
            printf("min:%08x max:%08x\n",new->range[4],new->range[5]);
            
            idt->next = new;
            idt = new;
            
            printf("new color:%p\n",new);
        }
    }
}
static
void _removeColors(LineSearchCtx* ctx) {
    MultiColor* idt = ctx->colors_head.next;
    while (idt != NULL) {
        MultiColor* next = idt->next;
        free(idt);
        idt = next;
    }
    ctx->colors_head.next = NULL;
    return;
}

/* 创建lineSearchCtx */

LineSearchCtx*
createLineSearchCtx(void) {
    size_t size = sizeof(LineSearchCtx);
    LineSearchCtx* lineCtx = (LineSearchCtx*)malloc(size);
    memset(lineCtx, 0, size);
    return lineCtx;
}

UInt32 initLineSearchCtx (MapCtx* gctx, int searchType, LineSearchCtx* lctx,
                            int x, int y, int width, int height, NSString* colors, float sim, int dir, DictWord* dict) {
    
    if (lctx->value == NULL) {
        lctx->value = malloc(sizeof(UInt32)*width);
        memset(lctx->value, 0, (sizeof(UInt32)*width));
        //printf("new value:%p\n",lctx->value);
    }
    
    if (lctx->line_info == NULL) {
        lctx->line_info  = malloc(sizeof(UInt32)*width);
        memset(lctx->line_info, 0, (sizeof(UInt32)*width));
        //printf("new info:%p\n",lctx->info);
    }
    
    if (lctx->row_info == NULL) {
        lctx->row_info  = malloc(sizeof(UInt32)*width);
        memset(lctx->row_info, 0, (sizeof(UInt32)*width));
        //printf("new row_info:%p\n",lctx->row_info);
    }
    
    lctx->x = x;
    lctx->y = y;
    lctx->searchType = searchType;
    lctx->global_width = gctx->width;
    lctx->global_height = gctx->height;
#warning 0
    lctx->line_max = width;                     //不包括最后一个点
    lctx->row_max = height - DICT_HIGH_MAX;     //不包括最后一个点
    lctx->mask = DICT_MASK;
    lctx->dir = dir;
    lctx->data = gctx->data;
    lctx->lineBreak = 0;
    lctx->lineDif = 0;
    lctx->cur_row = 0;
    lctx->result.str = [[NSMutableString alloc]init];
    lctx->result.sum = 0;
    lctx->result.fristX = -1;
    lctx->result.fristY = -1;
    
    
    lineSearchPointTransform(lctx, &x, &y, IPHONE_DIR_STD);       //转换坐标，获得firstPoint
    lctx->point = gctx->width*y + x;
    
    printf("line_max:%d\n",(unsigned int)lctx->line_max);
    printf("row_max:%d\n",(unsigned int)lctx->row_max);
    printf("pointTransform:%d,%d\n",x,y);
    printf("lctx->point:%08x\n",(unsigned int)lctx->point);
    
    initDictSim(dict,sim);          //初始化breadCount
    __initColors(lctx, colors);     //预处理颜色字符串
    
    UInt32* base = lctx->data;
    int point = lctx->point;
    
    //预处理前DICT_HIGH_MAX - 1行的点阵
    for (int idt_width = 0; idt_width < width; idt_width++) {
        UInt32 value = 0;
        int point2 = point;
        
        for (int idt_height = 0; idt_height < (DICT_HIGH_MAX - 1); idt_height++) {        //此处注意减1，只扫描DICT_HIGH_MAX-1个点。
            int c = __getColorUsePt(base, point2);
            value <<= 1;
            if (_comparaPt(lctx, c))
                value |= 1;
            point2 += lineSearchGetNextLineDif(lctx);
        }
        lctx->value[idt_width] = value;
        point += lineSearchGetNextPointDif(lctx);
    }
    
    lctx->point += (lineSearchGetNextLineDif(lctx) * (DICT_HIGH_MAX - 1));               //更新point;
    return 0;
}

void deallocLineSearchCtx(LineSearchCtx* ctx) {
    _removeColors(ctx);
    if (ctx->value != NULL){
        //printf("free value:%p\n",ctx->value);
        free(ctx->value);
    }
    if (ctx->line_info != NULL){
        //printf("free info:%p\n",ctx->info);
        free(ctx->line_info);
    }
    if (ctx->row_info != NULL){
        printf("free row_info:%p\n",ctx->row_info);
        free(ctx->row_info);
    }
    
    [ctx->result.str release];
    free(ctx);
}

UInt32 lineSearchGetNextPointDif(LineSearchCtx* ctx) {
    switch (ctx->dir) {
        case IPHONE_DIR_D:
            return 1;
            break;
        case IPHONE_DIR_R:
            return (ctx->global_width);
            break;
        case IPHONE_DIR_L:
            return -(ctx->global_width);
            break;
        case IPHONE_DIR_U:
            return -1;
            break;
        default:
            assert(0);      //终止
    }
}


UInt32 lineSearchGetNextLineDif(LineSearchCtx* ctx) {
    switch (ctx->dir) {
        case IPHONE_DIR_D:
            return ctx->global_width;
            break;
        case IPHONE_DIR_R:
            return -1;
            break;
        case IPHONE_DIR_L:
            return  1;
            break;
        case IPHONE_DIR_U:
            return -(ctx->global_width);
            break;
        default:
            assert(0);      //终止
    }
}

static
void _insertSearchResult(LineSearchCtx* ctx, int px, int py, DictWord* word) {
    
    int x = ctx->x + px;
    int y = ctx->y + py;
    
    if (ctx->result.fristX == -1) {
        ctx->result.fristX = x;
        ctx->result.fristY = y;
    }
    
    printf("(%d,%d):%s\n",x , y, [word->named UTF8String]);
    
    OcrLineResult* new = (OcrLineResult*)malloc(sizeof(OcrLineResult));
    memset(new, 0, sizeof(OcrLineResult));
    new->x = x;
    new->y = y;
    new->word = word->named;                            //不需要 retain 扫描结束后,ctx->result 会copy
    
    OcrLineResult* curt = &ctx->session;
    
    while (curt && curt->next) {
        OcrLineResult* next = curt->next;
        if (x < next->x) {
            curt->next = new;
            new->next = next;
            return;
        }
        curt = next;
    }
    curt->next = new;
    new->next = NULL;
    
}

static
void _updateSearchResult(LineSearchCtx* ctx) {
    OcrLineResult* result = ctx->session.next;
    while (result != NULL) {
        [ctx->result.str appendString:result->word];    //此处不需copy,ctx->result.str 会copy
        ctx->result.sum ++;
        OcrLineResult* next = result->next;
        free(result);
        result = next;
    }
    ctx->session.next = NULL;
}


/*  遍历字典字库进行找字,找到则返回true,参数 line 为当前idt */
static inline
bool _findWord(LineSearchCtx* ctx, UInt32* idt, DictWord* dict){
    DictWord* pitor = dict;
    while (pitor != NULL) {
        if  (__findWord(ctx, pitor, *idt)) {
            _insertSearchResult(ctx, *idt, ctx->cur_row-1, pitor);
            _jumpWordHeight(ctx, *idt, pitor);                   //跳过字高
            *idt = _jumpWordWidth(ctx, *idt, pitor);             //跳过字宽
            ctx->lineBreak = ctx->cur_row + pitor->higth;        //设置换行标记
            return true;
        }
        pitor = (DictWord*)pitor->next;
    }
    return false;
}


//static
//void _findStrFast(LineSearchCtx* ctx ,DictWord* dict) {
//    while (lineSearchUpdateLineInfo(ctx)) {
//        UInt32 idt_line = 0;
//        do {
//            if  (_findWord(ctx, &idt_line, dict)){
//                _updateSearchResult(ctx);
//                return;
//            }
//            idt_line = ctx->info[idt_line];
//        } while (idt_line);
//    }
//}

static
void _findStr(LineSearchCtx* ctx ,DictWord* dict) {
    bool isOcr = SEARCH_TYPEIS_IS_OCR(ctx->searchType);
    while (lineSearchUpdateLineInfo(ctx)) {
        UInt32 idt_line = 0;
        do {
            if (_findWord(ctx, &idt_line, dict)) {      //如果找到字，idt其实已更新
                if (isOcr)
                    continue;                           //如果是ocr,继续搜索
                else
                    goto end;                           //如果是findstr,结束
            }
            idt_line = ctx->line_info[idt_line];             //没找到，更新idt
        } while (idt_line != 0);
    }
end:
    _updateSearchResult(ctx);                           //最后一次update,更新ocr结果
}


/*   更新line,如果还有剩余行数,返回true   */
bool lineSearchUpdateLineInfo(LineSearchCtx* ctx) {
    
    int width = ctx->line_max;
    int point = ctx->point;
    int mask = ctx->mask;
    
    if (ctx->cur_row >=ctx->row_max){
        _updateSearchResult(ctx);                   //最后一次update,更新ocr结果
        return false;
    }
    
    ctx->cur_row ++ ;
    
    if (ctx->cur_row == ctx->lineBreak) {
        _updateSearchResult(ctx);                   //更新临时ocr结果
        ctx->lineBreak = 0;                         //重置lineBreak
    }
    
    UInt32* base = ctx->data;
    
    int last = 0;
    for (int idt_width = 0; idt_width < width; idt_width++) {
        
        ctx->value[idt_width] <<= 1;
        ctx->value[idt_width] &= mask;                                     //掩码
        
        int c = __getColorUsePt(base, point);                              //获取，对比
        
        if (_comparaPt(ctx, c))
            ctx->value[idt_width] |= 1;                                    //更新
        
        if (ctx->value[idt_width]) {                                       //串入
            if (ctx->cur_row > ctx->row_info[idt_width]) {                 //如果当前行大于设置的跳行,则有效,否则跳过该点
                ctx->line_info[last] = idt_width;
                last = idt_width;
            }
        }
        point += lineSearchGetNextPointDif(ctx);                           //获得下一点偏移
    }
    ctx->line_info[last] = 0;                                                   //设置停止
    ctx->point += lineSearchGetNextLineDif(ctx);
    return true;
}

NSString*
findStr (MapCtx* ctx, int searchType, int x, int y, int width, int height,
         NSString* colors, float sim , int dir, DictWord* dict, int* retX, int* retY, int* sum)
{
    //创建查找上下文
    LineSearchCtx* lineCtx = createLineSearchCtx();
    //初始化
    initLineSearchCtx(ctx, searchType, lineCtx, x, y, width, height, colors, sim, dir, dict);
    _findStr(lineCtx, dict);
    //返回结果拷贝
    NSString* ret = [lineCtx->result.str copy];
    *sum = lineCtx->result.sum;
    *retX = lineCtx->result.fristX;
    *retY = lineCtx->result.fristY;
    //清理查找上下文
    deallocLineSearchCtx(lineCtx);
    return ret;
}


//NSString*
//findStrFast (MapCtx* ctx, int x, int y, int width, int height,
//             NSString* colors, float sim , int dir, DictWord* dict, int* retX, int* retY)
//{
//    LineSearchCtx* lineCtx = createLineSearchCtx();
//    initLineSearchCtx(ctx, lineCtx, x, y, width, height, colors, sim, dir, dict);
//    _findStrFast(lineCtx, dict);
//    NSString* ret = [lineCtx->result.str copy];
//    *retX = lineCtx->result.fristX;
//    *retY = lineCtx->result.fristY;
//    deallocLineSearchCtx(lineCtx);
//    return ret;
//}
