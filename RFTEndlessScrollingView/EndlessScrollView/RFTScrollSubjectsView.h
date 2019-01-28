//
//  RFTScrollSubjectsView.h
//  RFTEndlessScrollingView
//
//  Created by YJXie on 16/1/9.
//  Copyright © 2016年 YJXie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RFTScrollSubjectsViewDelegate;

@interface RFTScrollSubjectsView : UIView

@property (nonatomic, strong) id<RFTScrollSubjectsViewDelegate> delegate;
@property (nonatomic, strong) NSArray<UIImage*> *subjects;
@property (nonatomic, strong, readonly) UIPageControl *pageControl;

@end

@protocol RFTScrollSubjectsViewDelegate <NSObject>

- (void)selectedAtSubject:(NSInteger)index;

@end