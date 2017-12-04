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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)showSimpleDemo:(id)sender {
    JRActionSheetView *actionSheetView = [JRActionSheetView actionSheetViewWithTitle:@"" message:@"333333333"];
    [actionSheetView addJRAlertAction:[JRAlertAction alerActionWithTitle:@"222" style:(JRAlertActionStyleCancel) handler:^(JRAlertAction * _Nullable action) {

    }]];
    for (NSInteger i = 0; i < 10; i ++) {
        JRAlertAction *action = [JRAlertAction alerActionWithTitle:@"test" style:(JRAlertActionStyleDefault) handler:^(JRAlertAction * _Nullable action) {
            NSLog(@"%ld", i);
        }];
        if (i == 3) {
            [actionSheetView setSelectAlertAction:action];
        }
        [actionSheetView addJRAlertAction:action];
    }
    [actionSheetView show];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
