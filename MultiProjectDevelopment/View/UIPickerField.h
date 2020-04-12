//
//  UIPickerField.h
//  MultiProjectDevelopment
//
//  Created by cybek on 07/04/2020.
//  Copyright © 2020 cybek. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIPickerField : UITextField

@property (nonatomic, nullable) NSArray<NSString*>* options;

@property (nonatomic, nullable) NSNumber* selectedOption;

@end

NS_ASSUME_NONNULL_END
