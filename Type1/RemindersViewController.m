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
    
    
    float frequency = 16.0 / [self.textField.text doubleValue];
    frequency = frequency * 3600;
    
    UILocalNotification *reminder = [[UILocalNotification alloc] init];
    
    [reminder setFireDate:[NSDate dateWithTimeIntervalSinceNow:frequency]];
    [reminder setRepeatInterval:NSCalendarUnitSecond];
    
    [reminder setAlertBody:[NSString stringWithFormat:@"Its been %.0f Hours since you last checked your blood sugar", 16 / [self.textField.text doubleValue]]];
    [reminder setSoundName:UILocalNotificationDefaultSoundName];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:reminder];
}


- (IBAction)clear:(id)sender {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
- (IBAction)screenTaped:(id)sender {
    [self.textField resignFirstResponder];
}

@end
