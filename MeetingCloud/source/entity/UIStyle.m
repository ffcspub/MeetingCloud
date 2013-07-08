//
//  Style.m
//  ＭeetingCould
//
//  Created by songhang he on 12-6-5.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "UIStyle.h"

@implementation UIStyle

@synthesize styleId;
@synthesize name;
@synthesize dirurl;

-(void) dealloc{
    [styleId release];
    [name release];
    [dirurl release];
    [super dealloc];
}

-(NSObject *) dic2Object:(NSDictionary *)dic{
    UIStyle *style = [[[UIStyle alloc]init]autorelease];
    NSNumber *idtemp = [dic objectForKey:@"id"];
    style.styleId = [idtemp stringValue];
    style.name = [dic objectForKey:@"name"];
    style.dirurl = [dic objectForKey:@"dirurl"];
    return style;
}

@end
