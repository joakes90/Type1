//
//  MainViewController.m
//  Type1
//
//  Created by jonathan thornburg on 5/22/15.
//  Copyright (c) 2015 Devmtn. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageView.image = [UIImage imageNamed:@"brimley"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToMainMenu:(UIStoryboardSegue*)sender {
    
}

@end
