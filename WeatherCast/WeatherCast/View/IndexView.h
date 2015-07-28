//
//  IndexView.h
//  WeatherCast
//
//  Created by An Long on 15/7/29.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherModel.h"

@interface IndexView : UIView
//@property (nonatomic, strong) IndexData *indexData;

- (id) initWithFrame:(CGRect)frame indexData:(IndexData *)indexData;
@end
