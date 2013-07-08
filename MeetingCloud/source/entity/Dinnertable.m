//
//  Dinnertable.m
//  ＭeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "Dinnertable.h"
#import "UITools.h"

@implementation Dinnertable

@synthesize tableId;
@synthesize name;
@synthesize tdConferenceId;
@synthesize tdDinnerplanId;
@synthesize dinnername;
@synthesize content;

-(void) dealloc{
    [tableId release];
    [name release];
    [tdConferenceId release];
    [tdDinnerplanId release];
    [dinnername release];
    [content release];
    [super dealloc];
}

-(NSObject *) dic2Object:(NSDictionary *)dic{
    Dinnertable *toolbean = [[[Dinnertable alloc]init]autorelease];
    toolbean.tableId= [dic objectToStringForKey:@"id"];
    toolbean.name= [dic objectToStringForKey:@"name"];
    toolbean.tdConferenceId= [dic objectToStringForKey:@"tdConferenceId"];
    toolbean.tdDinnerplanId= [dic objectToStringForKey:@"tdDinnerplanId"];
    toolbean.dinnername= [dic objectToStringForKey:@"dinnername"];
    toolbean.content= [dic objectToStringForKey:@"content"];
    return toolbean;
}


@end
