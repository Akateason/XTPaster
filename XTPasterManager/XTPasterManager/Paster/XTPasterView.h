//
//  XTPasterView.h
//  XTPasterManager
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTPasterStageView.h"

@class XTPasterView ;

@protocol XTPasterViewDelegate <NSObject>
- (void)makePasterBecomeFirstRespond:(int)pasterID ;
- (void)removePaster:(int)pasterID ;
@end

@interface XTPasterView : UIView

@property (nonatomic,strong)    UIImage *imagePaster ;
@property (nonatomic)           int     pasterID ;
@property (nonatomic)           BOOL    isOnFirst ;
@property (nonatomic,weak)    id <XTPasterViewDelegate> delegate ;
- (instancetype)initWithBgView:(XTPasterStageView *)bgView
                      pasterID:(int)pasterID
                           img:(UIImage *)img ;
- (void)remove ;

@end
