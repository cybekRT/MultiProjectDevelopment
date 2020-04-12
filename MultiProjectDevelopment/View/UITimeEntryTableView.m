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

@end

@implementation UITimeEntryTableView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];

    UINib* cellNib = [UINib nibWithNibName:@"UITimeEntryTableViewCell" bundle:nil];
    [self registerNib:cellNib forCellReuseIdentifier:@"timeEntryCell"];
    self.dataSource = self;

    return self;
}

- (void)reloadData {
    NSAssert(self.date != nil, @"");
    
    self.entries = [[Settings instance] getEntriesArrayFor:self.date];
    
    [super reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    UITimeEntryTableViewCell* cell = (UITimeEntryTableViewCell*)[self dequeueReusableCellWithIdentifier:@"timeEntryCell"];
    
    NSInteger index = [self.entries count] - 1 - indexPath.row;
    cell.timeEntry = [self.entries objectAtIndex:index];
    [cell refreshData];
    
    TimeEntry* entry = self.entries[indexPath.row];
    cell.timeEntry = entry;

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.entries count];
}

@end
