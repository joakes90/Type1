//
//  ReportBuilder.m
//  Type1
//
//  Created by Justin Oakes on 5/25/15.
//  Copyright (c) 2015 Devmtn. All rights reserved.
//

#import "ReportBuilder.h"
#import "HealthKitController.h"
@import HealthKit;

@interface ReportBuilder ()

@property NSString *HTMLString;

@property NSArray *glucoseArray;

@end

@implementation ReportBuilder


+ (instancetype) sharedInstance {
    static ReportBuilder *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ReportBuilder alloc] init];
        sharedInstance.HTMLString = [NSString stringWithFormat:@"<html> \n <body>"];
    });
    return sharedInstance;
}


- (void) buildStringForNumberOfWeeks:(float)number {
    [[HealthKitController sharedInstance] GlucoseStatsQuereyforNumberofWeeks:number];
    [[HealthKitController sharedInstance] carbStatusQuereyforNumberOfWeeks:number];
    [[HealthKitController sharedInstance] proteinStatusQuereyforNumberOfWeeks:number];
    [[HealthKitController sharedInstance] fatStatusQuereyforNumberOfWeeks:number];
    
    
    
    [self addInjectionDataForWeeks:number];
    [self performSelector:@selector(addGlucoseDataForWeeks) withObject:nil afterDelay:0.75];
}


- (void)addInjectionDataForWeeks:(float)number {
   NSArray *injectionArray = [[HealthKitController sharedInstance] numberOfinjectionsperDayforNumberOfWeeks:number];
    
    for (Injection *injection in injectionArray) {
        NSString *dateString = [NSDateFormatter localizedStringFromDate:injection.time dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
        NSString *newString = [NSString stringWithFormat:@"<li> On %@ I injected %@ Units of %@ </li> \n",dateString, injection.units, injection.type];
        [self.HTMLString stringByAppendingString:newString];
        
        //replace with building the string
//        NSLog(@"%@",newString);
    }
}

- (void)addGlucoseDataForWeeks {
    NSArray *glucoseData = [[HealthKitController sharedInstance] grabGlucose];
    for (HKStatistics *stat in glucoseData) {
        if (stat.averageQuantity) {
            NSLog(@"%@", stat.averageQuantity);
        }
    }
}


@end
