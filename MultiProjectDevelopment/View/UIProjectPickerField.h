//
//  UIPickerField.h
//  MultiProjectDevelopment
//
//  Created by cybek on 07/04/2020.
//  Copyright © 2020 cybek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIProjectPickerField : UITextField

@property (nonatomic, nullable) Project* selectedProject;

@end

NS_ASSUME_NONNULL_END
