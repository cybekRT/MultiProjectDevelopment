//
//  TimeEntry.h
//  MultiProjectDevelopment
//
//  Created by cybek on 12/04/2020.
//  Copyright © 2020 cybek. All rights reserved.
//

#import "Project.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeEntry : NSObject<NSCoding>

@property               NSDate*     started;
@property(nullable)     NSDate*     finished;
@property               NSUInteger  projectId;

@property(readonly)     Project*    project;

- (instancetype)initWithProject:(Project*)project;
- (instancetype)initWithProject:(Project*)project andDate:(NSDate*)date;
- (instancetype)initWithProjectId:(NSUInteger)projectId andDate:(NSDate*)date;

@end

NS_ASSUME_NONNULL_END
