//
//  TimeEntry.m
//  MultiProjectDevelopment
//
//  Created by cybek on 12/04/2020.
//  Copyright © 2020 cybek. All rights reserved.
//

#import "TimeEntry.h"
#import "Settings.h"

@implementation TimeEntry

- (instancetype)initWithProject:(Project*)project {
    return [self initWithProjectId:project.identifier andDate:[NSDate date]];
}

- (instancetype)initWithProject:(Project*)project andDate:(NSDate*)date {
    return [self initWithProjectId:project.identifier andDate:date];
}

- (instancetype)initWithProjectId:(NSUInteger)projectId andDate:(NSDate*)date {
    self = [super init];
    
    self.started = date;
    self.finished = nil;
    self.projectId = projectId;
    
    return self;
}

- (Project *)project {
    return [[Settings instance] getProjectById:self.projectId];
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.started forKey:@"started"];
    [coder encodeObject:self.finished forKey:@"finished"];
    [coder encodeInteger:self.projectId forKey:@"project"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];
    
    self.started = [coder decodeObjectForKey:@"started"];
    self.finished = [coder decodeObjectForKey:@"finished"];
    self.projectId = [coder decodeIntegerForKey:@"project"];
    
    return self;
}

@end
