//
//  PagePhotosView.h
//  PagePhotosDemo
//
//  Created by junmin liu on 10-8-23.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPageControl.h"

@protocol PageGirdViewDataSource;
@protocol PageGirdViewDelegate;
typedef enum PageGirdViewInsertStyle
{
    PageGirdViewInsertStyle_Same,     //所有间距一致(用于View大小的view,只计算第一页的view的间距)
    PageGirdViewInsertStyle_NoSame    //每页不同  
} PageGirdViewInsertStyle;

typedef enum PageGirdViewCompantViewStyle
{
    PageGirdViewCompantViewStyle_Same,     //所有view大小一致
    PageGirdViewCompantViewStyle_NoSame    //view大小不一致 
} PageGirdViewCompantViewStyle;

typedef enum PageControllBackgroundColorStyle
{
    PageControllBackgroundColor_None,     //无背景
    PageControllBackgroundColor_GrayColor//灰色  
} PageControllBackgroundColorStyle;

typedef enum TitleLabelStyle
{
    TitleLabelStyle_None,   //无文字
    TitleLabelStyle_Left,   //文字居左
    TitleLabelStyle_Top,    //文字居头
    TitleLabelStyle_Right   //文字居右
} PageControllPostionStyle;



@interface PageGirdView : UIView<UIScrollViewDelegate> {
	UIScrollView *scrollView;
	MyPageControl *pageControl;
    UILabel *titleLabel;
    NSArray *titleArray;
	// To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
    int pageIndex;
    int pageCount;
    NSTimer *timer;
    int actionTime;
    PageGirdViewInsertStyle insertStyle;
    PageGirdViewCompantViewStyle compantViewStyle;
    BOOL _actionAble;
    UIView *pagebackview;
    UIImage *img_pageContollerNoral;
    UIImage *img_pageContollerHightlighted;
}

@property (nonatomic, assign) IBOutlet id<PageGirdViewDataSource> dataSource;
@property (nonatomic, assign) IBOutlet id<PageGirdViewDelegate> delegate;
@property (nonatomic, assign) enum PageControllBackgroundColorStyle pageControllBackgroundColorStyle;
@property (nonatomic, assign) enum TitleLabelStyle titleLabelStyle;
@property (nonatomic,assign) CGFloat widthInsert;
@property (nonatomic,assign) CGFloat heightInsert;
//
-(void) reloadData;//设置数据
-(NSArray *) viewsFromGird;

-(void)beginAction;
-(void)endAction;

@end


@protocol PageGirdViewDataSource <NSObject>

@optional
// 有多少组件
- (int)numberViewOfPageGirdView:(PageGirdView *)pageGirdView;
// 每个组件的视图
- (UIView *)viewWithIndex:(int)index pageGirdView:(PageGirdView *)pageGirdView;

//每页的标题
-(NSString *) titleWithPage:(int)page;

//是否支持自动切换
-(BOOL) pageActiveOfPageGirdView:(PageGirdView *)pageGirdView;

//自动切换时间
-(int) activeTimeOfPageGirdView:(PageGirdView *)pageGirdView;

-(PageGirdViewInsertStyle) insertStyleOfPageGirdView:(PageGirdView *)pageGirdView;

-(PageGirdViewCompantViewStyle) pageGirdViewCompantViewStyle:(PageGirdView *)pageGirdView;

-(UIImage *) imageWithPageControllerStateNormal;

-(UIImage *) imageWithPageControllerStateHightlighted;

@end

@protocol PageGirdViewDelegate <NSObject>
@optional
- (void)pageChangeAtIndex:(int)index pageGirdView:(PageGirdView *)pageGirdView;
@end