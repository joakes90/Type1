//
//  GlucoseViewController.m
//  Type1
//
//  Created by Justin Oakes on 5/22/15.
//  Copyright (c) 2015 Devmtn. All rights reserved.
//

#import "GlucoseViewController.h"
#import "HealthKitController.h"

@interface GlucoseViewController ()
@property (strong, nonatomic) IBOutlet UITextField *TextField;

@end

@implementation GlucoseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender {
    float currentLevel = [self.TextField.text floatValue];
    
    [[HealthKitController sharedInstance] saveGlucoseLevelsWithFloat:currentLevel];
}

- (IBAction)screenTapped:(id)sender {
    [[HealthKitController sharedInstance] requestHKPermission];
    [self.TextField resignFirstResponder];
}


@end
