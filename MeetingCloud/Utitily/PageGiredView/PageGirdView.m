//
//  PagePhotosView.m
//  PagePhotosDemo
//
//  Created by junmin liu on 10-8-23.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "PageGirdView.h"

@interface PageGirdView (PrivateMethods)
- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
-(void)scrollViewDoAction;
@end

@implementation PageGirdView
@synthesize dataSource,delegate;
@synthesize pageControllBackgroundColorStyle;
@synthesize titleLabelStyle;
@synthesize widthInsert;
@synthesize heightInsert;

-(void)pageControlVauleChanged:(UIPageControl *)_pageControl{
    [self loadScrollViewWithPage:_pageControl.currentPage];
}


-(void) reloadPageController{
    if(pagebackview){
        [pagebackview removeFromSuperview];
    }    
    int pageControlHeight = 30;
    
    int backViewHeight = pageControlHeight;
    
    if(self.titleLabelStyle == TitleLabelStyle_Top){
        backViewHeight = 40;
    }
       
    pagebackview = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - backViewHeight, self.frame.size.width, backViewHeight)];
    
    UIColor *bcolor = [UIColor clearColor];
    if (self.pageControllBackgroundColorStyle == PageControllBackgroundColor_GrayColor) {
        bcolor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    [pagebackview setBackgroundColor:bcolor];
    
    CGFloat pageControl_X = 0;
    CGFloat pageControl_Y = 0;
    CGFloat pageControl_Width = self.frame.size.width;
    
    CGFloat titleLable_X = 20;
    CGFloat titleLable_Y = 0;
    CGFloat titleLableWidth = self.frame.size.width *2/3 - 20;    
    CGFloat titleLable_Height = 20;
    
    if(titleLabelStyle == TitleLabelStyle_Left){
        pageControl_X = self.frame.size.width *2/3 + 20; 
        pageControl_Width = self.frame.size.width *1/3 - 20;
    }
    if(titleLabelStyle == TitleLabelStyle_Top){
        pageControl_Y = 20;
    }
    
    if (titleLabelStyle != TitleLabelStyle_None) {
        titleArray = [[NSMutableArray alloc]init];
        if([dataSource respondsToSelector:@selector(titleWithPage:)]){
            for (int i =0; i<pageCount; i++) {
                NSString *title = [dataSource titleWithPage:i];
                if (title == nil) {
                    title = @"";
                }
                [(NSMutableArray *)titleArray addObject:title];
            }
        } 
    }
    
    pageControl = [[MyPageControl alloc] initWithFrame:CGRectMake(pageControl_X, pageControl_Y , pageControl_Width, pageControlHeight)];    
    pageControl.currentPage = 0;
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.numberOfPages = pageCount; 
    [pageControl addTarget:self action:@selector(pageControlVauleChanged:) forControlEvents:UIControlEventValueChanged];
    if(img_pageContollerNoral){
        [pageControl setImagePageStateNormal:img_pageContollerNoral];
    } 
    if(img_pageContollerNoral){
         [pageControl setImagePageStateHightlighted:img_pageContollerHightlighted];
    } 
    [pagebackview addSubview:pageControl];
    [pageControl release];

    if(titleLabelStyle != TitleLabelStyle_None){
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLable_X, titleLable_Y, titleLableWidth, titleLable_Height)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setText:[dataSource titleWithPage:0]];
        [pagebackview addSubview:titleLabel];
        [titleLabel release];
    }
    [self addSubview:pagebackview];
    [pagebackview release];

}

-(void) reloadData{
    [self endAction];
    pageCount = 0;
    pageIndex = 0;
    if (scrollView) {
        [scrollView removeFromSuperview];
        scrollView = nil;
    }
    if (pagebackview) {
        [pagebackview removeFromSuperview];
        pagebackview = nil;
    }
    if (titleArray) {
        [titleArray release];
        titleArray = nil;
    }
    [self _sharedGridViewInit];

    _actionAble = NO;
    if([dataSource respondsToSelector:@selector(pageActiveOfPageGirdView:)]){
        _actionAble = [dataSource pageActiveOfPageGirdView:self];
    }
    actionTime = 2;
    if([dataSource respondsToSelector:@selector(activeTimeOfPageGirdView:)]){
        actionTime = [dataSource activeTimeOfPageGirdView:self];;
    } 
    insertStyle = PageGirdViewInsertStyle_Same;
    if([dataSource respondsToSelector:@selector(insertStyleOfPageGirdView:)]){
        insertStyle = [dataSource insertStyleOfPageGirdView:self];
    }
    compantViewStyle = PageGirdViewCompantViewStyle_NoSame;
    if([dataSource respondsToSelector:@selector(pageGirdViewCompantViewStyle:)]){
        compantViewStyle = [dataSource pageGirdViewCompantViewStyle:self];
    }
    if (img_pageContollerNoral) {
        [img_pageContollerNoral release];
        img_pageContollerNoral = nil;
    }
    if([dataSource respondsToSelector:@selector(imageWithPageControllerStateNormal)]){
        img_pageContollerNoral = [[dataSource imageWithPageControllerStateNormal]retain];
    } 
    if (img_pageContollerHightlighted) {
        [img_pageContollerHightlighted release];
        img_pageContollerHightlighted = nil;
    }
    if([dataSource respondsToSelector:@selector(imageWithPageControllerStateHightlighted)]){
        img_pageContollerHightlighted = [[dataSource imageWithPageControllerStateHightlighted]retain];
    } 
    CGFloat width = scrollView.frame.size.width;
    CGFloat temp = 0;
    int page = 0;
    NSMutableArray *pageViews = [[NSMutableArray alloc]init];
    int viewCount = 0;
    if([dataSource respondsToSelector:@selector(numberViewOfPageGirdView:)]){
        viewCount = [dataSource numberViewOfPageGirdView:self];
    }else{
        
    }
    if(compantViewStyle == PageGirdViewCompantViewStyle_Same){
        if(viewCount > 0){
            UIView *compantViewtemp = [dataSource viewWithIndex:0 pageGirdView:self];
            CGFloat width = compantViewtemp.frame.size.width;
            CGFloat height = compantViewtemp.frame.size.height;
            int pageCompantViewCount_x = (scrollView.frame.size.width + widthInsert) /(width + widthInsert);//横向控件数量
            int pageCompantViewCount_y = (scrollView.frame.size.height - 40 + heightInsert) /(height + heightInsert);// 纵向控件数量
            int pageCompantViewCount = pageCompantViewCount_x * pageCompantViewCount_y;//单位页数中可容纳的控件数量
            CGFloat insert_x = (self.frame.size.width - width * pageCompantViewCount_x)/(pageCompantViewCount_x + 1);//横向间隔
            if (widthInsert > 0) {
                insert_x = (self.frame.size.width - width * pageCompantViewCount_x - widthInsert * (pageCompantViewCount_x - 1))/2;
            }
            CGFloat insert_y = 30;//纵向间隔(默认30)
            if (heightInsert>0) {
                insert_y = heightInsert;
            }
            if(viewCount % pageCompantViewCount == 0){
                page = viewCount / pageCompantViewCount;
            }else {
                page = viewCount / pageCompantViewCount + 1;
            }
            CGFloat viewTemp_x = 0;
            CGFloat viewTemp_y = 0;
            for (int i= 0; i<viewCount; i++) {
                int pageindex = i / pageCompantViewCount;
                
                UIView *view = [dataSource viewWithIndex:i pageGirdView:self];
                
                if (i %  pageCompantViewCount == 0) {
                    viewTemp_x = (0 + pageindex * scrollView.frame.size.width);
                    viewTemp_y = 0;
                    viewTemp_x += insert_x;
                }else {
                    if (i % pageCompantViewCount_x == 0) {
                        viewTemp_x = (0 + pageindex * scrollView.frame.size.width);
                        viewTemp_y += (insert_y + view.frame.size.height);
                        viewTemp_x += insert_x;
                    }else {
                        if (widthInsert > 0) {
                            viewTemp_x += widthInsert;
                        }else {
                            viewTemp_x += insert_x;
                        }
                    }
                    
                    
                }
                [view setFrame:CGRectMake(viewTemp_x, viewTemp_y, view.frame.size.width, view.frame.size.height)];
                [scrollView addSubview:view];
                viewTemp_x += view.frame.size.width;
            }
        }
    }else{
        CGFloat spacing = 0;
        for(int i=0;i<viewCount;i++){
            UIView *view = [dataSource viewWithIndex:i pageGirdView:self];
            CGFloat viewTemp = view.frame.size.width;
            temp += viewTemp;        
            if(temp > width){
                if(spacing == 0 || insertStyle == PageGirdViewInsertStyle_NoSame){
                    spacing = (width - (temp-viewTemp))/[pageViews count];
                }
                CGFloat rwidth = scrollView.frame.size.width * page + spacing/2;
                for (int j=0;j<[pageViews count];j++) {
                    UIView *tempView = [pageViews objectAtIndex:j];
                    [tempView setFrame:CGRectMake(rwidth, 0, tempView.frame.size.width, tempView.frame.size.height)];
                    [scrollView addSubview:tempView];
                    rwidth += (tempView.frame.size.width + spacing);
                }
                [pageViews removeAllObjects];
                temp = viewTemp;
                page ++;
            }
            [pageViews addObject:view];
        }
        if([pageViews count]>0){        
            CGFloat temp = 0;
            CGFloat viewTemp = 0;
            for(UIView *view in pageViews){
                viewTemp = view.frame.size.width;
                temp += viewTemp;
            }
            if(spacing == 0 || insertStyle == PageGirdViewInsertStyle_NoSame){
                spacing = (width - temp)/[pageViews count];
            }
            CGFloat rwidth = scrollView.frame.size.width * page + spacing/2;
            for (int j=0;j<[pageViews count];j++) {
                UIView *tempView = [pageViews objectAtIndex:j];
                [tempView setFrame:CGRectMake(rwidth, 0, tempView.frame.size.width, tempView.frame.size.height)];
                [scrollView addSubview:tempView];
                rwidth += (tempView.frame.size.width + spacing);
            }
            [pageViews removeAllObjects];
            page ++;
        }
        [pageViews release];
        pageViews = nil;
    }

    pageCount = page;  
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * pageCount, scrollView.frame.size.height);
    
    [self reloadPageController];
    
    if(_actionAble){
        [self beginAction];
    }
    
}

-(void)_sharedGridViewInit{
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0 ,self.frame.size.width, self.frame.size.height)];
    [self addSubview:scrollView];
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;		
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    //[self reloadPageController];
    //[self loadScrollViewWithPage:0];
}

- (id)initWithFrame: (CGRect) frame
{
    self = [super initWithFrame:frame];
	if ( self == nil )
		return ( nil );
	
	[self _sharedGridViewInit];
	
	return ( self );
}

- (id) initWithCoder: (NSCoder *) aDecoder
{
	self = [super initWithCoder: aDecoder];
	if ( self == nil )
		return ( nil );
	
	[self _sharedGridViewInit];
	
	return ( self );
}


- (void)loadScrollViewWithPage:(int)page {
	
    if (page < 0) return;
    if (page >= pageCount) return;
	
    pageIndex = page;
    // replace the placeholder if necessary
    
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    pageControl.currentPage = page;
    if(self.titleLabelStyle != TitleLabelStyle_None){
        NSString *title = [titleArray objectAtIndex:page];
        [titleLabel setText:title];
    }
    //[delegate pageChange:page];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
	if(self.titleLabelStyle != TitleLabelStyle_None){
        NSString *title = [titleArray objectAtIndex:page];
        [titleLabel setText:title];
    }
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    //[self loadScrollViewWithPage:page];
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

-(NSArray *) viewsFromGird{
    return scrollView.subviews;
}

-(void)beginAction{
    _actionAble = YES;
    if(timer){
        [timer invalidate];
    }
    if(_actionAble){
        timer = [NSTimer scheduledTimerWithTimeInterval:actionTime target:self selector:@selector(scrollViewDoAction) userInfo:nil repeats:YES];
    }
}

-(void)endAction{
    if(timer){
        [timer invalidate];
    }
    _actionAble = NO;
}

-(void)scrollViewDoAction{
    if(_actionAble){
        int currentPage = pageIndex;
        currentPage ++;
        if(currentPage >= pageCount){
            currentPage = 0;
        }
        [self loadScrollViewWithPage:currentPage];
    }    
}

- (void)dealloc{
    scrollView = nil;
    pageControl = nil;
    titleLabel = nil;
    timer = nil;
    pagebackview = nil;
    [img_pageContollerNoral release];
    [img_pageContollerHightlighted release];
    [titleArray release];
    [super dealloc];
}


@end
