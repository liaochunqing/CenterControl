//
//  APConfigView.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/20.
//

#import "APConfigView.h"

@implementation APConfigView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ColorHex(0x1D2242);
        _itemArray = [NSMutableArray array];
        
        [self createBaseView];
//        [self createUI];
    }
    return self;
}
//
//
//-(NSArray *)resolveValue:(NSString *)parameter_value
//{
//    NSMutableArray *returnArray = [NSMutableArray array];
//
//    NSString* pattern=@"(?<=,value:\"\\{)(.*?)(?=\\}\")";
//    NSRegularExpression *regex = [NSRegularExpression
//                                      regularExpressionWithPattern:pattern
//                                      options:NSRegularExpressionCaseInsensitive error:nil];
//
//
//    NSArray *match = [regex matchesInString:parameter_value options:0 range:NSMakeRange(0, parameter_value.length)];
//    for (NSTextCheckingResult* b in match)
//    {
//        NSRange resultRange = [b rangeAtIndex:0];
//        //从urlString当中截取数据
//        NSString *result=[parameter_value substringWithRange:resultRange];
//        if (result)
//        {
//            NSArray *tempArr = [result componentsSeparatedByString:@","];
//            for (NSString *str  in tempArr)
//            {
//                NSArray *tempArr = [str componentsSeparatedByString:@":"];
//                if(tempArr.count > 1)
//                {
//                    NSString *first = [tempArr firstObject];
//
//                    first = [first stringByReplacingOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [first length])];
//
//                    NSString *last = [tempArr lastObject];
//                    last = [last stringByReplacingOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [last length])];
//
//                    NSDictionary *dict = [NSDictionary dictionaryWithObject:last forKey:first];
//                    [returnArray addObject:dict];
//                }
//            }
//        }
//    }
//    return returnArray;
//}


-(void)initData
{
    _hmblArray = [NSMutableArray array];
    _azfsArray = [NSMutableArray array];
    //1.获得数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbfileName = [doc stringByAppendingPathComponent:DB_NAME];
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:dbfileName];
    //3.打开数据库
    if ([db open])
    {
        // 获取安装调节界面的命令  （安装配置）install_config
        APGroupNote *node = _selectedDevArray[0];
        NSString* sqlStr = [NSString stringWithFormat:@"select l.exec_name,i.exec_code ,l.parameter_value from zk_command_mount m,zk_execlist_info i ,dev_execlist l where m.model_id=%@ and m.tab_code='install_config' and  m.exec_info_id=i.id and m.dev_exec_id=l.id",node.model_id];
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while ([resultSet next])
        {
            NSString *exec_code = SafeStr([resultSet stringForColumn:@"exec_code"]);
//            NSString *exec_name = SafeStr([resultSet stringForColumn:@"exec_name"]);
            NSString *parameter_value = SafeStr([resultSet stringForColumn:@"parameter_value"]);

            if ([exec_code isEqualToString:@"installDeploy-ImageScale"])//3d模式
            {
                [_hmblArray addObjectsFromArray:[self resolveValue:parameter_value]];
            }
            else if ([exec_code isEqualToString:@"installDeploy-wayToInstall"])//3d格式
            {
                [_azfsArray addObjectsFromArray:[self resolveValue:parameter_value]];
            }
        }
        //关闭数据库
        [db close];
    }
    
    _tyjidArray = [NSMutableArray array];
    
    _ykidArray = [NSMutableArray array];
    
    _ykjsArray = [NSMutableArray array];
    
    _sshjArray = [NSMutableArray array];
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

-(void)createUI
{
    
    NSDictionary *dict1 = @{@"string":LSTRING(@"画面比例"),
                            @"data":_hmblArray?_hmblArray:[NSArray array],
                            @"execcode":@"installDeploy-ImageScale",
    };
    NSDictionary *dict2 = @{@"string":LSTRING(@"安装方式"),
                            @"data":_azfsArray?_azfsArray:[NSArray array],
                            @"execcode":@"installDeploy-wayToInstall",
    };
    NSDictionary *dict3 = @{@"string":LSTRING(@"投影机ID"),
                            @"data":_tyjidArray?_tyjidArray:[NSArray array],
                            @"execcode":@"installDeploy-projectorID",
    };
    NSDictionary *dict4 = @{@"string":LSTRING(@"遥控ID"),
                            @"data":_ykidArray?_ykidArray:[NSArray array],
                            @"execcode":@"installDeploy-remoteControlID",
    };
    NSDictionary *dict5 = @{@"string":LSTRING(@"遥控接收"),
                            @"data":_ykjsArray?_ykjsArray:[NSArray array],
                            @"execcode":@"installDeploy-remoteControlTakeIn",
    };
    NSDictionary *dict6 = @{@"string":LSTRING(@"三色汇聚"),
                            @"data":_sshjArray?_sshjArray:[NSArray array],
                            @"execcode":@"installDeploy-ThreeColorsTogether",
    };
    
    NSArray *temp = [NSArray arrayWithObjects:dict1, dict2, dict3, dict4,dict5, dict6,nil];
    NSMutableArray *dataArray = [NSMutableArray array];
    
    if (_selectedDevArray.count == 0)
    {
        dataArray = [NSMutableArray arrayWithArray:temp];
    }
    else
    {
        APGroupNote *node = _selectedDevArray[0];
        NSArray *searchArray = [node.installConfigDict allKeys];
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
            make.top.mas_equalTo(self.mas_top).offset(top_Gap + (h+h_gap)*i);
            make.left.mas_equalTo(self.mas_left).offset(Left_Gap);
            make.height.mas_equalTo(h);
            make.width.mas_equalTo(w);
        }];
        
//        if(i == 3)
//        {
//            [item mas_updateConstraints:^(MASConstraintMaker *make) {
//
//                    make.top.mas_equalTo(self.mas_top).offset(Left_Gap);
//                    make.left.mas_equalTo(self.mas_left).offset(W_SCALE(454));
//            }];
//
//        }
        

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
            NSData* sendData = node.installConfigDict[key];
            
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

//                APTcpSocket *tcpManager = [APTcpSocket shareManager];
//                [tcpManager connectToHost:node.ip Port:[node.port intValue]];
//                [tcpManager sendData:filanData];
                
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
                NSString *sss = [[NSString alloc] initWithData:sendData encoding:NSUTF8StringEncoding];

                if (node.udpManager == nil)
                {
                    node.udpManager = [APUdpSocket new];
                }
                node.udpManager.host = node.ip;//@"255.255.255.255";
                node.udpManager.port = [node.port intValue];
                [node.udpManager createClientUdpSocket];
                [node.udpManager sendMessage:filanData];
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
        [self createUI];
    }
    else//选择设备后，需要配置数据才显示界面
    {
        APGroupNote *node = _selectedDevArray[0];
        if (node.installConfigDict.count != 0)
        {
            [self initData];
            [self createUI];
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
