//
//  PasterChooseView.m
//  subao
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "PasterChooseView.h"


@interface PasterChooseView ()
@property (weak, nonatomic) IBOutlet UIImageView    *imgPaster;
@property (weak, nonatomic) IBOutlet UILabel        *lb_namePaster;
@property (weak, nonatomic) IBOutlet UIButton       *bt_bg;
@end

@implementation PasterChooseView

- (void)setAPaster:(NSString *)aPaster
{
    _aPaster = aPaster ;
    
    _lb_namePaster.text = aPaster ;
    
    _imgPaster.image = [UIImage imageNamed:aPaster] ;
}

- (IBAction)btBackgroundClickAction:(id)sender
{
    [self.delegate pasterClick:self.aPaster] ;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
