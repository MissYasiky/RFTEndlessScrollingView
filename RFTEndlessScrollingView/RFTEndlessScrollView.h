//
//  RFTEndlessScrollView.h
//  RFTEndlessScrollingView
//
//  Created by YJXie on 16/1/9.
//  Copyright © 2016年 YJXie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RFTEndlessScrollView;

typedef UIImageView *(^RFTEndlessScrollViewDataSource)(NSInteger index);

enum {
    RFTEndlessScrollViewTransitionAuto      =   0,
    RFTEndlessScrollViewTransitionForward   =   1,
    RFTEndlessScrollViewTransitionBackward  =   2
}; typedef NSUInteger RFTEndlessScrollViewTransition;

@protocol RFTEndlessScrollViewDelegate <NSObject>
@optional
/*
 - (void)lazyScrollViewWillBeginDragging:(DMLazyScrollView *)pagingView;
 //Called when it scrolls, except from as the result of self-driven animation.
 - (void)lazyScrollViewDidScroll:(DMLazyScrollView *)pagingView at:(CGPoint) visibleOffset;
 //Called whenever it scrolls: through user manipulation, setup, or self-driven animation.
 - (void)lazyScrollViewDidScroll:(DMLazyScrollView *)pagingView at:(CGPoint) visibleOffset withSelfDrivenAnimation:(BOOL)selfDrivenAnimation;
 - (void)lazyScrollViewDidEndDragging:(DMLazyScrollView *)pagingView;
 - (void)lazyScrollViewWillBeginDecelerating:(DMLazyScrollView *)pagingView;
 - (void)lazyScrollViewDidEndDecelerating:(DMLazyScrollView *)pagingView atPageIndex:(NSInteger)pageIndex;
 */
- (void)endlessScrollView:(RFTEndlessScrollView *)pagingView currentPageChanged:(NSInteger)currentPageIndex;
@end


@interface RFTEndlessScrollView : UIScrollView

@property (copy            ) RFTEndlessScrollViewDataSource   dataSource;
@property (nonatomic, weak ) id<RFTEndlessScrollViewDelegate> controlDelegate;
@property (nonatomic,assign) NSUInteger                    numberOfPages;
@property (readonly        ) NSUInteger                    currentPage;
@property (nonatomic,assign) CGFloat autoPlayTime; //default 3 seconds
@property (nonatomic, strong) NSTimer* timer_autoPlay;

- (void) resetAutoPlay;
- (void) setPage:(NSInteger) index animated:(BOOL) animated;
- (void) setPage:(NSInteger) newIndex transition:(RFTEndlessScrollViewTransition) transition animated:(BOOL) animated;

@end
