//
//  UIPickerField.m
//  MultiProjectDevelopment
//
//  Created by cybek on 07/04/2020.
//  Copyright © 2020 cybek. All rights reserved.
//

#import "UIPickerField.h"

@interface UIPickerField() <UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation UIPickerField

//UIPickerViewWithButtons* pickerView;
UIPickerView* pickerView;
//int selectedRow = -1;

//- (instancetype)init {
//    self = [super init];
//    
//    return self;
//}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    pickerView = [[UIPickerView alloc] init];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    self.inputView = pickerView;
    //self.delegate = self;
    
    UIToolbar* toolbar = [[UIToolbar alloc] init];
    [toolbar sizeToFit];
    self.inputAccessoryView = toolbar;
    
    UIBarButtonItem* toolbarDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneClicked:)];
    NSArray* toolbarButtons = [NSArray arrayWithObjects:toolbarDone, nil];
    [toolbar setItems:toolbarButtons];
    
//    self.options = [[NSMutableArray alloc] init];
//    [self.options addObject:@"Project 1"];
//    [self.options addObject:@"Project 2"];
//    [self.options addObject:@"Project 3"];
    
    self.options = nil;
    self.selectedOption = nil;
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    return self;
}

- (void)doneClicked:(id)sender {
    //[self removeFromSuperview];
    //[pickerView removeFromSuperview];
    //[pickerView setHidden:YES];
    
    if(self.selectedOption == nil && [self.options count] > 0) {
        self.selectedOption = [NSNumber numberWithLong:0];
    }
    
    [self endEditing:YES];
}

- (BOOL)endEditing:(BOOL)force {
    if(self.selectedOption != nil) {
        NSString* text = self.options[[self.selectedOption unsignedIntValue]];
        self.text = text;
    }
    
    return [super endEditing:force];
}

//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    NSString* text;
//
//    if(self.selectedOption == nil) {
//        text = @"<Not selected>";
//    } else {
//        text = self.options[self.selectedOption.unsignedIntValue];
//    }
//
//    self.text = text;
//}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    //return 3;
    return MAX(1, [self.options count]);
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //return @"YoLo";
    if([self.options count] == 0) {
        return @"<No projects>";
    } else {
        return self.options[row];
    }
}

/*- (NSString *)text {
    if(selectedRow < 0) {
        return @"<Not selected>";
    } else {
        return self.options[selectedRow];
    }
}*/

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component API_UNAVAILABLE(tvos) {
    self.selectedOption = [NSNumber numberWithLong:row];
    //self.text = self.options[selectedRow];
    NSLog(@"Selected row: %@, text: %@", self.selectedOption, self.text);
}

//- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component API_UNAVAILABLE(tvos);
//- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component API_AVAILABLE(ios(6.0)) API_UNAVAILABLE(tvos); // attributed title is favored if both methods are implemented
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view API_UNAVAILABLE(tvos);
//
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    self.selectedOption = [NSNumber numberWithInteger:row];
//}

- (void)setOptions:(NSArray<NSString *> *)options {
    _options = options;
    
    if([options count] > 0) {
        self.selectedOption = [NSNumber numberWithLong:0];
    } else {
        self.selectedOption = nil;
    }
}

- (void)setSelectedOption:(NSNumber *)selectedOption {
    _selectedOption = selectedOption;
    
    NSString* text;
    if(self.selectedOption == nil) {
        text = @"<Not selected>";
    } else {
        text = self.options[self.selectedOption.unsignedIntValue];
    }
    
    self.text = text;
    [self endEditing:YES];
}

@end
