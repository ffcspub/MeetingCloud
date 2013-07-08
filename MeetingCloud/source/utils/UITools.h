//
//  UITools.h
//  ChangePhonePush
//
//  Created by he songhang on 11-9-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UITools : NSObject {

}

+(NSString *)getUtfString:(NSString *)sourceStr;
+(void) easyAlert:(NSString *)message cancelButtonTitle:(NSString *)title;
+(NSString *)dataFilePath:(NSString *)filename;
+(NSDictionary *) loadDictionary:(NSString *)filename;
+(NSString *) myDate:(NSString *)dateformat dates:(int)dates;
+(NSString *) fromFormat:(NSString *)fromFormat toFormat:(NSString *) toFormat dateStr:(NSString *)dateStr;
+(NSString *) getRandcode:(int) size;//获取随机数
+(NSString *) getImisi;
//+(NSString *) saveImage:(NSString *)url;//保存图片
+(NSString *) getErrorMsg:(NSError *)error;
+(NSArray *)coreTextStyle;

@end

@interface UILabel (RESIZE)
-(void) reSizeMake;
@end

@interface UIImage (UIImageExt)
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
+(UIImage *)imageNamed:(NSString *)name;
//等比例缩放
-(UIImage*)scaleToSize:(CGSize)size;
@end

@interface NSDictionary (MY)
-(NSString *) objectToStringForKey:(id)key;
@end

@interface NSString(MY)
-(NSString *) pinyin;
-(BOOL)isValidateEmail;

@end
