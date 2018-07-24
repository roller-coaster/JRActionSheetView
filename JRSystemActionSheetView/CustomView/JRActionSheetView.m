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

/** 容器 */
@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, weak) UIView *subContentView;

@property (nonatomic, strong) NSMutableArray *defaultArrs;

@end

@implementation JRActionSheetView

#pragma mark - Public Methods

static JRActionSheetView *_onlyOneJRActionSheetView = nil;

+ (instancetype)actionSheetViewWithTitle:(NSString *)title message:(NSString *)message{
    if (!_onlyOneJRActionSheetView) {
        JRActionSheetView *customView = [[JRActionSheetView alloc] initWithFrame:[UIScreen mainScreen].bounds title:title message:message];
        customView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        customView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.0f];
        _onlyOneJRActionSheetView = customView;
    }
    return _onlyOneJRActionSheetView;
}


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)message{
    self = [super initWithFrame:frame];
    if (self) {
        _defaultArrs = @[].mutableCopy;
        [self createBackgroundView];
        [self createSubContentView];
        _title = title;
        _message = message;
        [self createTextView];
        /** 创建tableView滚动视图 */
        [self createMyTableView];
        [self addTapGesture];
    }return self;
}

#pragma mark 添加action
- (void)addJRSheetAction:(JRSheetAction *)action{
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:self.alartActions];
    if (action) {
        if (action.style == JRAlertActionStyleCancel) {
            for (JRSheetAction *cancelAction in self.alartActions) {
                if (cancelAction.style == JRAlertActionStyleCancel) {
                    if ([muArr containsObject:cancelAction]) {
                        [muArr removeObject:cancelAction];
                    }
                    break;
                }
            }
            [self createCancelButtonWith:action];
        } else {
            [_defaultArrs addObject:action];
        }
        [muArr addObject:action];
    }
    _alartActions = [muArr copy];
}

- (void)insertJRSheetAction:(JRSheetAction *)action atIndex:(NSUInteger)index {
    if (action) {
        if (![_defaultArrs containsObject:action] && action.style != JRAlertActionStyleCancel) {
            NSMutableArray *muArr = [NSMutableArray arrayWithArray:self.alartActions];
            [muArr addObject:action];
            if (index > _defaultArrs.count) {
                index = _defaultArrs.count;
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            if (_myTableView) {
                [_myTableView beginUpdates];
                [_defaultArrs insertObject:action atIndex:index];
                [_myTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
                [_myTableView endUpdates];
            }
        }
    }
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
    if (_myTableView) {
        [_myTableView reloadData];
    }
    UIView *keyBoardView = [UIView jr_findKeyboardView];
    /** 有键盘先收起键盘再弹出 */
    if(keyBoardView) [keyBoardView setHidden:YES];
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    CGRect backgroudViewF = _contentView.frame;
    backgroudViewF.origin.y = CGRectGetHeight(self.frame)/3;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25f delay:0.0f options:(UIViewAnimationOptionCurveLinear) animations:^{
        weakSelf.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.7987f];
        weakSelf.contentView.frame = backgroudViewF;
        weakSelf.contentView.frame = backgroudViewF;
    } completion:^(BOOL finished) {

    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat iPhoneXSafe_bottom = 0;
    if (@available(iOS 11.0, *)) {
        iPhoneXSafe_bottom = self.safeAreaInsets.bottom;
    }
    CGFloat width = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    CGFloat height = CGRectGetHeight(self.frame) - iPhoneXSafe_bottom;
    _contentView.frame = CGRectMake(JRActionSheetView_Default_Margin, height/3, width-JRActionSheetView_Default_Margin*2, height*2/3-JRActionSheetView_Default_Margin);
    [_contentView setCenter:CGPointMake(CGRectGetWidth(self.frame)/2, _contentView.center.y)];
    CGRect backgroudViewF = _contentView.frame;


    CGRect cancalBtnF = _cancelBtn.frame;
    if (_cancelBtn) {
        cancalBtnF = CGRectMake(0, CGRectGetHeight(backgroudViewF) - JRActionSheetView_CancelBtn_Hight - JRActionSheetView_Default_Margin, CGRectGetWidth(backgroudViewF), JRActionSheetView_CancelBtn_Hight);
        [_cancelBtn setFrame:cancalBtnF];
        _cancelBtn.layer.cornerRadius = JRActionSheetView_Default_CornerRadius;
    }

    if (!_myTableView && !_textView) return;
    CGFloat subContentViewHeight_Max = CGRectGetMinY(cancalBtnF) - JRActionSheetView_Default_Margin;
    CGFloat textViewHeight = [self heightForHeaderViewForSection:CGRectGetWidth(backgroudViewF)];
    CGRect textViewF = CGRectZero;
    CGRect myTableViewF = CGRectZero;
    if (_textView) {
        _textView.scrollEnabled = NO;
        if (subContentViewHeight_Max/2 < textViewHeight) {
            textViewHeight = subContentViewHeight_Max/2;
            _textView.scrollEnabled = YES;
        }
        textViewF = CGRectMake(0, 0, CGRectGetWidth(backgroudViewF), textViewHeight);
    }
    if (_myTableView) {
        /** cell的总高度 */
        CGFloat cellTotalHeight = [self getDataSource].count * JRActionSheetView_CancelBtn_Hight;
        BOOL isScroll = YES;
        /** tableView实际高度 */
        CGFloat myTableViewHeight = subContentViewHeight_Max - textViewHeight;
        if (myTableViewHeight > cellTotalHeight) {
            myTableViewHeight = cellTotalHeight;
            isScroll = NO;
        }
        _myTableView.scrollEnabled = isScroll;
        myTableViewF = CGRectMake(0, textViewHeight+.4f, CGRectGetWidth(backgroudViewF), myTableViewHeight-.4f);
    }
    _subContentView.frame = CGRectMake(0, subContentViewHeight_Max-CGRectGetHeight(myTableViewF)-CGRectGetHeight(textViewF), CGRectGetWidth(backgroudViewF), CGRectGetHeight(textViewF)+CGRectGetHeight(myTableViewF));
    _subContentView.layer.masksToBounds = YES;
    _subContentView.layer.cornerRadius = JRActionSheetView_Default_CornerRadius;
    _myTableView.frame = myTableViewF;
    _textView.frame = textViewF;
}

//- (void)setSelectAlertAction:(JRSheetAction *)alertAction{
//    alertAction.isSelect = YES;
//    _selectedAlertAction = alertAction;
//}
#pragma mark - Private Methods
#pragma mark 取消按钮
- (void)createCancelButtonWith:(JRSheetAction *)action {
    if (!_cancelBtn) {
        CGFloat width = CGRectGetWidth(_contentView.frame);
        CGFloat height = CGRectGetHeight(_contentView.frame);
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setFrame:CGRectMake(0, height - JRActionSheetView_CancelBtn_Hight - JRActionSheetView_Default_Margin, width, JRActionSheetView_CancelBtn_Hight)];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
        [button addTarget:self action:@selector(cancalButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_contentView addSubview:button];
        _cancelBtn = button;
    }
    [_cancelBtn setTitle:action.title forState:(UIControlStateNormal)];
    [_cancelBtn setTitleColor:[JRSheetAction jr_coverJRAlertActionStyle:action.style] forState:UIControlStateNormal];
}

- (void)cancalButtonAction{
    JRSheetAction *cancelAction = nil;
    for (JRSheetAction *alertActtion in self.alartActions) {
        if (alertActtion.style == JRAlertActionStyleCancel) {
            cancelAction = alertActtion;
            break;
        }
    }
    [self hiddenJRActionSheetView:^(BOOL finished) {
        if (cancelAction && cancelAction.alarActionBlock) cancelAction.alarActionBlock(cancelAction);
    }];
}

#pragma mark 点击
- (void)addTapGesture{
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancalButtonAction)];
    tapGest.delegate = self;
    [self addGestureRecognizer:tapGest];
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    id obj = NSStringFromClass([touch.view class]);
    if ([obj isEqualToString:@"UITableViewCellContentView"] || [obj isEqualToString:@"UITextView"]) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;//关闭手势
    }//否则手势存在
    return YES;
}


#pragma mark 移除视图
- (void)hiddenJRActionSheetView:(void(^)(BOOL finished))completion{
    CGRect backgroudViewF = _contentView.frame;
    backgroudViewF.origin.y = CGRectGetHeight(self.frame);
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25f delay:0.0f options:(UIViewAnimationOptionCurveLinear) animations:^{
        weakSelf.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:.0f];
        weakSelf.contentView.frame = backgroudViewF;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        _onlyOneJRActionSheetView = nil;
        if (completion) completion(YES);
    }];
}

#pragma mark 创建容器
- (void)createBackgroundView{
    if (!_contentView) {
        CGFloat width = CGRectGetWidth(self.frame);
        CGFloat height = CGRectGetHeight(self.frame);
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(JRActionSheetView_Default_Margin, height, width - JRActionSheetView_Default_Margin*2, height*2/3-JRActionSheetView_Default_Margin)];
        customView.backgroundColor = [UIColor clearColor];
        [self addSubview:customView];
        _contentView = customView;

//        UIView *custmLineView = [UIView new];
//        custmLineView.backgroundColor = [UIColor grayColor];
//        custmLineView.hidden = YES;
//        [_contentView addSubview:custmLineView];
//        _lineView = custmLineView;
//        [self createTextView];
    }
}

#pragma mark 创建标题View
- (void)createTextView{
    if (_title || _message) {
        UITextView *customTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        customTextView.font = [UIFont boldSystemFontOfSize:15.0f];
        if (_title.length > 0) customTextView.text = [NSString stringWithFormat:@"%@ \n", _title];
        customTextView.textColor = [UIColor grayColor];
        customTextView.editable = NO;
        customTextView.selectable = NO;
        customTextView.textAlignment = NSTextAlignmentCenter;
        customTextView.backgroundColor = [UIColor whiteColor];
        _textView = customTextView;
        [_subContentView addSubview:_textView];
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
        [_subContentView addSubview:customTableView];
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

#pragma mark 创建子容器
- (void)createSubContentView{
    if (!_subContentView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor lightGrayColor];
        view.userInteractionEnabled = YES;
        [_contentView addSubview:view];
        _subContentView = view;
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
    return _defaultArrs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"JRCustomActionSheetCell";
    JRActionSheetViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[JRActionSheetViewTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    JRSheetAction *alertAction = _defaultArrs[indexPath.row];
    [cell setCellData:alertAction];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return JRActionSheetView_CancelBtn_Hight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self)weakSelf = self;
    [self hiddenJRActionSheetView:^(BOOL finished) {
        JRSheetAction *alertAction = [weakSelf getDataSource][indexPath.row];
        if (alertAction.alarActionBlock) alertAction.alarActionBlock(alertAction);
    }];
}


@end


