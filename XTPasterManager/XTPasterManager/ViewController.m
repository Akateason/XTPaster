//
//  ViewController.m
//  XTPasterManager
//
//  Created by TuTu on 15/10/16.
//  Copyright © 2015年 teason. All rights reserved.
//

#import "ViewController.h"
#import "PasterController.h"

@interface ViewController () <PasterCtrllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@end

@implementation ViewController

- (IBAction)addPastersAction:(id)sender {
    [self performSegueWithIdentifier:@"2paster" sender:nil] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.navigationController setNavigationBarHidden:YES] ;
    [[UIApplication sharedApplication] setStatusBarHidden:YES] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- PasterCtrllerDelegate <NSObject>
- (void)pasterAddFinished:(UIImage *)imageFinished
{
    self.imgView.image = imageFinished ;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"2paster"])
    {
        PasterController *pasterCtrller = (PasterController *)[segue destinationViewController] ;
        pasterCtrller.imageWillHandle = self.imgView.image ;
        pasterCtrller.delegate = self ;
    }
    
    
}

@end
