//
//  ChatCell.m
//  KeyBoardTest
//
//  Created by wangqiulei on 11-8-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FaceView.h"
#import "ShareManager.h"
#define KFacialSizeWidth 20
#define KFacialSizeHeight 20

@implementation FaceView
@synthesize content = _content;
@synthesize noResizeable = _noResizeable;

-(void) dealloc{
    [_content release];
    _content = nil;
    [data  release];
    data = nil;
    [super dealloc];
}

-(void) setContent:(NSString *)content{
    if (_content) {
        [_content release];
        _content = nil;
    }
    if (content) {
        _content = [content retain];
        if (data) {
            [data removeAllObjects];
        }else {
            data = [[NSMutableArray alloc]init];
        }
        [FaceView getImageRange:_content :data];
        CGFloat height = [FaceView heigthWithContent:content size:self.frame.size];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    }
    [self setNeedsDisplay];

}

-(void) drawRect:(CGRect)rect
{
	UIFont *fon=[UIFont systemFontOfSize:14.0f];
	CGFloat upX=0;
    CGFloat upY=0;
	if (data) {
		for (int i=0;i<[data count];i++) {
			NSString *str=[data objectAtIndex:i];
			if ([str hasPrefix:@"[/"]&&[str hasSuffix:@"]"]) 
            {
                if (upX+ KFacialSizeWidth > rect.size.width) 
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                }
                if (_noResizeable && upY > rect.size.height) {
                    CGSize size= [@"..." sizeWithFont:fon constrainedToSize:rect.size];
                    [@"..." drawInRect:CGRectMake(upX, upY, size.width, self.bounds.size.height) withFont:fon];
                    break;
                }
				NSString *imageName=[NSString stringWithFormat:@"%@.png",[[ShareManager getInstance].faceDic objectForKey:str]];
				UIImage *img=[UIImage imageNamed:imageName];
				[img drawInRect:CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight)];
                upX=KFacialSizeWidth+upX;
			}else 
            {
                for (int j = 0; j<[str length]; j++) 
                {
                    NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                    CGSize size=[temp sizeWithFont:fon constrainedToSize:rect.size];
                    if (upX+size.width > rect.size.width) 
                    {
                        upY = upY + KFacialSizeHeight;
                        upX = 0;
                    }
                    if (_noResizeable && upY > rect.size.height) {
                        [@"..." drawInRect:CGRectMake(upX, upY, size.width, self.bounds.size.height) withFont:fon];
                        break;
                    }
                    [temp drawInRect:CGRectMake(upX, upY, size.width, self.bounds.size.height) withFont:fon];
                    upX=upX+size.width;
                }
			}
        }
        //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, upY);
                                
	}
	
}


//解析输入的文本，根据文本信息分析出那些是表情，那些是文字。

+(void)getImageRange:(NSString*)message :(NSMutableArray*)array
{
	NSRange range=[message rangeOfString:@"[/"];
	NSRange range1=[message rangeOfString:@"]"];
    //判断当前字符串是否还有表情的标志。
    if (range.length&&range1.length) {
        if (range.location>0) {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        }else {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str :array];
            }else {
                return;
            }
        }
    }else {
        [array addObject:message];
    }
	
}

+(CGFloat) heigthWithContent:(NSString *)content size:(CGSize)size{
    if (!content) {
        return KFacialSizeHeight;
    }
    UIFont *fon=[UIFont systemFontOfSize:14.0f];
    CGFloat upX=0;
    CGFloat upY=0;
    NSMutableArray *data = [NSMutableArray array];
    [FaceView getImageRange:content :data];
    if (data) {
        for (int i=0;i<[data count];i++) {
            NSString *str=[data objectAtIndex:i];
            if ([str hasPrefix:@"[/"]&&[str hasSuffix:@"]"]) 
            {
                if (upX+ KFacialSizeHeight > size.width) 
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                }
                upX=KFacialSizeWidth+upX;
            }else 
            {
                for (int j = 0; j<[str length]; j++) 
                {
                    NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                    CGSize size1=[temp sizeWithFont:fon constrainedToSize:size];
                    if (upX+size1.width > size.width)
                    {
                        upY = upY + KFacialSizeHeight;
                        upX = 0;
                    }
                    upX=upX+size1.width;
                }
            }
        }
        return upY + KFacialSizeHeight;
    }
    return KFacialSizeHeight;
}

@end
