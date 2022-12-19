//
//  APSignalView.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/19.
//

#import "APSignalView.h"

#import "APChooseItem.h"
#import "APSetNumberItem.h"

@implementation APSignalView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ColorHex(0x1D2242);
        _itemArray = [NSMutableArray array];

        [self createBaseView];
        [self createTitleView];
    }
    return self;
}


-(void)initData
{
    _xhxzArray = [NSMutableArray array];

    //1.获得数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbfileName = [doc stringByAppendingPathComponent:DB_NAME];
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:dbfileName];
    //3.打开数据库
    if ([db open])
    {
        //初始化数据容器
//        _groupData = [NSMutableArray array];
//        _modelData = [NSMutableArray array];

        // 获取安装调节界面的命令  （安装配置）install_config
        APGroupNote *node = _selectedDevArray[0];
        NSString* sqlStr = [NSString stringWithFormat:@"select l.exec_name,i.exec_code ,l.parameter_value from zk_command_mount m,zk_execlist_info i ,dev_execlist l where m.model_id=%@ and m.tab_code='signal' and  m.exec_info_id=i.id and m.dev_exec_id=l.id",node.model_id];
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while ([resultSet next])
        {
            NSString *exec_code = SafeStr([resultSet stringForColumn:@"exec_code"]);
            NSString *exec_name = SafeStr([resultSet stringForColumn:@"exec_name"]);
            NSString *parameter_value = SafeStr([resultSet stringForColumn:@"parameter_value"]);

            if ([exec_code containsString:@"signal-Source select-"])
            {
                NSDictionary *dict = [NSDictionary dictionaryWithObject:exec_name forKey:parameter_value];
                [_xhxzArray addObject:dict];
            }
        }
        //关闭数据库
        [db close];
    }

    
    _kjmrArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"记忆" forKey:@"Memory"],
                             [NSDictionary dictionaryWithObject:@"HDMI" forKey:@"HDMI:1"],
                             [NSDictionary dictionaryWithObject:@"DVI" forKey:@"DVI:1"],
                             [NSDictionary dictionaryWithObject:@"HDBaseT" forKey:@"HDBaseT:1"],
                             [NSDictionary dictionaryWithObject:@"RGB1" forKey:@"RGB1:1"],
                             [NSDictionary dictionaryWithObject:@"RGB2" forKey:@"RGB2:1"],
                                [NSDictionary dictionaryWithObject:@"Video" forKey:@"Video:1"],
                             nil];

    
    _kbpArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"黑" forKey:@"Black"],
                             [NSDictionary dictionaryWithObject:@"白" forKey:@"White"],
                            [NSDictionary dictionaryWithObject:@"红" forKey:@"Red"],
                            [NSDictionary dictionaryWithObject:@"绿" forKey:@"Green"],
                            [NSDictionary dictionaryWithObject:@"蓝" forKey:@"Blue"],
                             nil];
    

    
    _zdssArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"开" forKey:@"On"],
                                [NSDictionary dictionaryWithObject:@"关" forKey:@"Off"],
                             nil];
    /*

    _yxmsArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"标准模式" forKey:@"Standard"],
                            [NSDictionary dictionaryWithObject:@"自定义" forKey:@"Customize"],
                             [NSDictionary dictionaryWithObject:@"ECO1" forKey:@"ECO1"],
                             [NSDictionary dictionaryWithObject:@"ECO2" forKey:@"ECO2"],
                             nil];
    
    
    
    
    _languegArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"中文" forKey:@"zhongwen"],
                             [NSDictionary dictionaryWithObject:@"英文" forKey:@"english"],
                             nil];
    
    _locationArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"居中" forKey:@"Center"],
                             [NSDictionary dictionaryWithObject:@"左上" forKey:@"UperLeft"],
                      [NSDictionary dictionaryWithObject:@"右上" forKey:@"UperRight"],
                      [NSDictionary dictionaryWithObject:@"左下" forKey:@"BottomLeft"],
                      [NSDictionary dictionaryWithObject:@"右下" forKey:@"BottomRight"],
                             nil];
    
    _nosigalArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"开" forKey:@"On"],
                     [NSDictionary dictionaryWithObject:@"关" forKey:@"Off"],
                     nil];
    
    _quitArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"关" forKey:@"Off"],
                             [NSDictionary dictionaryWithObject:@"5s" forKey:@"Second5"],
                             [NSDictionary dictionaryWithObject:@"10s" forKey:@"Second10"],
                             [NSDictionary dictionaryWithObject:@"20s" forKey:@"Second15"],
                             [NSDictionary dictionaryWithObject:@"30s" forKey:@"Second30"],
                            [NSDictionary dictionaryWithObject:@"45s" forKey:@"Second45"],
                            [NSDictionary dictionaryWithObject:@"60s" forKey:@"Second60"],
                             nil];
    
    _hidenArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"显示" forKey:@"Show"],
                            [NSDictionary dictionaryWithObject:@"隐藏" forKey:@"Hide"],
                             nil];

    _muteArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"静音关" forKey:@"Off"],
                     [NSDictionary dictionaryWithObject:@"静音开" forKey:@"On"],
                     nil];
    */
}

-(void)createBaseView
{
    UIView *baseview = [[UIView alloc] init];
    [self addSubview:baseview];
    [baseview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
    }];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction)];
    [baseview addGestureRecognizer:singleTap];
}


-(void)createTitleView
{
    CGFloat w = W_SCALE(382);
    CGFloat h = H_SCALE(35);
    CGFloat y = H_SCALE(202);
    NSDictionary *dict1 = @{@"string":@"VGA设置",
                            @"frame":[NSValue valueWithCGRect:CGRectMake(Left_Gap, y , w,h)],
    };
    NSDictionary *dict2 = @{@"string":@"3D设置",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(436), y,w,h)],
    };
    NSDictionary *dict3 = @{@"string":@"HDMI设置",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(Left_Gap, H_SCALE(484), W_SCALE(797),h)],
    };
    
    NSArray *array = [NSArray arrayWithObjects:dict1, dict2, dict3,nil];
    for (int i = 0; i < array.count; i++)
    {
        NSDictionary *dic = array[i];
        if (dic == nil)
        {
            continue;
        }
        NSString *str = dic[@"string"];
        CGRect rect = [dic[@"frame"] CGRectValue];
//        __block NSString *code = dic[@"execcode"];

        UIView *view = [[UIView alloc] initWithFrame:rect];
        [self addSubview:view];
        ViewRadius(view, 5);
        view.backgroundColor = ColorHex(0x2D355C);

        UILabel *lab = [[UILabel alloc] init];
        [view addSubview:lab];
        lab.text = str;
        lab.font = [UIFont systemFontOfSize:18];
        lab.textColor = [UIColor whiteColor];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view.mas_left).offset(Left_Gap);
            make.top.mas_equalTo(view.mas_top).offset(0);
            make.bottom.mas_equalTo(view.mas_bottom).offset(0);
            make.width.mas_equalTo(150);
        }];
    }
}


-(void)createTopItem
{
    
    NSDictionary *dict1 = @{@"string":@"开机默认",
                            @"data":_kjmrArray?_kjmrArray:[NSArray array],
                            @"execcode":@"signal-TheDefaultBoot",
    };
    NSDictionary *dict2 = @{@"string":@"信号选择",
                            @"data":_xhxzArray?_xhxzArray:[NSArray array],
                            @"execcode":@"signal-Source select",
    };
    NSDictionary *dict3 = @{@"string":@"空白屏",
                            @"data":_kbpArray?_kbpArray:[NSArray array],
                            @"execcode":@"signal-A blank screen",
    };
    NSDictionary *dict4 = @{@"string":@"自动搜索",
                            @"data":_zdssArray?_zdssArray:[NSArray array],
                            @"execcode":@"signal-A search",
    };
    NSArray *temp = [NSArray arrayWithObjects:dict1, dict2, dict3, dict4,nil];
    NSMutableArray *dataArray = [NSMutableArray array];
    
    if (_selectedDevArray.count == 0)
    {
        dataArray = [NSMutableArray arrayWithArray:temp];
    }
    else
    {
        APGroupNote *node = _selectedDevArray[0];
        NSArray *searchArray = [node.signalDict allKeys];
        for (NSDictionary *d in temp)
        {
            NSString *str = d[@"execcode"];
            // 将搜索的结果存放到数组中
            NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF == %@", str];
            NSArray *aa = [searchArray filteredArrayUsingPredicate:searchPredicate] ;
            if (aa && aa.count>0)
            {
                [dataArray addObject:d];
            }
        }
    }
    
    
//    UIView *baseview = [[UIView alloc] init];
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction)];
//    [baseview addGestureRecognizer:singleTap];
//    [self addSubview:baseview];
//    [baseview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mas_top).offset(top_Gap);
//        make.left.mas_equalTo(self.mas_left).offset(Left_Gap);
//        make.height.mas_equalTo(4*W_SCALE(30)+5*top_Gap);
//        make.right.mas_equalTo(self.mas_right).offset(0);
//    }];
    
    
    CGFloat w = W_SCALE(200);
    CGFloat h = H_SCALE(30);
    CGFloat h_gap = H_SCALE(30);
    for (int i = 0; i < dataArray.count; i++)
    {
        NSDictionary *dic = dataArray[i];
        if (dic == nil) continue;
        
        NSString *str = dic[@"string"];
        __block NSArray* temparray = dic[@"data"]?dic[@"data"]:[NSArray array];
                
        APChooseItem *item = [[APChooseItem alloc] init];
        [self addSubview:item];
        [_itemArray addObject:item];
        item.label.text = str;
        item.tag = i;
        [item.field mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(145);
        }];
        
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(Left_Gap + (h+h_gap)*i);
            make.left.mas_equalTo(self.mas_left).offset(Left_Gap);
            make.height.mas_equalTo(w);
            make.width.mas_equalTo(h);
        }];
        
        if(i == 3)
        {
            [item mas_updateConstraints:^(MASConstraintMaker *make) {
                
                    make.top.mas_equalTo(self.mas_top).offset(Left_Gap);
                    make.left.mas_equalTo(self.mas_left).offset(W_SCALE(437));
            }];
            
        }
        

        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dict in temparray) {
            NSString *string = [dict allValues][0];
            [temp addObject:string];
        }
        [item setDefaultValue:temp];
        __block NSString *code = dic[@"execcode"];

        WS(weakSelf);
        [item setCellClickBlock:^(NSString * _Nonnull str) {
              
            for (NSDictionary *dict in temparray) {
                NSString *temp = [dict allValues][0];
                if ([str isEqualToString:temp])
                {
                    NSString *value = [dict allKeys][0];
                    [weakSelf sendDataToDevice:code value:value];
                    break;;
                }
            }
        }];
    }
}


-(void)sendDataToDevice:(NSString *)key value:(NSString *)value
{
    if (_selectedDevArray && _selectedDevArray.count)
    {
        for (APGroupNote *node in _selectedDevArray)
        {
            NSData* sendData = node.signalDict[key];
            
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

                APTcpSocket *tcpManager = [APTcpSocket shareManager];
                [tcpManager connectToHost:node.ip Port:[node.port intValue]];
                [tcpManager sendData:filanData];
            }
            else if ([@"udp" compare:node.access_protocol options:NSCaseInsensitiveSearch |NSNumericSearch] ==NSOrderedSame)
            {
                NSLog(@"%@,ip=%@,port=%@,发送数据：%@",node.access_protocol,node.ip,node.port,sendData);
                NSString *sss = [[NSString alloc] initWithData:sendData encoding:NSUTF8StringEncoding];

                APUdpSocket *udpManager = [APUdpSocket sharedInstance];
                udpManager.host = node.ip;//@"255.255.255.255";
                udpManager.port = [node.port intValue];
                [udpManager createClientUdpSocket];
                [udpManager sendMessage:filanData];
            }
        }
    }
}
#pragma mark 对外接口
-(void)setDefaultValue:(NSArray *)array
{
    if (array == nil)
        return;
//
    _selectedDevArray = [NSMutableArray arrayWithArray:array];
    
    if (_selectedDevArray.count == 0)//没有选设备显示界面
    {
        [self createTopItem];
//        [self createMenuItem];
//        [self createUsallyView];
    }
    else//选择设备后，需要配置数据才显示界面
    {
        APGroupNote *node = _selectedDevArray[0];
        if (node.signalDict.count != 0)
        {
            [self initData];
            [self createTopItem];
//            [self createMenuItem];
//            [self createUsallyView];
        }
    }
}


#pragma  mark button delegate
-(void)singleTapAction
{
    if(_itemArray)
    {
        //消除视图
        for (APChooseItem *item in _itemArray) {
            [item.tableView removeFromSuperview];
            item.tableView = nil;
            item.expendIm.image = [UIImage imageNamed:@"Vector(2)"];
        }
    }
}


@end
