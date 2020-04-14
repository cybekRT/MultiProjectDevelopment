//
//  Settings.m
//  MultiProjectDevelopment
//
//  Created by cybek on 11/04/2020.
//  Copyright © 2020 cybek. All rights reserved.
//

#import "Settings.h"
#import "NSDate+Extensions.h"

static Settings* instance = nil;

@interface Settings ()

@property NSString* entriesPath;
@property NSString* projectsPath;

@end

@implementation Settings

+ (Settings*)instance {
    if(instance == nil) {
        instance = [[Settings alloc] init];
    }
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.entriesPath = [paths[0] stringByAppendingString:@"/entries"];
    self.projectsPath = [paths[0] stringByAppendingString:@"/projects"];
    
    [self load];
    
    if(self.entries == nil) {
        self.entries = [[NSMutableDictionary alloc] init];
    }
    
    if(self.projects == nil) {
        self.projects = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)load {
    NSLog(@"Loading data - projects...");
    
    NSData* projectsData = [[NSData alloc] initWithContentsOfFile:self.projectsPath];
    if(projectsData) {
        NSError* error;
        NSKeyedUnarchiver* projectsDecoder = [[NSKeyedUnarchiver alloc] initForReadingFromData:projectsData error:&error];
        projectsDecoder.requiresSecureCoding = NO;

        self.projects = [projectsDecoder decodeObject];
    } else {
        NSLog(@"No saved projects!");
    }
    
    NSLog(@"Loading data - entries...");
    NSData* entriesData = [[NSData alloc] initWithContentsOfFile:self.entriesPath];
    if(entriesData) {
        NSError* error;
        NSKeyedUnarchiver* entriesDecoder = [[NSKeyedUnarchiver alloc] initForReadingFromData:entriesData error:&error];
        entriesDecoder.requiresSecureCoding = NO;

        self.entries = [entriesDecoder decodeObject];
    } else {
        NSLog(@"No saved entries!");
    }
    
    NSLog(@"Loading data - done!");
}

- (void)save {
    NSLog(@"Saving data...");
    
    NSData* projectsData = [self getArchivedProjects];
    BOOL res = [projectsData writeToFile:self.projectsPath atomically:YES];
    NSLog(@"Saving projects result: %d", res);
    
    NSData* entriesData = [self getArchivedEntries];
    res = [entriesData writeToFile:self.entriesPath atomically:YES];
    NSLog(@"Saving entries result: %d", res);
}

- (NSData*)getArchivedProjects {
    NSKeyedArchiver* projectsCoder = [[NSKeyedArchiver alloc] initRequiringSecureCoding:NO];
    [projectsCoder encodeObject:self.projects];
    NSData* projectsData = [projectsCoder encodedData];
    
    return projectsData;
}

- (NSData*)getArchivedEntries {
    NSKeyedArchiver* entriesCoder = [[NSKeyedArchiver alloc] initRequiringSecureCoding:NO];
    [entriesCoder encodeObject:self.entries];
    NSData* entriesData = [entriesCoder encodedData];
    
    return entriesData;
}

- (NSDate*)getLastDate {
    NSDate* recentDate = nil;
    for(NSDate* date in [self.entries allKeys]) {
        if(recentDate == nil || [date timeIntervalSinceDate:recentDate] > 0) {
            recentDate = date;
        }
    }
    
    return recentDate;
}

- (void)addEntry:(TimeEntry*)entry {
    [self addEntry:entry toDate:[entry.started dateOnly]];
}

- (void)addEntry:(TimeEntry*)entry toDate:(NSDate*)date {
    NSDate* entryDate = [date dateOnly];
    NSMutableArray* dateEntries = (NSMutableArray*)[self.entries objectForKey:entryDate];
    
    if(dateEntries == nil) {
        NSMutableDictionary* dict = (NSMutableDictionary*)self.entries;
        
        dateEntries = [[NSMutableArray alloc] init];
        [dict setObject:dateEntries forKey:entryDate];
    }
    
    [dateEntries addObject:entry];
    [self save];
}

- (TimeEntry*)getLastEntry {
    NSArray* sortedKeys = [[self.entries allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSDate* obj1, NSDate* obj2) {
        return [obj1 timeIntervalSinceDate:obj2];
    }];
    
    NSDate* lastDate = [sortedKeys lastObject];
    NSArray* lastDateentries = [self.entries objectForKey:lastDate];
    return [lastDateentries lastObject];
}

- (NSArray<TimeEntry*>*)getEntriesArrayFor:(NSDate*)date {
    NSArray* array = [self.entries objectForKey:[date dateOnly]];
    return array;
}

- (void)addProject:(Project*)project {
    self.projects = [self.projects arrayByAddingObject:project];
}

- (Project*)getProjectById:(NSUInteger)identifier {
    NSUInteger index = [self.projects indexOfObjectPassingTest:^BOOL(Project* obj, NSUInteger idx, BOOL* stop) {
        return obj.identifier == identifier;
    }];
    
    return [self.projects objectAtIndex:index];
}

@end
