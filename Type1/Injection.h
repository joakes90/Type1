//
//  Injection.h
//  Type1
//
//  Created by Justin Oakes on 5/19/15.
//  Copyright (c) 2015 Devmtn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Injection : NSManagedObject

@property (nonatomic, retain) NSNumber * units;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * type;

@end
