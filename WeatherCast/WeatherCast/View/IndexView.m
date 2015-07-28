//
//  IndexView.m
//  WeatherCast
//
//  Created by An Long on 15/7/29.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "IndexView.h"

@implementation IndexView
//@synthesize indexData;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame indexData:(IndexData *)indexData {
    
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
    
    titleView.backgroundColor = [UIColor blackColor];
    titleView.textColor = [UIColor whiteColor];
    titleView.alpha = 0.3f;
    titleView.font = [UIFont systemFontOfSize:16.0f];
    titleView.text = indexData.tipt;
    titleView.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleView];
    
    UILabel *briefView = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, frame.size.height - 20)];
    briefView.font = [UIFont systemFontOfSize:20.0f];
    briefView.text = indexData.zs;
    briefView.textColor = [UIColor whiteColor];
    briefView.backgroundColor = [UIColor colorWithRed:19.0f/255 green:119.0f/255 blue:183.0f/255 alpha:1.0f];
    briefView.alpha = 0.5f;
    briefView.textAlignment = NSTextAlignmentCenter;
    // 24 36 53
    [self addSubview:briefView];
    return self;
}
@end
