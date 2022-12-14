//
//  APMonitorView.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/23.
//

#import "APMonitorView.h"
#import "AppDelegate.h"

#define Monitor_getdatafromnet_clock (5)//定时秒 获取数据

@implementation APMonitorView
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
    CGFloat h = SCREEN_HEIGHT - y - top_Gap;
    
    [self setFrame:CGRectMake(x, y, w, h)];
    self.backgroundColor = ColorHex(0x161635);
    _data = [NSMutableArray array];

    [self createTitleView];
    [self createTableview];
    [self getDataFromLeftView];
    
    //监听设备选中的通知
    [kNotificationCenter addObserver:self selector:@selector(notifySelectedDevChanged:) name:Notification_Get_SelectedDev object:nil];
    
    WS(weakSelf);
    _timer = [NSTimer scheduledTimerWithTimeInterval:Monitor_getdatafromnet_clock repeats:YES block:^(NSTimer * _Nonnull timer)
    {
        if (weakSelf.data && weakSelf.data.count)
        {
            NSArray *arrIndex = weakSelf.tableview.indexPathsForVisibleRows;
            for (int i = 0; i<arrIndex.count; i++)
            {
                NSIndexPath *path = arrIndex[i];
                int row = (int)path.row;
                APGroupNote *node = weakSelf.data[row];
                //socket连接机器获取最新信息
                [weakSelf getDataFromNetwork:node row:row];
            }
        }
    }];

}


-(void)createTableview
{
    _tableview  = [[UITableView alloc] init];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.backgroundColor = ColorHex(0x1D2242);
    ViewRadius(_tableview, 10);

    [self addSubview:_tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(Left_Gap *2 + H_SCALE(45));
        make.left.mas_equalTo(self.mas_left).offset(Left_Gap);
        make.right.mas_equalTo(self.mas_right).offset(-Left_Gap);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
}

//标题 ：设备监测，展厅名称，报错码
-(void)createTitleView
{
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
//    ViewRadius(view, 10);
//    view.backgroundColor = [UIColor redColor];
//    self.testBaseView = view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(Left_Gap);
        make.top.mas_equalTo(self.mas_top).offset(top_Gap);
        make.right.mas_equalTo(self.mas_right).offset(-Left_Gap);
        make.height.mas_equalTo(H_SCALE(45));
    }];
    
    UILabel *lab = [[UILabel alloc] init];
    _titleLab = lab;
    [view addSubview:lab];
    lab.text = @"设备监测(0)";
    lab.font = [UIFont systemFontOfSize:20];
    lab.textColor = [UIColor whiteColor];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).offset(0);
        make.top.mas_equalTo(view.mas_top).offset(0);
        make.width.mas_equalTo(W_SCALE(290));
        make.bottom.mas_equalTo(view.mas_bottom).offset(0);
    }];
    

    UILabel *zhan = [[UILabel alloc] init];
    [view addSubview:zhan];
    zhan.text = @"展厅名称";
    zhan.font = [UIFont systemFontOfSize:16];
    zhan.textColor = ColorHex(0xABBDD5);
    [zhan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).offset(W_SCALE(618));
        make.top.mas_equalTo(view.mas_top).offset(0);
        make.width.mas_equalTo(W_SCALE(75));
        make.bottom.mas_equalTo(view.mas_bottom).offset(0);
    }];
    
    UIImageView *sort = [[UIImageView alloc] init];
    sort.image = [UIImage imageNamed:@"sort"];
        [view addSubview:sort];
        [sort mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view);
            make.left.mas_equalTo(zhan.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(W_SCALE(10), H_SCALE(12)));
    
        }];
    
    UILabel *cuo = [[UILabel alloc] init];
    [view addSubview:cuo];
    cuo.text = @"错误码";
    cuo.font = [UIFont systemFontOfSize:16];
    cuo.textColor = ColorHex(0xABBDD5);
    [cuo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).offset(W_SCALE(768));
        make.top.mas_equalTo(view.mas_top).offset(0);
        make.width.mas_equalTo(W_SCALE(56));
        make.bottom.mas_equalTo(view.mas_bottom).offset(0);
    }];
    
    sort = [[UIImageView alloc] init];
    sort.image = [UIImage imageNamed:@"sort"];
        [view addSubview:sort];
        [sort mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view);
            make.left.mas_equalTo(cuo.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(W_SCALE(10), H_SCALE(12)));
    
        }];
}

#pragma mark 方法
-(void)getDataFromNetwork:(APGroupNote *)node row:(int)row
{
    if ([@"tcp" compare:node.access_protocol options:NSCaseInsensitiveSearch |NSNumericSearch] ==NSOrderedSame)
    {
//        NSData * sendData = node.monitorDict[Monitor_device_info];
        int i = 0;
        for (NSString * key in node.monitorDict)
        {
            i++;
            NSData* tcpdata = node.monitorDict[key];
            
            _tcpManager = [APTcpSocket shareManager];
            [_tcpManager connectToHost:node.ip Port:[node.port intValue]];
//            [_tcpManager sendData:tcpdata];
            [_tcpManager performSelector:@selector(sendData:) withObject:tcpdata afterDelay:0.2*i];
            WS(weakSelf);
    //
    //            NSString *lll = @"appp#system: On, lightsource: Off,runtime: 180.5 H, temperature: 26, NtcCw1: 31, NtcBlueLaser1: 30, NtcBlueLaser2: 30, NtcDmd1: 18, NtcPowerSupply: 26, productinfo: modelname: L7, brandName: APPO, machinesn: SP002148000038";
            
            [_tcpManager setSocketMessageBlock:^(NSString * _Nonnull message) {
                   if(message)
                   {
                       NSArray *arr = [message componentsSeparatedByString:@"#"];
                       NSString *firstStr = [arr firstObject];
                       NSString *lastStr = [arr lastObject];
                       APGroupNote *tempNode = weakSelf.data[row];

                       if([@"AT+System" isEqualToString:firstStr])//电源开关机
                       {
                           tempNode.supply_status = [lastStr containsString:@"On"]?@"1":@"2";
                       }
                       else if([@"AT+LightSource" isEqualToString:firstStr])//光源（快门）开关
                       {
                           tempNode.shutter_status = [lastStr containsString:@"On"]?@"1":@"2";
                       }
                       else if([@"AT+LightSourceTime" isEqualToString:firstStr])//光源（快门）运行时间
                       {
                           arr = [lastStr componentsSeparatedByString:@"\r"];
                           tempNode.light_running_time = arr?arr[0]:lastStr;
                       }
                       else if([@"AT+RunTime" isEqualToString:firstStr])//整机运行时间
                       {
                           arr = [lastStr componentsSeparatedByString:@"\r"];
                           tempNode.machine_running_time = arr?arr[0]:lastStr;;
                       }
                       else if([@"AT+SignalChannel" isEqualToString:firstStr])//信源
                       {
                           arr = [lastStr componentsSeparatedByString:@"\r"];
                           tempNode.signals = arr?arr[0]:lastStr;;
                       }
                       else if([@"AT+Temperature" isEqualToString:firstStr])//温度
                       {
                           for (NSString *temp in [lastStr componentsSeparatedByString:@","])
                           {
                               NSArray *tempArr = [temp componentsSeparatedByString:@":"];
                               NSString *first = [[tempArr firstObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                               NSString *last = [[tempArr lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

                               if ([@"NtcEnv" compare:first options:NSCaseInsensitiveSearch] ==NSOrderedSame)
                               {
                                   tempNode.temperature = last;
                                   break;
                               }
                           }
                       }
                       else if([@"AT+deviceInfo" isEqualToString:firstStr])//S4整机信息
                       {
                           NSString* pattern=@"MachineSn:([^,]*()?)";

                           NSRegularExpression *regex = [NSRegularExpression
                                                             regularExpressionWithPattern:pattern
                                                             options:NSRegularExpressionCaseInsensitive error:nil];


                           NSArray *match = [regex matchesInString:message options:0 range:NSMakeRange(0, message.length)];
                           
                           for (NSTextCheckingResult* b in match)
                           {
                               NSRange resultRange = [b rangeAtIndex:0];
                               //从urlString当中截取数据
                               NSString *result=[message substringWithRange:resultRange];
                               if (result)
                               {
                                   NSArray *tempArr = [result componentsSeparatedByString:@":"];
                                   tempNode.device_id = [tempArr lastObject];
                               }
                           }
                           
                           pattern=@"(NtcEnv1:)[^,]*()?";

                           regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];

                           match = [regex matchesInString:message options:0 range:NSMakeRange(0, message.length)];
                           
                           for (NSTextCheckingResult* b in match)
                           {
                               NSRange resultRange = [b rangeAtIndex:0];
                               //从urlString当中截取数据
                               NSString *result=[message substringWithRange:resultRange];
                               if (result)
                               {
                                   NSArray *tempArr = [result componentsSeparatedByString:@":"];
                                   tempNode.temperature = [tempArr lastObject];
                               }
                           }
                       }
                       else if([@"appp" isEqualToString:firstStr])//s4mini整机信息
                       {
                           for (NSString *temp in [lastStr componentsSeparatedByString:@","])
                           {
                               NSArray *tempArr = [temp componentsSeparatedByString:@":"];
                               NSString *first = [[tempArr firstObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                               NSString *last = [[tempArr lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

                               if ([@"system" compare:first options:NSCaseInsensitiveSearch] ==NSOrderedSame)
                               {
                                   tempNode.supply_status = [@"on" compare:last options:NSCaseInsensitiveSearch] ==NSOrderedSame?@"1":@"2";
                               }
                               else if ([@"lightsource" compare:first options:NSCaseInsensitiveSearch] ==NSOrderedSame)
                               {
                                   tempNode.shutter_status = [@"on" compare:last options:NSCaseInsensitiveSearch] ==NSOrderedSame?@"1":@"2";
                               }
                               else if ([@"temperature" compare:first options:NSCaseInsensitiveSearch] ==NSOrderedSame)
                               {
                                   tempNode.temperature = last;
                               }
                               else if ([@"runtime" compare:first options:NSCaseInsensitiveSearch] ==NSOrderedSame)
                               {
                                   tempNode.machine_running_time = last;
                               }
                           }
                       }
                       
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                          // UI更新代码
                           NSArray *rowArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]];
                           [weakSelf.tableview reloadRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationFade];
                       });
                   }
            }];
        }
    }
    else if ([@"udp" compare:node.access_protocol options:NSCaseInsensitiveSearch |NSNumericSearch] ==NSOrderedSame)
    {
        _udpManager = [APUdpSocket sharedInstance];
        _udpManager.host = node.ip;
        _udpManager.port = [node.port intValue];
        for (NSString * key in node.monitorDict)
        {
            NSData* udpdata = node.monitorDict[key];
            [_udpManager createClientUdpSocket];
            [_udpManager sendMessage:udpdata];
            
            WS(weakSelf);

            [_udpManager setSocketMessageBlock:^(id message) {
                   if(message)
                   {
                       NSData* data = (NSData*)message;
                       Byte *testByte = (Byte *)[data bytes];
                       Byte bt4 = testByte[4];
                       Byte bt5 = testByte[5];

                       APGroupNote *tempNode = weakSelf.data[row];

                       if(bt4 == 0x25 && bt5 == 0x00)//电源开关
                       {
                           tempNode.supply_status = @"1";
                       }
                       else if(bt4 == 0x37)//环境温度
                       {
                           Byte bt = testByte[10];
                           //16进制转10进制
                           NSString* str = [NSString stringWithFormat:@"%x", bt];
                           int uint_ch = (int)strtoul([str UTF8String], 0, 16);

                           tempNode.temperature = [NSString stringWithFormat:@"%d",uint_ch];
                       }
                       dispatch_async(dispatch_get_main_queue(), ^{
                          // UI更新代码
                           NSArray *rowArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]];
                           [weakSelf.tableview reloadRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationFade];
                       });
                   }
            }];
        }
    }
}

-(void)getDataFromLeftView
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

        if (_data)
        {
            [self refreshTitle];
            if (_tableview)
                [ _tableview reloadData];
        }
    }
}

-(void)refreshTitle
{
    if(_data)
    {
        _titleLab.text = [NSString stringWithFormat:@"设备监测(%d)", (int)_data.count];
    }
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

    if (_data)
    {
        [_tableview reloadData];
        [self refreshTitle];
    }
}

#pragma mark *** UITableViewDelegate/UITableViewDataSource ***
 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _data.count;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *NODE_CELL_ID = @"node_cell_id";

    APMonitorCell *cell = [tableView dequeueReusableCellWithIdentifier:NODE_CELL_ID];
    if (!cell) {
        cell = [[APMonitorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NODE_CELL_ID];
    }
    
    APGroupNote *node;
//    int row = (int)indexPath.row;
    node = [_data objectAtIndex:indexPath.row];
    
    [cell updateCellWithData:node];
    return cell;
}

 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return H_SCALE(146);
}
 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
}


@end
