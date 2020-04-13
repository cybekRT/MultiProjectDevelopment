//
//  SecondViewController.m
//  MultiProjectDevelopment
//
//  Created by cybek on 06/04/2020.
//  Copyright © 2020 cybek. All rights reserved.
//

#import "SecondViewController.h"
#import "Project.h"
#import "Settings.h"

@interface SecondViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *testTable;
@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UISwitch *activeSwitch;
@property (weak, nonatomic) IBOutlet UIButton *addProjectButton;

@property Project* selectedProject;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.selectedProject = nil;
    self.testTable.delegate = self;
    self.testTable.dataSource = self;
    [self updateViewFromModel];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell* cell = [self.testTable dequeueReusableCellWithIdentifier:@"test"];
    cell.textLabel.text = [[[Settings instance] projects] objectAtIndex:indexPath.row].name;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[Settings instance] projects] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedProject = [[[Settings instance] projects] objectAtIndex:indexPath.row];
    [self updateViewFromModel];
}

- (IBAction)projectNameChanged:(id)sender {
    [self updateModel];
}

- (IBAction)activeChanged:(id)sender {
    [self updateModel];
}

- (IBAction)addProjectClicked:(id)sender {
    Project* lastProject = [[[Settings instance] projects] lastObject];
    
    NSUInteger nextIdentifier = (lastProject != nil) ? lastProject.identifier + 1 : 0;
    
    Project* project = [[Project alloc] initWithId:nextIdentifier andName:@"Unnamed project" andActive:YES];
    [[Settings instance] addProject:project];
    [self.testTable reloadData];
}

- (void)updateModel {
    self.selectedProject.name = self.nameTextField.text;
    self.selectedProject.active = [self.activeSwitch isOn];
    
    [self.testTable reloadData];
}

- (void)updateViewFromModel {
    if(self.selectedProject == nil) {
        self.nameTextField.enabled = NO;
        self.activeSwitch.enabled = NO;
        return;
    } else {
        self.nameTextField.enabled = YES;
        self.activeSwitch.enabled = YES;
    }
    
    self.idTextField.text = [NSString stringWithFormat:@"%lu", self.selectedProject.identifier];
    self.nameTextField.text = self.selectedProject.name;
    [self.activeSwitch setOn:self.selectedProject.active];
}

@end
