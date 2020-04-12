//
//  UITimeEntryTableView.h
//  MultiProjectDevelopment
//
//  Created by cybek on 12/04/2020.
//  Copyright © 2020 cybek. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITimeEntryTableView : UITableView

@property NSDate* date;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
