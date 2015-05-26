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

@property (strong, nonatomic) NSString *HTMLString;

@property (assign, nonatomic) float numberOfWeeks;

@end

@implementation ReportBuilder


+ (instancetype) sharedInstance {
    static ReportBuilder *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ReportBuilder alloc] init];
        
    });
    return sharedInstance;
}


- (void) buildStringForNumberOfWeeks:(float)number {
    self.numberOfWeeks = number;
    self.HTMLString = [NSString stringWithFormat:@"<html> \n <body> \n <h1> Diabetes Report </h1>  <h2> Powered by Type 1 </h2> "];
    [[HealthKitController sharedInstance] GlucoseStatsQuereyforNumberofWeeks:number];
    [[HealthKitController sharedInstance] carbStatusQuereyforNumberOfWeeks:number];
    [[HealthKitController sharedInstance] proteinStatusQuereyforNumberOfWeeks:number];
    [[HealthKitController sharedInstance] fatStatusQuereyforNumberOfWeeks:number];
    
    
    
    
    [self performSelector:@selector(addGlucoseDataForWeeks) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(addInjectionDataForWeeks) withObject:nil afterDelay:0.55];
    [self performSelector:@selector(addCarbsDataForWeeks) withObject:nil afterDelay:0.6];
    [self performSelector:@selector(addProteinDataForWeeks) withObject:nil afterDelay:0.65];
    [self performSelector:@selector(addFatDataForWeeks) withObject:nil afterDelay:0.7];
    
}


- (void)addGlucoseDataForWeeks {
   self.HTMLString = self.HTMLString = [self.HTMLString stringByAppendingString:@"<h3>Blood Suger Data</h3>  \n <ul>"];
    NSArray *glucoseData = [[HealthKitController sharedInstance] grabGlucose];
    for (HKStatistics *stat in glucoseData) {
        if (stat.averageQuantity) {
            NSString *dateString = [NSDateFormatter localizedStringFromDate:stat.startDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
            NSString *newString = [NSString stringWithFormat:@"<li> Average blood glucose on %@ was %@ </li> \n", dateString, stat.averageQuantity];
            self.HTMLString = [self.HTMLString stringByAppendingString:newString];
            //replace with building the string
//            NSLog(@"%@", newString);
        }
    }
  self.HTMLString =  [self.HTMLString stringByAppendingString:@"</ul> \n"];
}

- (void)addInjectionDataForWeeks {
   self.HTMLString = [self.HTMLString stringByAppendingString:@"<h3>Insulin Data</h3>  \n <ul>"];
    
    NSArray *injectionArray = [[HealthKitController sharedInstance] numberOfinjectionsperDayforNumberOfWeeks:self.numberOfWeeks];
    
    for (Injection *injection in injectionArray) {
        NSString *dateString = [NSDateFormatter localizedStringFromDate:injection.time dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
        NSString *newString = [NSString stringWithFormat:@"<li> On %@ I injected %@ Units of %@ </li> \n",dateString, injection.units, injection.type];
       self.HTMLString = [self.HTMLString stringByAppendingString:newString];
        
        //replace with building the string
        //        NSLog(@"%@",newString);
    }
   self.HTMLString = [self.HTMLString stringByAppendingString:@"</ul> \n"];
}

- (void)addCarbsDataForWeeks {
  self.HTMLString = [self.HTMLString stringByAppendingString:@"<h3>Carb Data</h3>  \n <ul>"];
    NSArray *carbData = [[HealthKitController sharedInstance] grabCarbs];
    for (HKStatistics *stat in carbData) {
        if (stat.sumQuantity) {
            NSString *dateString = [NSDateFormatter localizedStringFromDate:stat.startDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
            NSString *newString = [NSString stringWithFormat:@"<li> On %@ my total carb intake was %@ </li> \n", dateString, stat.sumQuantity];
            self.HTMLString = [self.HTMLString stringByAppendingString:newString];
            
            //replace with building the string
        }
    }
   self.HTMLString = [self.HTMLString stringByAppendingString:@"</ul> \n"];
}

- (void)addProteinDataForWeeks {
    self.HTMLString = [self.HTMLString stringByAppendingString:@"<h3>Protein Data</h3>  \n <ul>"];
    NSArray *proteinData = [[HealthKitController sharedInstance] grabProtein];
    for (HKStatistics *stat in proteinData) {
        if (stat.sumQuantity) {
            NSString *dateString = [NSDateFormatter localizedStringFromDate:stat.startDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
            NSString *newString = [NSString stringWithFormat:@"<li> On %@ my total protein intake was %@ </li> \n", dateString, stat.sumQuantity];
           self.HTMLString = [self.HTMLString stringByAppendingString:newString];
            
            //build the string
        }
    }
    self.HTMLString = [self.HTMLString stringByAppendingString:@"</ul> \n"];
}

- (void)addFatDataForWeeks {
    self.HTMLString =[self.HTMLString stringByAppendingString:@"<h3>Fat Data</h3>  \n <ul>"];
    NSArray *fatData = [[HealthKitController sharedInstance] grabFat];
    for (HKStatistics *stat in fatData) {
        if (stat.sumQuantity) {
            NSString *dateString = [NSDateFormatter localizedStringFromDate:stat.startDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
            NSString *newString = [NSString stringWithFormat:@"<li> On %@ my total fat intake was %@ </li> \n", dateString, stat.sumQuantity];
           self.HTMLString = [self.HTMLString stringByAppendingString:newString];
            
            //build the String
        }
    }
    self.HTMLString = [self.HTMLString stringByAppendingString:@"</ul> \n </body> </html>"];
}

- (NSString *) grabHTML {
    return self.HTMLString;
}

@end
