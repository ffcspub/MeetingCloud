//
//  MyButton.h
//  MeetingCloud
//
//  Created by songhang he on 12-7-12.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageCompat.h"
#import "SDWebImageManagerDelegate.h"
#import "SDWebImageManager.h"

@protocol MyButtonDelegate ;

@interface MyButton : UIButton<SDWebImageManagerDelegate>{
    int imagetype;
}

@property(nonatomic,assign) id<MyButtonDelegate> delegate;

- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options;
- (void)cancelCurrentImageLoad;

- (void)setBackImageWithURL:(NSURL *)url;

@end

@protocol MyButtonDelegate <NSObject>

-(void) didStartingLoadImage:(MyButton *)button;
-(void) myImageView:(MyButton *)button didFinishWithImage:(UIImage *)image;

@end
