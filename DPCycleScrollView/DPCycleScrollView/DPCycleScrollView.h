//
//  DPCycleScrollView.h
//  DuoPai
//
//  Created by yxw on 15/8/31.
//  Copyright (c) 2015年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPCycleScrollView;

@protocol DPCycleScrollViewDelegate <NSObject>
@optional
- (void)cycleScrollView:(DPCycleScrollView *)csView didScrollToPageAtIndex:(NSInteger)index;
- (void)cycleScrollView:(DPCycleScrollView *)csView clickPageAtIndex:(NSInteger)index;
@end

@protocol DPCycleScrollViewDatasource <NSObject>
@required
- (NSInteger)numberOfPagesInCycleScrollView:(DPCycleScrollView *)csView;
- (UIView *)cycleScrollView:(DPCycleScrollView *)csView pageAtIndex:(NSInteger)index;
@end

@interface DPCycleScrollView : UIView<UIScrollViewDelegate>

@property (nonatomic, assign) id<DPCycleScrollViewDelegate> delegate;
@property (nonatomic, assign) id<DPCycleScrollViewDatasource> datasource;

//滚动视图容器
@property (strong, nonatomic, readonly) UIScrollView *scrollView;

//是否自动翻页
@property (nonatomic, assign) BOOL autoScroll;
//是否显示Pagecontrol(页数大于1时，小于或等于1时均隐藏)
@property (nonatomic, assign) BOOL showPagecontrol;
//两个View翻页时间间隔
@property (nonatomic, assign) NSTimeInterval animationInterval;
//View翻页动画时间
@property (nonatomic, assign) CGFloat animateDuration;

//NSTimer停止
- (void)free;
//暂停翻滚
- (void)pause;
//继续翻滚
- (void)resume;
//reload数据
- (void)reloadData;

@end
