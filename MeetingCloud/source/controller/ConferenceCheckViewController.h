//
//  ConferenceCheckViewController.h
//  MeetingCloud
//
//  Created by Geory on 13-7-17.
//  Copyright (c) 2013年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZXingWidgetController.h>

@interface ConferenceCheckViewController : UIViewController<ZXingDelegate>
{
    NSString *_openUDID;
}

- (IBAction)backBtnClick:(id)sender;
- (IBAction)scanBtnClick:(id)sender;

@end
