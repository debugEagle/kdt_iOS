

#import "KDTTxtController.h"
#import "UIImage+RXExtension.h"
#import "UIBarButtonItem+RXExtension.h"
#import "conf.h"

@interface KDTTxtController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation KDTTxtController

+(instancetype) sharedInstance {
    static id _webController;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _webController = [[self alloc] init];
    });
    return _webController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.textView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    self.textView.text = self.text;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setIsModalStyle:(BOOL)isModalStyle
{
    _isModalStyle = isModalStyle;
    
    if (self.isModalStyle) {
        UIBarButtonItem *cancelItem = [UIBarButtonItem rx_barBtnItemWithNmlImg:@"Login_close_btn"
                                                                     hltImg:@"Login_close_btn"
                                                                     target:self
                                                                     action:@selector(backButtonDidClick)];
        self.navigationItem.rightBarButtonItem = cancelItem;
        
        self.navigationItem.leftBarButtonItem = nil;
    }else{
        UIBarButtonItem *shareItem = [UIBarButtonItem rx_barBtnItemWithNmlImg:@"share_item_icon"
                                                                    hltImg:@"share_item_icon"
                                                                    target:self
                                                                    action:@selector(shareItemDidClick)];
        self.navigationItem.rightBarButtonItem = shareItem;
    }
}

- (void)shareItemDidClick
{
    
}

- (void)backButtonDidClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.frame = CGRectMake(0, 64, kScreen_Width, kScreen_Height);
        _textView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    }
    return _textView;
}

- (void)setText:(NSString *)text
{
    _text = text;
}
@end
