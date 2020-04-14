//
//  FirstViewController.m
//  MultiProjectDevelopment
//
//  Created by cybek on 06/04/2020.
//  Copyright © 2020 cybek. All rights reserved.
//

#import "FirstViewController.h"
#import "Model/Settings.h"
#import "UIProjectPickerField.h"
#import "UITimeEntryTableView.h"
#import "NSDate+Extensions.h"
#import <BlocksKit/BlocksKit.h>

@interface FirstViewController ()

@property (weak, nonatomic) IBOutlet UIProjectPickerField *selectedProjectPickerField;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UILabel *timeCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeCounterLabel;
@property (weak, nonatomic) IBOutlet UITimeEntryTableView *timeEntryTableView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UISwitch *totalSwitch;

@property BOOL started;
@property NSTimer* counter;
@property NSDate* date;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.started = NO;
    self.counter = [[NSTimer alloc] init];
    self.date = [NSDate date];
    self.timeEntryTableView.date = self.date;

    [self.selectedProjectPickerField addObserver:self forKeyPath:@"selectedProject" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateEntries];
    [self updateCounter];
    [self updateButton];
    [self updateDate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.counter invalidate];
    self.counter = nil;
}

- (IBAction)startStopClicked:(id)sender {
    Project* selectedProject = self.selectedProjectPickerField.selectedProject;
    if(selectedProject == nil) {
        NSLog(@"Project not selected!");
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:@"No project selected!" preferredStyle:UIAlertControllerStyleAlert];
        [self showViewController:alert sender:self];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
        
        return;
    }
    
    if(self.started == NO) {
        NSUInteger projectId = selectedProject.identifier;
        Project* project = [[Settings instance] getProjectById:projectId];
        TimeEntry* entry = [[TimeEntry alloc] initWithProject:project];
        [[Settings instance] addEntry:entry toDate:self.date];
    } else {
        TimeEntry* entry = [[[Settings instance] getEntriesArrayFor:self.date] lastObject];
        entry.finished = [NSDate date];
        
        [[Settings instance] save];
        
        [self.counter invalidate];
        self.counter = nil;
    }
    
    self.started = !self.started;
    [self updateButton];
    [self updateCounter];
    [self.timeEntryTableView reloadData];
}

- (void)updateButton {
    if(self.started) {
        [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    } else {
        [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
    }
}

- (void)updateCounter {
    if(self.counter == nil && self.started == YES) {
        self.counter = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCounter) userInfo:nil repeats:YES];
    }
    
    if(self.started == NO) {
        [self.timeCounterLabel setText:@"-----"];
        return;
    }
    
    TimeEntry* entry = [[[Settings instance] getEntriesArrayFor:self.date] lastObject];
    if(entry == nil) {
        [self.timeCounterLabel setText:@"-----"];
        [self updateTotalCounter];
        return;
    }
    
    NSString* text = [[NSDate date] optionalHoursMinutesSecondsStringSince:entry.started];
    [self.timeCounterLabel setText:text];
    
    [self updateTotalCounter];
    
    if(self.totalSwitch.isOn) {
        [self.timeEntryTableView reloadData];
    }
}

- (void)updateTotalCounter {
    NSTimeInterval totalTime = 0.0;
    NSArray* entries = [[Settings instance] getEntriesArrayFor:self.timeEntryTableView.date];
    
    for(TimeEntry* entry in entries) {
        NSDate* started = entry.started;
        NSDate* finished = entry.finished;
        
        if(finished == nil) {
            finished = [NSDate date];
        }
        
        totalTime += [finished timeIntervalSinceDate:started];
    }
    
    NSUInteger interval = totalTime;
    NSUInteger seconds = interval % 60;
    NSUInteger minutes = (interval / 60) % 60;
    NSUInteger hours = (interval / 3600);
    
    NSString* text = @"";
    if(hours > 0) {
        text = [text stringByAppendingFormat:@"%lu:", (unsigned long)hours];
    }
    
    text = [text stringByAppendingFormat:@"%02lu:%02lu", (unsigned long)minutes, (unsigned long)seconds];
    self.totalTimeCounterLabel.text = text;
}

- (void)updateEntries {
    NSArray* entries = [[Settings instance] getEntriesArrayFor:self.date];
    TimeEntry* entry = [entries lastObject];
    
    if(entry != nil && entry.finished == nil) {
        self.started = YES;
    } else {
        self.started = NO;
    }
    
    [self.timeEntryTableView reloadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if(object == self.selectedProjectPickerField && self.started == YES) {
        [self startStopClicked:nil];
        [self startStopClicked:nil];
    }
}

- (IBAction)prevDayPressed:(id)sender {
    self.date = [self.date dateByAddingTimeInterval:-86400];
    [self updateDate];
}

- (IBAction)nextDayPressed:(id)sender {
    self.date = [self.date dateByAddingTimeInterval:86400];
    [self updateDate];
}

- (IBAction)totalChanged:(id)sender {
    self.timeEntryTableView.showTotal = self.totalSwitch.isOn;
}

- (void)updateDate {
    NSDateComponents* comp = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.date];
    
    NSUInteger year = comp.year;
    NSUInteger month = comp.month;
    NSUInteger day = comp.day;
    
    NSString* text = [NSString stringWithFormat:@"%04lu-%02lu-%02lu", year, month, day];
    [self.dateLabel setText:text];
    
    self.timeEntryTableView.date = self.date;
    [self updateEntries];
    [self updateButton];
    [self updateCounter];
    [self updateTotalCounter];
}

@end
