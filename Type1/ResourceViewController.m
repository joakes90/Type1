//
//  ResourceViewController.m
//  Type1
//
//  Created by Justin Oakes on 5/24/15.
//  Copyright (c) 2015 Devmtn. All rights reserved.
//

#import "ResourceViewController.h"

@interface ResourceViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *WebView;

@end

@implementation ResourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    NSURL *defaultURL = [NSURL URLWithString:@"http://www.myfitnesspal.com/food/calorie-chart-nutrition-facts"];
    NSURLRequest *defaultRequest = [NSURLRequest requestWithURL:defaultURL];
    
    [self.WebView loadRequest:defaultRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.WebView goBack];
}

- (IBAction)forward:(id)sender {
    [self.WebView goForward];
}

@end
