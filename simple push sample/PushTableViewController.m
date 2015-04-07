//
//  PushTableViewController.m
//  simple push sample
//
//  Created by Javier Albillos on 6/3/15.
//  Copyright (c) 2015 Gamedonia. All rights reserved.
//

#import "PushTableViewController.h"
#import <GamedoniaSDK/Gamedonia.h>
#include <GamedoniaSDK/OpenUDID.h>

@interface PushTableViewController ()

@end

@implementation PushTableViewController

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    float grey = (float) 238/255.0f;
    self.view.backgroundColor = [UIColor colorWithRed:(grey)
                                                green:(grey)
                                                 blue:(grey)
                                                alpha:1.0f];
    
    UIImageView *CurrentImage = [UIImageView alloc];
    CurrentImage = [CurrentImage initWithImage:[UIImage imageNamed:@"background"]];
    CurrentImage.frame = self.view.bounds;
    
    [self.tableView setBackgroundView:CurrentImage];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushReceivedWithUserInfo:) name:@"notification"
                                               object:nil];
    
    NSString *ses_token = [NSString alloc];
    ses_token = [[Gamedonia users] getSessionToken];
    
    if (ses_token != nil) {
        
        [[Gamedonia users] loginUserWithSessionToken:ses_token callback:^(BOOL success) {
            
            if (success) {
                
                [self processLogin];
            }
            else{
                
                NSLog(@"No active session token detected.");
            }
        }];
            

    }
    else {
        
        NSString* openUDID = [OpenUDID value];
        
        GDUser * user = [GDUser alloc];
        Credentials *credentials = [[Credentials alloc] init];
        [credentials setOpen_udid:openUDID];
        user.credentials = credentials;
        
        [[Gamedonia users] createUser:user callback:^(BOOL cr_success) {
            
            [self printText:@"Starting session with Gamedonia..."];
            
            [[Gamedonia users] loginUserWithOpenUDID:^(BOOL log_success) {
                
                if (log_success) {
                    
                    [self processLogin];
                    
                } else {
                    
                    NSLog(@"Login failed");
                }
            }];
        }];
    }
}



-(void) processLogin {
    
    [[Gamedonia users] getMe:^(BOOL getme_success, GDUserProfile *userProfile) {
        
        if (getme_success) {
            
            NSString *uid = [NSString alloc];
            uid = [[Gamedonia users].me _id];
            [self printText:[self concatenate:@"Session started successfully:\nuid: " with:uid]];
            
        }
        else {
            
           NSLog(@"Get me call failed.");
        }
    }];

}

- (void) didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) pushReceivedWithUserInfo:(NSNotification *)notification {
    
    NSDictionary *userInfo = [NSDictionary alloc];
    userInfo = notification.userInfo;
    NSDictionary *myAPS = [userInfo valueForKey:@"aps"];
    NSString *myAlert = [myAPS valueForKey:@"alert"];
    
    [self printText:myAlert];
    

}

- (IBAction) clickGenerate:(id)sender {
    
    [self printText:@"Requesting server to send push..."];
    
    [[Gamedonia script] run:@"sendpush" parameters:[[NSDictionary alloc] init] callback:^(BOOL script_success, NSDictionary *data) {
            if  (script_success) {
                
                [self printText:@"Push requested successfully"];
                
            } else {
                
                [self printText:@"Failed request for server push."];
                
            }
    }];

}

-(NSString*) concatenate:(NSString*)string1 with:(NSString*)string2 {
    
    NSMutableString* result = [NSMutableString stringWithString: string1];
    [result appendString: string2];
    NSString *res_string = result;
    
    return res_string;
}

-(void) printText:(NSString *)text {
    
    NSString *result = [NSString alloc];
    result = [self concatenate: _textView.text with:text];
    result = [self concatenate:result with:@"\n\n"];
    _textView.text = result;
    
    NSRange range = NSMakeRange(_textView.text.length - 1, 1);
    [_textView scrollRangeToVisible:range];

}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

@end
