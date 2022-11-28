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
