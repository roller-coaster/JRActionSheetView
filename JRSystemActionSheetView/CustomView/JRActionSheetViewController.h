//
//  JRActionSheetViewController.h
//  JRSystemActionSheetView
//
//  Created by Mr.D on 2018/12/7.
//  Copyright © 2018 Mr.D. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JRActionSheetViewController : UIViewController

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message;

//- (void)addAction:(UIAlertAction *)action;

- (void)show;

@end

NS_ASSUME_NONNULL_END
