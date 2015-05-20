//
//  HealthKitController.h
//  Type1
//
//  Created by Justin Oakes on 5/18/15.
//  Copyright (c) 2015 Devmtn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stack.h"
#import "Injection.h"

@import HealthKit;

@interface HealthKitController : NSObject

@property (strong, nonatomic, readonly) HKHealthStore *HealthStore;

+ (instancetype) sharedInstance;

-(BOOL) requestHKPermission;

// SAVE DATA METHODS

-(void)saveGlucoseLevelsWithFloat:(float)number;

-(void)saveGramsOfFatWithFloat:(float)number;

-(void)saveGramsOfProteinWithFloat:(float)number;

-(void)saveGramsOfCarbsWithFloat:(float)number;

-(void)saveUnitsOfInsulinInjected:(float)number andType:(NSString *)kind;

//GENERATE NSARRAYS OF HKSTATISTICS FOR WEEKS SPLIT BY DAYS

-(void)GlucoseStatsQuereyforNumberofWeeks:(int)weeks;

-(void)fatStatusQuereyforNumberOfWeeks:(int)weeks;

-(void)proteinStatusQuereyforNumberOfWeeks:(int)weeks;

-(void)carbStatusQuereyforNumberOfWeeks:(int)weeks;

-(NSArray *)numberOfinjectionsperDayforNumberOfWeeks:(int)weeks;

//RETREAVE GENERATED NSARRAYS

-(NSArray *) grabGlucose;

-(NSArray *) grabFat;

-(NSArray *)grabProtein;

-(NSArray *)grabCarbs;

@end
