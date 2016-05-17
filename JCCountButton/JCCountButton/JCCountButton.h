//
//  JCCountButton.h
//  JCCountButton
//
//  Created by admin on 16/5/16.
//  Copyright © 2016年 Tsoi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCCountButton : UIButton
/**
 *  是否有网络请求后计时//默认NO
 */
@property (assign, nonatomic) BOOL isCountAfterNetWorkOperation;
/**
 *  倒数总时间，默认60秒
 */
@property (assign, nonatomic) NSInteger totalTime;
/**
 *  非计时显示的（select = NO）标题,默认为"获取验证码"
 */
@property (strong, nonatomic) NSString *normalTitle;
/**
 *  按钮block
 */
@property (copy, nonatomic) void (^clickButton)();
/**
 *  开始计时
 */
- (void)starCount;
/**
 *  按钮点击方法的block 当使用这个方法的时候
 *  isCountAfterNetWorkOperation 会设置成YES
 *  需要手动执行starCount方法来让按钮开始计时
 *
 *  @param clickBlock block
 */
- (void)clickButtonWithBlock:(void(^)())clickBlock;
@end
