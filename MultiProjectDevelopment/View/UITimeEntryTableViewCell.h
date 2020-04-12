//
//  TimeEntryTableViewCell.h
//  MultiProjectDevelopment
//
//  Created by cybek on 12/04/2020.
//  Copyright © 2020 cybek. All rights reserved.
//

#import "TimeEntry.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITimeEntryTableViewCell : UITableViewCell

@property TimeEntry* timeEntry;

- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
