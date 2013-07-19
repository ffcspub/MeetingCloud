//
//  ConferenceCheckViewController.m
//  MeetingCloud
//
//  Created by Geory on 13-7-17.
//  Copyright (c) 2013年 ffcs. All rights reserved.
//

#import "ConferenceCheckViewController.h"
#import <QRCodeReader.h>
#import <MultiFormatOneDReader.h>
#import <UniversalResultParser.h>
#import <ParsedResult.h>
#import <ResultAction.h>
#import "MBProgressHUD.h"
#import "HttpHelper.h"
#import "ShareManager.h"
#import "UITools.h"
#include "OpenUDID.h"

@interface ConferenceCheckViewController ()

@end

@implementation ConferenceCheckViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _openUDID = [[NSString alloc] init];
    _openUDID = [OpenUDID value];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_openUDID release];
    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)submit:(NSString *)code
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        HttpHelper *helper = [[[HttpHelper alloc] init] autorelease];
        [helper checkCodeByUserId:[ShareManager getInstance].userInfo.userId qrcode:code imei:_openUDID];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (!helper.error) {
                [UITools easyAlert:helper.msg cancelButtonTitle:@"确定"];
            } else {
                [UITools easyAlert:[UITools getErrorMsg:helper.error] cancelButtonTitle:@"确定"];
            }
        });
    });
}

#pragma mark - Action

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)scanBtnClick:(id)sender {
    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    MultiFormatOneDReader *oneReader = [[MultiFormatOneDReader alloc] init];
    QRCodeReader *qrCodeReader = [[QRCodeReader alloc] init];
    NSSet *readers = [[NSSet alloc] initWithObjects:oneReader, qrCodeReader, nil];
    [oneReader release];
    [qrCodeReader release];
    widController.readers = readers;
    [readers release];
    [self presentModalViewController:widController animated:YES];
    [widController release];
}

#pragma mark -
#pragma mark ZXingDelegateMethods

- (void)zxingController:(ZXingWidgetController *)controller didScanResult:(NSString *)result
{
    NSString *code = result;
    [self dismissModalViewControllerAnimated:NO];
    
    [self submit:code];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
