//
//  APSignalView.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/19.
//

#import "APSignalView.h"

#import "APChooseItem.h"
#import "APSetNumberItem.h"
#define Titleview_y H_SCALE(190)
#define Titleview_h H_SCALE(35)

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
    _xhxzArray = [NSMutableArray array];
    _moshiArray = [NSMutableArray array];
    _geshiArray = [NSMutableArray array];
    _tongbuArray = [NSMutableArray array];
    _kjmrArray= [NSMutableArray array];
    _kbpArray= [NSMutableArray array];
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
            else if ([exec_code isEqualToString:@"signal-3D mode"])//3d模式
            {
                [_moshiArray addObjectsFromArray:[self resolveValue:parameter_value]];
            }
            else if ([exec_code isEqualToString:@"signal-format"])//3d格式
            {
                [_geshiArray addObjectsFromArray:[self resolveValue:parameter_value]];
            }
            else if ([exec_code isEqualToString:@"signal-Synchronization delay adjustment"])//同步延时
            {
                [_tongbuArray addObjectsFromArray:[self resolveValue:parameter_value]];
            }
            else if ([exec_code isEqualToString:@"signal-TheDefaultBoot"])//开机默认
            {
                [_kjmrArray addObjectsFromArray:[self resolveValue:parameter_value]];
            }
            else if ([exec_code isEqualToString:@"signal-A blank screen"])//空白屏
            {
                [_kbpArray addObjectsFromArray:[self resolveValue:parameter_value]];
            }
        }
        //关闭数据库
        [db close];
    }

    
//    _kjmrArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"记忆" forKey:@"Memory"],
//                             [NSDictionary dictionaryWithObject:@"HDMI" forKey:@"HDMI:1"],
//                             [NSDictionary dictionaryWithObject:@"DVI" forKey:@"DVI:1"],
//                             [NSDictionary dictionaryWithObject:@"HDBaseT" forKey:@"HDBaseT:1"],
//                             [NSDictionary dictionaryWithObject:@"RGB1" forKey:@"RGB1:1"],
//                             [NSDictionary dictionaryWithObject:@"RGB2" forKey:@"RGB2:1"],
//                                [NSDictionary dictionaryWithObject:@"Video" forKey:@"Video:1"],
//                             nil];

    
    _kbpArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"黑" forKey:@"Black"],
                             [NSDictionary dictionaryWithObject:@"白" forKey:@"White"],
                            [NSDictionary dictionaryWithObject:@"红" forKey:@"Red"],
                            [NSDictionary dictionaryWithObject:@"绿" forKey:@"Green"],
                            [NSDictionary dictionaryWithObject:@"蓝" forKey:@"Blue"],
                             nil];
    

    
    _zdssArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"开" forKey:@"On"],
                                [NSDictionary dictionaryWithObject:@"关" forKey:@"Off"],
                             nil];

//    _moshiArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"退出3D模式" forKey:@"Off"],
//                            [NSDictionary dictionaryWithObject:@"垂直同步半分离" forKey:@"VsyncSeparatedHalf"],
//                             [NSDictionary dictionaryWithObject:@"垂直同步全分离" forKey:@"VsyncSeparatedFull"],
//                             [NSDictionary dictionaryWithObject:@"垂直半封装" forKey:@"VertPackedHalf"],
//                   [NSDictionary dictionaryWithObject:@"垂直全封装" forKey:@"VertPackedFull"],
//                    [NSDictionary dictionaryWithObject:@"水平半封装" forKey:@"HorizPackedHalf"],
//                    [NSDictionary dictionaryWithObject:@"水平全封装" forKey:@"HorizPackedFull"],
//                             nil];
    
    
    
//    _geshiArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"左右" forKey:@"LRFlip"],
//                             [NSDictionary dictionaryWithObject:@"上下" forKey:@"UDFlip"],
//                   [NSDictionary dictionaryWithObject:@"帧序列" forKey:@"FrameSeq"],
//                             nil];

//    _tongbuArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"使用外接同步" forKey:@"External"],
//                             [NSDictionary dictionaryWithObject:@"内部信号配置" forKey:@"Internal"],
//                             nil];

    _zyyfzArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"开" forKey:@"On"],
                     [NSDictionary dictionaryWithObject:@"关" forKey:@"Off"],
                     nil];
    
    _zyyysArray = [NSMutableArray array];
    
    _acsjArray = [NSMutableArray array];
    
    
    _cskjArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"自动" forKey:@"Auto"],
                             [NSDictionary dictionaryWithObject:@"RGB" forKey:@"RGB"],
                   [NSDictionary dictionaryWithObject:@"Ycbcr" forKey:@"Ycbcr"],
                             nil];

    _xhdpfwArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"自动" forKey:@"Auto"],
                             [NSDictionary dictionaryWithObject:@"0_255" forKey:@"Range0_255"],
                   [NSDictionary dictionaryWithObject:@"16_235" forKey:@"Range16_235"],
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
//    CGFloat h = H_SCALE(35);
    NSDictionary *dict1 = @{@"string":@"VGA设置",
                            @"frame":[NSValue valueWithCGRect:CGRectMake(Left_Gap, Titleview_y , w,Titleview_h)],
    };
    NSDictionary *dict2 = @{@"string":@"3D设置",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(436), Titleview_y,w,Titleview_h)],
    };
    NSDictionary *dict3 = @{@"string":@"HDMI设置",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(Left_Gap, H_SCALE(465), w,Titleview_h)],
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
        
        if(i == 3)
        {
            [item mas_updateConstraints:^(MASConstraintMaker *make) {
                
                    make.top.mas_equalTo(self.mas_top).offset(Left_Gap);
                    make.left.mas_equalTo(self.mas_left).offset(W_SCALE(454));
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
                    APGroupNote *node = weakSelf.selectedDevArray[0];
                    if ([node.model_id isEqualToString:@"88"]
                        || [node.model_id isEqualToString:@"86"]
                        || [node.model_id isEqualToString:@"46"])
                    {
                        NSString *key = [NSString stringWithFormat:@"%@-%@",code,str];
                        [weakSelf sendDataToDevice:key];
                    }
                    else
                    {
                        NSString *value = [dict allKeys][0];
                        [weakSelf sendDataToDevice:code value:value];
                    }
                    
                    [weakSelf setVGAEnable:code value:str];
                    [weakSelf enableHDMI:code value:str];
                    break;
                }
            }
        }];
    }
}

-(BOOL)enableHDMI:(NSString *)code value:(NSString *)value
{
    if ([code isEqualToString:@"signal-Source select"] )
    {
        if ( [value containsString:@"HDMI"])
        {
            [self createHDMI];
            return YES;
        }
        else
        {
            for (APRadioItem *item in _HDMIitemArray) {
                [item removeFromSuperview];
            }
        }
    }
    
    return NO;
}

-(void)setVGAEnable:(NSString *)code value:(NSString *)value
{
    if ([code isEqualToString:@"signal-Source select"] )
    {
        if ( [value containsString:@"RGB"] ||  [value containsString:@"VGA"])
        {
            for (APSetNumberItem *item in self.VGAitemArray)
            {
                item.field.enabled = YES;
                item.slider.enabled = YES;
                item.slider.thumbTintColor = [UIColor whiteColor];
            }
            
        }
        else
        {
            for (APSetNumberItem *item in self.VGAitemArray)
            {
                item.field.enabled = NO;
                item.slider.enabled = NO;
                item.slider.thumbTintColor = [UIColor grayColor];
            }
        }
    }
}


-(void)createVGA
{
//    CGFloat x = Left_Gap;
    CGFloat w = W_SCALE(365);
    CGFloat h = H_SCALE(30);
    CGFloat h_gap = H_SCALE(28.5);

    NSDictionary *dict1 = @{@"string":@"水平位置",
                            @"execcode":@"signal-vga-level",
                           @"imageName":@"Group 11715",
//                            @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+10 , w,h)],
    };
    NSDictionary *dict2 = @{@"string":@"垂直位置",
                            @"execcode":@"signal-vga-vertical",
                            @"imageName":@"Group 11706",
//                             @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+(h+h_gap),w,h)],
    };
    NSDictionary *dict3 = @{@"string":@"相位调整",
                            @"execcode":@"signal-vga-phase",
                            @"imageName":@"Group 11707",
//                             @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+(h+h_gap)*2 + 10, w,h)],
    };
    NSDictionary *dict4 = @{@"string":@"时钟调整",
                            @"execcode":@"signal-vga-clock",
                            @"imageName":@"Group 11708",
//                             @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+(h+h_gap)*3, w,h)],
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
    
    _VGAitemArray = [NSMutableArray array];
    for (int i = 0; i < dataArray.count; i++)
    {
        NSDictionary *dic = dataArray[i];
        if (dic == nil) continue;
        
        NSString *str = dic[@"string"];
//        CGRect rect = [dic[@"frame"] CGRectValue];
        __block NSString *code = dic[@"execcode"];

        APSetNumberItem *item = [[APSetNumberItem alloc] init];
        item.label.text = str;
        item.label.font = [UIFont systemFontOfSize:13.5];
        item.field.enabled = NO;
        item.slider.enabled = NO;
        item.slider.thumbTintColor = [UIColor grayColor];
        [self addSubview:item];
        [_VGAitemArray addObject:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(Titleview_y + Titleview_h + top_Gap + (h+h_gap)*i);
            make.left.mas_equalTo(self.mas_left).offset(Left_Gap);
            make.height.mas_equalTo(h);
            make.width.mas_equalTo(w);
        }];
        
        WS(weakSelf);
        [item setChangedBlock:^(NSString * _Nonnull str) {
            [weakSelf sendDataToDevice:code value:str];
        }];
    }
}

-(void)create3D
{
     
        NSDictionary *dict1 = @{@"string":@"3D模式",
                                @"data":_moshiArray?_moshiArray:[NSArray array],
                                @"execcode":@"signal-3D mode",
        };
        NSDictionary *dict2 = @{@"string":@"3D格式",
                                @"data":_geshiArray?_geshiArray:[NSArray array],
                                @"execcode":@"signal-format",
        };
        NSDictionary *dict3 = @{@"string":@"同步延迟调节",
                                @"data":_tongbuArray?_tongbuArray:[NSArray array],
                                @"execcode":@"signal-Synchronization delay adjustment",
        };
        NSDictionary *dict4 = @{@"string":@"左右眼反转",
                                @"data":_zyyfzArray?_zyyfzArray:[NSArray array],
                                @"execcode":@"signal-Left and right eye reversal",
        };
    
    NSDictionary *dict5 = @{@"string":@"左右眼延时",
                            @"data":_zyyysArray?_zyyysArray:[NSArray array],
                            @"execcode":@"",
    };
    NSDictionary *dict6 = @{@"string":@"暗场时间",
                            @"data":_acsjArray?_acsjArray:[NSArray array],
                            @"execcode":@"",
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
            if(str.length >= 6)
            {
                item.label.font = [UIFont systemFontOfSize:13];
            }
            item.tag = i;
            [item.field mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(145);
            }];
            
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.mas_equalTo(self.mas_top).offset(top_Gap + (h+h_gap)*i);
                make.top.mas_equalTo(self.mas_top).offset(Titleview_y + Titleview_h + top_Gap + (h+h_gap)*i);
                make.left.mas_equalTo(self.mas_left).offset(W_SCALE(454));
                make.height.mas_equalTo(h);
                make.width.mas_equalTo(w);
            }];
            

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


-(void)createHDMI
{
     
        NSDictionary *dict1 = @{@"string":@"彩色空间",
                                @"data":_cskjArray?_cskjArray:[NSArray array],
                                @"execcode":@"signal-hdml-color",
        };
        NSDictionary *dict2 = @{@"string":@"信号电平范围",
                                @"data":_xhdpfwArray?_xhdpfwArray:[NSArray array],
                                @"execcode":@"signal-hdml-range",
        };
    
    
        NSArray *temp = [NSArray arrayWithObjects:dict1, dict2,nil];
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
        
    
    _HDMIitemArray = [NSMutableArray array];
    
        CGFloat w = W_SCALE(200);
        CGFloat h = H_SCALE(30);
        CGFloat h_gap = H_SCALE(20);
        for (int i = 0; i < dataArray.count; i++)
        {
            NSDictionary *dic = dataArray[i];
            if (dic == nil) continue;
            
            NSString *str = dic[@"string"];
            __block NSArray* temparray = dic[@"data"]?dic[@"data"]:[NSArray array];
                    
            APRadioItem *item = [[APRadioItem alloc] init];
            
            [self addSubview:item];
            
            [_HDMIitemArray addObject:item];
//            item.label.text = str;
            if(str.length >= 6)
            {
                item.label.font = [UIFont systemFontOfSize:13];
            }
            item.tag = i;
            
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.mas_equalTo(self.mas_top).offset(top_Gap + (h+h_gap)*i);
                make.top.mas_equalTo(self.mas_top).offset(H_SCALE(465) + Titleview_h + top_Gap + (h+h_gap)*i);
                make.left.mas_equalTo(self.mas_left).offset(Left_Gap);
                make.height.mas_equalTo(h);
                make.width.mas_equalTo(w);
            }];
            

            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary *dict in temparray) {
                NSString *string = [dict allValues][0];
                [temp addObject:string];
            }
            [item setDefaultValue:temp title:str];
            __block NSString *code = dic[@"execcode"];

            WS(weakSelf);
            [item setBtnClickBlock:^(NSString * _Nonnull str) {
                  
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

-(void)sendDataToDevice:(NSString *)key
{
    if (_selectedDevArray && _selectedDevArray.count)
    {
        for (APGroupNote *node in _selectedDevArray)
        {
            NSData* sendData = node.signalDict[key];
            
            if (sendData == nil)
                continue;
            
            if ([@"tcp" compare:node.access_protocol options:NSCaseInsensitiveSearch |NSNumericSearch] ==NSOrderedSame)
            {
                NSLog(@"%@,ip=%@,port=%@,发送数据：%@",node.access_protocol,node.ip,node.port,sendData);

//                APTcpSocket *tcpManager = [APTcpSocket shareManager];
//                [tcpManager connectToHost:node.ip Port:[node.port intValue]];
//                [tcpManager sendData:filanData];
                
                APTcpSocket *tcpManager;
                if (node.tcpSocket == nil)
                {
                    tcpManager = [APTcpSocket new];
                    node.tcpSocket = tcpManager;
                }
                node.tcpSocket.senddata = [NSData dataWithData:sendData];
                node.tcpSocket.ip = node.ip;
                node.tcpSocket.port = node.port.intValue;
                [node.tcpSocket connectToHost];
            }
            else if ([@"udp" compare:node.access_protocol options:NSCaseInsensitiveSearch |NSNumericSearch] ==NSOrderedSame)
            {
                NSLog(@"%@,ip=%@,port=%@,发送数据：%@",node.access_protocol,node.ip,node.port,sendData);
                NSString *sss = [[NSString alloc] initWithData:sendData encoding:NSUTF8StringEncoding];

                APUdpSocket *udpManager = [APUdpSocket sharedInstance];
                udpManager.host = node.ip;//@"255.255.255.255";
                udpManager.port = [node.port intValue];
                [udpManager createClientUdpSocket];
                [udpManager sendMessage:sendData];
            }
        }
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

//                APTcpSocket *tcpManager = [APTcpSocket shareManager];
//                [tcpManager connectToHost:node.ip Port:[node.port intValue]];
//                [tcpManager sendData:filanData];
                
                APTcpSocket *tcpManager;
                if (node.tcpSocket == nil)
                {
                    tcpManager = [APTcpSocket new];
                    node.tcpSocket = tcpManager;
                }
                node.tcpSocket.senddata = [NSData dataWithData:filanData];
                node.tcpSocket.ip = node.ip;
                node.tcpSocket.port = node.port.intValue;
                [node.tcpSocket connectToHost];
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
        [self createVGA];
        [self create3D];
        [self createHDMI];
    }
    else//选择设备后，需要配置数据才显示界面
    {
        APGroupNote *node = _selectedDevArray[0];
        if (node.signalDict.count != 0)
        {
            [self initData];
            [self createTopItem];
            [self createVGA];
            [self create3D];
//            [self createHDMI];
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
