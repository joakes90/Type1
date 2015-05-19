//
//  ViewController.m
//  Type1
//
//  Created by Justin Oakes on 5/18/15.
//  Copyright (c) 2015 Devmtn. All rights reserved.
//

#import "ViewController.h"
#import "HealthKitController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addGluco:(id)sender {
    [[HealthKitController sharedInstance] saveUnitsOfInsulinInjected:5.5 andType:@"Type 1"];
    
    [[HealthKitController sharedInstance] requestHKPermission];
    [[HealthKitController sharedInstance] saveGlucoseLevelsWithFloat:99.5];
}



@end
