//
//  UserCheckViewController.m
//  MeetingCloud
//
//  Created by songhang he on 12-7-11.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "UserCheckViewController.h"
#import "UITools.h"
#import "HttpHelper.h"
#import "ShareManager.h"
#import <QRCodeReader.h>
#import <MultiFormatOneDReader.h>
#import <UniversalResultParser.h>
#import <ParsedResult.h>
#import <ResultAction.h>


@implementation UserCheckViewController
@synthesize scanType = _scanType;

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
    _scanType = 1;
    [self leftTextLableWithUITextField:tf_code text:@"签到码："];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -Action
-(IBAction)backBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)scanBtnClicked:(id)sender{
    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    MultiFormatOneDReader *OneReaders=[[MultiFormatOneDReader alloc]init];
    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    NSSet *readers = [[NSSet alloc ] initWithObjects:OneReaders,qrcodeReader,nil];
    [qrcodeReader release];
    [OneReaders release];
    widController.readers = readers;
    [readers release];
    NSBundle *mainBundle = [NSBundle mainBundle];
    widController.soundToPlay =
    [NSURL fileURLWithPath:[mainBundle pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];
    [self presentModalViewController:widController animated:YES];
    [widController release];
}

-(IBAction)submitClicked:(id)sender{
    if ([tf_code.text length] ==0) {
        [UITools easyAlert:@"请输入签到码" cancelButtonTitle:@"确定"];
    }else {
        [self checkCode];
    }
}

#pragma mark -MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperViewOnHide];
    hud = nil;
    if (_error) {
        [UITools easyAlert:[UITools getErrorMsg:_error] cancelButtonTitle:@"确定"];
        [_error release];
        _error = nil;
    }else {
        [UITools easyAlert:_msg cancelButtonTitle:@"确定"];
        [_msg release];
        _msg = nil;
    }
}

-(void) leftTextLableWithUITextField:(UITextField *) textField  text:(NSString *)text{
    UIView *leftview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 60)];
    [leftview setBackgroundColor:[UIColor clearColor]];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 60)];
    [lable setBackgroundColor:[UIColor clearColor]];
    [lable setFont:[UIFont systemFontOfSize:17]];
    [lable setTextColor:[UIColor blackColor]];
    [lable setText:text];
    [leftview addSubview:lable];
    [lable release];
    textField.leftView = leftview;
    [leftview release];
    textField.leftViewMode = UITextFieldViewModeAlways;
}

-(void) checkCode{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        HttpHelper *helper = [[HttpHelper alloc]init];
        [helper checkCode:_scanType content:tf_code.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (!helper.error) {
                [UITools easyAlert:@"签到成功" cancelButtonTitle:@"确定"];
            }else{
                [UITools easyAlert:[UITools getErrorMsg:helper.error] cancelButtonTitle:@"确定"];
            }
        });
    });
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([@"\n" isEqualToString:string]) {
        _scanType = 1;
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark -
#pragma mark ZXingDelegateMethods

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {
    tf_code.text = result;
    _scanType = 2;
    [self dismissModalViewControllerAnimated:NO];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
    [self dismissModalViewControllerAnimated:YES];
}

@end
