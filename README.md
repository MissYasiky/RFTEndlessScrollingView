# RFTEndlessScrollingView

#控件效果

这是一个无限滚动的控件，可自动播放下一张，也可以自动播放上一张，也可以手动滑动，首尾相连，产生无限滚动的效果。

![滚屏效果](https://github.com/MissYasiky/RFTEndlessScrollingView/blob/master/ScreenShot/iphone6.gif)

#使用方法

初始化
```Objective-C
NSArray *subjects = @[[UIImage imageNamed:@"1.png"], [UIImage imageNamed:@"2.png"], [UIImage imageNamed:@"3.png"]];
    
CGRect rect = [UIScreen mainScreen].bounds;
RFTScrollSubjectsView *scrollSubjectsView = [[RFTScrollSubjectsView alloc] initWithFrame:rect];
scrollSubjectsView.subjects = subjects;
scrollSubjectsView.delegate = self;
[self.view addSubview:scrollSubjectsView];
```

点击响应
```Objective-C
- (void)selectedAtSubject:(NSInteger)index {
    //touch the view
}
```
