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
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;


@property (strong, nonatomic) NSArray *xAxis;
@property (strong, nonatomic) NSArray *data;
@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.xAxis = @[@"12", @"2", @"4", @"6", @"8", @"10",@"12", @"2", @"4", @"6", @"8", @"10"];
    self.data = @[@40.0, @400.0, @250.0, @200.0, @250.0, @300.0, @200.0, @250.0, @200.0, @350.0];
    
    [self buildGraph];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buildGraph {
    self.GraphView.dataSource = self;
    self.GraphView.delegate = self;
    self.GraphView.backgroundColor = [UIColor darkGrayColor];
    self.GraphView.maximumValue = 400.0;
    self.GraphView.minimumValue = 0;
    
    [self.GraphView reloadData];

    
}

#pragma mark - Requiered JBLineGraph methods

-(NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex {
    
    return self.data.count;
}

-(CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex {
    
    return [self.data[horizontalIndex] doubleValue];
}

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView {
    
    return 1;
}

#pragma mark - Optional JBLineGraph methods

-(UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex {
    
    return [UIColor colorWithRed:96.0/255 green:140.0/255 blue:195.0/255 alpha:1];
}

-(BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex {
    
    return YES;
}

-(UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex {
    return [UIColor whiteColor];
}

-(BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex{
    
    return YES;
}

-(CGFloat)lineChartView:(JBLineChartView *)lineChartView dotRadiusForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex{
    return 5.0;
}

-(void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex {
    self.infoLabel.text = [NSString stringWithFormat:@"Blood glucose for add later: add later"];
}

-(void)didDeselectLineInLineChartView:(JBLineChartView *)lineChartView {
    self.infoLabel.text = @"";
}
@end
