//
//  PasterController.m
//  XTPasterManager
//
//  Created by TuTu on 15/10/16.
//  Copyright © 2015年 teason. All rights reserved.
//

#import "PasterController.h"
#import "PasterChooseView.h"
#import "XTPasterStageView.h"
#import "XTPasterView.h"

#define APPFRAME        [UIScreen mainScreen].bounds

static const CGFloat width_pasterChoose = 110.0f ;

@interface PasterController () <UIScrollViewDelegate,PasterChooseViewDelegate>
// UIs
@property (weak, nonatomic) IBOutlet UIScrollView *scrollPaster;
@property (strong, nonatomic)        XTPasterStageView *stageView ;
@property (weak, nonatomic) IBOutlet UIView *topBar;
// Attrs
@property (nonatomic,copy) NSArray *pasterList ;
@end

@implementation PasterController
#pragma mark - PasterChooseViewDelegate
- (void)pasterClick:(NSString *)paster
{
    UIImage *image = [UIImage imageNamed:paster] ;
    
    if (!image) return ;
    
    //在这里 添加 贴纸
    [_stageView addPasterWithImg:image] ;
}


#pragma mark - Property
- (NSArray *)pasterList
{
    if (!_pasterList)
    {
        _pasterList = @[@"1",@"2",@"3",@"4",@"5"] ;
    }
    
    return _pasterList ;
}

#pragma mark - Actions
- (IBAction)backButtonClickedAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)nextButtonClickedAction:(id)sender
{
    UIImage *imgResult = [_stageView doneEdit] ;
    [self.delegate pasterAddFinished:imgResult] ;
    [self.navigationController popViewControllerAnimated:YES] ;
}

#pragma mark - Life cycle
- (void)setup
{
    CGFloat sideFlex = 10.0f ;
    CGRect rectImage = CGRectZero ;
    CGFloat length = APPFRAME.size.width - sideFlex * 2 ;
    rectImage.size = CGSizeMake(length, length) ;
    CGFloat y = (APPFRAME.size.height - self.scrollPaster.frame.size.height - length) ;
    rectImage.origin.x = sideFlex ;
    rectImage.origin.y = y ;
    
    _stageView = [[XTPasterStageView alloc] initWithFrame:rectImage] ;
    _stageView.originImage = self.imageWillHandle ;
    _stageView.backgroundColor = [UIColor whiteColor] ;
    [self.view addSubview:_stageView] ;
    
    self.view.backgroundColor = [UIColor darkGrayColor] ;
    
    [self.view bringSubviewToFront:self.topBar] ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setup] ;
    [self scrollviewSetup] ;
    
}


- (void)scrollviewSetup
{
    _scrollPaster.delegate = self ;
    _scrollPaster.pagingEnabled = NO ;
    _scrollPaster.showsVerticalScrollIndicator = NO ;
    _scrollPaster.showsHorizontalScrollIndicator = NO ;
    _scrollPaster.bounces = YES ;
    _scrollPaster.contentSize = CGSizeMake(width_pasterChoose * self.pasterList.count,
                                           self.scrollPaster.frame.size.height) ;
    
    int _x = 0 ;
    
    for (int i = 0; i < self.pasterList.count; i++)
    {
        CGRect rect = CGRectMake(_x, 0, width_pasterChoose, self.scrollPaster.frame.size.height) ;
        PasterChooseView *pView = (PasterChooseView *)[[[NSBundle mainBundle] loadNibNamed:@"PasterChooseView" owner:self options:nil] lastObject] ;
        pView.frame = rect ;
        
        pView.aPaster = self.pasterList[i] ;
        
        pView.delegate = self ;
        [_scrollPaster addSubview:pView] ;
        
        _x += width_pasterChoose ;
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
