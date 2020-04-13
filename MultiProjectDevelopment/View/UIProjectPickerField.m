//
//  UIPickerField.m
//  MultiProjectDevelopment
//
//  Created by cybek on 07/04/2020.
//  Copyright © 2020 cybek. All rights reserved.
//

#import "UIProjectPickerField.h"
#import "Settings.h"
#import <BlocksKit/BlocksKit.h>

@interface UIProjectPickerField() <UIPickerViewDelegate, UIPickerViewDataSource>

@property UIPickerView* pickerView;

@property NSArray* activeProjects;

@end

@implementation UIProjectPickerField

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.inputView = self.pickerView;
    
    UIToolbar* toolbar = [[UIToolbar alloc] init];
    [toolbar sizeToFit];
    self.inputAccessoryView = toolbar;
    
    UIBarButtonItem* toolbarDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneClicked:)];
    NSArray* toolbarButtons = [NSArray arrayWithObjects:toolbarDone, nil];
    [toolbar setItems:toolbarButtons];
    
    self.selectedProject = nil;
    [self reloadData];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    return self;
}

- (void)doneClicked:(id)sender {
    if(self.selectedProject == nil && [self.activeProjects count] > 0) {
        self.selectedProject = [self.activeProjects firstObject];
    }
    
    [self endEditing:YES];
}

- (BOOL)endEditing:(BOOL)force {
    if(self.selectedProject != nil) {
        self.text = self.selectedProject.name;
    }
    
    return [super endEditing:force];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return MAX(1, [self.activeProjects count]);
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    if([self.activeProjects count] == 0) {
        return @"<No projects>";
    } else {
        //return self.options[row];
        Project* project = self.activeProjects[row];
        return project.name;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedProject = self.activeProjects[row];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [self reloadData];
}

- (void)setSelectedProject:(Project *)selectedProject {
    _selectedProject = selectedProject;
    
    NSString* text;
    if(self.selectedProject == nil) {
        text = @"<Not selected>";
    } else {
        text = self.selectedProject.name;
    }
    
    self.text = text;
    [self endEditing:YES];
}

- (void)reloadData {
    NSArray* projects = [[Settings instance] projects];
    self.activeProjects = [projects bk_select:^BOOL(Project* obj) {
        return obj.active;
    }];
    
    [self.pickerView reloadAllComponents];
    
    NSUInteger index = [self.activeProjects indexOfObject:self.selectedProject];
    if(index == NSNotFound) {
        self.selectedProject = nil;
    } else {
        [self.pickerView selectRow:index inComponent:0 animated:NO];
    }
    
    [self updateObservers];
}

- (void)updateObservers {
    @try {
        [[Settings instance] removeObserver:self forKeyPath:@"projects"];
    }
    @catch(NSException*) {
        
    }
    
    [[Settings instance] addObserver:self forKeyPath:@"projects" options:NSKeyValueObservingOptionNew context:nil];
    NSArray* projects = [[Settings instance] projects];
    
    for(Project* project in projects) {
        @try {
            [project removeObserver:self forKeyPath:@"name"];
            [project removeObserver:self forKeyPath:@"active"];
        }
        @catch(NSException*) {
            
        }
        
        [project addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
        [project addObserver:self forKeyPath:@"active" options:NSKeyValueObservingOptionNew context:nil];
    }
}

@end
