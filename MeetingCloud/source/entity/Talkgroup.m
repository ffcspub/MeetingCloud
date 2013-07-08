//
//  Talkgroup.m
//  MeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "Talkgroup.h"
#import "UITools.h"

@implementation Talkgroup

@synthesize groupId;
@synthesize groupname;
@synthesize content;
@synthesize tdConferenceId;
@synthesize grouptype;
@synthesize groupUsers;


-(void) dealloc{
    [groupId release];
    [groupname release];
    [content release];
    [tdConferenceId release];
    [grouptype release];
    [groupUsers release];
    [super dealloc];
}

-(NSObject *) dic2Object:(NSDictionary *)dic{
    Talkgroup *toolbean = [[[Talkgroup alloc]init]autorelease];
    toolbean.groupId= [dic objectToStringForKey:@"id"];
    toolbean.groupname= [dic objectToStringForKey:@"groupname"];
    toolbean.content= [dic objectToStringForKey:@"content"];
    toolbean.tdConferenceId= [dic objectToStringForKey:@"tdConferenceId"];
    toolbean.grouptype= [dic objectToStringForKey:@"grouptype"];
    toolbean.groupUsers = [dic objectToStringForKey:@"groupUsers"];
    return toolbean;
}

-(id) copyWithZone:(NSZone *)zone{
    Talkgroup *group = [[[Talkgroup alloc]init]autorelease];
    group.groupId = self.groupId;
    group.groupname = self.groupname;
    group.content = self.content;
    group.tdConferenceId = self.tdConferenceId;
    group.grouptype = self.grouptype;
    group.groupUsers = self.groupUsers;    
    return  group;
}

@end
