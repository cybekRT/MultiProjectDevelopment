//
//  NSDate+Extensions.h
//  MultiProjectDevelopment
//
//  Created by cybek on 12/04/2020.
//  Copyright © 2020 cybek. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Extensions)

- (NSDate*)dateOnly;

- (NSString*)optionalHoursMinutesSecondsStringSince:(NSDate*)date;
- (NSString*)hoursMinutesSecondsStringSince:(NSDate*)date;

@end

NS_ASSUME_NONNULL_END
