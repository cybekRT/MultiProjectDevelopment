//
//  Project.h
//  MultiProjectDevelopment
//
//  Created by cybek on 11/04/2020.
//  Copyright © 2020 cybek. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Project : NSObject<NSCoding>

@property NSUInteger identifier;

@property NSString* name;

@property BOOL active;

- (instancetype)initWithId:(NSUInteger)identifier andName:(NSString*)name andActive:(BOOL)active;

@end

NS_ASSUME_NONNULL_END
