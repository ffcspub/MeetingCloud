//
//  TalkmessageGroup.m
//  MeetingCloud
//
//  Created by Geory on 13-7-9.
//  Copyright (c) 2013年 ffcs. All rights reserved.
//

#import "TalkmessageGroup.h"
#import "UITools.h"

@implementation TalkmessageGroup

@synthesize groupId;
@synthesize tdConferenceId;
@synthesize creatorName;
@synthesize groupname;
@synthesize grouptype;
@synthesize showindex;
@synthesize status;
@synthesize intro;
@synthesize creatorId;
@synthesize joinRight;

- (void)dealloc
{
    [groupId release];
    [tdConferenceId release];
    [creatorName release];
    [groupname release];
    [grouptype release];
    [showindex release];
    [status release];
    [intro release];
    [creatorId release];
    [joinRight release];
    [super dealloc];
}

-(NSObject *) dic2Object:(NSDictionary *)dic{
    TalkmessageGroup *toolbean = [[[TalkmessageGroup alloc]init]autorelease];
    toolbean.groupId= [dic objectToStringForKey:@"id"];
    toolbean.tdConferenceId= [dic objectToStringForKey:@"tdConferenceId"];
    toolbean.creatorName= [dic objectToStringForKey:@"creatorName"];
    toolbean.groupname= [dic objectToStringForKey:@"groupname"];
    toolbean.grouptype= [dic objectToStringForKey:@"grouptype"];
    toolbean.showindex= [dic objectToStringForKey:@"showindex"];
    toolbean.status= [dic objectToStringForKey:@"status"];
    toolbean.intro= [dic objectToStringForKey:@"intro"];
    toolbean.creatorId= [dic objectToStringForKey:@"creatorId"];
    toolbean.joinRight= [dic objectToStringForKey:@"joinRight"];
    return toolbean;
}

@end
