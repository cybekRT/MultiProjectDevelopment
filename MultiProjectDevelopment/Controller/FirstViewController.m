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
#import <BlocksKit/BlocksKit.h>

@interface FirstViewController ()

@property (weak, nonatomic) IBOutlet UIProjectPickerField *selectedProjectPickerField;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UILabel *timeCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeCounterLabel;
@property (weak, nonatomic) IBOutlet UITimeEntryTableView *timeEntryTableView;

@property BOOL started;
@property NSTimer* counter;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.started = NO;
    self.counter = [[NSTimer alloc] init];

    [self.selectedProjectPickerField addObserver:self forKeyPath:@"selectedProject" options:NSKeyValueObservingOptionNew context:nil];
    
    self.timeEntryTableView.date = [NSDate date];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateEntries];
    [self updateCounter];
    [self updateButton];
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
        [[Settings instance] addEntry:entry];
    } else {
        TimeEntry* entry = [[Settings instance] getLastEntry];
        entry.finished = [NSDate date];
        
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
    
    TimeEntry* entry = [[Settings instance] getLastEntry];
    NSUInteger interval = (NSUInteger)(-[entry.started timeIntervalSinceNow]);
    
    NSUInteger seconds = interval % 60;
    NSUInteger minutes = (interval / 60) % 60;
    NSUInteger hours = (interval / 3600);
    
    NSString* text = @"";
    if(hours > 0) {
        text = [text stringByAppendingFormat:@"%lu:", (unsigned long)hours];
    }
    
    text = [text stringByAppendingFormat:@"%02lu:%02lu", (unsigned long)minutes, (unsigned long)seconds];
    self.timeCounterLabel.text = text;
    
    [self updateTotalCounter];
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
    NSDate* lastDate = [[Settings instance] getLastDate];
    NSArray* entries = [[Settings instance] getEntriesArrayFor:lastDate];
    TimeEntry* entry = [entries lastObject];
    
    if(entry != nil && entry.finished == nil) {
        self.started = YES;
    }
    
    [self.timeEntryTableView reloadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if(object == self.selectedProjectPickerField && self.started == YES) {
        [self startStopClicked:nil];
        [self startStopClicked:nil];
    }
}

@end
