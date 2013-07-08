//
//  UITools.m
//  ChangePhonePush
//
//  Created by he songhang on 11-9-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UITools.h"
#import "Context.h"
#import "UIDevice+IdentifierAddition.h"
#import "pinyin.h"
#import "FTCoreTextView.h"

@implementation UIImage (UIImageExt)
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;      
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }      
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        //NSLog(@"could not scale image");
        
        //pop the context to get back to the default
        UIGraphicsEndImageContext();
    return newImage;
}
//等比例缩放
-(UIImage*)scaleToSize:(CGSize)size{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    width = width*radio;
    height = height*radio;
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;   
}

+(UIImage *)imageNamed:(NSString *)name { 
    
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], name ] ];
} 
@end

@implementation UILabel (private)
-(void) reSizeMake{
    //NSLog(@"%f,%f,%f,%f",self.frame.origin.x, self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    self.numberOfLines = 100;
    CGSize titleSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width,1000) lineBreakMode:UILineBreakModeWordWrap];
    //NSLog(@"%f",titleSize.height);
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                             self.frame.size.width, titleSize.height);
    //NSLog(@"%f,%f,%f,%f",self.frame.origin.x, self.frame.origin.y,self.frame.size.width,self.frame.size.height);
}    
@end

@implementation UITools

+(NSString *)getUtfString:(NSString *)sourceStr{
    CFStringRef stringRef = CFURLCreateStringByAddingPercentEscapes(NULL,  
                                                              (CFStringRef)sourceStr,  
                                                              NULL,  
                                                              (CFStringRef)@"!*'$, %#[]",  
                                                               kCFStringEncodingUTF8);
    NSString *utfStr = (NSString *)stringRef;
	return utfStr;
}



+(void) easyAlert:(NSString *)message cancelButtonTitle:(NSString *)title{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:title otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

+(NSString *)dataFilePath:(NSString *)filename { 
#if TARGET_IPHONE_SIMULATOR && PIERRE_LE_GROS_CRADE
    NSString *directoryPath = @"/Users/steg/changphonepush";
#else
	NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *directoryPath = [paths objectAtIndex:0];
#endif
	return [directoryPath stringByAppendingPathComponent:filename];
}

+(NSDictionary *) loadDictionary:(NSString *)filename{
	NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
	NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
	return dictionary;
}

+(NSString *) myDate:(NSString *)dateformat dates:(int)dates{
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:dateformat];
	
	NSDate *date = [NSDate dateWithTimeIntervalSinceNow:dates*24*60*60];
    NSString *time =  [formatter stringFromDate:date];
    [formatter release];
	return time;
	
}

//获取随机数（0-9）
+(NSString *) getRandcode:(int) size{
	NSMutableString *str = [[[NSMutableString alloc]init]autorelease];
	for (int i = 0; i < size; i++) {
		int rand = arc4random() % 10;
		[str appendFormat:@"%d",rand];
	}
	return str;
}

+(NSString *) fromFormat:(NSString *)fromFormat toFormat:(NSString *) toFormat dateStr:(NSString *)dateStr{
	NSDateFormatter* formatter_from = [[[NSDateFormatter alloc] init] autorelease];
	[formatter_from setDateFormat:fromFormat];
	NSDate * date = [formatter_from dateFromString:dateStr];
	NSDateFormatter* formatter_to = [[[NSDateFormatter alloc] init] autorelease];
	[formatter_to setDateFormat:toFormat];
	NSString *result = [formatter_to stringFromDate:date];
	return result;	
}

//获取机器码
+(NSString *) getImisi{
	return [[UIDevice currentDevice] uniqueDeviceIdentifier];
}

+(NSString *) getErrorMsg:(NSError *)error{
    if([error.domain isEqualToString:NSURLErrorDomain] || [@"ASIHTTPRequestErrorDomain" isEqualToString:error.domain]){
        return MSG_ERROR_URL;
    }else if([error.domain isEqualToString:ERROR_MYTYPE]){
        NSDictionary *dic = error.userInfo;
        return [dic objectForKey:ERROR_MESSAGE];
    }else{
        return MSG_ERROR_SERVER;
    }
}

+ (NSArray *)coreTextStyle
{
    NSMutableArray *result = [NSMutableArray array];
    
	FTCoreTextStyle *defaultStyle = [FTCoreTextStyle new];
	defaultStyle.name = FTCoreTextTagDefault;	//thought the default name is already set to FTCoreTextTagDefault
	defaultStyle.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    defaultStyle.color = [UIColor grayColor];
    defaultStyle.bulletFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
	defaultStyle.textAlignment = FTCoreTextAlignementLeft;
	[result addObject:defaultStyle];
	
	
	FTCoreTextStyle *titleStyle = [FTCoreTextStyle styleWithName:@"title"]; // using fast method
	titleStyle.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:40.f];
	titleStyle.paragraphInset = UIEdgeInsetsMake(0, 0, 25, 0);
	titleStyle.textAlignment = FTCoreTextAlignementCenter;
	[result addObject:titleStyle];
	
	FTCoreTextStyle *imageStyle = [FTCoreTextStyle new];
	imageStyle.paragraphInset = UIEdgeInsetsMake(0,0,0,0);
	imageStyle.name = FTCoreTextTagImage;
	imageStyle.textAlignment = FTCoreTextAlignementLeft;
	[result addObject:imageStyle];
	[imageStyle release];	
    
	FTCoreTextStyle *nameStyle = [FTCoreTextStyle new];
	nameStyle.name = @"nameStyle";
	nameStyle.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:18.f];
	[result addObject:nameStyle];
	[nameStyle release];
    
    FTCoreTextStyle *companyStyle = [FTCoreTextStyle new];
	companyStyle.name = @"companyStyle";
    companyStyle.color = [UIColor grayColor];
	companyStyle.paragraphInset = UIEdgeInsetsMake(10, 0, 10, 0);
	companyStyle.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:16.f];
	[result addObject:companyStyle];
	[companyStyle release];
    
	FTCoreTextStyle *firstLetterStyle = [FTCoreTextStyle new];
	firstLetterStyle.name = @"firstLetter";
	firstLetterStyle.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:30.f];
	[result addObject:firstLetterStyle];
	[firstLetterStyle release];
	
	FTCoreTextStyle *linkStyle = [defaultStyle copy];
	linkStyle.name = FTCoreTextTagLink;
	linkStyle.color = [UIColor orangeColor];
	[result addObject:linkStyle];
	[linkStyle release];
	
	FTCoreTextStyle *subtitleStyle = [FTCoreTextStyle styleWithName:@"subtitle"];
	subtitleStyle.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:25.f];
	subtitleStyle.color = [UIColor brownColor];
	subtitleStyle.paragraphInset = UIEdgeInsetsMake(10, 0, 10, 0);
	[result addObject:subtitleStyle];
	
	FTCoreTextStyle *bulletStyle = [defaultStyle copy];
	bulletStyle.name = FTCoreTextTagBullet;
	bulletStyle.bulletFont = [UIFont fontWithName:@"TimesNewRomanPSMT" size:16.f];
	bulletStyle.bulletColor = [UIColor orangeColor];
	bulletStyle.bulletCharacter = @"❧";
	[result addObject:bulletStyle];
	[bulletStyle release];
    
    FTCoreTextStyle *italicStyle = [defaultStyle copy];
	italicStyle.name = @"italic";
	italicStyle.underlined = YES;
    italicStyle.font = [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:16.f];
	[result addObject:italicStyle];
	[italicStyle release];
    
    FTCoreTextStyle *boldStyle = [defaultStyle copy];
	boldStyle.name = @"bold";
    boldStyle.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:16.f];
	[result addObject:boldStyle];
	[boldStyle release];
    
    FTCoreTextStyle *hightStyle = [defaultStyle copy];
    [hightStyle setName:@"hightColor"];
    hightStyle.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:20.f];
    [hightStyle setColor:[UIColor colorWithRed:0.85 green:0.42 blue:0.16 alpha:1.0]];
	[result addObject:hightStyle];
    [hightStyle release];
    
    FTCoreTextStyle *coloredStyle = [defaultStyle copy];
    [coloredStyle setName:@"colored"];
    [coloredStyle setColor:[UIColor redColor]];
	[result addObject:coloredStyle];
    [defaultStyle release];
    return  result;
}


@end

@implementation NSDictionary(MY)

-(NSString *) objectToStringForKey:(id)key{
    NSString *value = @"";
    NSObject *obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]]) {
        if ([(NSNumber *)obj doubleValue] > 1000000000000) {
            double time = [(NSNumber *)obj doubleValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            value = [formatter  stringFromDate:date];
        }else {
            value = [(NSNumber *)obj stringValue];
        }
    }else if ([obj isKindOfClass:[NSString class]]){
        value = (NSString *)obj;
    }
    return value;
}

@end

@implementation NSString (MY)

-(NSString *)pinyin{
    NSMutableString *str = [NSMutableString string];
    for (int i=0; i<[self length]; i ++) {
        [str appendFormat:@"%c",pinyinFirstLetter([self characterAtIndex:i])];
    }
    return str;
}

-(BOOL)isValidateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:self];
}

@end
