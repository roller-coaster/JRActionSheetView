//
//  JRActionSheetView.h
//  JRImageViewDemo
//
//  Created by Mr.D on 2017/11/28.
//  Copyright © 2017年 Mr.D. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JRAlertActionStyle) {
    JRAlertActionStyleDefault = 0, //默认
    JRAlertActionStyleCancel,   //取消
    JRAlertActionStyleDestructive //会红色提示
};

#pragma mark ----JRAlertAction(start)----
@interface JRAlertAction : NSObject

+ (instancetype _Nullable )alerActionWithTitle:(nullable NSString *)title style:(JRAlertActionStyle)style handler:(void (^ __nullable)(JRAlertAction * _Nullable action))handler;
@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) JRAlertActionStyle style;

@end
#pragma mark ----JRAlertAction(end)----

@interface JRActionSheetView : UIView

+ (instancetype _Nullable )actionSheetViewWithTitle:(nullable NSString *)title message:(nullable NSString *)message;

/** 添加行 */
- (void)addJRAlertAction:(JRAlertAction *_Nullable)action;

/** 设置选择行 */
- (void)setSelectAlertAction:(JRAlertAction *_Nullable)alertAction;

@property (nonatomic, readonly) NSArray<JRAlertAction *> * _Nullable alartActions;

@property (nonatomic, readonly) JRAlertAction * _Nullable selectedAlertAction;
/**
 显示view
 */
- (void)show;

@end
