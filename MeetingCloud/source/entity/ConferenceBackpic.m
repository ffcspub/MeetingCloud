//
//  ConferenceBackpic.m
//  ＭeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "ConferenceBackpic.h"
#import "UITools.h"

@implementation ConferenceBackpic

@synthesize picId;
@synthesize picpath;
@synthesize pictype;
@synthesize conferenceid;

-(void) dealloc{
    [picId release];
    [picpath release];
    [pictype release];
    [conferenceid release];
    [super dealloc];
}

-(NSObject *) dic2Object:(NSDictionary *)dic{
    ConferenceBackpic *toolbean = [[[ConferenceBackpic alloc]init]autorelease];
    toolbean.picId= [dic objectToStringForKey:@"id"];
    toolbean.picpath= [dic objectToStringForKey:@"picpath"];
    toolbean.pictype= [dic objectToStringForKey:@"pictype"];
    toolbean.conferenceid= [dic objectToStringForKey:@"conferenceid"];
    return toolbean;
}

@end
