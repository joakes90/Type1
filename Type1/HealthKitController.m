//
//  HealthKitController.m
//  Type1
//
//  Created by Justin Oakes on 5/18/15.
//  Copyright (c) 2015 Devmtn. All rights reserved.
//

#import "HealthKitController.h"

@interface HealthKitController ()

@property (strong, nonatomic) HKHealthStore *HealthStore;

@end

@implementation HealthKitController

+ (instancetype) sharedInstance {
    static HealthKitController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HealthKitController alloc] init];
        
        sharedInstance.HealthStore = [[HKHealthStore alloc] init];
    });
    return sharedInstance;
}


-(void)saveGlucoseLevelsWithFloat:(float)number{
    HKUnit *mg = [HKUnit gramUnitWithMetricPrefix:HKMetricPrefixMilli];
    HKUnit *dl = [HKUnit literUnitWithMetricPrefix:HKMetricPrefixDeci];
    HKUnit *mgPerDl = [mg unitDividedByUnit:dl];
    
    HKQuantity *glucoseLevel = [HKQuantity quantityWithUnit:mgPerDl doubleValue:number];
    
    HKQuantityType *bloodGlucoseType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
    
    HKQuantitySample *bloodGlucoseSample = [HKQuantitySample quantitySampleWithType:bloodGlucoseType
                                                                           quantity:glucoseLevel
                                                                          startDate:[NSDate new] endDate:[NSDate new]];
    
    [_HealthStore saveObject:bloodGlucoseSample withCompletion:^(BOOL success, NSError *error) {
        NSLog(@"Saved");
    }];
    
}


@end
