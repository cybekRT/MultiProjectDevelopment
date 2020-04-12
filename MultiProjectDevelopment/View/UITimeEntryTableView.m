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

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *entriesTableView;

@property NSArray* entries;

@end

@implementation UITimeEntryTableView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    UINib* nib = [UINib nibWithNibName:@"UITimeEntryTableView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.contentView.bounds = self.bounds;
    [self addSubview:self.contentView];
    
    UINib* cellNib = [UINib nibWithNibName:@"UITimeEntryTableViewCell" bundle:nil];
    [self.entriesTableView registerNib:cellNib forCellReuseIdentifier:@"timeEntryCell"];
    self.entriesTableView.dataSource = self;
    
    return self;
}

//- (void)encodeWithCoder:(nonnull NSCoder *)coder {
//
//}
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    return self;
//}

- (void)reloadData {
    //self.entriesTableView.delegate = self;
    //self.entriesTableView.dataSource = self;
    
    NSAssert(self.date != nil, @"");
    
    self.entries = [[Settings instance] getEntriesArrayFor:self.date];
    
    [self.entriesTableView reloadData];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //UITableViewCell* cell = [self.entriesTableView dequeueReusableCellWithIdentifier:@"timeEntryCell"];
    //UITableViewCell* cell = [[UITableViewCell alloc] init];
    //UITimeEntryTableViewCell* cell = [[UITimeEntryTableViewCell alloc] init];
    
    UITimeEntryTableViewCell* cell = (UITimeEntryTableViewCell*)[self.entriesTableView dequeueReusableCellWithIdentifier:@"timeEntryCell"];
    
    NSInteger index = [self.entries count] - 1 - indexPath.row;
    cell.timeEntry = [self.entries objectAtIndex:index];
    [cell refreshData];
    
    
    //cell.textLabel.text = [NSString stringWithFormat:@"Row: %ld", (long)indexPath.row];
    
    TimeEntry* entry = self.entries[indexPath.row];
    //cell.textLabel.text = entry.project.name;
    
    cell.timeEntry = entry;

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.entries count];
    //return 3;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

//+ (nonnull instancetype)appearance {
//    <#code#>
//}
//
//+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait {
//    <#code#>
//}
//
//+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait whenContainedIn:(nullable Class<UIAppearanceContainer>)ContainerClass, ... {
//    <#code#>
//}
//
//+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait whenContainedInInstancesOfClasses:(nonnull NSArray<Class<UIAppearanceContainer>> *)containerTypes {
//    <#code#>
//}
//
//+ (nonnull instancetype)appearanceWhenContainedIn:(nullable Class<UIAppearanceContainer>)ContainerClass, ... {
//    <#code#>
//}
//
//+ (nonnull instancetype)appearanceWhenContainedInInstancesOfClasses:(nonnull NSArray<Class<UIAppearanceContainer>> *)containerTypes {
//    <#code#>
//}
//
//- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
//    <#code#>
//}

//- (CGPoint)convertPoint:(CGPoint)point fromCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace {
//    <#code#>
//}
//
//- (CGPoint)convertPoint:(CGPoint)point toCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace {
//    <#code#>
//}
//
//- (CGRect)convertRect:(CGRect)rect fromCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace {
//    <#code#>
//}
//
//- (CGRect)convertRect:(CGRect)rect toCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace {
//    <#code#>
//}

//- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
//    <#code#>
//}
//
//- (void)setNeedsFocusUpdate {
//    <#code#>
//}
//
//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
//    <#code#>
//}
//
//- (void)updateFocusIfNeeded {
//    <#code#>
//}
//
//- (nonnull NSArray<id<UIFocusItem>> *)focusItemsInRect:(CGRect)rect {
//    <#code#>
//}

@end
