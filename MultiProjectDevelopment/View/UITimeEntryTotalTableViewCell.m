//
//  UITimeEntryTotalTableViewCell.m
//  MultiProjectDevelopment
//
//  Created by cybek on 14/04/2020.
//  Copyright © 2020 cybek. All rights reserved.
//

#import "UITimeEntryTotalTableViewCell.h"
#import "NSDate+Extensions.h"

@interface UITimeEntryTotalTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *projectLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation UITimeEntryTotalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshData {
    [self.projectLabel setText:self.timeEntry.project.name];
    
    NSDate* started = self.timeEntry.started;
    NSDate* finished = self.timeEntry.finished;
    
    if(finished == nil) {
        finished = [NSDate date];
    }
    
    NSString* timeElapsed = [finished hoursMinutesSecondsStringSince:started];
    [self.timeLabel setText:timeElapsed];
}

@end
