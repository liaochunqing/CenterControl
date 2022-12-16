//
//  APImageView.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/15.
//

#import "APImageView.h"

@implementation APImageView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self createBaseView];
        [self createUI];
        [self createChooseItems];
    }
    return self;
}

-(void)initData
{
    _sceneModeArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"标准" forKey:@"Standard"],
                             [NSDictionary dictionaryWithObject:@"影院" forKey:@"Cinema"],
                             [NSDictionary dictionaryWithObject:@"REC709" forKey:@"REC709"],
                             [NSDictionary dictionaryWithObject:@"DICOM" forKey:@"DICOM"],
                             [NSDictionary dictionaryWithObject:@"低延迟" forKey:@"LowLatency"],
                             [NSDictionary dictionaryWithObject:@"自定义" forKey:@"Customize"],
                             nil];
    
    _dynamicContrastArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"开" forKey:@"On"],
                             [NSDictionary dictionaryWithObject:@"关" forKey:@"Off"],
                             nil];
    
    _contrastEnhanceArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"开" forKey:@"On"],
                             [NSDictionary dictionaryWithObject:@"关" forKey:@"Off"],
                             nil];
    
    _ImageScaleArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"本征" forKey:@"Native"],
                             [NSDictionary dictionaryWithObject:@"填充" forKey:@"Fill"],
                             [NSDictionary dictionaryWithObject:@"16_9" forKey:@"Scale16_9"],
                             [NSDictionary dictionaryWithObject:@"16_10" forKey:@"Scale16_10"],
                             [NSDictionary dictionaryWithObject:@"16_6" forKey:@"Scale16_6"],
                             [NSDictionary dictionaryWithObject:@"4_3" forKey:@"Scale4_3"],
                             nil];
    _gammaAdjustArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"1_0" forKey:@"1_0"],
                             [NSDictionary dictionaryWithObject:@"1.8" forKey:@"1.8"],
                             [NSDictionary dictionaryWithObject:@"2_0" forKey:@"2_0"],
                             [NSDictionary dictionaryWithObject:@"2_2" forKey:@"2_2"],
                             [NSDictionary dictionaryWithObject:@"2_6" forKey:@"2_6"],
                             nil];

    _colorAdjustingArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"标准" forKey:@"Standard"],
                            [NSDictionary dictionaryWithObject:@"自定义" forKey:@"Customize"],
                             [NSDictionary dictionaryWithObject:@"暖色" forKey:@"Warm"],
                             [NSDictionary dictionaryWithObject:@"冷色" forKey:@"Cool"],
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


-(void)createUI
{
    CGFloat w = W_SCALE(385);
    CGFloat h = H_SCALE(30);
    CGFloat h_gap = H_SCALE(30);

    NSDictionary *dict1 = @{@"string":@"亮度",
                           @"imageName":@"Group 11715",
                            @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(15), H_SCALE(25) , w,h)],
    };
    NSDictionary *dict2 = @{@"string":@"对比度",
                            @"imageName":@"Group 11706",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(15), H_SCALE(25)+(h+h_gap),w,h)],
    };
    NSDictionary *dict3 = @{@"string":@"饱和度",
                            @"imageName":@"Group 11707",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(15), H_SCALE(25)+(h+h_gap)*2, w,h)],
    };
    NSDictionary *dict4 = @{@"string":@"锐度",
                            @"imageName":@"Group 11708",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(15), H_SCALE(25)+(h+h_gap)*3, w,h)],
    };
    
    NSDictionary *dict5 = @{@"string":@"红色增益",
                            @"imageName":@"Group 11708",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(15), H_SCALE(395), w,h)],
    };
    
    NSDictionary *dict6 = @{@"string":@"绿色增益",
                            @"imageName":@"Group 11706",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(15), H_SCALE(395)+(h+h_gap), w,h)],
    };
    
    NSDictionary *dict7 = @{@"string":@"蓝色增益",
                            @"imageName":@"Group 11708",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(15), H_SCALE(395)+(h+h_gap)*2, w,h)],
    };
    
    
    NSArray *array = [NSArray arrayWithObjects:dict1, dict2, dict3, dict4,dict5,dict6,dict7,nil];
    for (int i = 0; i < array.count; i++)
    {
        NSDictionary *dic = array[i];
        if (dic == nil)
        {
            continue;
        }
        NSString *str = dic[@"string"];
//        NSString *imgStr = dic[@"imageName"];
        CGRect rect = [dic[@"frame"] CGRectValue];
        
        APSetNumberItem *item = [[APSetNumberItem alloc] initWithFrame:rect];
        item.label.text = str;
        
//        ViewRadius(button, 3);
//        [button setBackgroundImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
//        button.tag = i;
//        [button addTarget:self action:@selector(btnDirectionClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
    }
}

-(void)createChooseItems
{
    CGFloat w = W_SCALE(200);
    CGFloat h = H_SCALE(30);
    CGFloat h_gap = H_SCALE(30);
    
    NSDictionary *dict1 = @{@"string":@"场景模式",
                           @"data":_sceneModeArray,
                            @"execcode":@"image-scene mode",
                            @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(507), H_SCALE(25) , w,h)],
    };
    NSDictionary *dict2 = @{@"string":@"动态对比度",
                            @"data":_dynamicContrastArray,
                            @"execcode":@"image-Dynamic contrast",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(507), H_SCALE(25)+(h+h_gap),w,h)],
    };
    NSDictionary *dict3 = @{@"string":@"对比度增强",
                            @"data":_contrastEnhanceArray,
                            @"execcode":@"image-contrastEnhance",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(507), H_SCALE(25)+(h+h_gap)*2, w,h)],
    };
    NSDictionary *dict4 = @{@"string":@"画面比例",
                            @"data":_ImageScaleArray,
                            @"execcode":@"image-ImageScale",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(507), H_SCALE(25)+(h+h_gap)*3, w,h)],
    };
    
    NSDictionary *dict5 = @{@"string":@"gamma调节",
                            @"data":_gammaAdjustArray,
                            @"execcode":@"image-gammaAdjust",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(15), H_SCALE(275), w,h)],
    };
    
    NSDictionary *dict6 = @{@"string":@"色温调节",
                            @"data":_colorAdjustingArray,
                            @"execcode":@"image-colorAdjusting",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(15), H_SCALE(275)+(h+h_gap), w,h)],
    };
    
    NSArray *array = [NSArray arrayWithObjects:dict1, dict2, dict3, dict4,dict5,dict6,nil];
    _chooseItemArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++)
    {
        NSDictionary *dic = array[i];
        if (dic == nil)
        {
            continue;
        }
        NSString *str = dic[@"string"];
        __block NSArray* array = dic[@"data"];
        CGRect rect = [dic[@"frame"] CGRectValue];
                
        APChooseItem *item = [[APChooseItem alloc] initWithFrame:rect];
        [self addSubview:item];
        [_chooseItemArray addObject:item];
        item.label.text = str;
        item.tag = i;

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
            NSData* sendData = node.imageDict[key];
            
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
#pragma  mark textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

//写你要实现的：页面跳转的相关代码

    return YES;
}
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}


//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark 对外接口
-(void)setDefaultValue:(NSArray *)array
{
    if (array == nil || array.count == 0)
        return;
//
    _selectedDevArray = [NSMutableArray arrayWithArray:array];
//
//    //设置默认值
//    //1.获得数据库文件的路径
//    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *dbfileName = [doc stringByAppendingPathComponent:DB_NAME];
//    //2.获得数据库
//    FMDatabase *db = [FMDatabase databaseWithPath:dbfileName];
//    //3.打开数据库
//    if ([db open])
//    {
//        //初始化数据容器
//        _groupData = [NSMutableArray array];
//        _modelData = [NSMutableArray array];
//
//        // 获取安装调节界面的命令  （安装配置）install_config
//        APGroupNote *node = array[0];
//        NSString* sqlStr = [NSString stringWithFormat:@"select l.exec_name,i.exec_code from zk_command_mount m,zk_execlist_info i ,dev_execlist l where m.model_id=%@ and m.tab_code='install_config' and  m.exec_info_id=i.id and m.dev_exec_id=l.id",node.model_id];
//        FMResultSet *resultSet = [db executeQuery:sqlStr];
//        while ([resultSet next])
//        {
//            NSString *exec_code = SafeStr([resultSet stringForColumn:@"exec_code"]);
//            NSString *exec_name = SafeStr([resultSet stringForColumn:@"exec_name"]);
//            if ([exec_code containsString:@"ImageScale-"])
//            {
//                NSDictionary *dict = [NSDictionary dictionaryWithObject:exec_name forKey:exec_code];
//                [_groupData addObject:dict];
//            }
//            else if ([exec_code containsString:@"wayToInstall-"])
//            {
//                NSDictionary *dict = [NSDictionary dictionaryWithObject:exec_name forKey:exec_code];
//                [_modelData addObject:dict];
//            }
//        }
//        //关闭数据库
//        [db close];
//    }
//
//    if(_groupData && _groupData.count)
//    {
//        [self createScaleView];
//        NSDictionary *dict = _groupData[0];
//        _groupField.text = [dict allValues][0] ;
//    }
//    if(_modelData && _modelData.count)
//    {
//        [self createInstallTypeView];
//        NSDictionary *dict = _modelData[0];
//        _modelField.text = [dict allValues][0] ;
//    }
}
#pragma  mark button delegate
-(void)singleTapAction
{
    if(_chooseItemArray)
    {
        //消除视图
        for (APChooseItem *item in _chooseItemArray) {
            [item.tableView removeFromSuperview];
            item.tableView = nil;
            item.expendIm.image = [UIImage imageNamed:@"Vector(2)"];
        }
    }
}

@end