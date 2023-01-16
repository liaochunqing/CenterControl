//
//  APMonitorView.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/23.
//

#import "APMonitorView.h"
#import "AppDelegate.h"

#define Monitor_getdatafromnet_clock (8)//定时秒 获取数据

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
    
//    AppDelegate *appDelegate = kAppDelegate;
//    APGroupView *vc = appDelegate.mainVC.leftView.groupView;
//    if (vc && [vc isKindOfClass:[APGroupView class]])
//    {
//        _groupView = vc;
//    }
    
    _selectedDevArr = [NSMutableArray array];

    [self createTitleView];
    [self createTableview];
    [self getSelectedDevFromLeftView];
    
    //监听设备选中的通知
    [kNotificationCenter addObserver:self selector:@selector(notifySelectedDevChanged:) name:Notification_Get_SelectedDev object:nil];
    
    WS(weakSelf);
    [self doTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:Monitor_getdatafromnet_clock repeats:YES block:^(NSTimer * _Nonnull timer)
    {
        [weakSelf doTimer];
    }];
}



-(void)doTimer
{
    if (self.selectedDevArr && self.selectedDevArr.count)
    {
        NSArray *arrIndex = self.tableview.indexPathsForVisibleRows;
        for (int i = 0; i<arrIndex.count; i++)
        {
            NSIndexPath *path = arrIndex[i];
            int row = (int)path.row;
//            NSNumber *number = [NSNumber numberWithInt:row];
                //socket连接机器获取最新信息
            [self getDataFromDevice:[NSNumber numberWithInt:row]];

//            [self performSelector:@selector(refreshCell:) withObject:number afterDelay:1];
        }
        
        [self.tableview performSelector:@selector(reloadData) withObject:nil afterDelay:1];
    }
}

-(void)refreshCell:(NSNumber *)number
{
    int row = [number intValue];
    WS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(weakSelf.selectedDevArr  && weakSelf.selectedDevArr.count > row)
        {
//            [weakSelf.tableview reloadData];
            // UI更新代码
             NSArray *rowArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]];
             [weakSelf.tableview reloadRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationNone];
             
        }
    });
}


-(void)createTableview
{
    _tableview  = [[UITableView alloc] init];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.backgroundColor = ColorHex(0x1D2242);
    _tableview.separatorStyle = NO;

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
    cuo.text = @"报错码";
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
-(void)getDataFromDevice:(NSNumber*)number
{
    int row = [number intValue];
    if(self.selectedDevArr == nil || self.selectedDevArr.count <= row) return;
    APGroupNote *node = self.selectedDevArr[row];

//    WS(weakSelf);
    if ([@"tcp" compare:node.access_protocol options:NSCaseInsensitiveSearch |NSNumericSearch] ==NSOrderedSame)
    {
        int i = 0;
        for (NSString * key in node.monitorDict)
        {
            i++;
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:number, @"number", key, @"key", nil];
            [self performSelector:@selector(tcpSendAndRecive:) withObject:dict afterDelay:0.2*i];
        }
    }
    else if ([@"udp" compare:node.access_protocol options:NSCaseInsensitiveSearch |NSNumericSearch] ==NSOrderedSame)
    {
//        _udpManager = [APUdpSocket sharedInstance];
//        _udpManager.host = node.ip;
//        _udpManager.port = [node.port intValue];
        if (node.udpManager == nil)
        {
            node.udpManager = [APUdpSocket new];
        }
        node.udpManager.host = node.ip;//@"255.255.255.255";
        node.udpManager.port = [node.port intValue];
        
        for (NSString * key in node.monitorDict)
        {
            NSData* udpdata = node.monitorDict[key];
//            [_udpManager createClientUdpSocket];
//            [_udpManager sendMessage:udpdata];
            [node.udpManager createClientUdpSocket];
            [node.udpManager sendMessage:udpdata];

            [_udpManager setDidDisconnectBlock:^(NSString * _Nonnull message) {
                node.connect = @"2";
            }];
            
            [_udpManager setSocketMessageBlock:^(id message) {
                   if(message)
                   {
                       NSData* data = (NSData*)message;
                       Byte *testByte = (Byte *)[data bytes];
                       Byte bt4 = testByte[4];
                       Byte bt5 = testByte[5];

                       //网络已经连接
                       node.connect = @"1";
                       
                       if(bt4 == 0x25 && bt5 == 0x00)//电源开关
                       {
                           node.supply_status = @"1";
                       }
                       else if(bt4 == 0x37)//环境温度
                       {
                           Byte bt = testByte[10];
                           //16进制转10进制
                           NSString* str = [NSString stringWithFormat:@"%x", bt];
                           int uint_ch = (int)strtoul([str UTF8String], 0, 16);

                           node.temperature = [NSString stringWithFormat:@"%d",uint_ch];
                       }
                   }
            }];
        }
    }
}

-(void)tcpSendAndRecive:(NSDictionary *)dict
{
    if (dict == nil) return;
    NSNumber *number = dict[@"number"];
    NSString *key = dict[@"key"];
    int row = [number intValue];
    if(self.selectedDevArr == nil || self.selectedDevArr.count <= row) return;
    APGroupNote *node = self.selectedDevArr[row];

    if (node.tcpManager == nil)
    {
        node.tcpManager = [APTcpSocket new];
    }
    node.tcpManager.senddata = node.monitorDict[key];//[NSData dataWithData:tcpdata];
    node.tcpManager.ip = node.ip;
    node.tcpManager.port = node.port.intValue;
    [node.tcpManager connectToHost];
    
    //    NSString *sss = [[NSString alloc] initWithData:tcpdata encoding:NSUTF8StringEncoding];
    //    NSLog(@"monitorview发送数据：%@",sss);
    //    if ([sss isEqualToString:@"AT+SignalChannel=\r\n"])
    //    {
    //        return;
    //    }
    
    WS(weakSelf);
    //连接失败
    [node.tcpManager setDidDisconnectBlock:^(NSString * _Nonnull message) {
        if(weakSelf.selectedDevArr && weakSelf.selectedDevArr.count > row)
        {
            //重置
//            APGroupNote *node = weakSelf.selectedDevArr[row];
            
            if (node)
            {
                node.connect = @"2";
                node.supply_status = @"2";
                node.shutter_status = @"2";
                
                NSString *message = [NSString stringWithFormat:@"tcp ip = %@ ：连接失败\n",node.ip];
                NSLog(@"%@",message);
            }
        }
    }];
    
    //连接成功
    [node.tcpManager setDidConnectedBlock:^(NSString * _Nonnull message) {
        if(weakSelf.selectedDevArr && weakSelf.selectedDevArr.count > row)
        {
            //重置
            APGroupNote *node = weakSelf.selectedDevArr[row];
            //网络已经连接
            node.connect = @"1";
            node.supply_status = @"1";
        }
    }];
    
    [node.tcpManager setSocketMessageBlock:^(NSString * _Nonnull message) {
           if(message)
           {
               if(weakSelf.selectedDevArr == nil || weakSelf.selectedDevArr.count <= row) return;

               APGroupNote *tempNode = weakSelf.selectedDevArr[row];
               tempNode.connect = @"1";
               NSLog(@"3 == %@", [NSThread currentThread]);

               NSArray *temparray = [message componentsSeparatedByString:@"\r\n"];
               for (NSString *string in temparray)
               {
                   if (string.length == 0) continue;
                   NSArray *arr = [string componentsSeparatedByString:@"#"];
                   NSString *firstStr = [arr firstObject];
                   NSString *lastStr = [arr lastObject];
                   NSLog(@"ip = %@(%@)收到数据:\n%@",tempNode.ip,tempNode.name,message);

                   if([@"AT+System" isEqualToString:firstStr])//电源开关机
                   {
                       //on是开机 off待机 其他关机
                       if([lastStr containsString:@"On"])
                       {
                           tempNode.supply_status = @"1";
                       }
                       else if ([lastStr containsString:@"Off"])
                       {
                           tempNode.supply_status = @"0";
                       }
                       else
                       {
                           tempNode.supply_status = @"2";
                       }
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
                   else if([@"AT+deviceInfo" isEqualToString:firstStr])//S
                   {
                       //devid
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
                               break;
                           }
                       }
                       
                       //温度
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
                               break;
                           }
                       }
                       
                       //整机运行时间
                       pattern=@"(runtime:)[^,]*()?";
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
                               tempNode.machine_running_time = [tempArr lastObject];
                               break;
                           }
                       }
                       
                       //快门状态
                       pattern=@"(lightsource:)[^,]*()?";
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
                               NSString *lastStr = [tempArr lastObject];
                               tempNode.shutter_status = [lastStr containsString:@"On"]?@"1":@"2";

                               break;
                           }
                       }
                       
                       //电源状态
                       pattern=@"(system:)[^,]*()?";
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
                               NSString *lastStr = [tempArr lastObject];
                               tempNode.supply_status = [lastStr containsString:@"On"]?@"1":@"2";

                               break;
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

               }
           }
    }];
}

-(void)getSelectedDevFromLeftView
{
    AppDelegate *appDelegate = kAppDelegate;
    APGroupView *vc = appDelegate.mainVC.leftView.groupView;
    if (vc && [vc isKindOfClass:[APGroupView class]])
    {
        NSArray *temp = [vc getSelectedDevice];
        if (!temp) return;
        
        if (_selectedDevArr && _selectedDevArr.count)
        {
            [_selectedDevArr removeAllObjects];
        }
        else
        {
            _selectedDevArr = [NSMutableArray array];
        }
        _selectedDevArr = [NSMutableArray arrayWithArray:temp];

        if (_selectedDevArr)
        {
            [self refreshTitle];
            if (_tableview)
                [ _tableview reloadData];
        }
    }
}

-(void)getAllDevFromLeftView
{
    AppDelegate *appDelegate = kAppDelegate;
    APGroupView *vc = appDelegate.mainVC.leftView.groupView;
    if (vc && [vc isKindOfClass:[APGroupView class]])
    {
        NSArray *temp = [vc getAllDevice];
        if (!temp) return;
        
        if (_allDevArr && _allDevArr.count)
        {
            [_allDevArr removeAllObjects];
        }
        else
        {
            _allDevArr = [NSMutableArray array];
        }
        _allDevArr = [NSMutableArray arrayWithArray:temp];

    }
}

-(void)refreshTitle
{
    if(_selectedDevArr)
    {
        _titleLab.text = [NSString stringWithFormat:@"设备监测(%d)", (int)_selectedDevArr.count];
    }
}


-(void)notifySelectedDevChanged:(NSNotification *)notification
{
    NSArray *arr = notification.userInfo[@"array"];
    if (!arr) return;
    
    if (_selectedDevArr && _selectedDevArr.count)
    {
        [_selectedDevArr removeAllObjects];
    }
    else
    {
        _selectedDevArr =[NSMutableArray array];
    }
    _selectedDevArr = [NSMutableArray arrayWithArray:arr];

    if (_selectedDevArr)
    {
        [_tableview reloadData];
        [self refreshTitle];
    }
}

#pragma mark *** UITableViewDelegate/UITableViewDataSource ***
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selectedDevArr.count;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *NODE_CELL_ID = @"node_cell_id";

    APMonitorCell *cell = [tableView dequeueReusableCellWithIdentifier:NODE_CELL_ID];
    if (!cell) {
        cell = [[APMonitorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NODE_CELL_ID];
    }
    
    APGroupNote *node;
//    int row = (int)indexPath.row;
    node = [_selectedDevArr objectAtIndex:indexPath.row];
    
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
