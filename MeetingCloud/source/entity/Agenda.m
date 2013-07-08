//
//  Agenda.m
//  ＭeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "Agenda.h"
#import "UITools.h"

@implementation Agenda
@synthesize agendaId;
@synthesize name;
@synthesize starttime;
@synthesize endtime;
@synthesize columndetail;
@synthesize content;
@synthesize createdate;
@synthesize tdConferenceId;
@synthesize agendDate;
@synthesize agendWeek;

-(void) dealloc{
    [agendaId release];
    [name release];
    [starttime release];
    [endtime release];
    [columndetail release];
    [content release];
    [createdate release];
    [tdConferenceId release];
    [agendDate release];
    [agendWeek release];
    [super dealloc];
}

-(NSObject *) dic2Object:(NSDictionary *)dic{
    Agenda *toolbean = [[[Agenda alloc]init]autorelease];
    toolbean.agendaId= [dic objectToStringForKey:@"id"];
    toolbean.name= [dic objectToStringForKey:@"name"];
    toolbean.starttime= [dic objectToStringForKey:@"starttime"];
    toolbean.endtime= [dic objectToStringForKey:@"endtime"];
    toolbean.columndetail= [dic objectToStringForKey:@"columndetail"];
    toolbean.content= [dic objectToStringForKey:@"content"];
    toolbean.createdate= [dic objectToStringForKey:@"createdate"];
    toolbean.tdConferenceId= [dic objectToStringForKey:@"tdConferenceId"];
    toolbean.agendDate= [dic objectToStringForKey:@"agendDate"];
    toolbean.agendWeek= [dic objectToStringForKey:@"agendWeek"];
    return toolbean;
}

@end
