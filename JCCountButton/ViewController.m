//
//  ViewController.m
//  JCCountButton
//
//  Created by admin on 16/5/16.
//  Copyright © 2016年 Tsoi. All rights reserved.
//

#import "ViewController.h"
#import "JCCountButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    JCCountButton *button = [[JCCountButton alloc]init];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.titleLabel.textColor = [UIColor whiteColor];
    button.normalTitle = @"获取验证码";
    
    //想短信验证成功以后再计算用以下方法,想按了之后直接计算时间不等是否成功就不用任何处理
//    [button clickButtonWithBlock:^{
//        sleep(3);
//        NSLog(@"请求完毕，开始计时");
//        [button starCount];
//    }];
    
//    manager.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:button];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
