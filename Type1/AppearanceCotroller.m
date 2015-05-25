//
//  AppearanceComtroller.m
//  Type1
//
//  Created by Justin Oakes on 5/24/15.
//  Copyright (c) 2015 Devmtn. All rights reserved.
//

#import "AppearanceCotroller.h"

@import UIKit;

@implementation AppearanceCotroller

+ (void)setUpAppearance {
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:252.0/255.0 green:32.0/255.0 blue:28.0/255.0 alpha:1]];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:252.0/255.0 green:32.0/255.0 blue:28.0/255.0 alpha:1]];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:252.0/255.0 green:32.0/255.0 blue:28.0/255.0 alpha:1]];
}
@end
