//
//  JRActionSheetView.m
//  JRImageViewDemo
//
//  Created by Mr.D on 2017/11/28.
//  Copyright © 2017年 Mr.D. All rights reserved.
//

#import "JRActionSheetView.h"

#pragma mark
#pragma mark ----JRAlertAction(start)----
@interface JRSheetAction ()

@property (copy, nonatomic) void(^alarActionBlock)(JRSheetAction * action);

@property (assign, nonatomic) BOOL isSelect;
@end

@implementation JRSheetAction

+ (instancetype)sheetActionWithTitle:(NSString *)title style:(JRAlertActionStyle)style handler:(void (^)(JRSheetAction * _Nullable))handler{
    JRSheetAction *alerAction = [[JRSheetAction alloc] initWithTitle:title style:style];
    alerAction.alarActionBlock = handler;
    return alerAction;
}

- (instancetype)initWithTitle:(NSString *)title style:(JRAlertActionStyle)style{
    self = [super init];
    if (self) {
        _title = title;
        _style = style;
    }return self;
}

#pragma mark style取颜色
+ (UIColor *)jr_coverJRAlertActionStyle:(JRAlertActionStyle)style{
    UIColor *color = [UIColor colorWithRed:21.0f/255.0f green:126.0f/255.0f blue:251.0f/255.0f alpha:1.0f];
    if (style == JRAlertActionStyleDestructive) color = [UIColor colorWithRed:252.0f/255.0f green:61.0f/255.0f blue:57.0f/255.0f alpha:1.0f];
    return color;
}
@end
#pragma mark ----JRAlertAction(end)----
#pragma mark
#pragma mark -----UIView+JRFindSuperView(start)-----
@interface UIView (JRFindSuperView)


@end

@implementation UIView (JRFindSuperView)

#pragma mark 查找键盘的父视图
+ (UIView *)jr_findKeyboardView
{
    UIView *keyboardView = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for(UIWindow *window in [windows reverseObjectEnumerator]){
        keyboardView = [self findKeyboardInView:window];
        if(keyboardView)
        {
            return keyboardView;
        }
    }
    return nil;
}

+ (UIView *)findKeyboardInView:(UIView *)view
{
    for(UIView *subView in [view subviews]){
        if(strstr(object_getClassName(subView), "UIInputSetContainerView"))
        {
            for (UIView *possibleKeyboard in [subView subviews]) {
                if (strstr(object_getClassName(possibleKeyboard), "UIInputSetHostView"))
                {
                    /** possibleKeyboard的高度有可能为0，需要跳过 */
                    if (possibleKeyboard.frame.size.height > 0) {
                        /** 返回上级superView */
                        return subView;
                    }
                }
            }
        }else{
            UIView *tempView = [self findKeyboardInView:subView];
            if(tempView){
                return tempView;
            }
        }
    }
    return nil;
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
#pragma mark ---UIView+JRFindSuperView(end)-----
#pragma mark
#pragma mark ---JRActionSheetViewTableViewCell(start)-----
@interface JRActionSheetViewTableViewCell : UITableViewCell

@property (nonatomic, weak, readonly) UIImageView *headImgView;

@property (nonatomic, weak, readonly) UILabel *titleLab;

@property (nonatomic, readonly) JRSheetAction *alaertAction;

- (void)setCellData:(JRSheetAction *)action;

+ (CGFloat)JRActionSheetViewTableViewCellForHeight;
@end

@implementation JRActionSheetViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createCutomView];
    }return self;
}

- (void)setCellData:(JRSheetAction *)action{
    _alaertAction = action;
    _titleLab.text = action.title;
    _titleLab.textColor = [JRSheetAction jr_coverJRAlertActionStyle:action.style];
//    [self setAccessoryType:UITableViewCellAccessoryNone];
//    if (action.isSelect) [self setAccessoryType:UITableViewCellAccessoryCheckmark];
}

+ (CGFloat)JRActionSheetViewTableViewCellForHeight{
    return 60.0f;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.contentView.frame);
    _headImgView.hidden = !_headImgView.image;
    if (!_headImgView.hidden) [_headImgView setFrame:CGRectMake(15, 15, 30, 30)];
    _titleLab.hidden = _titleLab.text.length > 0 ? NO : YES;
    if (_titleLab) {
        CGRect rect = CGRectMake(60, 15, width - 60 - 30, 30);
        if (_headImgView.hidden) {
            rect.origin.x = 15;
            rect.size.width = width - 30;
        }
        [_titleLab setFrame:rect];
    }
}

#pragma mark Private Methods
- (void)createCutomView{
    if (!_headImgView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
        [self.contentView addSubview:imageView];
        _headImgView = imageView;
    }
    if (!_titleLab) {
        UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, 100, 30)];
        customLab.textAlignment = NSTextAlignmentCenter;
        customLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self.contentView addSubview:customLab];
        _titleLab = customLab;
    }
}

@end

#pragma mark ---JRActionSheetViewTableViewCell(end)-----
#pragma mark
#pragma mark ---JRActionSheetView(start)-----

CGFloat const JRActionSheetView_CancelBtn_Hight = 60.0f;
CGFloat const JRActionSheetView_Default_Margin = 10.0f;
CGFloat const JRActionSheetView_Default_CornerRadius = 10.0f;

@interface JRActionSheetView () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIButton *cancelBtn;

@property (nonatomic, weak) UIView *topView;

@property (nonatomic, weak) UITableView *myTableView;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, weak) UITextView *textView;

@property (nonatomic, weak) UIView *lineView;
/** 标题view和tableView容器 */
@property (nonatomic, weak) UIView *backgroundView;

@end

@implementation JRActionSheetView

#pragma mark - Public Methods

static JRActionSheetView *_onlyOneJRActionSheetView = nil;

+ (instancetype)actionSheetViewWithTitle:(NSString *)title message:(NSString *)message{
    if (!_onlyOneJRActionSheetView) {
        JRActionSheetView *customView = [[JRActionSheetView alloc] initWithFrame:[UIScreen mainScreen].bounds title:title message:message];
        customView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        customView.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.8f];
        _onlyOneJRActionSheetView = customView;
    }
    return _onlyOneJRActionSheetView;
}


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)message{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        _message = message;
        [self createBackgroundView];
    }return self;
}

#pragma mark 添加action
- (void)addJRSheetAction:(JRSheetAction *)action{
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:self.alartActions];
    if (action) {
        JRSheetAction *cancelAction = nil;
        for (JRSheetAction *alertActtion in muArr) {
            if (alertActtion.style == JRAlertActionStyleCancel) {
                cancelAction = alertActtion;
                break;
            }
        }
        if (cancelAction) {
            if (action.style == JRAlertActionStyleCancel) {
                NSAssert(NO, @"卧槽，不能添加2个cancel");
            }
        } else {
            if (action.style == JRAlertActionStyleCancel) {
                [self createCancelButtonWith:action];
                [self addTapGesture];
            }
        }
        [muArr addObject:action];
        /** 创建tableView滚动视图 */
        [self createMyTableView];
    }
    _alartActions = [muArr copy];
}

/** 视图堆栈 */
static NSMutableArray *_jrActionSheetViewArrs = nil;
#pragma mark 展示出来
- (void)show{
    /** 可以连续show出来 */
//    if (!_jrActionSheetViewArrs) _jrActionSheetViewArrs = @[].mutableCopy;
//    [_jrActionSheetViewArrs addObject:self];
//    for (UIView *actionSheetView in _jrActionSheetViewArrs) {
//        if (![actionSheetView isEqual:self]) {
//            actionSheetView.hidden = YES;
//            continue;
//        }
//    }
    if (_myTableView) [_myTableView reloadData];
    UIView *keyBoardView = [UIView jr_findKeyboardView];
    if(keyBoardView){
        [keyBoardView addSubview:self];
    }else{
        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
        [window addSubview:self];
    }

}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat iPhoneXSafe_bottom = 0;
    if (@available(iOS 11.0, *)) {
        iPhoneXSafe_bottom = self.safeAreaInsets.bottom;
    }
    CGFloat width = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    CGFloat height = CGRectGetHeight(self.frame) - iPhoneXSafe_bottom;
    CGRect cancalBtnF = CGRectZero;
    CGRect myTableViewF = CGRectZero;
    CGRect backgroundF = CGRectMake(JRActionSheetView_Default_Margin, height/3, width - JRActionSheetView_Default_Margin*2, height*2/3-JRActionSheetView_Default_Margin);
    CGRect topViewF = CGRectZero;
    CGFloat topViewHeight = [self heightForHeaderViewForSection:width - JRActionSheetView_Default_Margin*2];
    if (_cancelBtn){
        cancalBtnF = CGRectMake(JRActionSheetView_Default_Margin, height - JRActionSheetView_CancelBtn_Hight - JRActionSheetView_Default_Margin, width - JRActionSheetView_Default_Margin*2, JRActionSheetView_CancelBtn_Hight);
        [_cancelBtn setFrame:cancalBtnF];
        _cancelBtn.layer.cornerRadius = JRActionSheetView_Default_CornerRadius;
        /** 减去按钮的高度 */
        backgroundF.size.height -= (JRActionSheetView_CancelBtn_Hight+JRActionSheetView_Default_Margin);
        [_cancelBtn setCenter:CGPointMake(CGRectGetWidth(self.frame)/2, _cancelBtn.center.y)];
    }

    if (_backgroundView) {
        CGFloat beforeHeight = CGRectGetHeight(backgroundF);
        if (_textView) {
            _textView.scrollEnabled = NO;
            if (beforeHeight/2 < topViewHeight) {
                topViewHeight = beforeHeight/2;
                _textView.scrollEnabled = YES;
            }
            topViewF = CGRectMake(0, 0,CGRectGetWidth(backgroundF), topViewHeight);
            [_textView setFrame:topViewF];
        }
        if (_myTableView) {
            if (_textView) {
                [_lineView setFrame:CGRectMake(0, CGRectGetMaxY(_textView.frame), CGRectGetWidth(backgroundF), .5f)];
                _lineView.hidden = NO;
            }
            /** cell的总高度 */
            CGFloat cellTotalHeight = [self getDataSource].count * JRActionSheetView_CancelBtn_Hight;
            BOOL isScroll = YES;
            /** tableView实际高度 */
            CGFloat myTableViewHeight = CGRectGetHeight(backgroundF) - topViewHeight;
            if (myTableViewHeight > cellTotalHeight) {
                myTableViewHeight = cellTotalHeight;
                isScroll = NO;
            }
            myTableViewF = CGRectMake(0, CGRectGetMaxY(topViewF)+CGRectGetHeight(_lineView.frame), CGRectGetWidth(backgroundF), myTableViewHeight-CGRectGetHeight(_lineView.frame));
            _myTableView.scrollEnabled = isScroll;
            [_myTableView setFrame:myTableViewF];
        }
        backgroundF.size.height = topViewHeight + CGRectGetHeight(myTableViewF);
        backgroundF.origin.y += beforeHeight - CGRectGetHeight(backgroundF);
        [_backgroundView setFrame:backgroundF];
        _backgroundView.layer.masksToBounds = YES;
        [_backgroundView.layer setCornerRadius:JRActionSheetView_Default_CornerRadius];
        [_backgroundView setCenter:CGPointMake(CGRectGetWidth(self.frame)/2, _backgroundView.center.y)];
    }

}

- (void)setSelectAlertAction:(JRSheetAction *)alertAction{
    alertAction.isSelect = YES;
    _selectedAlertAction = alertAction;
}
#pragma mark - Private Methods
#pragma mark 取消按钮
- (void)createCancelButtonWith:(JRSheetAction *)action {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setFrame:CGRectMake(JRActionSheetView_Default_Margin, height - JRActionSheetView_CancelBtn_Hight - JRActionSheetView_Default_Margin, width - JRActionSheetView_Default_Margin*2, JRActionSheetView_CancelBtn_Hight)];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [button setTitle:action.title forState:(UIControlStateNormal)];
    [button setTitleColor:[JRSheetAction jr_coverJRAlertActionStyle:action.style] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancalButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:button];
    _cancelBtn = button;

}

- (void)cancalButtonAction{
    [self hiddenJRActionSheetView];

}

#pragma mark 点击
- (void)addTapGesture{
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancalButtonAction)];
    tapGest.delegate = self;
    [self addGestureRecognizer:tapGest];
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;//关闭手势
    }//否则手势存在
    return YES;
}


#pragma mark 移除视图
- (void)hiddenJRActionSheetView{
    [UIView animateWithDuration:0.5f animations:^{
        [self removeFromSuperview];
        _onlyOneJRActionSheetView = nil;
//        [_jrActionSheetViewArrs removeObject:self];
//        JRActionSheetView *actionSheetView = [_jrActionSheetViewArrs lastObject];
//        [UIView animateWithDuration:0.15f animations:^{
//            if (actionSheetView) actionSheetView.hidden = NO;
//        }];
    }];
}

#pragma mark 创建容器
- (void)createBackgroundView{
    if (!_backgroundView) {
        CGFloat width = CGRectGetWidth(self.frame);
        CGFloat height = CGRectGetHeight(self.frame);
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(JRActionSheetView_Default_Margin, height/2, width - JRActionSheetView_Default_Margin*2, height/2-JRActionSheetView_Default_Margin)];
        customView.backgroundColor = [UIColor whiteColor];
        [self addSubview:customView];
        _backgroundView = customView;

        UIView *custmLineView = [UIView new];
        custmLineView.backgroundColor = [UIColor grayColor];
        custmLineView.hidden = YES;
        [_backgroundView addSubview:custmLineView];
        _lineView = custmLineView;
        [self createTextView];
    }
}

#pragma mark 创建标题View
- (void)createTextView{
    if (_title || _message) {
        UITextView *customTextView = [[UITextView alloc] initWithFrame:CGRectMake(JRActionSheetView_Default_Margin, 0, CGRectGetWidth(_backgroundView.frame), 100)];
        customTextView.font = [UIFont boldSystemFontOfSize:15.0f];
        if (_title.length > 0) customTextView.text = [NSString stringWithFormat:@"%@ \n", _title];
        customTextView.textColor = [UIColor grayColor];
        customTextView.editable = NO;
        customTextView.selectable = NO;
        customTextView.textAlignment = NSTextAlignmentCenter;
        customTextView.backgroundColor = [UIColor whiteColor];
        _textView = customTextView;
        [_backgroundView addSubview:_textView];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.alignment = NSTextAlignmentCenter;
        if (_message.length > 0)[_textView.textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _message] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName:paragraph}]];
    }
}

#pragma mark 创建MyTableView
- (void)createMyTableView {
    if (!_myTableView) {
        UITableView *customTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        customTableView.delegate = self;
        customTableView.dataSource = self;
        customTableView.backgroundColor = [UIColor whiteColor];
        [_backgroundView addSubview:customTableView];
        _myTableView = customTableView;
        /** 这个设置iOS9以后才有，主要针对iPad，不设置的话，分割线左侧空出很多 */
        if ([_myTableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
            if (@available(iOS 9.0, *)) {
                _myTableView.cellLayoutMarginsFollowReadableWidth = NO;
            } else {
                // Fallback on earlier versions
            }
        }
        /** 解决ios7中tableview每一行下面的线向右偏移的问题 */
        if ([_myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_myTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        /** 解决iOS11自动计算内边距问题 */
        if (@available(iOS 11.0, *)) {
            [_myTableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    }
}

#pragma mark 获取tableView数据源
- (NSArray *)getDataSource {
    NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:2];
    for (JRSheetAction *alertAction in self.alartActions) {
        if (alertAction.style != JRAlertActionStyleCancel) {
            [muArr addObject:alertAction];
        }
    }
    return [muArr copy];
}

#pragma mark 计算文字高度
- (CGFloat)heightForHeaderViewForSection:(CGFloat)width{
    CGFloat height = 0;
    if (_title || _message) {
        UIFont *titleFont = [UIFont boldSystemFontOfSize:15.0f];
        UIFont *messageFont = [UIFont systemFontOfSize:15.0f];
        CGSize titleSize = CGSizeMake(0, 10);
        CGSize messageSize = CGSizeMake(0, 10);
        if (_title.length > 0) titleSize = [[NSString stringWithFormat:@"%@", _title] boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:titleFont} context:nil].size;
        if (_message.length > 0) messageSize = [_message boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:messageFont} context:nil].size;
        if (_title.length > 0 && _message.length > 0) {
            if (_title.length > 0) titleSize = [[NSString stringWithFormat:@"%@ \n", _title] boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:titleFont} context:nil].size;
            if (_message.length > 0) messageSize = [_message boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:messageFont} context:nil].size;
        }
        height = titleSize.height + messageSize.height + JRActionSheetView_Default_Margin;
    }
    return height;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self getDataSource].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"JRCustomActionSheetCell";
    JRActionSheetViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[JRActionSheetViewTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    JRSheetAction *alertAction = [self getDataSource][indexPath.row];
    [cell setCellData:alertAction];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return JRActionSheetView_CancelBtn_Hight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hiddenJRActionSheetView];
    JRSheetAction *alertAction = [self getDataSource][indexPath.row];
    alertAction.alarActionBlock(alertAction);
}


@end


