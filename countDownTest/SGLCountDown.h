//
//  SGLCountDown.h
//  倒计时
//
//  Created by song guolin on 2019/7/12.
//  Copyright © 2019 song guolin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SGLCountDownBlock)(NSInteger day,NSInteger hour,NSInteger minute,NSInteger second,NSTimeInterval nowTimestamp);

typedef void(^SGLCountDownSecBlock)(NSTimeInterval nowTimestamp);

/**
 倒计时,注意是秒级
 */
@interface SGLCountDown : NSObject

+(instancetype)shareInstance;


/**
 时间戳倒计时

 @param starTimeStamp 开始时间戳
 @param finishTimeStamp 结束时间戳
 @param completeBlock 天,时,分,秒,当前时间戳
 */
-(void)countDownWithStratTimeStamp:(long long)starTimeStamp finishTimeStamp:(long long)finishTimeStamp completeBlock:(SGLCountDownBlock)completeBlock;


/**
 倒计时,短信验证码

 @param timeInterval 倒计时时间
 @param completeBlock 天,时,分,秒,当前时间戳
 */
-(void)countDownWithTimeInterval:(NSTimeInterval)timeInterval completeBlock:(SGLCountDownBlock)completeBlock;


/**
 每秒都回调

 @param secBlock 返回当前时间戳,主要用于列表cell计算
 */
-(void)countDownWithSecBlock:(SGLCountDownSecBlock)secBlock;


/**
 根据时间差 直接格式化

 @param timeInterval 时间差
 @param completeBlock 天,时,分,秒,当前时间戳
 */
+(void)getTimeWithTimeInterval:(long long)timeInterval completeBlock:(SGLCountDownBlock)completeBlock;

/**
 销毁定时,要主动调用
 */
-(void)destoryTimer;


@end

NS_ASSUME_NONNULL_END
