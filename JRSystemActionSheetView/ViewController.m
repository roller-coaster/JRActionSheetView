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
    JRActionSheetView *actionSheetView = [JRActionSheetView actionSheetViewWithTitle:@"很多啊删掉吧技术部问问额外i加班费未v呃我基本vi额外v金额为吧额外能访问哦被我爸vi饿死v呃我i别u我不vi俄文版v额无比的vi俄文版vi俄文版vu额外iv被窝i北堤村额外iv被窝i吧v未必额外i吧vi饿唔吧vIE五百vi二维表iv被窝i" message:@"33333多啊删掉吧技术部问问额外i加班费未v呃我基本vi额外v金额为吧额外能访问哦被我爸vi饿死v呃我i别u我不vi俄文版v额无比的vi俄文版vi俄文版vu额外iv被窝i北堤村额外iv被窝i吧v未必额外i吧vi饿唔吧vIE五百vi二维表iv被窝i多啊删掉吧技术部问问额外i加班费未v呃我基本vi额外v金额为吧额外能访问哦被我爸vi饿死v呃我i别u我不vi俄文版v额无比的vi俄文版vi俄文版vu额外iv被窝i北堤村额外iv被窝i吧v未必额外i吧vi饿唔吧vIE五百vi二维表iv被窝i多啊删掉吧技术部问问额外i加班费未v呃我基本vi额外v金额为吧额外能访问哦被我爸vi饿死v呃我i别u我不vi俄文版v额无比的vi俄文版vi俄文版vu额外iv被窝i北堤村额外iv被窝i吧v未必额外i吧vi饿唔吧vIE五百vi二维表iv被窝i多啊删掉吧技术部问问额外i加班费未v呃我基本vi额外v金额为吧额外能访问哦被我爸vi饿死v呃我i别u我不vi俄文版v额无比的vi俄文版vi俄文版vu额外iv被窝i北堤村额外iv被窝i吧v未必额外i吧vi饿唔吧vIE五百vi二维表iv被窝i3333"];
    [actionSheetView addJRSheetAction:[JRSheetAction sheetActionWithTitle:@"222" style:(JRAlertActionStyleCancel) handler:^(JRSheetAction * _Nullable action) {

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
                        NSLog(@"🎮🎮🎮🎮🎮%ld", (long)i);
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


@end
