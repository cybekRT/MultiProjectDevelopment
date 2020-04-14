//
//  NSDate+Extensions.m
//  MultiProjectDevelopment
//
//  Created by cybek on 12/04/2020.
//  Copyright © 2020 cybek. All rights reserved.
//

#import "NSDate+Extensions.h"

@implementation NSDate (Extensions)

- (NSDate*)dateOnly {
    NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    [components setCalendar:[NSCalendar currentCalendar]];
    
    return [components date];
}

- (NSString*)optionalHoursMinutesSecondsStringSince:(NSDate*)date {
    NSUInteger interval = (NSUInteger)[self timeIntervalSinceDate:date];
    
    NSUInteger seconds = interval % 60;
    NSUInteger minutes = (interval / 60) % 60;
    NSUInteger hours = (interval / 3600);
    
    NSString* text = @"";
    if(hours > 0) {
        text = [text stringByAppendingFormat:@"%lu:", (unsigned long)hours];
    }
    
    text = [text stringByAppendingFormat:@"%02lu:%02lu", (unsigned long)minutes, (unsigned long)seconds];
    
    return text;
}

- (NSString*)hoursMinutesSecondsStringSince:(NSDate*)date {
    NSUInteger interval = (NSUInteger)[self timeIntervalSinceDate:date];
    
    NSUInteger seconds = interval % 60;
    NSUInteger minutes = (interval / 60) % 60;
    NSUInteger hours = (interval / 3600);
    
    NSString* text = [NSString stringWithFormat:@"%02lu:%02lu:%02lu", hours, minutes, seconds];
    
    return text;
}

@end
