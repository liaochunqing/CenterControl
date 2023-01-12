//
//  APCenterView.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/14.
//


#import "APCenterView.h"


@implementation APCenterView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    CGFloat x = Left_View_Width + 1;
    CGFloat y = 0;
    CGFloat w = Center_View_Width;
    CGFloat h = SCREEN_HEIGHT;
    
    [self setFrame:CGRectMake(x, y, w, h)];
    self.backgroundColor = ColorHex(0x161635 );
    
    [self createMenu];
    [self createMonitorView];
    if(_controlBtn)//默认选中第一个
    {
        [_controlBtn sendActionsForControlEvents:UIControlEventTouchUpInside];//代码点击
    }
}


//右侧顶部菜单
- (void)createMenu
{
    NSArray *array = [NSArray arrayWithObjects:@"控制", @"监视", @"日程设定", @"安装调节", @"工程", @"工厂",nil];

    CGFloat midGap = (Center_View_Width - 2*Left_Gap - array.count*Center_Btn_Width)/(array.count - 1);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, Center_Top_Gap, Center_View_Width, Center_Btn_Heigth)];
    view.backgroundColor = [UIColor clearColor];
    self.menuBtnArray = [NSMutableArray array];
    
        int x = Left_Gap;
        for (int i = 0; i < array.count; i++)
        {
            NSString *str = array[i];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, Center_Btn_Width, Center_Btn_Heigth)];
            [view addSubview:button];
            
            [button setTitle:str forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize: 16.0];
            [button setTitleColor:ColorHex(0xFFFFFF ) forState:UIControlStateNormal];
            button.tag = i;
            [button setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
//            [button setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateSelected];
            
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            if (self.menuBtnArray)
            {
                [self.menuBtnArray addObject:button];
            }
            
            if (i == 2 || i==4 || i==5)
            {
                button.enabled = NO;
                button.backgroundColor = [UIColor grayColor];
                ViewRadius(button, 8);
            }
            else
            {
                ViewBorderRadius(button, 8, 2, ColorHex(0x375BCD ));
            }
            
            if(i == 0)//默认选中第一个
            {
//                [button sendActionsForControlEvents:UIControlEventTouchUpInside];//代码点击
                _controlBtn = button;
            }
            
            x += Center_Btn_Width + midGap;
        }

       [self addSubview:view];
}

//创建“控制”窗口view
-(void)createCommandView
{
    if(self.commandView == nil)
    {
        self.commandView = [[APCommandView alloc] init];
        [self addSubview:self.commandView];
    }
    else
    {
        [self bringSubviewToFront:self.commandView];
    }
    
    self.commandView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.commandView.alpha = 1;
    }];
}

//创建“监控”窗口view
-(void)createMonitorView
{
    if(self.monitorView == nil)
    {
        self.monitorView = [[APMonitorView alloc] init];
        [self addSubview:self.monitorView];
    }
    else
    {
        [self bringSubviewToFront:self.monitorView];
    }
    
    self.monitorView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.monitorView.alpha = 1;
    }];
}

//创建“安装调节”窗口view
-(void)createInstallView
{
    if(self.installView == nil)
    {
        self.installView = [[APInstallView alloc] init];
        [self addSubview:self.installView];
    }
    else
    {
        [self bringSubviewToFront:self.installView];
        
        if (self.installView.selectedMenuIndex == 0)
        {
            [self.installView.sceneView setDefaultValue:self.installView.sceneView.selectedArray];
        }
    }
    
    self.installView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.installView.alpha = 1;
    }];
}

#pragma button响应函数

-(void)btnClick:(UIButton *)btn
{
    if(btn)
    {
        //设置按钮切换后的颜色图片变化
        for (int i = 0; i < self.menuBtnArray.count; i++)
        {
            UIButton *temp = self.menuBtnArray[i];
            if (temp && temp.enabled)
            {
                [temp setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
                //清除边框
                ViewBorder(temp, 2, ColorHex(0x375BCD ));
            }
            
        }
        ViewBorder(btn, 0, ColorHex(0x375BCD ));
        [btn setBackgroundImage:[self imageWithColor:ColorHex(0x3F6EF2)] forState:UIControlStateNormal];
        
        
//        if(self.monitorView != nil)
//        {
//            [self.monitorView.timer invalidate];
//            self.monitorView.timer = nil;
//            [self.monitorView removeFromSuperview];
//            self.monitorView = nil;
//            [kNotificationCenter removeObserver:Notification_Get_SelectedDev];
//        }
        
        switch (btn.tag) {
            case 0://按钮“控制”
            {
                [self createCommandView];
            }
                break;
            case 1://按钮“监控”
            {
                [self createMonitorView];
            }
                break;
                
            case 3://“安装调节”
            {
                [self createInstallView];
            }
                break;
                
            default:
                break;
        }
    }
}

@end
