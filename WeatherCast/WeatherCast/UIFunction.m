//
//  UIFunction.m
//  WeatherCast
//
//  Created by long on 15/7/28.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "UIFunction.h"
#import "ConstDef.h"

@implementation UIFunction

/**
 *	@brief	设置导航栏标题
 *
 *	@param 	title 	标题内容
 *
 *	@return	导航栏标题View
 */
+(UILabel *)navgationLabel:(NSString *)title
{
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(ZERO_SCREEN,
                                                                    ZERO_SCREEN,
                                                                    ZERO_SCREEN,
                                                                    TITLELABELHEIGHT)];
    titleLable.text = title;
    titleLable.textColor = [UIColor whiteColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont boldSystemFontOfSize:TITLELABELFONT];
    titleLable.backgroundColor = [UIColor clearColor];
    return titleLable;
}

/**
 *	@brief	用于tableHeader的Label
 *
 *	@param 	text 	显示内容
 *	@param 	frame 	位置以及大小
 *	@param  fontsize字体大小
 *	@param  color   字体颜色
 *
 *	@return tableHeader的Label
 */
+(UILabel *)tableViewHeaderViewLabel:(NSString *)text frame:(CGRect)frame fontsize:(float)fontsize textColor:(UIColor *)color
{
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = text;
    headerLabel.opaque = NO;
    headerLabel.textColor = color;
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName: nil size:fontsize];
    headerLabel.frame = frame;
    return headerLabel;
}
@end
