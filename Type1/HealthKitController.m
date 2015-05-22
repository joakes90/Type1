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

@property (strong, nonatomic) NSArray *GlucoseStats;

@property (strong, nonatomic) NSArray *FatStats;

@property (strong, nonatomic) NSArray *ProteinStats;

@property (strong, nonatomic) NSArray *CarbStats;

@property (strong, nonatomic) NSArray *Glucosedata;

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

-(BOOL) requestHKPermission {
    if ([HKHealthStore isHealthDataAvailable]) {
    
    NSSet *typesToUse = [NSSet setWithArray:@[[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose],
                                              [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryFatTotal],
                                              [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryProtein],
                                              [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCarbohydrates]
                                              ]];
    
    [_HealthStore requestAuthorizationToShareTypes:typesToUse readTypes:typesToUse completion:^(BOOL success, NSError *error) {
        
    }];
        return YES;
    } else {
        return NO;
    }
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



-(void)saveUnitsOfInsulinInjected:(float)number andType:(NSString *)kind {
    Injection *injection = [NSEntityDescription insertNewObjectForEntityForName:@"Injection" inManagedObjectContext:[Stack sharedInstance].managedObjectContext];
    injection.units = [NSNumber numberWithFloat:number];
    injection.time = [NSDate new];
    injection.type = kind;
    
    [[Stack sharedInstance].managedObjectContext save:nil];
}

-(void)GlucoseStatsQuereyforNumberofWeeks:(int)weeks {
    
    HKQuantityType *glucoseType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
    NSDate *anchorDate = [NSDate dateWithTimeIntervalSinceNow:-86400 * (weeks * 7)];
    NSDateComponents *days = [[NSDateComponents alloc] init];
    days.day = 1;
    
    HKStatisticsCollectionQuery *glucoseQuery = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:glucoseType
                                                                                  quantitySamplePredicate:nil
                                                                                                  options:HKStatisticsOptionDiscreteAverage
                                                                                               anchorDate:anchorDate
                                                                                       intervalComponents:days];
    
    glucoseQuery.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *results, NSError *error) {
        if (error) {
            NSLog(@"Error occured");
            abort();
        } else {
            NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
            
            [results enumerateStatisticsFromDate:anchorDate toDate:[NSDate new] withBlock:^(HKStatistics *result, BOOL *stop) {
                [resultsArray addObject:result];
            }];
            
            [resultsArray removeObjectAtIndex:resultsArray.count - 1];
            self.GlucoseStats = resultsArray;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"glucoseReport" object:nil];
        }};
    
    
    [_HealthStore executeQuery:glucoseQuery];
    
}

-(void)fatStatusQuereyforNumberOfWeeks:(int)weeks {
    
    HKQuantityType *fatType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryFatTotal];
    NSDate *anchorDate =[NSDate dateWithTimeIntervalSinceNow:-86400 * (weeks * 7)];
    NSDateComponents *days = [[NSDateComponents alloc] init];
    days.day = 1;
    
    HKStatisticsCollectionQuery *fatQuerey =[[HKStatisticsCollectionQuery alloc] initWithQuantityType:fatType
                                                                              quantitySamplePredicate:nil
                                                                                              options:HKStatisticsOptionCumulativeSum
                                                                                           anchorDate:anchorDate
                                                                                   intervalComponents:days];
    
    fatQuerey.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *results, NSError *error) {
        if (error) {
            NSLog(@"Error occured");
            abort();
        } else {
            NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
            
            [results enumerateStatisticsFromDate:anchorDate toDate:[NSDate new] withBlock:^(HKStatistics *result, BOOL *stop) {
                [resultsArray addObject:result];
            }];
            [resultsArray removeObjectAtIndex:resultsArray.count -1];
            self.FatStats = resultsArray;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"fatReport" object:nil];
        }};
    
    [_HealthStore executeQuery:fatQuerey];
}

-(void)proteinStatusQuereyforNumberOfWeeks:(int)weeks {
    
    HKQuantityType *proteinType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryProtein];
    NSDate *anchorDate = [NSDate dateWithTimeIntervalSinceNow:-86400 * (weeks * 7)];
    NSDateComponents *days = [[NSDateComponents alloc] init];
    days.day = 1;
    
    HKStatisticsCollectionQuery *proteinQuerey = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:proteinType
                                                                                   quantitySamplePredicate:nil
                                                                                                   options:HKStatisticsOptionCumulativeSum
                                                                                                anchorDate:anchorDate
                                                                                        intervalComponents:days];
    
    proteinQuerey.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *results, NSError *error) {
        if (error) {
            NSLog(@"Error occured");
            abort();
        } else {
            NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
            
            [results enumerateStatisticsFromDate:anchorDate toDate:[NSDate new] withBlock:^(HKStatistics *result, BOOL *stop) {
                [resultsArray addObject:result];
            }];
            [resultsArray removeObjectAtIndex:resultsArray.count -1];
            self.ProteinStats = resultsArray;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"proteinReport" object:nil];
        }};
    [_HealthStore executeQuery:proteinQuerey];
}

-(void)carbStatusQuereyforNumberOfWeeks:(int)weeks {
    HKQuantityType *carbType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCarbohydrates];
    NSDate *anchorDate = [NSDate dateWithTimeIntervalSinceNow:-86400 * (weeks * 7)];
    NSDateComponents *days = [[NSDateComponents alloc] init];
    days.day = 1;
    
    HKStatisticsCollectionQuery *carbsQuerey = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:carbType
                                                                                 quantitySamplePredicate:nil
                                                                                                 options:HKStatisticsOptionCumulativeSum
                                                                                              anchorDate:anchorDate
                                                                                      intervalComponents:days];
    carbsQuerey.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *results, NSError *error) {
        if (error) {
            NSLog(@"Error occured");
            abort();
        } else {
            NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
            
            [results enumerateStatisticsFromDate:anchorDate toDate:[NSDate new] withBlock:^(HKStatistics *result, BOOL *stop) {
                [resultsArray addObject:result];
            }];
            [resultsArray removeObjectAtIndex:resultsArray.count - 1];
            self.CarbStats = resultsArray;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"carbReport" object:nil];
        }};
    [_HealthStore executeQuery:carbsQuerey];
}


-(void)allGlucoseNumbersForToday {
    HKQuantityType *glucoseType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
    NSDate *anchorDate = [NSDate dateWithTimeIntervalSinceNow:-86400];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:anchorDate endDate:[NSDate new] options:HKQueryOptionNone];

    
   HKSampleQuery *glucoseQuerey = [[HKSampleQuery alloc] initWithSampleType:glucoseType
                                                                predicate:predicate
                                                                    limit:HKObjectQueryNoLimit
                                                        sortDescriptors:nil
resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
    NSLog(@"%@", results);
    
}];
    [_HealthStore executeQuery:glucoseQuerey];
    
}


-(NSArray *)numberOfinjectionsperDayforNumberOfWeeks:(int)weeks {
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-86400 * (weeks * 7)];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Injection"];
    NSArray *allInjections = [[Stack sharedInstance].managedObjectContext executeFetchRequest:request error:nil];
    NSMutableArray *injectionsinRange = [[NSMutableArray alloc] init];
    
    for (Injection *i in allInjections) {
        NSDate *laterDate = [startDate laterDate:i.time];
        BOOL isInRange = [laterDate isEqual:i.time];
        
        if (isInRange) {
            [injectionsinRange addObject:i];
        }
    }
    return injectionsinRange;
}


-(NSArray *) grabGlucose {
    return self.GlucoseStats;
}

-(NSArray *) grabFat {
    return self.FatStats;
}

-(NSArray *)grabProtein {
    return self.ProteinStats;
}

-(NSArray *)grabCarbs {
    return self.CarbStats;
}

-(NSArray *)grabGlucoseData {
    return self.Glucosedata;
}

@end
