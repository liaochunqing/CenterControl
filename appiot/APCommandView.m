//
//  APCommandView.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/14.
//

#import "APCommandView.h"
#import "AppDelegate.h"

@implementation APCommandView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(void)createUI
{

    CGFloat x = 0;
    CGFloat y = Center_Top_Gap + Center_Btn_Heigth + top_Gap;
    CGFloat w = Center_View_Width;
    CGFloat h = SCREEN_HEIGHT - y;
    
    [self setFrame:CGRectMake(x, y, w, h)];
    self.backgroundColor = ColorHex(0x161635);
    
    [self performSelector:@selector(setDeviceStatus) withObject:nil afterDelay:2];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(setDeviceStatus) userInfo:nil repeats:YES];
    
    //监听设备选中的通知
    [kNotificationCenter addObserver:self selector:@selector(notifySelectedDevChanged:) name:Notification_Get_SelectedDev object:nil];
    
    [self createSwitchView];
    [self createTestView];
    [self createMonitorView];
    [self getSelectedDev];
}

-(void)notifySelectedDevChanged:(NSNotification *)notification
{
    NSArray *arr = notification.userInfo[@"array"];
    if (!arr) return;
    
    if (_data && _data.count)
    {
        [_data removeAllObjects];
    }
    else
    {
        _data =[NSMutableArray array];
    }
    _data = [NSMutableArray arrayWithArray:arr];

    if (_data.count)
    {
    }
}

-(void)getSelectedDev
{
    AppDelegate *appDelegate = kAppDelegate;
    APGroupView *vc = appDelegate.mainVC.leftView.groupView;
    if (vc && [vc isKindOfClass:[APGroupView class]])
    {
        NSArray *temp = [vc getSelectedDevice];
        if (!temp) return;

        if (_data && _data.count)
        {
            [_data removeAllObjects];
        }
        else
        {
            _data = [NSMutableArray array];
        }
        _data = [NSMutableArray arrayWithArray:temp];
    }
}

-(void)getDevExecDict
{
    //1.获得数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbfileName = [doc stringByAppendingPathComponent:DB_NAME];
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:dbfileName];
    //3.打开数据库
    if ([db open])
    {
        for (APGroupNote *node in _data)
        {
            node.commandDict = [NSMutableDictionary dictionary];
            NSString *sqlStr = [NSString stringWithFormat:@"select l.parameter_value,i.exec_code from zk_command_mount m,zk_execlist_info i ,dev_execlist l where m.model_id=%@ and m.tab_code='control' and  m.exec_info_id=i.id and m.dev_exec_id=l.id",node.model_id];
            FMResultSet *resultSet = [db executeQuery:sqlStr];
            // 遍历结果集
            while ([resultSet next])
            {
                NSString *key = SafeStr([resultSet stringForColumn:@"exec_code"]);
                NSString *value = SafeStr([resultSet stringForColumn:@"parameter_value"]);
                [node.commandDict setValue:value forKey:key];
            }
        }
    }
        
    [db close];
}

-(void)createSwitchView
{
    NSDictionary *dict1 = @{@"string":@"开机",
                           @"imageName":@"active 3",
    };
    NSDictionary *dict2 = @{@"string":@"关机",
                           @"imageName":@"active 1",
    };
    NSDictionary *dict3 = @{@"string":@"开快门",
                           @"imageName":@"active 4",
    };
    NSDictionary *dict4 = @{@"string":@"关快门",
                           @"imageName":@"active 2",
    };
    
    
    NSArray *array = [NSArray arrayWithObjects:dict1, dict2, dict3, dict4,nil];
    CGFloat btnW = Command_Btn_W;
    CGFloat btnH = Command_Btn_H;
    int x = Left_Gap;
    CGFloat midGap = (Center_View_Width - 2*Left_Gap - array.count*btnW)/(array.count - 1);

    for (int i = 0; i < array.count; i++)
    {
        NSDictionary *dic = array[i];
        if (dic == nil)
        {
            continue;
        }
        NSString *str = dic[@"string"];
        NSString *strImage = dic[@"imageName"];
        APComandButton *button = [[APComandButton alloc] initWithFrame:CGRectMake(x, 0, btnW, btnH)];
        ViewRadius(button, 12);
        [self addSubview:button];
        if (str && str.length)
        {
            button.lab.text = str;
        }
        if (strImage && strImage.length)
        {
            [button.iv setImage:[UIImage imageNamed:strImage]];
        }
        if(i == 0)//默认选中第一个
        {
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];//代码点击
        }
        
        button.tag = i;
        [button addTarget:self action:@selector(btnSwithClick:) forControlEvents:UIControlEventTouchUpInside];
        x += btnW + midGap;
    }
}

//测试
-(void)createTestView
{
    NSDictionary *dict1 = @{@"string":@"关",
                           @"color":ColorHex(0x494E67),
                            @"textColor":ColorHex(0xABBDD5)
    };
    NSDictionary *dict2 = @{@"string":@"网格",
                           @"color":ColorHex(0x344B67),
                            @"textColor":ColorHex(0x96EFFF)
    };
    NSDictionary *dict3 = @{@"string":@"红",
                           @"color":ColorHex(0x491B34),
                            @"textColor":[UIColor redColor]
    };
    NSDictionary *dict4 = @{@"string":@"绿",
                           @"color":ColorHex(0x164E34),
                            @"textColor":[UIColor greenColor]
    };
    
    NSDictionary *dict5 = @{@"string":@"蓝",
                           @"color":ColorHex(0x1D3066),
                            @"textColor":[UIColor blueColor]
    };
    
    NSDictionary *dict6 = @{@"string":@"白",
                           @"color":ColorHex(0x494E67),
                            @"textColor":[UIColor whiteColor]
    };
    
    NSDictionary *dict7 = @{@"string":@"黑",
                            @"color":[UIColor darkGrayColor],//ColorHex(0x493C39),
                            @"textColor":[UIColor blackColor]
    };
    
    
    NSArray *array = [NSArray arrayWithObjects:dict1, dict2, dict3, dict4,dict5,dict6,dict7,nil];

//    CGFloat w = 841;
    CGFloat h = H_SCALE(143);
    
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    ViewRadius(view, 10);
    view.backgroundColor = ColorHex(0x1D2242);
    self.testBaseView = view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(Left_Gap);
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(208)+top_Gap);
        make.right.mas_equalTo(self.mas_right).offset(-Left_Gap);
        make.height.mas_equalTo(h);
    }];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(Left_Gap, top_Gap, 80, 28)];
    [view addSubview:lab];
    lab.text = @"测试图";
    lab.font = [UIFont systemFontOfSize:20];
    lab.textColor = [UIColor whiteColor];
    
    CGFloat btnW = W_SCALE(90);
    CGFloat btnH = H_SCALE(43);
    CGFloat midGap = (((Center_View_Width - 2*Left_Gap) - 2*Left_Gap) - btnW*array.count) / (array.count-1);//W_SCALE(20);
    CGFloat x = Left_Gap;
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dic = array[i];
        if (dic == nil)
        {
            continue;
        }
        NSString *str = dic[@"string"];
        

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, H_SCALE(70), btnW, btnH)];
        ViewRadius(button, 5);
        [button setBackgroundImage:[self imageWithColor:dic[@"color"]] forState:UIControlStateNormal];
        [button setBackgroundImage:[self imageWithColor:ColorHex(0x494E67)] forState:UIControlStateHighlighted];
        
//        [button setBackgroundImage:[UIImage getColorImageWithColor:dic[@"color"]] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage getColorImageWithColor:ColorHex(0x7877A9)] forState:UIControlStateHighlighted];
        [view addSubview:button];
        if (str && str.length)
        {
            [button setTitle:str forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize: 16];
        }
        [button setTitleColor:dic[@"textColor"] forState:UIControlStateNormal];

        
        button.tag = i;
        [button addTarget:self action:@selector(btnTestClick:) forControlEvents:UIControlEventTouchUpInside];
        x = Left_Gap + (btnW + midGap) * (i+1);
    }
}

//设备监测
-(void)createMonitorView
{
    NSString*total = @"520";
    NSString*erroNumber = @"5";
    NSString*online = @"0";
    NSString*offline =@"520";
    
    AppDelegate *appDelegate = kAppDelegate;
    APGroupView *vc = appDelegate.mainVC.leftView.groupView;
    if (vc && [vc isKindOfClass:[APGroupView class]])
    {
        total = [NSString stringWithFormat:@"%d",vc.allNumber];
        offline = total;
        erroNumber = [NSString stringWithFormat:@"%d",vc.errorCodeNumber];
    }
    
    NSDictionary *dict1 = @{@"string":@"设备总数",
                           @"number":total,
                            @"imageName":@"Group 215",
    };
    NSDictionary *dict2 = @{@"string":@"在线设备数",
                           @"number":online,
                            @"imageName":@"Group 216",
    };
    NSDictionary *dict3 = @{@"string":@"离线设备数",
                           @"number":offline,
                            @"imageName":@"Group 217",
    };
    NSDictionary *dict4 = @{@"string":@"异常设备",
                           @"number":erroNumber,
                            @"imageName":@"Group 218",
    };

    
    NSArray *array = [NSArray arrayWithObjects:dict1, dict2, dict3, dict4,nil];

//    CGFloat w = Center_View_Width - 2*Left_Gap;
//    CGFloat h = 143;
    UIView *view = [[UIView alloc] init];
    ViewRadius(view, 10);
    view.backgroundColor = ColorHex(0x1D2242);
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(Left_Gap);
        make.right.mas_equalTo(self.mas_right).offset(-Left_Gap);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-Left_Gap);
        make.top.mas_equalTo(self.testBaseView.mas_bottom).offset(top_Gap);
    }];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(Left_Gap, top_Gap, 120, 28)];
    [view addSubview:lab];
    lab.text = @"设备监测";
    lab.font = [UIFont systemFontOfSize:20];
    lab.textColor = [UIColor whiteColor];
    
//刷新按钮
    UIButton *btnRight = [UIButton new];
    [view addSubview:btnRight];
    ViewRadius(btnRight, 5);
    [btnRight setTitle:@"刷新" forState:UIControlStateNormal];
    btnRight.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [btnRight setTitleColor:ColorHex(0xFFFFFF ) forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[self imageWithColor:ColorHex(0x3F6EF2)] forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateSelected];
    [btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(W_SCALE(60), H_SCALE(32)));
        make.top.mas_equalTo(view.mas_top).offset(top_Gap);
        make.right.mas_equalTo(view.mas_right).offset(-Left_Gap);
    }];
    [btnRight addTarget:self action:@selector(btnRefreshClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat btnW = (Center_View_Width - 5*Left_Gap)/2;//W_SCALE(389);
    CGFloat btnH = H_SCALE(70);
    CGFloat x = Left_Gap;
    CGFloat y = H_SCALE(70);
    _itemArray = [NSMutableArray array];

    for (int i = 0; i < array.count; i++)
    {
        NSDictionary *dic = array[i];
        if (dic == nil)
        {
            continue;
        }

        APMonitorItem *item = [[APMonitorItem alloc] initWithFrame:CGRectMake(x, y, btnW, btnH)];
        ViewRadius(item, 5);
        item.tag = i;
//        [button setBackgroundImage:[self imageWithColor:dic[@"color"]] forState:UIControlStateNormal];
//        [button setBackgroundImage:[self imageWithColor:ColorHex(0x7877A9)] forState:UIControlStateHighlighted];
        [view addSubview:item];
        [_itemArray addObject:item];
        NSString *str = dic[@"string"];
        NSString *number = dic[@"number"];
        [item.iv setImage:[UIImage imageNamed:dic[@"imageName"]]];
        if (str && str.length)
        {
            item.title.text = str;
        }
        if (number && number.length)
        {
            item.detail.text = [NSString stringWithFormat:@"%@ 台",number];
        }
        if (i == 3)
        {
            item.detail.textColor = [UIColor redColor];
        }
        
        int k = (i+1)%2;
        x = Left_Gap +  k*(btnW + Left_Gap);
        if(i >= 1)
        {
            y =H_SCALE(70) +btnH + 2*top_Gap;
        }

    }
}

-(void)setDeviceStatus
{
    NSString*total = @"0";
    NSString*erroNumber = @"0";
    NSString*online = @"0";
    NSString*offline =@"0";
    
    AppDelegate *appDelegate = kAppDelegate;
    APGroupView *vc = appDelegate.mainVC.leftView.groupView;
    if (vc && [vc isKindOfClass:[APGroupView class]])
    {
        vc.allNumber = 0;
        vc.selectedNumber = 0;
        vc.onlineNumber = 0;
        vc.errorCodeNumber = 0;
        for(APGroupNote *temp in vc.data)
        {
            if (temp.isDevice)
            {
//                if([temp.name isEqualToString:@"s4mini"])
//                {
//                    int i = 0;
//                }
                vc.allNumber++;
                if (temp.selected)
                {
                    vc.selectedNumber++;
                }
                if((temp.tcpManager && temp.tcpManager.socket.isConnected)
                       || [temp.connect isEqualToString:@"1"])
                {
                    vc.onlineNumber++;
                }
                if (temp.error_code && temp.error_code.length > 0)
                {
                    vc.errorCodeNumber++;
                }
            }
        }
        
        total = [NSString stringWithFormat:@"%d",vc.allNumber];
        offline = [NSString stringWithFormat:@"%d",vc.allNumber - vc.onlineNumber];;
        erroNumber = [NSString stringWithFormat:@"%d",vc.errorCodeNumber];
        online = [NSString stringWithFormat:@"%d",vc.onlineNumber];
        
        for (APMonitorItem *item in _itemArray)
        {
            NSString *number = @"";
            if(item.tag == 0)
            {
                number = total;
            }
            else if (item.tag == 1)
            {
                number = online;
            }
            else if (item.tag == 2)
            {
                number = offline;
            }
            else if (item.tag == 3)
            {
                number = erroNumber;
            }
            
            item.detail.text = [NSString stringWithFormat:@"%@ 台",number];

        }
    }
}

-(void)sendMessage:(NSString *)command
{
    int i = 0;
    for (APGroupNote *node in _data)
    {
        NSData * sendData = node.commandDict[command];
        if (sendData == nil)
            continue;
        
        if ([@"tcp" compare:node.access_protocol options:NSCaseInsensitiveSearch |NSNumericSearch] ==NSOrderedSame)
        {
            NSLog(@"%@,ip=%@,port=%@,发送数据：%@",node.access_protocol,node.ip,node.port,sendData);
//            NSString *sss = [[NSString alloc] initWithData:sendData encoding:NSUTF8StringEncoding];

            APTcpSocket *tcpManager;
            if (node.tcpManager == nil)
            {
                node.tcpManager = [APTcpSocket new];

            }
            node.tcpManager.senddata = sendData;
            
            node.tcpManager.ip = node.ip;
            node.tcpManager.port = node.port.intValue;
            [node.tcpManager connectToHost];
//            [node.tcpManager connectToHost:node.ip Port:[node.port intValue]];
            
//            WS(weakSelf);
//            [node.tcpManager setSocketMessageBlock:^(NSString * _Nonnull message) {
//                   if(message && [message localizedStandardContainsString:@"ok"])
//                   {
//
//                       AppDelegate *appDelegate = kAppDelegate;
//                       APViewController *vc = appDelegate.mainVC;
//                       if (vc && vc.centerView && vc.centerView.installView && vc.centerView.installView.sceneView)
//                       {
//                           NSArray *array = vc.centerView.installView.sortData.count > 0?vc.centerView.installView.sortData[vc.centerView.installView.selectedModelTag] : [NSArray array];
//                           [vc.centerView.installView.sceneView setDefaultValue:array];
//                       }
//                   }
//            }];
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
        i++;
    }
}

#pragma mark button回调

-(void)btnTestClick:(UIButton *)btn
{
//    [self getSelectedDev];
    
    if(_data.count == 0)
    {
        NSString *t= @"提示";
        NSString *m= @"没有选中任何设备";
        UIAlertController  *alert = [UIAlertController alertControllerWithTitle:t message:m preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action2= [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                }];

        
        //修改title
//        [[APTool shareInstance] setAlterviewTitleWith:alert title:t color:[UIColor blackColor]];
//        [[APTool shareInstance] setAlterviewMessageWith:alert message:m color:[UIColor blackColor]];
//        [[APTool shareInstance] setAlterviewBackgroundColor:alert color:[UIColor whiteColor]];
//        ViewRadius(alert, 5);

        [alert addAction:action2];
        AppDelegate *appDelegate = kAppDelegate;
        UIViewController *vc = appDelegate.mainVC;
        [vc presentViewController:alert animated:YES completion:nil];
    }
    
    if(btn)
    {
        switch (btn.tag) {
            case 0://关
            {
                [self sendMessage:Command_guan];
            }
                break;
            case 1://网络
            {
                [self sendMessage:Command_wangge];
            }
                break;
            case 2://红
            {
                [self sendMessage:Command_hong];
            }
                break;
                
            case 3://绿
            {
                [self sendMessage:Command_lv];
            }
                break;
            case 4://蓝
            {
                [self sendMessage:Command_lan];
            }
                break;
            case 5://白
            {
                [self sendMessage:Command_bai];
            }
                break;
            case 6://黑
            {
                [self sendMessage:Command_hei];
            }
                break;
                
            default:
                break;
        }
    }
}


-(void)btnSwithClick:(UIButton *)btn
{
//    [self getSelectedDev];

    if(_data.count == 0)
    {
        NSString *t= @"提示";
        NSString *m= @"没有选中任何设备";
        UIAlertController  *alert = [UIAlertController alertControllerWithTitle:t message:m preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action2= [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                }];
//        ViewRadius(alert, 5);

        [alert addAction:action2];
        //修改title
//        [[APTool shareInstance] setAlterviewTitleWith:alert title:t color:[UIColor blackColor]];
//        [[APTool shareInstance] setAlterviewMessageWith:alert message:m color:[UIColor blackColor]];
//        [[APTool shareInstance] setAlterviewBackgroundColor:alert color:[UIColor whiteColor]];
        
        AppDelegate *appDelegate = kAppDelegate;
        UIViewController *vc = appDelegate.mainVC;
        [vc presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    if(btn)
    {
        switch (btn.tag) {
            case 0://按钮“开机”
            {
                [self sendMessage:Command_kaiji];
            }
                break;
            case 1://按钮“关机”
            {
                [self sendMessage:Command_guanji];
            }
                break;
            case 2://按钮“开快门”
            {
                [self sendMessage:Command_kaikuaimen];
            }
                break;
                
            case 3://按钮“关快门”
            {
                [self sendMessage:Command_guankuaimen];
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)btnRefreshClick:(UIButton *)btn
{
    [self setDeviceStatus];

    if(btn)
    {
        if (btn.tag == 0)//
        {
        }
        else
        {
            
        }
    }
}
@end
