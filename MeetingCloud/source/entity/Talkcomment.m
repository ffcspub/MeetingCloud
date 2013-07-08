//
//  Talkcomment.m
//  ＭeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "Talkcomment.h"
#import "UITools.h"

@implementation Talkcomment

@synthesize commentId;
@synthesize tdTalkmessageId;
@synthesize tdUserId;
@synthesize content;
@synthesize createdate;
@synthesize imsi;
@synthesize tdConferenceId;
@synthesize userInfo;

-(void) dealloc{
    [commentId release];
    [tdTalkmessageId release];
    [tdUserId release];
    [content release];
    [createdate release];
    [imsi release];
    [tdConferenceId release];
    [userInfo release];
    [super dealloc];
}

-(NSObject *) dic2Object:(NSDictionary *)dic{
    Talkcomment *toolbean = [[[Talkcomment alloc]init]autorelease];
    toolbean.commentId= [dic objectToStringForKey:@"id"];
    toolbean.tdTalkmessageId= [dic objectToStringForKey:@"tdTalkmessageId"];
    toolbean.tdUserId= [dic objectToStringForKey:@"tdUserId"];
    toolbean.content= [dic objectToStringForKey:@"content"];
    toolbean.createdate= [dic objectToStringForKey:@"createdate"];
    toolbean.imsi= [dic objectToStringForKey:@"imsi"];
    toolbean.tdConferenceId= [dic objectToStringForKey:@"tdConferenceId"];
    NSDictionary *userdic = [dic objectForKey:@"userInfo"];
    if (userdic) {
        UserInfo *userToolbean = [[[UserInfo alloc]init]autorelease];
        toolbean.userInfo = (UserInfo *)[userToolbean dic2Object:userdic];
    }
    return toolbean;
}


@end
