//
//  RemindersViewController.m
//  Type1
//
//  Created by Justin Oakes on 5/26/15.
//  Copyright (c) 2015 Devmtn. All rights reserved.
//

#import "RemindersViewController.h"

@interface RemindersViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textField;


@end

@implementation RemindersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)save:(id)sender {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    UIApplication *application = [UIApplication sharedApplication];
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    
    
    float hours = [self.textField.text doubleValue];
    NSDate *lastFired = [NSDate new];
    
    for (NSInteger time = 1; time <= 200; time++) {
        NSDate *fireTime =[NSDate dateWithTimeInterval:3600 * hours sinceDate:lastFired];
        
        UILocalNotification *reminder = [[UILocalNotification alloc] init];
        [reminder setFireDate:fireTime];
        [reminder setAlertBody:[NSString stringWithFormat:@"Its been %.0f Hours since you last checked your blood sugar", hours]];
        [reminder setSoundName:UILocalNotificationDefaultSoundName];
        [[UIApplication sharedApplication] scheduleLocalNotification:reminder];
        
        lastFired = fireTime;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


- (IBAction)clear:(id)sender {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)screenTaped:(id)sender {
    [self.textField resignFirstResponder];
}

@end
