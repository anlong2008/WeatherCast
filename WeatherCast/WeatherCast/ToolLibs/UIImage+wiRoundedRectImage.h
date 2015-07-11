//
//  UIImage+wiRoundedRectImage.h
//  WeatherCast
//
//  Created by An Long on 15/7/11.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (widRoundedRectImage)

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;

@end
