//
//  UIImage+AddFunction.m
//  
//
//  Created by mini1 on 14-6-13.
//  Copyright (c) 2014年 TEASON. All rights reserved.
//

#import "UIImage+AddFunction.h"

@implementation UIImage (AddFunction)

//裁剪正方
/**
 *  剪切图片为正方形
 *
 *  @param image   原始图片比如size大小为(400x200)pixels
 *  @param newSize 正方形的size比如400pixels
 *
 *  @return 返回正方形图片(400x400)pixels
 */
+ (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize
{
    CGAffineTransform scaleTransform;
    CGPoint origin;
    
    if (image.size.width > image.size.height)
    {
        //image原始高度为200，缩放image的高度为400pixels，所以缩放比率为2
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        //设置绘制原始图片的画笔坐标为CGPoint(-100, 0)pixels
        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    }
    else
    {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }
    
    CGSize size = CGSizeMake(newSize, newSize);
    //创建画板为(400x400)pixels
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    }
    else
    {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //将image原始图片(400x200)pixels缩放为(800x400)pixels
    CGContextConcatCTM(context, scaleTransform);
    //origin也会从原始(-100, 0)缩放到(-200, 0)
    [image drawAtPoint:origin];
    
    //获取缩放后剪切的image图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

// 将UIView转成UIImage
+ (UIImage *)getImageFromView:(UIView *)theView
{
    CGSize orgSize = theView.bounds.size ;
    UIGraphicsBeginImageContextWithOptions(orgSize, YES, theView.layer.contentsScale * 2);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()]   ;
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext()    ;
    UIGraphicsEndImageContext() ;
    
    return image ;
}

@end
