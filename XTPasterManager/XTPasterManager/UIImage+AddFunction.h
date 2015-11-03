//
//  UIImage+AddFunction.h
//
//  Created by mini1 on 14-6-13.
//  Copyright (c) 2014年 TEASON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AddFunction)

+ (UIImage *)squareImageFromImage:(UIImage *)image
                     scaledToSize:(CGFloat)newSize ;

+ (UIImage *)getImageFromView:(UIView *)theView ;

@end
