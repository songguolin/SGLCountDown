//
//  SGLCountDown.m
//  倒计时
//
//  Created by song guolin on 2019/7/12.
//  Copyright © 2019 song guolin. All rights reserved.
//
/**
 //控制闪烁
 NSString *strTime = [NSString stringWithFormat:@"%ld", second];
 dispatch_async(dispatch_get_main_queue(), ^{//根据自己需求设置倒计时显示
 [self.timeBtn setTitle:[NSString stringWithFormat:@"%@S",strTime] forState:UIControlStateNormal];
 [self.timeBtn setTitle:[NSString stringWithFormat:@"%@S",strTime] forState:UIControlStateDisabled];
 
 [self.timeBtn setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];
 
 self.timeBtn.titleLabel.transform = CGAffineTransformMakeScale(1, 1);
 self.timeBtn.titleLabel.alpha     = 1;
 
 });
 */
#import "SGLCountDown.h"

@interface SGLCountDownModel : NSObject

@property (nonatomic,assign) NSTimeInterval timeInterval;
@property (nonatomic,copy) SGLCountDownBlock countDownBlock;


@end

@implementation SGLCountDownModel

@end


//倒计时通知
NSString * const SGLCountDownNotification = @"SGLCountDownNotification";

@interface SGLCountDown ()

@property (nonatomic,assign) BOOL isNotification;

@property(nonatomic,retain) dispatch_source_t timer;
@property (nonatomic,assign) NSTimeInterval nowTimeInterval;

@property (nonatomic,strong) NSMutableArray * blockArr;

@end

@implementation SGLCountDown
+(instancetype)shareInstance
{
    static SGLCountDown * share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[SGLCountDown alloc] init];
    });
    return share;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.blockArr = [NSMutableArray array];
        self.isNotification = NO;
    }
    return self;
}



-(void)countDownWithStratTimeStamp:(long long)starTimeStamp finishTimeStamp:(long long)finishTimeStamp completeBlock:(SGLCountDownBlock)completeBlock
{
    
    NSTimeInterval timeInterval = (finishTimeStamp - starTimeStamp);
    [self countDownWithTimeInterval:timeInterval completeBlock:completeBlock];
    
}


-(void)addCountDownNotification
{
    self.isNotification = YES;
    [self countDownWithTimeInterval:1 completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second, NSTimeInterval nowTimestamp) {
        
    }];
}

-(void)countDownWithTimeInterval:(NSTimeInterval)timeInterval completeBlock:(SGLCountDownBlock)completeBlock
{
    self.nowTimeInterval = [[NSDate date] timeIntervalSince1970];
    if (completeBlock!=nil) {
        SGLCountDownModel * model = [SGLCountDownModel new];
        model.timeInterval = timeInterval;
        model.countDownBlock = completeBlock;
        [self.blockArr addObject:model];
    }
    
    __block int timeout = timeInterval; //倒计时时间
    if (_timer==nil) {
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                self.nowTimeInterval ++;
                if (self.isNotification) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:SGLCountDownNotification object:[NSNumber numberWithDouble:self.nowTimeInterval]];
                }
                NSArray * countDownArr = self.blockArr.copy;
                for (SGLCountDownModel * model in countDownArr) {
                    if(model.timeInterval<=0){ //倒计时结束，关闭
                        dispatch_async(dispatch_get_main_queue(), ^{
                            model.countDownBlock(0,0,0,0,self.nowTimeInterval);
                            [self.blockArr removeObject:model];
                            
                            
                        });
                    }else{
                        int days = (int)(model.timeInterval/(3600*24));
                        int hours = (int)((model.timeInterval-days*24*3600)/3600);
                        int minute = (int)(model.timeInterval-days*24*3600-hours*3600)/60;
                        int second = model.timeInterval-days*24*3600-hours*3600-minute*60;
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            model.countDownBlock(days,hours,minute,second,self.nowTimeInterval);
                            
                        });
                        model.timeInterval--;
 
                    }
                }
                
            });
            dispatch_resume(_timer);
        }
    }
}
/**
 *  主动销毁定时器
 
 */
-(void)destoryTimer{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    NSLog(@"\n----销毁定时器-------\n");
    [self.blockArr removeAllObjects];
}

-(NSDate *)dateWithLongLong:(long long)longlongValue{
    long long value = longlongValue/1000;
    NSNumber *time = [NSNumber numberWithLongLong:value];
    //转换成NSTimeInterval,用longLongValue，防止溢出
    NSTimeInterval nsTimeInterval = [time longLongValue];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    return date;
}

+(void)getTimeWithTimeInterval:(long long)timeInterval completeBlock:(SGLCountDownBlock)completeBlock
{
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minute = (int)(timeInterval-days*24*3600-hours*3600)/60;
    int second = (int)(timeInterval-days*24*3600-hours*3600-minute*60);
    if (completeBlock) {
        completeBlock(days,hours,minute,second,0);
    }
}

-(void)dealloc{
    NSLog(@"%s dealloc",object_getClassName(self));
}


@end

