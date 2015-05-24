//
//  FoodViewController.m
//  Type1
//
//  Created by Justin Oakes on 5/24/15.
//  Copyright (c) 2015 Devmtn. All rights reserved.
//

#import "FoodViewController.h"
#import "HealthKitController.h"

@interface FoodViewController ()

@property (strong, nonatomic) IBOutlet UITextField *ProteinTextField;

@property (strong, nonatomic) IBOutlet UITextField *CarbTextField;

@property (strong, nonatomic) IBOutlet UITextField *FatTextField;

@end

@implementation FoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)save:(id)sender {
    
    [[HealthKitController sharedInstance] requestHKPermission];
    
    [[HealthKitController sharedInstance] saveGramsOfCarbsWithFloat:[self.CarbTextField.text doubleValue]];
    [[HealthKitController sharedInstance] saveGramsOfProteinWithFloat:[self.ProteinTextField.text doubleValue]];
    [[HealthKitController sharedInstance] saveGramsOfFatWithFloat:[self.FatTextField.text doubleValue]];
}

- (IBAction)viewTapped:(id)sender {
    [self.CarbTextField resignFirstResponder];
    [self.ProteinTextField resignFirstResponder];
    [self.FatTextField resignFirstResponder];
}

@end
