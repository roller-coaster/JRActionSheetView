//
//  ViewController.m
//  JRSystemActionSheetView
//
//  Created by Mr.D on 2017/12/4.
//  Copyright © 2017年 Mr.D. All rights reserved.
//

#import "ViewController.h"
#import "JRActionSheetView.h"

@interface ViewController ()
{
    UIImageView *imgV;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)showSimpleDemo:(id)sender {

//    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"123" message:@"223" preferredStyle:(UIAlertControllerStyleActionSheet)];
//    [alertCon addAction:[UIAlertAction actionWithTitle:@"22" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
//
//    }]];
//    for (NSInteger i = 0; i < 5; i ++) {
//        [alertCon addAction:[UIAlertAction actionWithTitle:@"22" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//
//        }]];
//    }
//    [alertCon addAction:[UIAlertAction actionWithTitle:@"22" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
//
//    }]];
//    [self.navigationController presentViewController:alertCon animated:YES completion:nil];
//    return;
    JRActionSheetView *actionSheetView = [JRActionSheetView actionSheetViewWithTitle:@"很多被窝" message:@"堤村"];
    [actionSheetView addJRSheetAction:[JRSheetAction sheetActionWithTitle:@"222" style:(JRAlertActionStyleCancel) handler:^(JRSheetAction * _Nullable action) {
        JRActionSheetView *jr1 = [JRActionSheetView actionSheetViewWithTitle:@"取消" message:@"我是取消弹出来的"];
        [jr1 addJRSheetAction:[JRSheetAction sheetActionWithTitle:@"取消" style:JRAlertActionStyleCancel handler:nil]];
        for (NSInteger i = 0; i < 10; i ++) {
            JRSheetAction *action1 = [JRSheetAction sheetActionWithTitle:@"test" style:(JRAlertActionStyleDefault) handler:^(JRSheetAction * _Nullable action) {
                NSLog(@"🎮🎮🎮🎮%ld", (long)i);
            }];
            [jr1 addJRSheetAction:action1];
        }
        [jr1 show];
    }]];
    for (NSInteger i = 0; i < 10; i ++) {
        JRSheetAction *action = [JRSheetAction sheetActionWithTitle:@"test" style:(JRAlertActionStyleDefault) handler:^(JRSheetAction * _Nullable action) {
            NSLog(@"%ld", (long)i);
            if (i == 3) {
                JRActionSheetView *jr1 = [JRActionSheetView actionSheetViewWithTitle:@"123" message:@"22"];
                [jr1 addJRSheetAction:[JRSheetAction sheetActionWithTitle:@"取消" style:JRAlertActionStyleCancel handler:^(JRSheetAction * _Nullable action) {

                }]];
                for (NSInteger i = 0; i < 10; i ++) {
                    JRSheetAction *action1 = [JRSheetAction sheetActionWithTitle:@"test" style:(JRAlertActionStyleDefault) handler:^(JRSheetAction * _Nullable action) {
                        NSLog(@"🎲🎲🎲🎲%ld", (long)i);
                    }];
                    [jr1 addJRSheetAction:action1];
                }
                [jr1 show];
            }
        }];
        [actionSheetView addJRSheetAction:action];
    }
    [actionSheetView show];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSLog(@"是否了");
}


@end
