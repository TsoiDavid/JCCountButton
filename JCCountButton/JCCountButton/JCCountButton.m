//
//  JCCountButton.m
//  JCCountButton
//
//  Created by admin on 16/5/16.
//  Copyright © 2016年 Tsoi. All rights reserved.
//

#import "JCCountButton.h"

static const NSInteger normalTotalTime = 5;

@interface JCCountButton ()

@property (nonatomic, strong) UILabel *timeLabel;
//当前时间
@property (assign, nonatomic) NSInteger currentTime;
//计时器
@property (strong, nonatomic) NSTimer *time;

@property (assign, nonatomic) UIBackgroundTaskIdentifier myTask;

@property (assign, nonatomic) BOOL isCounting;
@end

@implementation JCCountButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setNormalAttribute];
    }
    
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setNormalAttribute];
    }
    
    return self;
}

#pragma mark - set UI
- (void)setTotalTime:(NSInteger)totalTime {
    //赋值总时间
    _totalTime = totalTime + 1;
}

- (void)setNormalTitle:(NSString *)normalTitle {
    _normalTitle = normalTitle;
    [self refreshTitleLabel];
}
- (void)setNormalAttribute {
    
    self.backgroundColor = [UIColor grayColor];
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 4;
    //默认标题
    self.normalTitle = @"获取验证码";
    //默认是未开始计时
    self.isCounting = NO;
    //赋值默认总时间
    self.totalTime = normalTotalTime;
    //添加按钮显示的label
    [self addSubview:self.timeLabel];
    [self refreshTitleLabel];
    //添加点击方法
    [self addTarget:self action:@selector(clickButtonAction) forControlEvents:UIControlEventTouchUpInside];
    //注册通知
    [self registerNotification];
}


- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textColor = self.titleLabel.textColor;
        _timeLabel.backgroundColor = self.backgroundColor;
        _timeLabel.font = self.titleLabel.font;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = self.titleLabel.text;
    }
    
    return _timeLabel;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.timeLabel.frame = self.bounds;
}
- (void)refreshTitleLabel {
    if (!self.selected) {
        self.timeLabel.text = _normalTitle;
    }else {
        self.timeLabel.text = [NSString stringWithFormat:@"%ld",(long)self.currentTime];
    }
}
#pragma mark - NSTimer method
- (void)countTime {
    self.currentTime -= 1;
   
    NSLog(@"totalTime = %@",self.timeLabel.text);
    
    if (self.currentTime == 0) {
        //计时完成时，停止计时。
        [self stopCount];
    }
    
    [self refreshTitleLabel];
}
//按钮点击方法
- (void)setClickButton:(void (^)())clickButton {
    _clickButton = clickButton;
}
- (void)clickButtonWithBlock:(void (^)())clickBlock {
    _clickButton = clickBlock;
    _isCountAfterNetWorkOperation = YES;
}
- (void)clickButtonAction {
    if (_isCountAfterNetWorkOperation) {//涉及网络部分手动操作执行block
        
        if(_clickButton) _clickButton();
    }else {
        if (self.selected) return;
        
            [self starCount];
            
        
    }
}
//- (void)clickButton {
//    NSLog(@"self.selected ==%d",self.selected);
//    if (!self.selected) {
//        [self starCount];
//        
//        self.selected = YES;
//    }
//}

#pragma mark - count method
- (void)starCount {
    if (!_isCounting) {
        //设置为正在计时
        _isCounting = YES;
        
        self.selected = YES;
        
        NSLog(@"开始计时");
        //赋值当前时间
        _currentTime = _totalTime;
        //创建计时器
        _time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
        [_time fire];
        
    }else {
        //停止计时
        [self stopCount];
    }
}
- (void)stopCount {
    NSLog(@"------停止计时-----");
    
    //移除计时器
    [_time invalidate];
    
    self.selected = NO;
    self.isCounting = NO;

}

#pragma mark - background method
//进入后台继续计时 600s
-(void)enterBackgroundNotification {
    NSLog(@"进入后台了，执行后台程序");
    __weak typeof(self)weakSelf = self;
    _myTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        //如果在系统规定时间内任务还没有完成，在时间到之前会调用到这个方法，一般是10分钟
        [weakSelf stopCount];

    }];
}
- (void)enterForegroundNotification {
    NSLog(@"后台任务完成，进入APP继续运行");
    [[UIApplication sharedApplication] endBackgroundTask: _myTask];
    _myTask = UIBackgroundTaskInvalid;
}

- (void)dismiss {
    [self removeFromSuperview];
}
#pragma mark - NotificationCenter
- (void)registerNotification {
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
