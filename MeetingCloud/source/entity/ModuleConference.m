//
//  ModuleConference.m
//  ＭeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "ModuleConference.h"
#import "UITools.h"

@implementation ModuleConference
@synthesize moduleId;
@synthesize name;
@synthesize icon;
@synthesize iconName;
@synthesize url;
@synthesize tdConferenceId;
@synthesize functionid;
@synthesize englishname;


-(void) dealloc{
    [moduleId release];
    [name release];
    [icon release];
    [iconName release];
    [url release];
    [tdConferenceId release];
    [functionid release];
    [englishname release];
    [super dealloc];
}

-(NSObject *) dic2Object:(NSDictionary *)dic{
    ModuleConference *toolbean = [[[ModuleConference alloc]init]autorelease];
    toolbean.moduleId= [dic objectToStringForKey:@"id"];
    toolbean.name= [dic objectToStringForKey:@"name"];
    toolbean.icon= [dic objectToStringForKey:@"icon"];
    toolbean.iconName= [dic objectToStringForKey:@"iconName"];
    toolbean.url= [dic objectToStringForKey:@"url"];
    toolbean.tdConferenceId= [dic objectToStringForKey:@"tdConferenceId"];
    toolbean.functionid= [dic objectToStringForKey:@"functionid"];
    toolbean.englishname= [dic objectToStringForKey:@"englishname"];
    return toolbean;
}

@end
