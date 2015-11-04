//
//  DPCycleScrollView.m
//  DuoPai
//
//  Created by yxw on 15/8/31.
//  Copyright (c) 2015年 Jacky. All rights reserved.
//

#import "DPCycleScrollView.h"
#import "NSTimer+Addition.h"

@interface DPCycleScrollView()
@property (assign, nonatomic) NSInteger totalPages;
@property (assign, nonatomic) NSInteger curPage;
@property (strong, nonatomic) NSMutableArray *curViews;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *animationTimer;

@end

@implementation DPCycleScrollView
@synthesize delegate;
@synthesize datasource;
@synthesize autoScroll;
@synthesize showPagecontrol;
@synthesize animationInterval;
@synthesize animateDuration;
@synthesize totalPages;
@synthesize curPage;
@synthesize curViews;
@synthesize scrollView;
@synthesize pageControl;
@synthesize animationTimer;

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.delegate = self;
        scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        scrollView.showsHorizontalScrollIndicator = NO;//水平线
        scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        scrollView.pagingEnabled = YES;
        scrollView.scrollsToTop = NO;
        [self addSubview:scrollView];
        
        CGRect rect = self.bounds;
        rect.origin.y = rect.size.height - 30;
        rect.size.height = 30;
        pageControl = [[UIPageControl alloc] initWithFrame:rect];
        pageControl.userInteractionEnabled = NO;
        [self addSubview:pageControl];
        
        curPage = 0;
        //自动翻页
        autoScroll = YES;
        showPagecontrol = YES;
        animationInterval = 5.f;
        animateDuration = 0.5f;
        [self setupAnimationTimer];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)dealloc
{
    scrollView = nil;
    pageControl = nil;
    animationTimer = nil;
}

- (void)setAutoScroll:(BOOL)scroll
{
    autoScroll = scroll;
    [animationTimer invalidate];
    [self setupAnimationTimer];
}

- (void)setShowPagecontrol:(BOOL)show
{
    showPagecontrol = show;
    if (totalPages == 0 || totalPages < 0) {
        pageControl.hidden = YES;
    }else if (totalPages == 1) {
        pageControl.hidden = YES;
    }else {
        pageControl.hidden = !showPagecontrol;
    }
}

- (void)setAnimationInterval:(NSTimeInterval)interval
{
    animationInterval = interval;
    [animationTimer invalidate];
    [self setupAnimationTimer];
}

- (void)setupAnimationTimer
{
    if (self.autoScroll&&self.animationInterval > 0) {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:self.animationInterval
                                                               target:self
                                                             selector:@selector(animationTimerDidFired:)
                                                             userInfo:nil
                                                              repeats:YES];
    }
}

- (void)setDatasource:(id<DPCycleScrollViewDatasource>)aDatasource
{
    datasource = aDatasource;
    [self reloadData];
}

- (void)reloadData
{
    totalPages = [datasource numberOfPagesInCycleScrollView:self];
    if (totalPages == 0 || totalPages < 0) {
        pageControl.hidden = YES;
        return;
    }else if (totalPages == 1) {
        scrollView.scrollEnabled = NO;
        pageControl.hidden = YES;
    }else {
        scrollView.scrollEnabled = YES;
        pageControl.hidden = !showPagecontrol;
    }
    pageControl.numberOfPages = totalPages;
    [self loadData];
}

- (void)loadData
{
    pageControl.currentPage = curPage;
    
    [self setNeedsLayout];
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayViewsWithCurpage:curPage];
    
    for (int i = 0; i < 3; i++) {
        UIView *v = [curViews objectAtIndex:i];
        v.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [v addGestureRecognizer:singleTap];
        v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
        [scrollView addSubview:v];
    }
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width * 3, scrollView.frame.size.height)];
    [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0)];
    
    [self layoutIfNeeded];
}

- (void)getDisplayViewsWithCurpage:(NSInteger)page
{
    NSInteger pre = [self validPageValue:curPage-1];
    NSInteger last = [self validPageValue:curPage+1];
    
    if (!curViews) {
        curViews = [[NSMutableArray alloc] init];
    }
    
    [curViews removeAllObjects];
    [curViews addObject:[datasource cycleScrollView:self pageAtIndex:pre]];
    [curViews addObject:[datasource cycleScrollView:self pageAtIndex:page]];
    [curViews addObject:[datasource cycleScrollView:self pageAtIndex:last]];
}

- (NSInteger)validPageValue:(NSInteger)value {
    
    if(value == -1) value = totalPages - 1;
    if(value == totalPages) value = 0;
    
    return value;
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if (delegate && [delegate respondsToSelector:@selector(cycleScrollView:clickPageAtIndex:)]) {
        [delegate cycleScrollView:self clickPageAtIndex:curPage];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        curPage = [self validPageValue:curPage+1];
        [self loadData];
        
        if (delegate && [delegate respondsToSelector:@selector(cycleScrollView:didScrollToPageAtIndex:)]) {
            [delegate cycleScrollView:self didScrollToPageAtIndex:curPage];
        }
    }
    
    //往上翻
    if(x <= 0) {
        curPage = [self validPageValue:curPage-1];
        [self loadData];
        
        if (delegate && [delegate respondsToSelector:@selector(cycleScrollView:didScrollToPageAtIndex:)]) {
            [delegate cycleScrollView:self didScrollToPageAtIndex:curPage];
        }
    }
}

//ScrollView的手势操作
- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0) animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.animationTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationInterval];
}

#pragma mark - Timer
- (void)animationTimerDidFired:(NSTimer *)timer
{
    if (totalPages > 1) {
        CGPoint newOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame) * 2, self.scrollView.contentOffset.y);
        scrollView.delegate = nil;
        [self pause];
        
        [UIView animateWithDuration:self.animateDuration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.scrollView.contentOffset = newOffset;
                         }
                         completion:^(BOOL finished){
                             int x = scrollView.contentOffset.x;
                             //往下翻一张
                             if(x >= (2*self.frame.size.width)) {
                                 curPage = [self validPageValue:curPage+1];
                                 [self loadData];
                                 
                                 if (delegate && [delegate respondsToSelector:@selector(cycleScrollView:didScrollToPageAtIndex:)]) {
                                     [delegate cycleScrollView:self didScrollToPageAtIndex:curPage];
                                 }
                             }
                             //往上翻
                             if(x <= 0) {
                                 curPage = [self validPageValue:curPage-1];
                                 [self loadData];
                                 
                                 if (delegate && [delegate respondsToSelector:@selector(cycleScrollView:didScrollToPageAtIndex:)]) {
                                     [delegate cycleScrollView:self didScrollToPageAtIndex:curPage];
                                 }
                             }
                             scrollView.delegate = self;
                             [self resume];
                         }];
    }
}

//暂停动画
- (void)pause
{
    [self.animationTimer pauseTimer];
}

//继续动画
- (void)resume
{
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationInterval];
}

//减少父控件的引用计数
- (void)free
{
    [animationTimer invalidate];
}

@end
