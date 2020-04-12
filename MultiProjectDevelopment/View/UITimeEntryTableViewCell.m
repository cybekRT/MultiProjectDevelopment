//
//  TimeEntryTableViewCell.m
//  MultiProjectDevelopment
//
//  Created by cybek on 12/04/2020.
//  Copyright © 2020 cybek. All rights reserved.
//

#import "UITimeEntryTableViewCell.h"

@interface UITimeEntryTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;


@end

@implementation UITimeEntryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)refreshData {
    [self.label1 setText:self.timeEntry.project.name];
    
    [self.label2 setText:[self.timeEntry.started description]];
    
    NSDateComponents* startedComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self.timeEntry.started];
    
    [self.label2 setText:[NSString stringWithFormat:@"%lu:%02lu", startedComponents.hour, startedComponents.minute]];

    if(self.timeEntry.finished) {
        NSUInteger interval = [self.timeEntry.finished timeIntervalSinceDate:self.timeEntry.started];
        
        NSUInteger seconds = interval % 60;
        NSUInteger minutes = (interval / 60) % 60;
        NSUInteger hours = (interval / 3600);
        
        NSString* text = [NSString stringWithFormat:@"%lu:%02lu:%02lu", hours, minutes, seconds];
        [self.label3 setText:text];
    } else {
        [self.label3 setText:@"-----"];
    }
}

@end
