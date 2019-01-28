//
//  RFTEndlessScrollView.m
//  RFTEndlessScrollingView
//
//  Created by YJXie on 16/1/9.
//  Copyright © 2016年 YJXie. All rights reserved.
//

#import "RFTEndlessScrollView.h"

// 切换下一页的动画持续时间
static NSTimeInterval const kEndlessScrollViewTransitionDuration = 0.4;
// 自动播放时，每一页停留时间
static NSTimeInterval const kAutoPlayTimeInterval = 3.0;

typedef NS_ENUM(NSUInteger, RFTEndlessScrollViewScrollDirection) {
    RFTEndlessScrollViewScrollDirectionBackward = 0,
    RFTEndlessScrollViewScrollDirectionForward
};

@interface RFTEndlessScrollView ()<UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isManualAnimating;
@property (nonatomic, strong) NSTimer *timer_autoPlay;
@property (nonatomic, assign) NSUInteger currentPage;

@end

@implementation RFTEndlessScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeControl];
    }
    return self;
}

- (void)dealloc {
    [_timer_autoPlay invalidate];
    _timer_autoPlay = nil;
    _controlDelegate = nil;
}

#pragma mark - Initialization

- (void) initializeControl {
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.delegate = self;
    self.contentSize = CGSizeMake(self.frame.size.width, self.contentSize.height);
    _currentPage = NSNotFound;
}

#pragma mark - Public Method

- (void)resetAutoPlay {
    if(_timer_autoPlay) {
        [_timer_autoPlay invalidate];
        _timer_autoPlay = nil;
    }
    _timer_autoPlay = [NSTimer scheduledTimerWithTimeInterval:kAutoPlayTimeInterval target:self selector:@selector(autoPlayHandle:) userInfo:nil repeats:YES];
}

- (void)setPage:(NSInteger)newIndex animated:(BOOL)animated {
    [self setPage:newIndex transition:RFTEndlessScrollViewTransitionForward animated:animated];
}

- (void)setPage:(NSInteger)newIndex transition:(RFTEndlessScrollViewTransition)transition animated:(BOOL)animated {
    if (newIndex == self.currentPage) return;
    
    if (animated) {
        CGPoint finalOffset;
        
        if (transition == RFTEndlessScrollViewTransitionAuto) {
            if (newIndex > self.currentPage) transition = RFTEndlessScrollViewTransitionForward;
            else if (newIndex < self.currentPage) transition = RFTEndlessScrollViewTransitionBackward;
        }
        
        CGFloat size = self.frame.size.width;
        
        if (transition == RFTEndlessScrollViewTransitionForward) {
            [self loadImageViewAtIndex:newIndex andPlaceAtIndex:1];
            finalOffset = [self createPoint:(size*3)];
        } else {
            [self loadImageViewAtIndex:newIndex andPlaceAtIndex:-1];
            finalOffset = [self createPoint:(size*1)];
        }
        self.isManualAnimating = YES;
        
        [UIView animateWithDuration:kEndlessScrollViewTransitionDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.contentOffset = finalOffset;
                         } completion:^(BOOL finished) {
                             if (!finished) return;
                             [self setCurrentImageView:newIndex];
                             self.isManualAnimating = NO;
                         }];
    } else {
        [self setCurrentImageView:newIndex];
    }
}

#pragma mark - Private Method

- (void)autoPlayHandle:(id)timer {
    if ([self hasMultiplePages]) {
        [self autoPlayGoToNextPage];
    }
}

- (void)autoPlayGoToNextPage {
    NSInteger nextPage = self.currentPage + 1;
    if(nextPage >= self.numberOfPages) {
        nextPage = 0;
    }
    [self setPage:nextPage animated:YES];
}

- (void)autoPlayPause {
    if(_timer_autoPlay) {
        [_timer_autoPlay invalidate];
        _timer_autoPlay = nil;
    }
}

- (void)autoPlayResume {
    [self resetAutoPlay];
}

- (CGPoint)createPoint:(CGFloat)size {
    return CGPointMake(size, 0);
}

- (void)setNumberOfPages:(NSUInteger)pages {
    if (pages != _numberOfPages) {
        _numberOfPages = pages;
        unsigned long int offset = [self hasMultiplePages] ? _numberOfPages + 2 : 1;
        self.contentSize = CGSizeMake(self.frame.size.width * offset, self.contentSize.height);
    }
}

- (void)setCurrentImageView:(NSInteger)index {
    if (index == self.currentPage) return;
    self.currentPage = index;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self loadImageViewAtIndex:index andPlaceAtIndex:0];
    
    // Pre-load the content for the adjacent pages if multiple pages are to be displayed
    if ([self hasMultiplePages]) {
        
        NSInteger prevPage = [self pageIndexByAdding:-1 from: self.currentPage];
        NSInteger nextPage = [self pageIndexByAdding:+1 from: self.currentPage];
        
        [self loadImageViewAtIndex:prevPage andPlaceAtIndex:-1];   // load previous page
        [self loadImageViewAtIndex:nextPage andPlaceAtIndex:1];   // load next page
    }
    
    CGFloat size = self.frame.size.width;
    self.contentOffset = [self createPoint: size * ([self hasMultiplePages] ? 2 : 0)];
    
    if ([self.controlDelegate respondsToSelector:@selector(endlessScrollView:currentPageChanged:)])
        [self.controlDelegate endlessScrollView:self currentPageChanged:self.currentPage];
}

- (UIImageView *)loadImageViewAtIndex:(NSInteger)index andPlaceAtIndex:(NSInteger)destIndex {
    UIImageView *imageView = self.dataSource[index];
    
    CGRect viewFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    int offset = [self hasMultiplePages] ? 2 : 0;
    viewFrame = CGRectOffset(viewFrame, self.frame.size.width * (destIndex + offset), 0);
    imageView.frame = viewFrame;
    [self addSubview:imageView];
    return imageView;
}

- (NSInteger)pageIndexByAdding:(NSInteger)offset from:(NSInteger)index {
    while (offset < 0) {
        offset += _numberOfPages;
    }
    return (_numberOfPages + index + offset) % _numberOfPages;
}

- (BOOL)hasMultiplePages {
    return self.numberOfPages > 1;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self autoPlayPause];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.bounces = YES;
    [self autoPlayResume];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isManualAnimating) {
        return;
    }
    
    CGFloat offset = scrollView.contentOffset.x;
    CGFloat size = self.frame.size.width;
    
    // with two pages only scrollview you can only go forward
    // (this prevents us to have a glitch with the next UIView (it can't be placed in two positions at the same time)
    RFTEndlessScrollViewScrollDirection proposedScroll = (offset <= (size*2) ?
                                                         RFTEndlessScrollViewScrollDirectionBackward : // we're moving back
                                                         RFTEndlessScrollViewScrollDirectionForward); // we're moving forward
    
    self.bounces = YES;
    NSInteger prevPage = [self pageIndexByAdding:-1 from:self.currentPage];
    NSInteger nextPage = [self pageIndexByAdding:+1 from:self.currentPage];
    if (prevPage == nextPage) {
        // This happends when our scrollview have only two and we should have the same prev/next page at left/right
        // A single UIView instance can't be in two different location at the same moment so we need to place it
        // loooking at proposed direction
        [self loadImageViewAtIndex:prevPage andPlaceAtIndex:(proposedScroll == RFTEndlessScrollViewScrollDirectionBackward ? -1 : 1)];
    }
    
    NSInteger newPageIndex = self.currentPage;
    
    if (offset <= size)
        newPageIndex = [self pageIndexByAdding:-1 from:self.currentPage];
    else if (offset >= (size*3))
        newPageIndex = [self pageIndexByAdding:+1 from:self.currentPage];
    
    [self setCurrentImageView:newPageIndex];
}

@end
