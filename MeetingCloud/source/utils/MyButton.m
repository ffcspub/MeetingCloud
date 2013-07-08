//
//  MyButton.m
//  MeetingCloud
//
//  Created by songhang he on 12-7-12.
//  Copyright (c) 2012年 ffcs. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
    if (_delegate && [_delegate respondsToSelector:@selector(didStartingLoadImage:)]) {
        [_delegate didStartingLoadImage:self];
    }
}

- (void)setBackImageWithURL:(NSURL *)url{
    imagetype = 1;
    [self setImageWithURL:url placeholderImage:nil];
    if (_delegate && [_delegate respondsToSelector:@selector(didStartingLoadImage:)]) {
        [_delegate didStartingLoadImage:self];
    }
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    [self setImage:placeholder forState:UIControlStateNormal];
    
    if (url)
    {
        [manager downloadWithURL:url delegate:self];
        if (_delegate && [_delegate respondsToSelector:@selector(didStartingLoadImage:)]) {
            [_delegate didStartingLoadImage:self];
        }
    }
    
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    if (imagetype == 0) {
        [self setImage:image forState:UIControlStateNormal];
    }else if (imagetype == 1){
        [self setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(myImageView:didFinishWithImage:)]) {
        [_delegate myImageView:self didFinishWithImage:image];
    }
}


@end
