//
//  APViewController.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/14.
//

#import "APViewController.h"



@interface APViewController ()

@end

@implementation APViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ColorHex(0x8E8E92);
    [self creatLeftView];
    [self creatCenterView];

//    [self FitScreen];
}

//屏幕适配
-(void)FitScreen
{
    CGRect rect = [UIScreen mainScreen].bounds;
    float x = rect.size.width / 1194;
    float y = rect.size.height / 834;

//    if(x > y)
//    {
        self.view.transform = CGAffineTransformMakeScale(x, y);
//    }else
//    {
//        self.view.transform = CGAffineTransformMakeScale(x, x);
//    }
//    CGFloat yourDesiredWidth = 1194.0;
//    CGFloat yourDesiredHeight = 834.0;
//
//    CGAffineTransform scalingTransform;
//    scalingTransform = CGAffineTransformMakeScale(yourDesiredWidth/[UIScreen mainScreen].bounds.size.width,
//                                                  yourDesiredHeight/[UIScreen mainScreen].bounds.size.height);
//    self.view.transform = scalingTransform;
        
}

//左侧view创建
-(void)creatLeftView
{
    self.leftView = [[APLeftView alloc] init];
    [self.view addSubview:self.leftView];
}

//右边view创建
-(void)creatCenterView
{
    self.centerView = [[APCenterView alloc] init];
    [self.view addSubview:self.centerView];
}

@end
