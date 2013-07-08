//
//  Talkmessage.m
//  MeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "Talkmessage.h"
#import "UITools.h"
#import "UserInfo.h"


@implementation Talkmessage

@synthesize messageId;
@synthesize tdUserId;
@synthesize content;
@synthesize createdate;
@synthesize imsi;
@synthesize picturename;
@synthesize picturenameThum;
@synthesize tdConferenceId;
@synthesize commentcount;
@synthesize clickcount;
@synthesize userInfo;

-(void) dealloc{
    [messageId release];
    [tdUserId release];
    [content release];
    [createdate release];
    [imsi release];
    [picturename release];
    [picturenameThum release];
    [tdConferenceId release];
    [commentcount release];
    [clickcount release];
    [userInfo release];
    [super dealloc];
}

-(NSObject *) dic2Object:(NSDictionary *)dic{
    Talkmessage *toolbean = [[[Talkmessage alloc]init]autorelease];
    toolbean.messageId= [dic objectToStringForKey:@"id"];
    toolbean.tdUserId= [dic objectToStringForKey:@"tdUserId"];
    toolbean.content= [dic objectToStringForKey:@"content"];
    toolbean.createdate= [dic objectToStringForKey:@"createdate"];
    toolbean.imsi= [dic objectToStringForKey:@"imsi"];
    toolbean.picturename= [dic objectToStringForKey:@"picturename"];
    toolbean.picturenameThum= [dic objectToStringForKey:@"picturenameThum"];
    toolbean.tdConferenceId= [dic objectToStringForKey:@"tdConferenceId"];
    toolbean.commentcount= [dic objectToStringForKey:@"commentcount"];
    toolbean.clickcount= [dic objectToStringForKey:@"clickcount"];
    NSDictionary *userdic = [dic objectForKey:@"userInfo"];
    if (userdic) {
        UserInfo *userToolbean = [[[UserInfo alloc]init]autorelease];
        toolbean.userInfo = (UserInfo *)[userToolbean dic2Object:userdic];
    }
    return toolbean;
}

@end
