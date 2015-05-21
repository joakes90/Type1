//
//  ViewController.m
//  Type1
//
//  Created by Justin Oakes on 5/18/15.
//  Copyright (c) 2015 Devmtn. All rights reserved.
//

#import "ReviewViewController.h"
#import "HealthKitController.h"
#import "GraphView.h"

@interface ReviewViewController () <JBLineChartViewDataSource, JBLineChartViewDelegate>
@property (strong, nonatomic) IBOutlet GraphView *GraphView;

@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self buildGraph];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buildGraph {
    self.GraphView.dataSource = self;
    self.GraphView.delegate = self;
    

}

-(NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex {
    
}

-(CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex {
    
}

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView {
    
}

@end
