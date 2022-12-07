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
    
    [self createSwitchView];
    [self createTestView];
    [self createMonitorView];
    [self getSelectedDev];
}
-(void)refreshSelectedList:(NSArray *)arr
{
    if (!arr) return;
    
//    if (_data && _data.count)
//    {
//        [_data removeAllObjects];
//    }
//    else
//    {
//        _data =[NSMutableArray array];
//    }
//
//    _data = [NSMutableArray arrayWithArray:arr];
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
    };
    NSDictionary *dict2 = @{@"string":@"网格",
                           @"color":ColorHex(0x344B67),
    };
    NSDictionary *dict3 = @{@"string":@"红",
                           @"color":ColorHex(0x491B34),
    };
    NSDictionary *dict4 = @{@"string":@"绿",
                           @"color":ColorHex(0x164E34),
    };
    
    NSDictionary *dict5 = @{@"string":@"蓝",
                           @"color":ColorHex(0x1D3066),
    };
    
    NSDictionary *dict6 = @{@"string":@"白",
                           @"color":ColorHex(0x494E67),
    };
    
    NSDictionary *dict7 = @{@"string":@"黑",
                            @"color":[UIColor darkGrayColor],//ColorHex(0x493C39),
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
        [button setBackgroundImage:[self imageWithColor:ColorHex(0x7877A9)] forState:UIControlStateHighlighted];
        
//        [button setBackgroundImage:[UIImage getColorImageWithColor:dic[@"color"]] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage getColorImageWithColor:ColorHex(0x7877A9)] forState:UIControlStateHighlighted];
        [view addSubview:button];
        if (str && str.length)
        {
            [button setTitle:str forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize: 16];
        }
        
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
    
    CGFloat btnW = W_SCALE(389);
    CGFloat btnH = H_SCALE(70);
//    CGFloat midGap = 20;
    CGFloat x = Left_Gap;
    CGFloat y = H_SCALE(70);
    for (int i = 0; i < array.count; i++)
    {
        NSDictionary *dic = array[i];
        if (dic == nil)
        {
            continue;
        }

        APMonitorItem *item = [[APMonitorItem alloc] initWithFrame:CGRectMake(x, y, btnW, btnH)];
        ViewRadius(item, 5);
//        [button setBackgroundImage:[self imageWithColor:dic[@"color"]] forState:UIControlStateNormal];
//        [button setBackgroundImage:[self imageWithColor:ColorHex(0x7877A9)] forState:UIControlStateHighlighted];
        [view addSubview:item];
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

-(void)sendMessage:(NSString *)command
{
    for (APGroupNote *node in _data)
    {
        NSData * sendData = node.commandDict[command];
        
        
        if ([@"tcp" compare:node.access_protocol options:NSCaseInsensitiveSearch |NSNumericSearch] ==NSOrderedSame)
        {
            NSLog(@"%@,ip=%@,port=%@,发送数据：%@",node.access_protocol,node.ip,node.port,sendData);
            NSString *sss = [[NSString alloc] initWithData:sendData encoding:NSUTF8StringEncoding];

            APTcpSocket *tcpManager = [APTcpSocket shareManager];
            [tcpManager connectToHost:node.ip Port:[node.port intValue]];
            [tcpManager sendData:sendData];
        }
        else if ([@"udp" compare:node.access_protocol options:NSCaseInsensitiveSearch |NSNumericSearch] ==NSOrderedSame)
        {
            NSLog(@"%@,ip=%@,port=%@,发送数据：%@",node.access_protocol,node.ip,node.port,sendData);

            APUdpSocket *udpManager = [APUdpSocket sharedInstance];
            udpManager.host = node.ip;//@"255.255.255.255";
            udpManager.port = [node.port intValue];
            [udpManager createClientUdpSocket];
            [udpManager sendMessage:sendData];
        }
    }
}

#pragma mark button回调

-(void)btnTestClick:(UIButton *)btn
{
    [self getSelectedDev];
    
    if(_data.count == 0)
    {
        UIAlertController  *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有选中任何设备" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action2= [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                }];

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
    [self getSelectedDev];

    if(_data.count == 0)
    {
        UIAlertController  *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有选中任何设备" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action2= [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                }];

        [alert addAction:action2];
//        UIView* subview = alert.view.subviews.firstObject;
//        UIView*  alertContentView = subview.subviews.firstObject;
//        alertContentView.backgroundColor = [UIColor whiteColor];
        
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
    [self getSelectedDev];

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
