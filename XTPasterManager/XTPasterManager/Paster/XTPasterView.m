//
//  XTPasterView.m
//  XTPasterManager
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "XTPasterView.h"

#define PASTER_SLIDE        150.0
#define FLEX_SLIDE          15.0
#define BT_SLIDE            30.0
#define BORDER_LINE_WIDTH   1.0
#define SECURITY_LENGTH     75.0


@interface XTPasterView ()
{
    CGFloat minWidth;
    CGFloat minHeight;
    CGFloat deltaAngle;
    CGPoint prevPoint;
    CGPoint touchStart;
    CGRect  bgRect ;
}

@property (nonatomic,strong) UIImageView    *imgContentView ;
@property (nonatomic,strong) UIImageView    *btDelete ;
@property (nonatomic,strong) UIImageView    *btSizeCtrl ;

@end

@implementation XTPasterView

- (void)remove
{
    [self removeFromSuperview] ;
    [self.delegate removePaster:self.pasterID] ;
}

#pragma mark -- Initial
- (instancetype)initWithBgView:(XTPasterStageView *)bgView
                      pasterID:(int)pasterID
                           img:(UIImage *)img
{
    self = [super init];
    if (self)
    {
        self.pasterID = pasterID ;
        self.imagePaster = img ;
        
        bgRect = bgView.frame ;
        
        [self setupWithBGFrame:bgRect] ;
        [self imgContentView] ;
        [self btDelete] ;
        [self btSizeCtrl] ;
        [bgView addSubview:self] ;
        self.isOnFirst = YES ;
    }
    return self;
}


- (void)setFrame:(CGRect)newFrame
{
    [super setFrame:newFrame];
    
    CGRect rect = CGRectZero ;
    CGFloat sliderContent = PASTER_SLIDE - FLEX_SLIDE * 2 ;
    rect.origin = CGPointMake(FLEX_SLIDE, FLEX_SLIDE) ;
    rect.size = CGSizeMake(sliderContent, sliderContent) ;
    self.imgContentView.frame = rect ;
    
    self.imgContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}


- (void)resizeTranslate:(UIPanGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        // preventing from the picture being shrinked too far by resizing
        if (self.bounds.size.width < minWidth || self.bounds.size.height < minHeight)
        {
            self.bounds = CGRectMake(self.bounds.origin.x,
                                     self.bounds.origin.y,
                                     minWidth + 1 ,
                                     minHeight + 1);
            self.btSizeCtrl.frame =CGRectMake(self.bounds.size.width-BT_SLIDE,
                                                   self.bounds.size.height-BT_SLIDE,
                                                   BT_SLIDE,
                                                   BT_SLIDE);
            prevPoint = [recognizer locationInView:self];
        }
        // Resizing
        else
        {
            CGPoint point = [recognizer locationInView:self];
            float wChange = 0.0, hChange = 0.0;
            
            wChange = (point.x - prevPoint.x);
            float wRatioChange = (wChange/(float)self.bounds.size.width);
            
            hChange = wRatioChange * self.bounds.size.height;
            
            if (ABS(wChange) > 50.0f || ABS(hChange) > 50.0f)
            {
                prevPoint = [recognizer locationOfTouch:0 inView:self];
                return;
            }
            
            CGFloat finalWidth  = self.bounds.size.width + (wChange) ;
            CGFloat finalHeight = self.bounds.size.height + (wChange) ;
            
            if (finalWidth > PASTER_SLIDE*(1+0.5))
            {
                finalWidth = PASTER_SLIDE*(1+0.5) ;
            }
            if (finalWidth < PASTER_SLIDE*(1-0.5))
            {
                finalWidth = PASTER_SLIDE*(1-0.5) ;
            }
            if (finalHeight > PASTER_SLIDE*(1+0.5))
            {
                finalHeight = PASTER_SLIDE*(1+0.5) ;
            }
            if (finalHeight < PASTER_SLIDE*(1-0.5))
            {
                finalHeight = PASTER_SLIDE*(1-0.5) ;
            }
            
            self.bounds = CGRectMake(self.bounds.origin.x,
                                     self.bounds.origin.y,
                                     finalWidth,
                                     finalHeight) ;
            
            self.btSizeCtrl.frame = CGRectMake(self.bounds.size.width-BT_SLIDE  ,
                                                    self.bounds.size.height-BT_SLIDE ,
                                                    BT_SLIDE ,
                                                    BT_SLIDE) ;
            
            prevPoint = [recognizer locationOfTouch:0
                                                  inView:self] ;
        }
        
        /* Rotation */
        float ang = atan2([recognizer locationInView:self.superview].y - self.center.y,
                          [recognizer locationInView:self.superview].x - self.center.x) ;
        
        float angleDiff = deltaAngle - ang ;

        self.transform = CGAffineTransformMakeRotation(-angleDiff) ;
        
        [self setNeedsDisplay] ;
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
}

- (void)setImagePaster:(UIImage *)imagePaster
{
    _imagePaster = imagePaster ;
    
    self.imgContentView.image = imagePaster ;
}


- (void)setupWithBGFrame:(CGRect)bgFrame
{
    CGRect rect = CGRectZero ;
    rect.size = CGSizeMake(PASTER_SLIDE, PASTER_SLIDE) ;
    self.frame = rect ;
    self.center = CGPointMake(bgFrame.size.width / 2, bgFrame.size.height / 2) ;
    self.backgroundColor = nil ;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)] ;
    [self addGestureRecognizer:tapGesture] ;

//    UIPinchGestureRecognizer *pincheGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)] ;
//    [self addGestureRecognizer:pincheGesture] ;

    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)] ;
    [self addGestureRecognizer:rotateGesture] ;
    
    self.userInteractionEnabled = YES ;
    
    minWidth   = self.bounds.size.width * 0.5;
    minHeight  = self.bounds.size.height * 0.5;
  
    deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,
                       self.frame.origin.x+self.frame.size.width - self.center.x) ;

}

- (void)tap:(UITapGestureRecognizer *)tapGesture
{
    NSLog(@"tap paster become first respond") ;
    self.isOnFirst = YES ;
    [self.delegate makePasterBecomeFirstRespond:self.pasterID] ;
}

- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGesture
{
    self.isOnFirst = YES ;
    [self.delegate makePasterBecomeFirstRespond:self.pasterID] ;
    
    self.imgContentView.transform = CGAffineTransformScale(self.imgContentView.transform,
                                                           pinchGesture.scale,
                                                           pinchGesture.scale) ;
    pinchGesture.scale = 1 ;
}

- (void)handleRotation:(UIRotationGestureRecognizer *)rotateGesture
{
    self.isOnFirst = YES ;
    [self.delegate makePasterBecomeFirstRespond:self.pasterID] ;
    
    self.transform = CGAffineTransformRotate(self.transform, rotateGesture.rotation) ;
    rotateGesture.rotation = 0 ;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isOnFirst = YES ;
    [self.delegate makePasterBecomeFirstRespond:self.pasterID] ;

    UITouch *touch = [touches anyObject] ;
    touchStart = [touch locationInView:self.superview] ;
}

- (void)translateUsingTouchLocation:(CGPoint)touchPoint
{
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - touchStart.x,
                                    self.center.y + touchPoint.y - touchStart.y) ;
    
    // Ensure the translation won't cause the view to move offscreen. BEGIN
    CGFloat midPointX = CGRectGetMidX(self.bounds) ;
    if (newCenter.x > self.superview.bounds.size.width - midPointX + SECURITY_LENGTH)
    {
        newCenter.x = self.superview.bounds.size.width - midPointX + SECURITY_LENGTH;
    }
    if (newCenter.x < midPointX - SECURITY_LENGTH)
    {
        newCenter.x = midPointX - SECURITY_LENGTH;
    }
    
    CGFloat midPointY = CGRectGetMidY(self.bounds);
    if (newCenter.y > self.superview.bounds.size.height - midPointY + SECURITY_LENGTH)
    {
        newCenter.y = self.superview.bounds.size.height - midPointY + SECURITY_LENGTH;
    }
    if (newCenter.y < midPointY - SECURITY_LENGTH)
    {
        newCenter.y = midPointY - SECURITY_LENGTH;
    }
    
    // Ensure the translation won't cause the view to move offscreen. END
    self.center = newCenter;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.btSizeCtrl.frame, touchLocation)) {
        return;
    }
    
    CGPoint touch = [[touches anyObject] locationInView:self.superview];
    
    [self translateUsingTouchLocation:touch] ;
    
    touchStart = touch;
}

#pragma mark -- Properties
- (void)setIsOnFirst:(BOOL)isOnFirst
{
    _isOnFirst = isOnFirst ;
    
    self.btDelete.hidden = !isOnFirst ;
    self.btSizeCtrl.hidden = !isOnFirst ;
    self.imgContentView.layer.borderWidth = isOnFirst ? BORDER_LINE_WIDTH : 0.0f ;
    
    if (isOnFirst)
    {
        NSLog(@"pasterID : %d is On",self.pasterID) ;
    }
}

- (UIImageView *)imgContentView
{
    if (!_imgContentView)
    {
        CGRect rect = CGRectZero ;
        CGFloat sliderContent = PASTER_SLIDE - FLEX_SLIDE * 2 ;
        rect.origin = CGPointMake(FLEX_SLIDE, FLEX_SLIDE) ;
        rect.size = CGSizeMake(sliderContent, sliderContent) ;
        
        _imgContentView = [[UIImageView alloc] initWithFrame:rect] ;
        _imgContentView.backgroundColor = nil ;
        _imgContentView.layer.borderColor = [UIColor whiteColor].CGColor ;
        _imgContentView.layer.borderWidth = BORDER_LINE_WIDTH ;
        _imgContentView.contentMode = UIViewContentModeScaleAspectFit ;
        
        if (![_imgContentView superview])
        {
            [self addSubview:_imgContentView] ;
        }
    }
    
    return _imgContentView ;
}

- (UIImageView *)btSizeCtrl
{
    if (!_btSizeCtrl)
    {
        _btSizeCtrl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - BT_SLIDE  ,
                                                                        self.frame.size.height - BT_SLIDE ,
                                                                        BT_SLIDE ,
                                                                        BT_SLIDE)
                            ] ;
        _btSizeCtrl.userInteractionEnabled = YES;
        _btSizeCtrl.image = [UIImage imageNamed:@"bt_paster_transform"] ;

        UIPanGestureRecognizer *panResizeGesture = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(resizeTranslate:)] ;
        [_btSizeCtrl addGestureRecognizer:panResizeGesture] ;
        if (![_btSizeCtrl superview]) {
            [self addSubview:_btSizeCtrl] ;
        }
    }
    
    return _btSizeCtrl ;
}

- (UIImageView *)btDelete
{
    if (!_btDelete)
    {
        CGRect btRect = CGRectZero ;
        btRect.size = CGSizeMake(BT_SLIDE, BT_SLIDE) ;

        _btDelete = [[UIImageView alloc]initWithFrame:btRect] ;
        _btDelete.userInteractionEnabled = YES;
        _btDelete.image = [UIImage imageNamed:@"bt_paster_delete"] ;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(btDeletePressed:)] ;
        [_btDelete addGestureRecognizer:tap] ;
        
        if (![_btDelete superview]) {
            [self addSubview:_btDelete] ;
        }
    }
    
    return _btDelete ;
}

- (void)btDeletePressed:(id)btDel
{
    NSLog(@"btDel") ;
    [self remove] ;
}

//- (void)btOriginalAction
//{
//    [self.delegate clickOriginalButton] ;
//}

@end
