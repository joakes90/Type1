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


@property (strong, nonatomic) NSMutableArray *xAxis;
@property (strong, nonatomic) NSMutableArray *data;
@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [[NSMutableArray alloc] init];
    self.xAxis = [[NSMutableArray alloc] init];
    
    [[HealthKitController sharedInstance] allGlucoseNumbersForToday];


    self.GraphView.backgroundColor = [UIColor darkGrayColor];
    self.GraphView.maximumValue = 400.0;
    self.GraphView.minimumValue = 0;
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildGraph) name:@"dailyG" object:nil];
    // Do any additional setup after loading the view, typically from a nib.

    
    }

-(void)viewWillAppear:(BOOL)animated {
    [self performSelector:@selector(updateGraph) withObject:nil afterDelay:0.75];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buildGraph {

    HKUnit *mg = [HKUnit gramUnitWithMetricPrefix:HKMetricPrefixMilli];
    HKUnit *dl = [HKUnit literUnitWithMetricPrefix:HKMetricPrefixDeci];
    HKUnit *mgPerDl = [mg unitDividedByUnit:dl];

    
    NSArray *rawData = [[HealthKitController sharedInstance] grabGlucoseData];
    
    for (HKQuantitySample *stat in rawData) {
        double quantity = [[stat quantity] doubleValueForUnit:mgPerDl];
        
        [self.data addObject:[NSNumber numberWithDouble:quantity]];
        [self.xAxis addObject:[stat startDate]];
    }
    self.GraphView.dataSource = self;
    self.GraphView.delegate = self;

    [self.GraphView reloadData];
}

-(void)updateGraph {
    [self buildGraph];
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
    NSString *dateString = [NSDateFormatter localizedStringFromDate:self.xAxis[horizontalIndex] dateStyle:nil timeStyle:NSDateFormatterShortStyle];
    
    self.infoLabel.text = [NSString stringWithFormat:@"Blood glucose for %@: %.0f mg/dL",dateString, [self.data[horizontalIndex] doubleValue]];
}

-(void)didDeselectLineInLineChartView:(JBLineChartView *)lineChartView {
    self.infoLabel.text = @"";
}
@end
