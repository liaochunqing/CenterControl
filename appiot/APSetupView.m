//
//  APSetupView.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/17.
//

#import "APSetupView.h"

@implementation APSetupView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ColorHex(0x1D2242);
        [self createBaseView];

        [self createTitleView];
        
    }
    return self;
}

-(void)initData
{
    
    _djmsDevArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"低功耗" forKey:@"LowPower"],
                             [NSDictionary dictionaryWithObject:@"联网" forKey:@"NetworkStandby"],
                             [NSDictionary dictionaryWithObject:@"REC709" forKey:@"REC709"],
                             [NSDictionary dictionaryWithObject:@"DICOM" forKey:@"DICOM"],
                             [NSDictionary dictionaryWithObject:@"低延迟" forKey:@"LowLatency"],
                             [NSDictionary dictionaryWithObject:@"自定义" forKey:@"Customize"],
                             nil];
    
    _ghbmsArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"开" forKey:@"On"],
                             [NSDictionary dictionaryWithObject:@"关" forKey:@"Off"],
                             nil];
    
    _kjszArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"手动开机" forKey:@"Manual"],
                             [NSDictionary dictionaryWithObject:@"上电自动开机" forKey:@"Auto"],
                  [NSDictionary dictionaryWithObject:@"有信号自动唤醒" forKey:@"Signal"],
                             nil];
    
    _zjdjArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"关" forKey:@"Off"],
                             [NSDictionary dictionaryWithObject:@"5分钟" forKey:@"min5"],
                             [NSDictionary dictionaryWithObject:@"10分钟" forKey:@"min10"],
                             [NSDictionary dictionaryWithObject:@"15分钟" forKey:@"min15"],
                             [NSDictionary dictionaryWithObject:@"15分钟" forKey:@"min30"],
                             nil];

    _yxmsArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"标准模式" forKey:@"Standard"],
                            [NSDictionary dictionaryWithObject:@"自定义" forKey:@"Customize"],
                             [NSDictionary dictionaryWithObject:@"ECO1" forKey:@"ECO1"],
                             [NSDictionary dictionaryWithObject:@"ECO2" forKey:@"ECO2"],
                             nil];
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
    NSDictionary *dict1 = @{@"string":@"电源设置",
                            @"frame":[NSValue valueWithCGRect:CGRectMake(Left_Gap, top_Gap , w,h)],
    };
    NSDictionary *dict2 = @{@"string":@"菜单设置",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(436), top_Gap,w,h)],
    };
    NSDictionary *dict3 = @{@"string":@"通用",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(Left_Gap, H_SCALE(459), W_SCALE(797),h)],
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

-(void)createPowerItem
{
    
    NSDictionary *dict1 = @{@"string":@"待机模式",
                            @"data":_djmsDevArray?_djmsDevArray:[NSArray array],
                            @"execcode":@"setup-standby mode",
//                            @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(507), H_SCALE(25) , w,h)],
    };
    NSDictionary *dict2 = @{@"string":@"自动待机",
                            @"data":_zjdjArray?_zjdjArray:[NSArray array],
                            @"execcode":@"setup-Automatic standby",
//                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(507), H_SCALE(25)+(h+h_gap),w,h)],
    };
    NSDictionary *dict3 = @{@"string":@"开机设置",
                            @"data":_kjszArray?_kjszArray:[NSArray array],
                            @"execcode":@"setup-power-on setting",
//                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(507), H_SCALE(25)+(h+h_gap)*2, w,h)],
    };
    NSDictionary *dict4 = @{@"string":@"高海拔模式",
                            @"data":_ghbmsArray?_ghbmsArray:[NSArray array],
                            @"execcode":@"setup-High altitude model",
//                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(507), H_SCALE(25)+(h+h_gap)*3, w,h)],
    };
    
    NSDictionary *dict5 = @{@"string":@"运行模式",
                            @"data":_yxmsArray?_yxmsArray:[NSArray array],
                            @"execcode":@"setup-running mode",
//                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(15), H_SCALE(275), w,h)],
    };
    
    NSArray *temp = [NSArray arrayWithObjects:dict1, dict2, dict3, dict4,dict5,nil];
    NSMutableArray *array = [NSMutableArray array];
    
    if (_selectedDevArray.count == 0)
    {
        array = [NSMutableArray arrayWithArray:temp];
    }
    else
    {
        APGroupNote *node = _selectedDevArray[0];
        NSArray *searchArray = [node.setupDict allKeys];
        for (NSDictionary *d in temp)
        {
            NSString *str = d[@"execcode"];
            // 将搜索的结果存放到数组中
            NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF == %@", str];
            NSArray *aa = [searchArray filteredArrayUsingPredicate:searchPredicate] ;
            if (aa && aa.count>0)
            {
                [array addObject:d];
            }
        }
    }
    
    
    
    _powerItemArray = [NSMutableArray array];
    
    UIView *baseview = [[UIView alloc] init];
    [self addSubview:baseview];
    [baseview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(W_SCALE(35)+2*top_Gap);
        make.left.mas_equalTo(self.mas_left).offset(Left_Gap);
        make.height.mas_equalTo(H_SCALE(399));
        make.width.mas_equalTo(W_SCALE(382));
    }];
    
    
    CGFloat w = W_SCALE(200);
    CGFloat h = H_SCALE(30);
//    CGFloat y = Left_Gap;
    CGFloat h_gap = H_SCALE(30);
    for (int i = 0; i < array.count; i++)
    {
        NSDictionary *dic = array[i];
        if (dic == nil) continue;
        
        NSString *str = dic[@"string"];
        __block NSArray* array = dic[@"data"]?dic[@"data"]:[NSArray array];
                
        APChooseItem *item = [[APChooseItem alloc] init];
        [baseview addSubview:item];
        [_powerItemArray addObject:item];
        item.label.text = str;
        item.tag = i;
        [item.field mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(145);
        }];
        
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(baseview.mas_top).offset(Left_Gap + (h+h_gap)*i);
            make.left.mas_equalTo(baseview.mas_left).offset(0);
            make.height.mas_equalTo(w);
            make.width.mas_equalTo(h);
        }];
        

        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            NSString *string = [dict allValues][0];
            [temp addObject:string];
        }
        [item setDefaultValue:temp];
        __block NSString *code = dic[@"execcode"];

        WS(weakSelf);
        [item setCellClickBlock:^(NSString * _Nonnull str) {
              
            for (NSDictionary *dict in array) {
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
            NSData* sendData = node.setupDict[key];
            
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
        [self createPowerItem];
    }
    else//选择设备后，需要配置数据才显示界面
    {
        APGroupNote *node = _selectedDevArray[0];
        if (node.setupDict.count != 0)
        {
            [self initData];
            [self createPowerItem];
        }
    }
}


#pragma  mark button delegate
-(void)singleTapAction
{
    if(_powerItemArray)
    {
        //消除视图
        for (APChooseItem *item in _powerItemArray) {
            [item.tableView removeFromSuperview];
            item.tableView = nil;
            item.expendIm.image = [UIImage imageNamed:@"Vector(2)"];
        }
    }
}

@end
