//
//  ThirdViewController.m
//  MultiProjectDevelopment
//
//  Created by cybek on 13/04/2020.
//  Copyright © 2020 cybek. All rights reserved.
//

#import "ThirdViewController.h"
#import "Settings.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)exportProjectsClicked:(id)sender {
    NSData* projects = [[Settings instance] getArchivedProjects];;
    
    UIActivityViewController* act = [[UIActivityViewController alloc] initWithActivityItems:@[projects] applicationActivities:nil];
    [self showViewController:act sender:self];
}

- (IBAction)exportEntriesClicked:(id)sender {
    NSData* entries = [[Settings instance] getArchivedEntries];
    
    UIActivityViewController* act = [[UIActivityViewController alloc] initWithActivityItems:@[entries] applicationActivities:nil];
    [self showViewController:act sender:self];
}

@end
