//
//  RFTEndlessScrollView.h
//  RFTEndlessScrollingView
//
//  Created by YJXie on 16/1/9.
//  Copyright © 2016年 YJXie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RFTEndlessScrollView;

typedef NS_ENUM(NSUInteger, RFTEndlessScrollViewTransition) {
    RFTEndlessScrollViewTransitionAuto      =   0,
    RFTEndlessScrollViewTransitionForward,
    RFTEndlessScrollViewTransitionBackward
};

@protocol RFTEndlessScrollViewDelegate <NSObject>

@optional
- (void)endlessScrollView:(RFTEndlessScrollView *)pagingView currentPageChanged:(NSInteger)currentPageIndex;

@end

@interface RFTEndlessScrollView : UIScrollView

@property (nonatomic,   weak) id<RFTEndlessScrollViewDelegate> controlDelegate;
@property (nonatomic,   copy) NSArray *dataSource;
@property (nonatomic, assign) NSUInteger numberOfPages;

/**
 开始自动播放，每 autoPlayTime 秒播放下一张，播放完回到第一页
 */
- (void)resetAutoPlay;
- (void)setPage:(NSInteger)index animated:(BOOL)animated;
- (void)setPage:(NSInteger)newIndex transition:(RFTEndlessScrollViewTransition)transition animated:(BOOL)animated;

@end
