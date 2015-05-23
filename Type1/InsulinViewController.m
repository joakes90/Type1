//
//  InsulinViewController.m
//  Type1
//
//  Created by Justin Oakes on 5/23/15.
//  Copyright (c) 2015 Devmtn. All rights reserved.
//

#import "InsulinViewController.h"
#import "HealthKitController.h"

@interface InsulinViewController ()

@property (strong, nonatomic) IBOutlet UITextField *TextField;

@property (strong, nonatomic) IBOutlet UISegmentedControl *TypeSegment;

@end

@implementation InsulinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)viewTaped:(id)sender {
    [self.TextField resignFirstResponder];
}

- (IBAction)save:(id)sender {
    float qunatity = [self.TextField.text doubleValue];
    NSString *type;
    if (self.TypeSegment.selectedSegmentIndex == 0) {
        type = @"Lantus";
    } else {
        type = @"Humalog";
    }
    
    [[HealthKitController sharedInstance] saveUnitsOfInsulinInjected:qunatity andType:type];
}

@end
