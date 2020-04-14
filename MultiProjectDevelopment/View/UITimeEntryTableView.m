//
//  UITimeEntryTableView.m
//  MultiProjectDevelopment
//
//  Created by cybek on 12/04/2020.
//  Copyright © 2020 cybek. All rights reserved.
//

#import "UITimeEntryTableView.h"
#import "UITimeEntryTableViewCell.h"
#import "Settings.h"

@interface UITimeEntryTableView () <UITableViewDelegate, UITableViewDataSource>

@property NSArray* entries;
@property NSArray* totalEntries;

@end

@implementation UITimeEntryTableView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];

    UINib* cellNib = [UINib nibWithNibName:@"UITimeEntryTableViewCell" bundle:nil];
    [self registerNib:cellNib forCellReuseIdentifier:@"timeEntryCell"];
    self.dataSource = self;
    
    self.totalEntries = nil;
    _showTotal = NO;

    return self;
}

- (void)reloadData {
    //NSAssert(self.date != nil, @"");
    if(self.date == nil) {
        return;
    }
    
    self.entries = [[Settings instance] getEntriesArrayFor:self.date];
    [self reloadTotalEntries];
    
    [super reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    UITimeEntryTableViewCell* cell = (UITimeEntryTableViewCell*)[self dequeueReusableCellWithIdentifier:@"timeEntryCell"];
    
    if(self.showTotal == YES) {
        cell.timeEntry = [self.totalEntries objectAtIndex:indexPath.row];
    } else {
        NSInteger index = [self.entries count] - 1 - indexPath.row;
        cell.timeEntry = [self.entries objectAtIndex:index];
    }
    
    [cell refreshData];

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.showTotal == YES) {
        return [self.totalEntries count];
    } else {
        return [self.entries count];
    }
}

- (void)setShowTotal:(BOOL)showTotal {
    _showTotal = showTotal;
    [self reloadData];
}

- (void)reloadTotalEntries {
    
    NSMutableDictionary* projectsToTimes = [[NSMutableDictionary alloc] init];
    
    for(TimeEntry* entry in self.entries) {
        NSDate* started = entry.started;
        NSDate* finished = entry.finished;
        
        if(finished == nil) {
            finished = [NSDate date];
        }
        
        NSTimeInterval interval = [finished timeIntervalSinceDate:started];
        
        NSString* projectKey = [NSString stringWithFormat:@"%lu", entry.projectId];
        
        TimeEntry* projectTime = [projectsToTimes valueForKey:projectKey];
        if(projectTime == nil) {
            projectTime = [[TimeEntry alloc] initWithProject:entry.project andDate:[NSDate date]];
            projectTime.finished = [NSDate date];
            
            projectsToTimes[projectKey] = projectTime;
        }
        
        projectTime.finished = [projectTime.finished dateByAddingTimeInterval:interval];
    }
    
    self.totalEntries = [projectsToTimes allValues];
}

@end
