//
//  Privatemessage.m
//  ＭeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "Privatemessage.h"
#import "UITools.h"

@implementation Privatemessage

@synthesize messageId;
@synthesize fromuserid;
@synthesize touserid;
@synthesize content;
@synthesize createdate;
@synthesize imsi;
@synthesize picturename;
@synthesize tdConferenceId;
@synthesize parentid;
@synthesize userInfo;

-(void) dealloc{
    [messageId release];
    [fromuserid release];
    [touserid release];
    [content release];
    [createdate release];
    [imsi release];
    [picturename release];
    [tdConferenceId release];
    [parentid release];
    [userInfo release];
    [super dealloc];
}

-(NSObject *) dic2Object:(NSDictionary *)dic{
    Privatemessage *toolbean = [[[Privatemessage alloc]init]autorelease];
    toolbean.messageId= [dic objectToStringForKey:@"id"];
    toolbean.fromuserid= [dic objectToStringForKey:@"fromuserid"];
    toolbean.touserid= [dic objectToStringForKey:@"touserid"];
    toolbean.content= [dic objectToStringForKey:@"content"];
    toolbean.createdate= [dic objectToStringForKey:@"createdate"];
    toolbean.imsi= [dic objectToStringForKey:@"imsi"];
    toolbean.picturename= [dic objectToStringForKey:@"picturename"];
    toolbean.tdConferenceId= [dic objectToStringForKey:@"tdConferenceId"];
    toolbean.parentid= [dic objectToStringForKey:@"parentid"];
    NSDictionary *userdic = [dic objectForKey:@"userInfo"];
    if (userdic) {
        UserInfo *userToolbean = [[[UserInfo alloc]init]autorelease];
        toolbean.userInfo = (UserInfo *)[userToolbean dic2Object:userdic];
    }
    return toolbean;
}



@end
