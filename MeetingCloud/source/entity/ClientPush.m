//
//  ClientPush.m
//  MeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "ClientPush.h"
#import "UITools.h"

@implementation ClientPush

@synthesize pushId;
@synthesize userId;
@synthesize conferenceId;
@synthesize type;
@synthesize pushMsg;
@synthesize optId;

-(void) dealloc{
    [pushId release];
    [userId release];
    [conferenceId release];
    [type release];
    [pushMsg release];
    [optId release];
    [super dealloc];
}

-(NSObject *) dic2Object:(NSDictionary *)dic{
    ClientPush *toolbean = [[[ClientPush alloc]init]autorelease];
    toolbean.pushId= [dic objectToStringForKey:@"id"];
    toolbean.userId= [dic objectToStringForKey:@"userId"];
    toolbean.conferenceId= [dic objectToStringForKey:@"conferenceId"];
    toolbean.type= [dic objectToStringForKey:@"type"];
    toolbean.pushMsg= [dic objectToStringForKey:@"pushMsg"];
    toolbean.optId= [dic objectToStringForKey:@"optId"];
    return toolbean;
}

@end
