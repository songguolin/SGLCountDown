//
//  ViewController.m
//  countDownTest
//
//  Created by song guolin on 2019/7/12.
//  Copyright © 2019 song guolin. All rights reserved.
//

#import "ViewController.h"
#import "SGLCountDown.h"
#import "TimeTableViewCell.h"

static NSString * cellIdentifire = @"TimeTableViewCell";



@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel1;

@property (nonatomic,strong) SGLCountDown * countDown;


@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSMutableArray * dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.countDown = [[SGLCountDown alloc] init];
    
     __weak typeof(self) weakSelf = self;
    //抢购倒计
    NSTimeInterval startTimeInterval = [[NSDate date] timeIntervalSince1970];
    [self.countDown countDownWithStratTimeStamp:startTimeInterval finishTimeStamp:startTimeInterval+60*60*24*9 completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second,NSTimeInterval nowTimestamp) {
        

        if (startTimeInterval > nowTimestamp) {
            weakSelf.timeLabel.text =  @"活动未开始";
        }
        else
        {
            if (second == 0) {
                weakSelf.timeLabel.text =  @"活动已开始";
            }
            else
            {
                weakSelf.timeLabel.text = [NSString stringWithFormat:@"抢购倒计时还剩:%ld天%ld小时%ld分%ld秒",(long)day,hour,minute,second];
            }
           
        }
    }];
    
    //抢购倒计 第二个
    [self.countDown countDownWithStratTimeStamp:startTimeInterval finishTimeStamp:startTimeInterval+60*60*4+12 completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second,NSTimeInterval nowTimestamp) {
        
        
        if (startTimeInterval > nowTimestamp) {
            weakSelf.timeLabel1.text =  @"活动未开始";
        }
        else
        {
            if (second == 0) {
                weakSelf.timeLabel1.text =  @"活动已开始";
            }
            else
            {
                weakSelf.timeLabel1.text = [NSString stringWithFormat:@"抢购倒计时还剩:%ld天%ld小时%ld分%ld秒",(long)day,hour,minute,second];
            }
            
        }
    }];
    
    
    //列表
    self.dataArr = [NSMutableArray array];
    for (int i= 0; i<100; i++) {
        CellModel * model = [CellModel new];
        //当前时间 前后都有
        model.startTime = startTimeInterval + arc4random_uniform(60)+5;

        model.finishTime = model.startTime + arc4random_uniform(60*60*3);
        
        
        if (model.startTime > startTimeInterval) {
            model.timeStr = @"活动未开始";
        }
        
        else
        {
            //格式化
            [SGLCountDown getTimeWithTimeInterval:model.finishTime - startTimeInterval completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second, NSTimeInterval nowTimestamp) {
                model.timeStr = [NSString stringWithFormat:@"活动倒计时还剩:%ld天%ld小时%ld分%ld秒",(long)day,hour,minute,second];
            }];
            
        }
        [self.dataArr addObject:model];
    }
    
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.rowHeight = 60;
    [self.myTableView reloadData];

   
    [self.countDown countDownWithSecBlock:^(NSTimeInterval nowTimestamp) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray  *cells = weakSelf.myTableView.visibleCells; //取出屏幕可见ceLl
            for (TimeTableViewCell * cell in cells) {
                if (cell.cellModel.startTime > nowTimestamp) {
                    cell.cellModel.timeStr = @"活动未开始";
                }

                else
                {
                    //格式化
                    [SGLCountDown getTimeWithTimeInterval:cell.cellModel.finishTime - nowTimestamp completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second, NSTimeInterval nowTimestamp) {
                        cell.cellModel.timeStr = [NSString stringWithFormat:@"活动倒计时还剩:%ld天%ld小时%ld分%ld秒",(long)day,hour,minute,second];
                    }];

                }
            }

            [weakSelf.myTableView reloadData];

        });
    }];
//
    
}
- (IBAction)timeAction:(id)sender {
    self.timeBtn.enabled = NO;
    
    [self.timeBtn setTitle:@"5s" forState:UIControlStateNormal];
    [self.countDown countDownWithTimeInterval:5 completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second,NSTimeInterval nowTimestamp) {
        NSLog(@"timeout---:%ld",(long)second);
        if (second <= 0) {
            self.timeBtn.enabled = YES;
             [self.timeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
            [self.timeBtn setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
           
        }
        else
        {
            
            NSString *strTime = [NSString stringWithFormat:@"%ld", second];
            dispatch_async(dispatch_get_main_queue(), ^{//根据自己需求设置倒计时显示
                [self.timeBtn setTitle:[NSString stringWithFormat:@"%@S",strTime] forState:UIControlStateNormal];

                [self.timeBtn setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];
                
    
                self.timeBtn.titleLabel.transform = CGAffineTransformMakeScale(1, 1);
                self.timeBtn.titleLabel.alpha     = 1;
            
            });
        }
     
    }];
    
    
}
#pragma mark --UITableViewDataSource-
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifire];
    CellModel * model = [self.dataArr objectAtIndex:indexPath.row];
    cell.cellModel = model;

    return cell;
}

-(void)dealloc
{
    //注意销毁的时机
    [self.countDown destoryTimer];
    [[SGLCountDown shareInstance] destoryTimer];
}
@end
