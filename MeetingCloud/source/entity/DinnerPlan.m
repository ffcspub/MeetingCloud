//
//  ModuleConference.m
//  ＭeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "DinnerPlan.h"
#import "UITools.h"

@implementation DinnerPlan

@synthesize planId;
@synthesize name;
@synthesize starttime;
@synthesize endtime;
@synthesize columndetail;
@synthesize content;
@synthesize tdConferenceId;
@synthesize dinnerDate;
@synthesize dinnerWeek;
@synthesize menus;
@synthesize dinnerTables;

-(void)dealloc{
    [planId release];
    [name release];
    [starttime release];
    [endtime release];
    [columndetail release];
    [content release];
    [tdConferenceId release];
    [dinnerDate release];
    [dinnerWeek release];
    [menus release];
    [dinnerTables release];
    [super dealloc];
}

-(NSObject *) dic2Object:(NSDictionary *)dic{
    DinnerPlan *toolbean = [[[DinnerPlan alloc]init]autorelease];
    toolbean.planId= [dic objectToStringForKey:@"id"];
    toolbean.name= [dic objectToStringForKey:@"name"];
    toolbean.starttime= [dic objectToStringForKey:@"starttime"];
    toolbean.endtime= [dic objectToStringForKey:@"endtime"];
    toolbean.columndetail= [dic objectToStringForKey:@"columndetail"];
    toolbean.content= [dic objectToStringForKey:@"content"];
    toolbean.tdConferenceId= [dic objectToStringForKey:@"tdConferenceId"];
    toolbean.dinnerDate = [dic objectToStringForKey:@"dinnerDate"];
    toolbean.dinnerWeek = [dic objectToStringForKey:@"dinnerWeek"];
    toolbean.menus = [dic objectToStringForKey:@"menus"];
    return toolbean;
}
@end
