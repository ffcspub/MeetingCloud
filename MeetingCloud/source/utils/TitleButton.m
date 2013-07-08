//
//  TitleButton.m
//  MeetingCloud
//
//  Created by songhang he on 12-6-19.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "TitleButton.h"

@implementation TitleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleEdgeInsets = UIEdgeInsetsMake(80, 0, 0, 0);
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
