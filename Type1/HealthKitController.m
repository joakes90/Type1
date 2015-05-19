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

-(void) requestHKPermission {
    NSSet *typesToUse = [NSSet setWithArray:@[[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose],
                                              [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryFatTotal],
                                              [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryProtein],
                                              [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCarbohydrates]
                                              ]];
    
    [_HealthStore requestAuthorizationToShareTypes:typesToUse readTypes:typesToUse completion:^(BOOL success, NSError *error) {
        
    }];
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
    
    }];
    
}

-(void)saveGramsOfFatWithFloat:(float)number {
    HKUnit *g = [HKUnit gramUnit];
    HKQuantity *fat = [HKQuantity quantityWithUnit:g doubleValue:number];
    HKQuantityType *fatType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryFatTotal];
    HKQuantitySample *fatSample = [HKQuantitySample quantitySampleWithType:fatType
                                                                  quantity:fat
                                                                 startDate:[NSDate new]
                                                                   endDate:[NSDate new]];
    [_HealthStore saveObject:fatSample withCompletion:^(BOOL success, NSError *error) {
        
    }];
}

-(void)saveGramsOfProteinWithFloat:(float)number {
    HKUnit *g = [HKUnit gramUnit];
    HKQuantity *protein = [HKQuantity quantityWithUnit:g doubleValue:number];
    HKQuantityType *proteinType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryProtein];
    HKQuantitySample *proteinSample = [HKQuantitySample quantitySampleWithType:proteinType
                                                                      quantity:protein
                                                                     startDate:[NSDate new]
                                                                       endDate:[NSDate new]];
    
    [_HealthStore saveObject:proteinSample withCompletion:^(BOOL success, NSError *error) {
        
    }];
}

-(void)saveGramsOfCarbsWithFloat:(float)number {
    HKUnit *g = [HKUnit gramUnit];
    HKQuantity *carbs = [HKQuantity quantityWithUnit:g doubleValue:number];
    HKQuantityType *carbType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCarbohydrates];
    HKQuantitySample *carbSample = [HKQuantitySample quantitySampleWithType:carbType
                                                                   quantity:carbs
                                                                  startDate:[NSDate new]
                                                                    endDate:[NSDate new]];
    
    [_HealthStore saveObject:carbSample withCompletion:^(BOOL success, NSError *error) {
        
    }];
}


@end
