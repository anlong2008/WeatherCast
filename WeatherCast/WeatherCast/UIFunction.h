//
//  UIFunction.h
//  WeatherCast
//
//  Created by long on 15/7/28.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIFunction : NSObject
+(UILabel *)navgationLabel:(NSString *)title;
+(UILabel *)tableViewHeaderViewLabel:(NSString *)text frame:(CGRect)frame fontsize:(float)fontsize textColor:(UIColor *)color;
@end
