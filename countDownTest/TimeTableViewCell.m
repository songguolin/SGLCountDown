//
//  TimeTableViewCell.m
//  countDownTest
//
//  Created by song guolin on 2019/7/12.
//  Copyright © 2019 song guolin. All rights reserved.
//

#import "TimeTableViewCell.h"

@implementation CellModel


@end



@implementation TimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    
}

-(void)setCellModel:(CellModel *)cellModel
{
    _cellModel = cellModel;
   self.timeLabel.text = cellModel.timeStr;
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
