//
//  ReportBuilder.h
//  Type1
//
//  Created by Justin Oakes on 5/25/15.
//  Copyright (c) 2015 Devmtn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportBuilder : NSObject

+ (instancetype) sharedInstance;

- (void) buildStringForNumberOfWeeks:(float)number;

- (NSString *) grabHTML;

@end
