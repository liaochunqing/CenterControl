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
    
//    NSString *message = @"AT+deviceInfo#System#On,LightSource#On,RunTime#3,Temperature#NtcDmd1:38,NtcCw1:64,NtcBlueLaser1:59,NtcBlueLaser2:54,NtcXpr1:54,NtcEnv1:24,NtcPowerSupply:51,,ProductInformation#ModelName:AL_DFQ730,BrandName:APPO,MachineSn:EP002051000017";
//    NSString* pattern=@"MachineSn:([^,]*()?)";
////                           NSString *pattern = @"[^a-zA-Z0-9\u4e00-\u9fa5]";//正则取反
//    NSError *error = nil;
//
//    // use regular expression to replace the emoji
//    NSRegularExpression *regex = [NSRegularExpression
//                                      regularExpressionWithPattern:pattern
//                                      options:NSRegularExpressionCaseInsensitive error:&error];
//    if(error != nil){
//        NSLog(@"ERror: %@",error);
//    }
//
//    NSArray *match = [regex matchesInString:message options:0 range:NSMakeRange(0, message.length)];
//    
//    for (NSTextCheckingResult* b in match)
//        {
//            NSRange resultRange = [b rangeAtIndex:0];
//
//            //从urlString当中截取数据
//
//            NSString *result=[message substringWithRange:resultRange];
//            //输出结果
//            NSLog(@"%@",result);
//        }
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
//                [button setSelected:YES];
                [button sendActionsForControlEvents:UIControlEventTouchUpInside];//代码点击
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
}

-(void)creatCenterChuangeView
{
    if(self.centerChangeView == nil)
    {
        CGFloat x = 0;
        CGFloat y = Center_Top_Gap + Center_Btn_Heigth + top_Gap;
        CGFloat w = Center_View_Width;
        CGFloat h = SCREEN_HEIGHT - y;
        self.centerChangeView  = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        self.centerChangeView.backgroundColor = ColorHex(0x161635);
        [self addSubview:self.centerChangeView];
    }
    else
    {
        [self bringSubviewToFront:self.centerChangeView];
    }
}

//创建“控制”窗口view
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
    }
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
        
        
        if(self.monitorView != nil)
        {
            [self.monitorView.timer invalidate];
            self.monitorView.timer = nil;
            [self.monitorView removeFromSuperview];
            self.monitorView = nil;
            [kNotificationCenter removeObserver:Notification_Get_SelectedDev];
        }
        
        switch (btn.tag) {
            case 0://按钮“控制”
            {
                [self createCommandView];
            }
                break;
            case 1://按钮“监控”
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
            }
                break;
            case 2://按钮“”
            {
                [self creatCenterChuangeView];
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
