//
//  JRActionSheetViewController.m
//  JRSystemActionSheetView
//
//  Created by Mr.D on 2018/12/7.
//  Copyright © 2018 Mr.D. All rights reserved.
//

#import "JRActionSheetViewController.h"

@interface JRActionSheetViewController ()

@property (strong, nonatomic) UIWindow *window;

@property (weak, nonatomic) UIView *contentView;

@property (weak, nonatomic) UIButton *cancelBtn;

@end

@implementation JRActionSheetViewController

static JRActionSheetViewController *_onlyActionSheetVC = nil;

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message
{
    if (!_onlyActionSheetVC) {
        _onlyActionSheetVC = [[JRActionSheetViewController alloc] init];
    }
    return _onlyActionSheetVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSAssert(_onlyActionSheetVC != nil, @"fuck you");
    [_onlyActionSheetVC _addGestGestureRecognizer];
    [_onlyActionSheetVC _createActionSheetView];
}

- (void)dealloc
{
    _window = nil;
    _contentView = nil;
    _cancelBtn = nil;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect rect = _onlyActionSheetVC.contentView.frame;
    CGFloat safeAreaBottom = 0.f;
    if (@available(iOS 11.0, *)) {
        safeAreaBottom = _onlyActionSheetVC.view.safeAreaInsets.bottom;
    }
    rect.size.height = CGRectGetHeight(_onlyActionSheetVC.view.frame)*3/4-20.f-safeAreaBottom;
    rect.size.width = MIN(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    if (CGRectGetWidth(rect)==CGRectGetWidth(_onlyActionSheetVC.view.frame)) {
        rect.size.width -= 30.f;
    }
    rect.origin.x = (CGRectGetWidth(_onlyActionSheetVC.view.frame)-CGRectGetWidth(rect))/2;
    rect.origin.y = CGRectGetHeight(_onlyActionSheetVC.view.frame)/4;
    _onlyActionSheetVC.contentView.frame = rect;
}

#pragma mark - Private Mtehods
#pragma mark 点击手势
- (void)_addGestGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:_onlyActionSheetVC action:@selector(_UITapGestureRecognizer)];
    [_onlyActionSheetVC.view addGestureRecognizer:tap];
}

- (void)_UITapGestureRecognizer
{
    [_onlyActionSheetVC _hiddenView];
}

- (void)_hiddenView
{
    if (_onlyActionSheetVC.window) {
        [UIView animateWithDuration:0.25f animations:^{
            CGRect frame = _onlyActionSheetVC.view.frame;
            frame.origin.y += frame.size.height;
            _onlyActionSheetVC.view.frame = frame;
        } completion:^(BOOL finished) {
            [_onlyActionSheetVC.window resignKeyWindow];
            [_onlyActionSheetVC.window removeFromSuperview];
            _onlyActionSheetVC.window = nil;
            _onlyActionSheetVC = nil;
        }];
    }
}

- (void)_createActionSheetView
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
    containerView.backgroundColor = [UIColor whiteColor];
    CATransition *animation = [CATransition animation];
    //动画时间
    animation.duration = 0.25f;
    //过滤效果
    animation.type = kCATransitionPush;
    //动画执行完毕时是否被移除
    animation.removedOnCompletion = YES;
    //设置方向-该属性从下往上弹出
    animation.subtype = kCATransitionFromTop;
    [containerView.layer addAnimation:animation forKey:nil];
    [_onlyActionSheetVC.view addSubview:containerView];
    _onlyActionSheetVC.contentView = containerView;
}

#pragma mark - Public Methods
- (void)show
{
    _onlyActionSheetVC.view.backgroundColor = [UIColor colorWithWhite:0.4f alpha:0.456789f];
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.windowLevel = UIWindowLevelNormal+1;
    window.backgroundColor = [UIColor clearColor];
    self.window = window;

//    CATransition *animation = [CATransition animation];
//    //动画时间
//    animation.duration = 0.25f;
//    //过滤效果
//    animation.type = kCATransitionPush;
//    //动画执行完毕时是否被移除
//    animation.removedOnCompletion = YES;
//    //设置方向-该属性从下往上弹出
//    animation.subtype = kCATransitionFromTop;
//    [window.layer addAnimation:animation forKey:nil];
    window.rootViewController = self;
    [window makeKeyAndVisible];
}


@end
