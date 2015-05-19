//
//  HealthKitController.h
//  Type1
//
//  Created by Justin Oakes on 5/18/15.
//  Copyright (c) 2015 Devmtn. All rights reserved.
//

#import <Foundation/Foundation.h>
@import HealthKit;

@interface HealthKitController : NSObject

@property (strong, nonatomic, readonly) HKHealthStore *HealthStore;

+ (instancetype) sharedInstance;

-(void) requestHKPermission;

-(void)saveGlucoseLevelsWithFloat:(float)number;

-(void)saveGramsOfFatWithFloat:(float)number;

-(void)saveGramsOfProteinWithFloat:(float)number;

-(void)saveGramsOfCarbsWithFloat:(float)number;

@end
