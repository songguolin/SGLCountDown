//
//  TimeTableViewCell.h
//  countDownTest
//
//  Created by song guolin on 2019/7/12.
//  Copyright © 2019 song guolin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGLCountDown.h"
NS_ASSUME_NONNULL_BEGIN
@interface CellModel : NSObject

@property (nonatomic,assign) long long startTime;
@property (nonatomic,assign) long long finishTime;

@property (nonatomic,copy) NSString * timeStr;

@end

@interface TimeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,strong) CellModel * cellModel;


@end

NS_ASSUME_NONNULL_END
