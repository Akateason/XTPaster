//
//  PasterChooseView.h
//  subao
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PasterChooseViewDelegate <NSObject>
- (void)pasterClick:(NSString *)paster ;
@end

@interface PasterChooseView : UIView
@property (nonatomic,weak)   id <PasterChooseViewDelegate> delegate ;
@property (nonatomic,copy)   NSString *aPaster ;
@end
