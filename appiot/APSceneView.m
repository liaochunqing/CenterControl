//
//  APSceneView.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/14.
//

#import "APSceneView.h"

#define view_width W_SCALE(841)

@implementation APSceneView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(void)createUI
{
//    CGFloat x = Left_Gap;
//    CGFloat y = Center_Top_Gap + Center_Btn_Heigth + top_Gap;
//    CGFloat w = Center_View_Width- 2*Left_Gap;
//    CGFloat h = SCREEN_HEIGHT - y - top_Gap;
//
//    [self setFrame:CGRectMake(x, y, w, h)];
//    self.backgroundColor = ColorHex(0x1D2242);
    ViewRadius(self, 10);
    
    //监听设备选中的通知
//    [kNotificationCenter addObserver:self selector:@selector(notifySelectedDevChanged:) name:Notification_Get_SelectedDev object:nil];


    [self createTestView];
    [self createCameraView];
}

//镜头
-(void)createCameraView
{
    
    CGFloat h = H_SCALE(40);
    
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    ViewRadius(view, 5);
    view.backgroundColor = ColorHex(0x2D355C);
//    self.testBaseView = view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(Left_Gap);
        make.top.mas_equalTo(self.mas_top).offset(top_Gap);
        make.right.mas_equalTo(self.mas_right).offset(-Left_Gap);
        make.height.mas_equalTo(h);
    }];
    
    UILabel *lab = [[UILabel alloc] init];
    [view addSubview:lab];
    lab.text = @"镜头调节";
    lab.font = [UIFont systemFontOfSize:18];
    lab.textColor = [UIColor whiteColor];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).offset(Left_Gap);
        make.top.mas_equalTo(view.mas_top).offset(0);
        make.bottom.mas_equalTo(view.mas_bottom).offset(0);
        make.width.mas_equalTo(150);
    }];
    
    lab = [[UILabel alloc] init];
    [self addSubview:lab];
    lab.text = @"位移";
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = ColorHex(0xA1A7C1);
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(Left_Gap*2);
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(81));
        make.height.mas_equalTo(H_SCALE(25));
        make.width.mas_equalTo(W_SCALE(65));
    }];
    
    lab = [[UILabel alloc] init];
    [self addSubview:lab];
    lab.text = @"自动居中";
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = ColorHex(0xA1A7C1);
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(Left_Gap*2);
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(286));
        make.height.mas_equalTo(H_SCALE(25));
        make.width.mas_equalTo(W_SCALE(75));
    }];
    
    lab = [[UILabel alloc] init];
    [self addSubview:lab];
    lab.text = @"聚焦";
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = ColorHex(0xA1A7C1);
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(W_SCALE(459));
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(102));
        make.height.mas_equalTo(H_SCALE(25));
        make.width.mas_equalTo(W_SCALE(65));
    }];
    
    lab = [[UILabel alloc] init];
    [self addSubview:lab];
    lab.text = @"缩放";
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = ColorHex(0xA1A7C1);
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(W_SCALE(459));
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(206));
        make.height.mas_equalTo(H_SCALE(25));
        make.width.mas_equalTo(W_SCALE(65));
    }];
    
    lab = [[UILabel alloc] init];
    [self addSubview:lab];
    lab.text = @"快门";
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = ColorHex(0xA1A7C1);
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(W_SCALE(459));
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(286));
        make.height.mas_equalTo(H_SCALE(25));
        make.width.mas_equalTo(W_SCALE(65));
    }];
    
    UIButton *button = [[UIButton alloc] init];
    ViewRadius(button, 5);
    [button setTitle:@"自动居中" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setBackgroundImage:[self imageWithColor:ColorHex(0x2589EE)] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageWithColor:ColorHex(0x7877A9)] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(btnAutoCenterClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(W_SCALE(147));
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(281));
        make.height.mas_equalTo(H_SCALE(30));
        make.width.mas_equalTo(W_SCALE(78));
    }];
    
    
    //创建一个开关对象
    UISwitch *_mySwitch = [[UISwitch alloc]init];
    _mySwitch.frame=CGRectMake(W_SCALE(540), H_SCALE(281), W_SCALE(54), H_SCALE(30));
//    _mySwitch.on=YES;
    [self addSubview:_mySwitch];
    //设置开启状态的风格颜色
    [_mySwitch setOnTintColor:ColorHex(0x0083FF)];
//    //设置开关圆按钮的风格颜色
//    [_mySwitch setThumbTintColor:[UIColor blueColor]];
//    //设置整体风格颜色,按钮的白色是整个父布局的背景颜色
//    [_mySwitch setTintColor:[UIColor greenColor]];
    [_mySwitch addTarget:self action:@selector(swChange:) forControlEvents:UIControlEventValueChanged];

    
    NSDictionary *dict1 = @{@"string":@"weiyi_up",
                           @"imageName":@"Group 11715",
                            @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(157), H_SCALE(119), W_SCALE(50.5), H_SCALE(50.5))],
    };
    NSDictionary *dict2 = @{@"string":@"weiyi_right",
                            @"imageName":@"Group 11706",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(220), H_SCALE(182), W_SCALE(50.5), H_SCALE(50.5))],
    };
    NSDictionary *dict3 = @{@"string":@"weiyi_down",
                            @"imageName":@"Group 11707",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(157), H_SCALE(182), W_SCALE(50.5), H_SCALE(50.5))],
    };
    NSDictionary *dict4 = @{@"string":@"weiyi_left",
                            @"imageName":@"Group 11708",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(93), H_SCALE(182), W_SCALE(50.5), H_SCALE(50.5))],
    };
    
    NSDictionary *dict5 = @{@"string":@"jujiao_left",
                            @"imageName":@"Group 11708",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(517), H_SCALE(88), W_SCALE(50.5), H_SCALE(50.5))],
    };
    
    NSDictionary *dict6 = @{@"string":@"jujiao_right",
                            @"imageName":@"Group 11706",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(580), H_SCALE(88), W_SCALE(50.5), H_SCALE(50.5))],
    };
    
    NSDictionary *dict7 = @{@"string":@"suofang_left",
                            @"imageName":@"Group 11708",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(517), H_SCALE(188), W_SCALE(50.5), H_SCALE(50.5))],
    };
    
    NSDictionary *dict8 = @{@"string":@"suofang_right",
                            @"imageName":@"Group 11706",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(580), H_SCALE(188), W_SCALE(50.5), H_SCALE(50.5))],
    };
    
    NSArray *array = [NSArray arrayWithObjects:dict1, dict2, dict3, dict4,dict5,dict6,dict7,dict8,nil];
    for (int i = 0; i < array.count; i++)
    {
        NSDictionary *dic = array[i];
        if (dic == nil)
        {
            continue;
        }
        NSString *str = dic[@"string"];
        NSString *imgStr = dic[@"imageName"];
        CGRect rect = [dic[@"frame"] CGRectValue];
        
        UIButton *button = [[UIButton alloc] initWithFrame:rect];
        ViewRadius(button, 3);
        [button setBackgroundImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(btnDirectionClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    /******************************************************************/
    APAdjustButton *weiyiAdjust = [APAdjustButton new];
    [self addSubview:weiyiAdjust];
    [weiyiAdjust mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(W_SCALE(300));
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(138));
        make.height.mas_equalTo(H_SCALE(100));
        make.width.mas_equalTo(W_SCALE(80));
    }];
    
    APAdjustButton *jujiaoAdjust = [APAdjustButton new];
    [self addSubview:jujiaoAdjust];
    [jujiaoAdjust mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(W_SCALE(681));
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(60));
        make.height.mas_equalTo(H_SCALE(100));
        make.width.mas_equalTo(W_SCALE(80));
    }];
    
    APAdjustButton *suofangAdjust = [APAdjustButton new];
    [self addSubview:suofangAdjust];
    [suofangAdjust mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(W_SCALE(681));
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(170));
        make.height.mas_equalTo(H_SCALE(100));
        make.width.mas_equalTo(W_SCALE(80));
    }];
}
//测试
-(void)createTestView
{
    NSDictionary *dict1 = @{@"string":@"关",
                           @"color":ColorHex(0x1D2242),
    };
    NSDictionary *dict2 = @{@"string":@"网格",
                           @"color":ColorHex(0x1D2242),
    };
    NSDictionary *dict3 = @{@"string":@"白",
                           @"color":ColorHex(0x1D2242),
    };
    NSDictionary *dict4 = @{@"string":@"红",
                           @"color":ColorHex(0x1D2242),
    };
    
    NSDictionary *dict5 = @{@"string":@"绿",
                           @"color":ColorHex(0x1D2242),
    };
    
    NSDictionary *dict6 = @{@"string":@"蓝",
                           @"color":ColorHex(0x1D2242),
    };
    
    NSDictionary *dict7 = @{@"string":@"青",
                            @"color":ColorHex(0x1D2242),
    };
    
    NSDictionary *dict8 = @{@"string":@"洋红",
                           @"color":ColorHex(0x1D2242),
    };
    NSDictionary *dict9 = @{@"string":@"黄",
                           @"color":ColorHex(0x1D2242),
    };
    NSDictionary *dict10 = @{@"string":@"黑",
                           @"color":ColorHex(0x1D2242),
    };
    NSDictionary *dict11 = @{@"string":@"16灰阶",
                           @"color":ColorHex(0x1D2242),
    };
    
    NSDictionary *dict12 = @{@"string":@"256灰阶",
                           @"color":ColorHex(0x1D2242),
    };
    
    NSDictionary *dict13 = @{@"string":@"彩条",
                           @"color":ColorHex(0x1D2242),
    };
    
    NSDictionary *dict14 = @{@"string":@"rgb ramp",
                            @"color":ColorHex(0x1D2242),
                             
    };
    NSDictionary *dict15 = @{@"string":@"棋盘格",
                            @"color":ColorHex(0x1D2242),
    };
    
    
    NSArray *array = [NSArray arrayWithObjects:dict1, dict2, dict3, dict4,dict5,dict6,dict7,dict8, dict9, dict10, dict11,dict12,dict13,dict14,dict15,nil];


    _btnArray = [NSMutableArray array];
    _imageArray = [NSMutableArray array];

    CGFloat h = H_SCALE(40);
    
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    ViewRadius(view, 5);
    view.backgroundColor = ColorHex(0x2D355C);
//    self.testBaseView = view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(Left_Gap);
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(335));
        make.right.mas_equalTo(self.mas_right).offset(-Left_Gap);
        make.height.mas_equalTo(h);
    }];
    
    UILabel *lab = [[UILabel alloc] init];
    [view addSubview:lab];
    lab.text = @"测试图";
    lab.font = [UIFont systemFontOfSize:18];
    lab.textColor = [UIColor whiteColor];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).offset(Left_Gap);
        make.top.mas_equalTo(view.mas_top).offset(0);
        make.bottom.mas_equalTo(view.mas_bottom).offset(0);
        make.width.mas_equalTo(150);
    }];
    
    CGFloat btnW = W_SCALE(80);
    CGFloat btnH = H_SCALE(37);
    int col = 7;
    CGFloat midGap = ((view_width - 2*Left_Gap - 2*Left_Gap) - btnW*col) / (col-1);
    CGFloat x = 2*Left_Gap;
    CGFloat y = H_SCALE(403);

    for (int i = 0; i < array.count; i++)
    {
        NSDictionary *dic = array[i];
        if (dic == nil)
        {
            continue;
        }
        NSString *str = dic[@"string"];

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, btnW, btnH)];
        ViewBorderRadius(button, 3, 0.8, ColorHex(0xADACA8));
        [button setTitle:str forState:UIControlStateNormal];
//        button.titleLabel.textColor = ColorHex(0x9699AC);
        button.titleLabel.font = [UIFont systemFontOfSize: 14];
        button.tag = i;
        [button addTarget:self action:@selector(btnTestClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UIImageView *_iv = [[UIImageView alloc] init];
        _iv.image = [UIImage imageNamed:@"Group 11710"];
        _iv.hidden = YES;
        [button addSubview:_iv];
        [_iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(button.mas_top).offset(0);
            make.right.mas_equalTo(button.mas_right).offset(0);
            make.width.mas_equalTo(18);
            make.height.mas_equalTo(18);
        }];
        
//        int yu = i%col;
//        int mod = i/col;
        x = 2*Left_Gap + (btnW + midGap) * ((i+1)%col);
        y =  H_SCALE(403) +(btnH + W_SCALE(32)) * ((i+1)/col);
        
        [_btnArray addObject:button];
        [_imageArray addObject:_iv];
    }
}
#pragma button响应函数
//自动居中按钮
-(void)btnAutoCenterClick:(UIButton *)btn
{
    
}

//方向按钮
-(void)btnDirectionClick:(UIButton *)btn
{
    
}


-(void)btnTestClick:(UIButton *)btn
{
    if(btn)
    {
        //设置按钮切换后的颜色图片变化
        for (int i = 0; i < _btnArray.count; i++)
        {
            UIButton *temp = _btnArray[i];
            UIImageView *tempIm = _imageArray[i];
            if (temp)
            {
                tempIm.hidden = YES;
                ViewBorderRadius(temp, 3, 0.8, ColorHex(0xADACA8));
                [temp setTitleColor:ColorHex(0x9699AC) forState:UIControlStateNormal];
            }
        }
        
        [btn setTitleColor:ColorHex(0x3F6EF2) forState:UIControlStateNormal];
        ViewBorderRadius(btn, 3, 1, ColorHex(0x3F6EF2 ));
        UIImageView *im = _imageArray[btn.tag];
        if (im)
        {
            im.hidden = NO;
        }


        switch (btn.tag) {
            case 0://
            {
//                [self createCommandView];
            }
                break;
            case 1://
            {
            }
                break;
            case 2://
            {
            }
                break;
                
            case 3://“
            {
            }
                break;
                
            default:
                break;
        }
    }
}

//参数传入开关对象本身
- (void) swChange:(UISwitch*) sw
{
    if(sw.on==YES)
    {
//     NSLog(@"开关被打开");
    }
    else
    {
//     NSLog(@"开关被关闭");
    }
}
@end
