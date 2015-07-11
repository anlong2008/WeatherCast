//
//  UIImageUtil.h
//  UC_Iphone
//
//  Created by long on 15/5/31.
//
//

#import <UIKit/UIKit.h>

@interface UIImageUtil : NSObject

+(UIImage *)clipImageFromImage:(UIImage *)orgImage  Rect:(CGRect)clipRect;
+ (UIImage *)scaleImage:(UIImage *)image withScale:(float)scale;
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;
+ (UIImage *)scaleImageTo540X900:(UIImage *)image;
+ (UIImage *)imageFromText:(NSString*) arrContent withFont: (CGFloat)fontSize withColor:(UIColor*)color;
@end
