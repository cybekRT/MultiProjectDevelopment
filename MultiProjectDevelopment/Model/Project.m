//
//  Project.m
//  MultiProjectDevelopment
//
//  Created by cybek on 11/04/2020.
//  Copyright © 2020 cybek. All rights reserved.
//

#import "Project.h"

@implementation Project

- (instancetype)initWithId:(NSUInteger)identifier andName:(NSString*)name andActive:(BOOL)active {
    self = [super init];
    
    self.identifier = identifier;
    self.name = name;
    self.active = active;
    
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeInteger:self.identifier forKey:@"identifier"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeBool:self.active forKey:@"active"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];
    
    self.identifier = [coder decodeIntegerForKey:@"identifier"];
    self.name = [coder decodeObjectForKey:@"name"];
    self.active = [coder decodeBoolForKey:@"active"];
    
    return self;
}

@end
