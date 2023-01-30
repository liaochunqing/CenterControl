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
        self.backgroundColor = ColorHex(0x1D2242);

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


//    [self createTestView];
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
    lab.text = LSTRING(@"镜头调节");
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
    lab.text = LSTRING(@"位移");
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = ColorHex(0xA1A7C1);
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(Left_Gap*2);
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(81));
        make.height.mas_equalTo(H_SCALE(25));
        make.width.mas_equalTo(W_SCALE(165));
    }];
    
    lab = [[UILabel alloc] init];
    [self addSubview:lab];
    lab.text = LSTRING(@"自动居中");
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = ColorHex(0xA1A7C1);
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(Left_Gap*2);
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(286));
        make.height.mas_equalTo(H_SCALE(25));
        make.width.mas_equalTo(W_SCALE(175));
    }];
    
    lab = [[UILabel alloc] init];
    [self addSubview:lab];
    lab.text = LSTRING(@"聚焦");
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
    lab.text = LSTRING(@"缩放");
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
    lab.text = LSTRING(@"快门");
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
    [button setTitle:LSTRING(@"自动居中") forState:UIControlStateNormal];
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
    _mySwitch = [[UISwitch alloc]init];
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
//        NSString *str = dic[@"string"];
        NSString *imgStr = dic[@"imageName"];
        CGRect rect = [dic[@"frame"] CGRectValue];
        
        UIButton *button = [[UIButton alloc] initWithFrame:rect];
        ViewRadius(button, 3);
//        button.backgroundColor = [UIColor redColor];
        [button setBackgroundImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(btnDirectionClick:) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLongPress:)];
        longPress.minimumPressDuration = 0.3;//长按时间
//        longPress.
        [button addGestureRecognizer:longPress];
        [self addSubview:button];
    }
    
    /******************************************************************/
    APAdjustButton *weiyiAdjust = [APAdjustButton new];
    _wyAdjustButton = weiyiAdjust;
    [self addSubview:weiyiAdjust];
    [weiyiAdjust mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(W_SCALE(300));
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(138));
        make.height.mas_equalTo(H_SCALE(100));
        make.width.mas_equalTo(W_SCALE(80));
    }];
    
    APAdjustButton *jujiaoAdjust = [APAdjustButton new];
    _jjAdjustButton = jujiaoAdjust;
    [self addSubview:jujiaoAdjust];
    [jujiaoAdjust mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(W_SCALE(681));
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(60));
        make.height.mas_equalTo(H_SCALE(100));
        make.width.mas_equalTo(W_SCALE(80));
    }];
    
    APAdjustButton *suofangAdjust = [APAdjustButton new];
    _sfAdjustButton = suofangAdjust;
    [self addSubview:suofangAdjust];
    [suofangAdjust mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(W_SCALE(681));
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(170));
        make.height.mas_equalTo(H_SCALE(100));
        make.width.mas_equalTo(W_SCALE(80));
    }];
}


//测试
-(void)createTestView:(NSArray *)selectedArray
{
    
    _selectedArray = [NSMutableArray arrayWithArray:selectedArray];
    NSDictionary *dict1 = @{@"string":@"关",
                           @"parameter_value":@"Off",
                            @"exec_code":@"scene-testChart-Off",
    };
    NSDictionary *dict2 = @{@"string":@"网格",
                            @"parameter_value":@"Grid",
                            @"exec_code":@"scene-testChart-Grid",
    };
    NSDictionary *dict3 = @{@"string":@"白",
                            @"parameter_value":@"White",
                            @"exec_code":@"scene-testChart-White",
    };
    NSDictionary *dict4 = @{@"string":@"红",
                            @"parameter_value":@"Red",
                            @"exec_code":@"scene-testChart-Rad",
    };
    
    NSDictionary *dict5 = @{@"string":@"绿",
                            @"parameter_value":@"Green",
                            @"exec_code":@"scene-testChart-Green",
    };
    
    NSDictionary *dict6 = @{@"string":@"蓝",
                            @"parameter_value":@"Blue",
                            @"exec_code":@"scene-testChart-Blue",
    };
    
    NSDictionary *dict7 = @{@"string":@"青",
                            @"parameter_value":@"Cyan",
                            @"exec_code":@"scene-testChart-Cyan",
    };
    
    NSDictionary *dict8 = @{@"string":@"洋红",
                            @"parameter_value":@"Megenta",
                            @"exec_code":@"scene-testChart-Radc",
    };
    NSDictionary *dict9 = @{@"string":@"黄",
                            @"parameter_value":@"Yellow",
                            @"exec_code":@"scene-testChart-yellow",
    };
    NSDictionary *dict10 = @{@"string":@"黑",
                             @"parameter_value":@"Black",
                             @"exec_code":@"scene-testChart-Black",
    };
    NSDictionary *dict11 = @{@"string":@"16灰阶",
                             @"parameter_value":@"Grey16",
                             @"exec_code":@"scene-testChart-Grey16",
    };
    
    NSDictionary *dict12 = @{@"string":@"256灰阶",
                             @"parameter_value":@"Grey256",
                             @"exec_code":@"scene-testChart-Grey256",
    };
    
    NSDictionary *dict13 = @{@"string":@"彩条",
                             @"parameter_value":@"ColorBars",
                             @"exec_code":@"scene-testChart-ColorBars",
    };
    
    NSDictionary *dict14 = @{@"string":@"rgb ramp",
                             @"parameter_value":@"RGBRamps",
                             @"exec_code":@"scene-testChart-Grid1",
                             
    };
    NSDictionary *dict15 = @{@"string":@"棋盘格",
                             @"parameter_value":@"CheckErboard",
                             @"exec_code":@"scene-testChart-CheckErboard",
    };
    NSDictionary *dict16 = @{@"string":LSTRING(@"切换测试图"),
                             @"parameter_value":@"",
                             @"exec_code":@"scene-testSwitch",
    };
    
    
    
    NSMutableArray *orgArray = [NSMutableArray arrayWithObjects:dict1, dict2, dict3, dict4,dict5,dict6,dict7,dict8, dict9, dict10, dict11,dict12,dict13,dict14,dict15,dict16,nil];
    
    _testDataArray = [NSMutableArray array];
    if(selectedArray && selectedArray.count)
    {
        APGroupNote *node = selectedArray[0];
        
        _isSpecial = NO;
        
        for (NSString *key in node.sceneDict)
        {
            if ([@"scene-testChart" isEqualToString:key])
            {
                [orgArray removeObject:dict16];
                _testDataArray = [NSMutableArray arrayWithArray:orgArray];
                _isSpecial = YES;
                break;
            }
        }
        if (_isSpecial == NO)
        {
            for (int i = (int)orgArray.count - 1; i >= 0; i--)
            {
                NSDictionary *dict = orgArray[i];
                NSString *str = dict[@"exec_code"];
                
                for (NSString *key in node.sceneDict)
                {
                    if ([str compare:key options:NSCaseInsensitiveSearch] ==NSOrderedSame)
                    {
                        [_testDataArray addObject:dict];
                        [orgArray removeObject:dict];
                    }
                }
            }
            
            _testDataArray = (NSMutableArray*)[[_testDataArray reverseObjectEnumerator] allObjects];
        }
    }
    

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
    
    [_testBaseView removeFromSuperview];
    _testBaseView = nil;
    _testBaseView = [[UIView alloc] init];
//    _testBaseView.backgroundColor = [UIColor redColor];
    [self addSubview:_testBaseView];
    ViewRadius(view, 5);
    [_testBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(view.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    
    CGFloat btnW = W_SCALE(80);
    CGFloat btnH = H_SCALE(37);
    int col = 7;
    CGFloat midGap = ((view_width - 2*Left_Gap - 2*Left_Gap) - btnW*col) / (col-1);
    CGFloat x = 2*Left_Gap;
    CGFloat y = H_SCALE(28);

    for (int i = 0; i < _testDataArray.count; i++)
    {
        NSDictionary *dic = _testDataArray[i];
        if (dic == nil)
        {
            continue;
        }
        NSString *str = dic[@"string"];

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, btnW, btnH)];
        ViewBorderRadius(button, 3, 0.8, ColorHex(0xADACA8));
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:ColorHex(0x9699AC) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize: 14];
        button.tag = i;
        [_testBaseView addSubview:button];
        
        if([@"scene-testSwitch" isEqualToString:dic[@"exec_code"]])//切换测试图按钮，特殊处理
        {
            [button setBackgroundImage:[self imageWithColor:ColorHex(0x2589EE)] forState:UIControlStateNormal];
            [button setBackgroundImage:[self imageWithColor:ColorHex(0x7877A9)] forState:UIControlStateHighlighted];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            ViewBorderRadius(button, 5, 0.001, ColorHex(0xADACA8));
//            button.tag = 1000;
            CGRect frame = button.frame;
            frame.size.width = W_SCALE(110);
            [button setFrame:frame];
            [button addTarget:self action:@selector(btnTestSwichClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [button addTarget:self action:@selector(btnTestClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
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
        y =  H_SCALE(28) +(btnH + W_SCALE(32)) * ((i+1)/col);
        
        [_btnArray addObject:button];
        [_imageArray addObject:_iv];
    }
}

-(void)setDefaultValue:(NSArray *)array
{
    if (array == nil)
        return;
    
    if (array.count > 0)//没有选设备显示界面
    {
        APGroupNote *node = array[0];

        _mySwitch.on = [node.shutter_status isEqualToString:@"1"] ? YES : NO;
    }
}

#pragma button响应函数
//自动居中按钮
-(void)btnAutoCenterClick:(UIButton *)btn
{
    NSString *key = @"scene-auto-center";
    [self sendMssageToDev:key];
}

-(void)sendMssageToDev:(NSString *)key
{
    for (APGroupNote *node in _selectedArray)
    {
        NSData* sendData = node.sceneDict[key];
        if (sendData == nil)
            continue;

        if ([@"tcp" compare:node.access_protocol options:NSCaseInsensitiveSearch |NSNumericSearch] ==NSOrderedSame)
        {
            NSLog(@"%@,ip=%@,port=%@,发送数据：%@",node.access_protocol,node.ip,node.port,sendData);
            APTcpSocket *tcpManager;
            if (node.tcpManager == nil)
            {
                node.tcpManager = [APTcpSocket new];

            }
            node.tcpManager.senddata = [NSData dataWithData:sendData];
            node.tcpManager.ip = node.ip;
            node.tcpManager.port = node.port.intValue;
            [node.tcpManager connectToHost];
        }
        else if ([@"udp" compare:node.access_protocol options:NSCaseInsensitiveSearch |NSNumericSearch] ==NSOrderedSame)
        {
            NSLog(@"%@,ip=%@,port=%@,发送数据：%@",node.access_protocol,node.ip,node.port,sendData);
            NSString *sss = [[NSString alloc] initWithData:sendData encoding:NSUTF8StringEncoding];

//            APUdpSocket *udpManager;
            if (node.udpManager == nil)
            {
                node.udpManager = [APUdpSocket new];
            }
            node.udpManager.host = node.ip;//@"255.255.255.255";
            node.udpManager.port = [node.port intValue];
            [node.udpManager createClientUdpSocket];
            [node.udpManager sendMessage:sendData];
        }
    }
}


-(void)sendMssageToDev:(NSString *)key value:(NSString *)value
{
    for (APGroupNote *node in _selectedArray)
    {
        NSData* sendData = node.sceneDict[key];
        if (sendData == nil)
            continue;
        
        NSString *str = [[NSString alloc] initWithData:sendData encoding:NSUTF8StringEncoding];
        NSString *finalStr = [SafeStr(str) stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        finalStr = [NSString stringWithFormat:@"%@%@\r\n",finalStr,SafeStr(value)];
        finalStr = [[APTool shareInstance] hexStringFromString:finalStr];
        NSData *filanData = [[APTool shareInstance] convertHexStrToData:finalStr];

        if ([@"tcp" compare:node.access_protocol options:NSCaseInsensitiveSearch |NSNumericSearch] ==NSOrderedSame)
        {
            NSLog(@"%@,ip=%@,port=%@,发送数据：%@",node.access_protocol,node.ip,node.port,sendData);

            APTcpSocket *tcpManager;
            if (node.tcpManager == nil)
            {
                node.tcpManager = [APTcpSocket new];

            }
            node.tcpManager.senddata = [NSData dataWithData:filanData];
            node.tcpManager.ip = node.ip;
            node.tcpManager.port = node.port.intValue;
            [node.tcpManager connectToHost];
        }
        else if ([@"udp" compare:node.access_protocol options:NSCaseInsensitiveSearch |NSNumericSearch] ==NSOrderedSame)
        {
            NSLog(@"%@,ip=%@,port=%@,发送数据：%@",node.access_protocol,node.ip,node.port,sendData);
//            NSString *sss = [[NSString alloc] initWithData:sendData encoding:NSUTF8StringEncoding];

            if (node.udpManager == nil)
            {
                node.udpManager = [APUdpSocket new];
            }
            node.udpManager.host = node.ip;//@"255.255.255.255";
            node.udpManager.port = [node.port intValue];
            [node.udpManager createClientUdpSocket];
            [node.udpManager sendMessage:sendData];
        }
    }
}
//方向按钮
-(void)btnDirectionClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 0://位移上
        {
            NSString *key = _wyAdjustButton.microBtn.selected?@"scene-up-fine tuning":@"scene-up-coarse tuning";
            [self sendMssageToDev:key];
        }
            break;
        case 1://位移右
        {
            NSString *key = _wyAdjustButton.microBtn.selected?@"scene-right-fine tuning":@"scene-right-fine tuning";
            [self sendMssageToDev:key];
        }
            break;
        case 2://位移下
        {
            NSString *key = _wyAdjustButton.microBtn.selected?@"scene-down-fine tuning":@"scene-down-coarse tuning";
            [self sendMssageToDev:key];
        }
            break;
            
        case 3://位移左
        {
            NSString *key = _wyAdjustButton.microBtn.selected?@"scene-left-fine tuning":@"scene-left-coarse tuning";
            [self sendMssageToDev:key];
        }
            break;
            
        case 4://聚焦左
        {
            NSString *key = _jjAdjustButton.microBtn.selected?@"scene-focusing-left-fine tuning":@"scene-focusing-left-coarse tuning";
            [self sendMssageToDev:key];
            
        }
            break;
        case 5://聚焦右
        {
            NSString *key = _jjAdjustButton.microBtn.selected?@"scene-focusing-right-fine tuning":@"scene-focusing-right-coarse tuning";
            [self sendMssageToDev:key];
        }
            break;
        case 6://缩放左
        {
            NSString *key = _sfAdjustButton.microBtn.selected?@"scene-zoom-left-fine tuning":@"scene-zoom-left-coarse tuning";
            [self sendMssageToDev:key];
        }
            break;
            
        case 7://缩放右
        {
            NSString *key = _sfAdjustButton.microBtn.selected?@"scene-zoom-right-fine tuning":@"scene-zoom-right-coarse tuning";
            [self sendMssageToDev:key];
        }
            break;
            
        default:
            break;
    }
}


//方向按钮 长按键
-(void)btnLongPress:(UILongPressGestureRecognizer*)sender
{

    UIButton *btn = (UIButton *)[sender view];
    NSLog(@"btnLongPress %d",(int)btn.tag);
    
//    if (sender.state == UIGestureRecognizerStateBegan)
    {
        
        
        switch (btn.tag) {
            case 0://位移上
            {
                NSString *key = _wyAdjustButton.microBtn.selected?@"scene-up-fine tuning":@"scene-up-coarse tuning";
                [self sendMssageToDev:key];
            }
                break;
            case 1://位移右
            {
                NSString *key = _wyAdjustButton.microBtn.selected?@"scene-right-fine tuning":@"scene-right-fine tuning";
                [self sendMssageToDev:key];
            }
                break;
            case 2://位移下
            {
                NSString *key = _wyAdjustButton.microBtn.selected?@"scene-down-fine tuning":@"scene-down-coarse tuning";
                [self sendMssageToDev:key];
            }
                break;
                
            case 3://位移左
            {
                NSString *key = _wyAdjustButton.microBtn.selected?@"scene-left-fine tuning":@"scene-left-coarse tuning";
                [self sendMssageToDev:key];
            }
                break;
                
            case 4://聚焦左
            {
                NSString *key = _jjAdjustButton.microBtn.selected?@"scene-focusing-left-fine tuning":@"scene-focusing-left-coarse tuning";
                [self sendMssageToDev:key];
                
            }
                break;
            case 5://聚焦右
            {
                NSString *key = _jjAdjustButton.microBtn.selected?@"scene-focusing-right-fine tuning":@"scene-focusing-right-coarse tuning";
                [self sendMssageToDev:key];
            }
                break;
            case 6://缩放左
            {
                NSString *key = _sfAdjustButton.microBtn.selected?@"scene-zoom-left-fine tuning":@"scene-zoom-left-coarse tuning";
                [self sendMssageToDev:key];
            }
                break;
                
            case 7://缩放右
            {
                NSString *key = _sfAdjustButton.microBtn.selected?@"scene-zoom-right-fine tuning":@"scene-zoom-right-coarse tuning";
                [self sendMssageToDev:key];
            }
                break;
                
            default:
                break;
        }
    }
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

        //发送指令
        if (_testDataArray && _testDataArray.count > btn.tag)
        {
            NSDictionary *dic = _testDataArray[btn.tag];
            NSString *key = dic[@"exec_code"];
            NSString *value = dic[@"parameter_value"];
            if(_isSpecial)
            {
                [self sendMssageToDev:@"scene-testChart" value:value];

            }
            else
            {
                [self sendMssageToDev:key];

            }
        }
    }
}

-(void)btnTestSwichClick:(UIButton *)btn
{
    if(btn)
    {
        //发送指令
        if (_testDataArray && _testDataArray.count > btn.tag)
        {
            NSDictionary *dic = _testDataArray[btn.tag];
            NSString *key = dic[@"exec_code"];
            NSString *value = dic[@"parameter_value"];
            if(_isSpecial)
            {
                [self sendMssageToDev:@"scene-testChart" value:value];

            }
            else
            {
                [self sendMssageToDev:key];
            }
        }
    }
}


//参数传入开关对象本身
- (void)swChange:(UISwitch*) sw
{
    if(sw.on==YES)
    {
//     NSLog(@"开关被打开");
        NSString *key = @"scene-shutter";
//        [self sendMssageToDev:key];
        [self sendMssageToDev:key value:@"On"];
    }
    else
    {
//     NSLog(@"开关被关闭");
        NSString *key = @"scene-shutter";
//        [self sendMssageToDev:key];
        [self sendMssageToDev:key value:@"Off"];
    }
}
@end
