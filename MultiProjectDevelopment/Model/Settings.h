//
//  Settings.h
//  MultiProjectDevelopment
//
//  Created by cybek on 11/04/2020.
//  Copyright © 2020 cybek. All rights reserved.
//

#import "Project.h"
#import "TimeEntry.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Settings : NSObject

@property NSDictionary<NSDate*, NSArray<TimeEntry*>*>*  entries;
@property NSArray<Project*>*                            projects;

+ (Settings*)instance;
- (void)save;

- (NSDate*)getLastDate;

- (void)addEntry:(TimeEntry*)entry;
- (TimeEntry*)getLastEntry;
- (NSArray<TimeEntry*>*)getEntriesArrayFor:(NSDate*)date;

- (void)addProject:(Project*)project;
- (Project*)getProjectById:(NSUInteger)identifier;

@end

NS_ASSUME_NONNULL_END
