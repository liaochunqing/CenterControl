//
//  APColourView.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/17.
//

#import "APColourView.h"

@implementation APColourView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ColorHex(0x1D2242);
    }
    return self;
}

-(void)initData
{
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
    CGFloat x = Left_Gap;
    CGFloat w = W_SCALE(365);
    CGFloat h = H_SCALE(30);
    CGFloat h_gap = H_SCALE(28.5);

    NSDictionary *dict1 = @{@"string":LSTRING(@"红色色调"),
                            @"execcode":@"colour-red-tone",
                           @"imageName":@"Group 11715",
                            @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+10 , w,h)],
    };
    NSDictionary *dict2 = @{@"string":LSTRING(@"红色饱和度"),
                            @"execcode":@"colour-red-saturation",
                            @"imageName":@"Group 11706",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+(h+h_gap),w,h)],
    };
    NSDictionary *dict3 = @{@"string":LSTRING(@"绿色色调"),
                            @"execcode":@"colour-green-tone",
                            @"imageName":@"Group 11707",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+(h+h_gap)*2 + 10, w,h)],
    };
    NSDictionary *dict4 = @{@"string":LSTRING(@"绿色饱和度"),
                            @"execcode":@"colour-green-saturation",
                            @"imageName":@"Group 11708",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+(h+h_gap)*3, w,h)],
    };
    
    NSDictionary *dict5 = @{@"string":LSTRING(@"蓝色色调"),
                            @"execcode":@"colour-blue-tone",
                            @"imageName":@"Group 11708",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+(h+h_gap)*4+ 10, w,h)],
    };
    
    NSDictionary *dict6 = @{@"string":LSTRING(@"蓝色饱和度"),
                            @"execcode":@"colour-blue-saturation",
                            @"imageName":@"Group 11706",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+(h+h_gap)*5, w,h)],
    };
    
    NSDictionary *dict7 = @{@"string":LSTRING(@"洋红色调"),
                            @"execcode":@"colour-brightRed-tone",
                            @"imageName":@"Group 11708",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+(h+h_gap)*6+ 10, w,h)],
    };
    
    NSDictionary *dict8 = @{@"string":LSTRING(@"洋红饱和度"),
                            @"execcode":@"colour-brightRed-saturation",
                            @"imageName":@"Group 11708",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+(h+h_gap)*7, w,h)],
    };
    
    NSDictionary *dict9 = @{@"string":LSTRING(@"黄色色调"),
                            @"execcode":@"colour-yellow-tone",
                            @"imageName":@"Group 11706",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+(h+h_gap)*8+ 10, w,h)],
    };
    
    NSDictionary *dict10 = @{@"string":LSTRING(@"黄色饱和度"),
                            @"execcode":@"colour-yellow-saturation",
                            @"imageName":@"Group 11708",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+(h+h_gap)*9, w,h)],
    };
    
    
    
    
    x = W_SCALE(455);
    h_gap = H_SCALE(13.5);

    NSDictionary *dict11 = @{@"string":LSTRING(@"青色色调"),
                            @"execcode":@"colour-cyan-tone",
                            @"imageName":@"Group 11706",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25), w,h)],
    };
    
    NSDictionary *dict12 = @{@"string":LSTRING(@"青色饱和度"),
                            @"execcode":@"colour-cyan-saturation",
                            @"imageName":@"Group 11708",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+(h+h_gap)*1, w,h)],
    };
    
///////////////////////////////////////////////    //白色色调
    NSDictionary *dict13 = @{@"string":LSTRING(@"红"),
                            @"execcode":@"colour-white-tone-red",
                            @"imageName":@"Group 11708",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+(h+h_gap)*3, w,h)],
    };
    
    NSDictionary *dict14 = @{@"string":LSTRING(@"绿"),
                            @"execcode":@"colour-white-tone-green",
                            @"imageName":@"Group 11706",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+(h+h_gap)*4, w,h)],
    };
    
    NSDictionary *dict15 = @{@"string":LSTRING(@"蓝"),
                            @"execcode":@"colour-white-tone-blue",
                            @"imageName":@"Group 11708",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+(h+h_gap)*5, w,h)],
    };
//////////////////视觉增强
    CGFloat add = 14;
    NSDictionary *dict16 = @{@"string":LSTRING(@"洋红增益"),
                             @"execcode":@"colour-brightRed-gain",
                             @"imageName":@"Group 11708",
                              @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+(h+h_gap)*7 +add, w,h)],
                         };

    NSDictionary *dict17 = @{@"string":LSTRING(@"红色增益"),
                             @"execcode":@"colour-red-gain",
                             @"imageName":@"Group 11706",
                              @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+(h+h_gap)*8 +add, w,h)],
                         };

    NSDictionary *dict18 = @{@"string":LSTRING(@"绿色增益"),
                             @"execcode":@"colour-green-gain",
                             @"imageName":@"Group 11708",
                              @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+(h+h_gap)*9 +add, w,h)],
                         };
    
    NSDictionary *dict19 = @{@"string":LSTRING(@"黄色增益"),
                           @"execcode":@"colour-yellow-gain",
                           @"imageName":@"Group 11708",
                            @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+(h+h_gap)*10 +add, w,h)],
   };
   
   NSDictionary *dict20 = @{@"string":LSTRING(@"蓝色增益"),
                           @"execcode":@"colour-blue-gain",
                           @"imageName":@"Group 11706",
                            @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+(h+h_gap)*11 +add, w,h)],
   };
   
   NSDictionary *dict21 = @{@"string":LSTRING(@"青色增益"),
                           @"execcode":@"colour-rcyan-gain",
                           @"imageName":@"Group 11708",
                            @"frame":[NSValue valueWithCGRect:CGRectMake(x, H_SCALE(25)+(h+h_gap)*12 +add, w,h)],
   };
    NSArray *array = [NSArray arrayWithObjects:dict1, dict2, dict3, dict4,dict5,dict6,dict7,dict8,dict9,dict10,
                                            dict11, dict12, dict13, dict14,dict15,dict16,dict17,dict18,dict19,dict20,dict21,nil];
    for (int i = 0; i < array.count; i++)
    {
        NSDictionary *dic = array[i];
        if (dic == nil)
        {
            continue;
        }
        NSString *str = dic[@"string"];
        CGRect rect = [dic[@"frame"] CGRectValue];
        __block NSString *code = dic[@"execcode"];

        APSetNumberItem *item = [[APSetNumberItem alloc] initWithFrame:rect];
        item.label.text = str;
        item.label.font = [UIFont systemFontOfSize:13.5];
        
        if([str containsString:LSTRING(@"色调")])
        {
            item.slider.minimumValue = -100;
            item.slider.maximumValue = 99;
            item.slider.value = item.slider.minimumValue;
            item.field.text = [NSString stringWithFormat:@"%d",(int)item.slider.minimumValue];
        }
        else
        {
            item.slider.minimumValue = 0;
            item.slider.maximumValue = 199;
        }
        
        [self addSubview:item];
        
        if ([LSTRING(@"红") isEqualToString:SafeStr(str)])
        {
            UILabel *fenzuLab = [[UILabel alloc] init];
            fenzuLab.text = LSTRING(@"白色色调");
            [self addSubview:fenzuLab];
            fenzuLab.font = [UIFont systemFontOfSize:14];
            fenzuLab.textColor = ColorHex(0xA1A7C1);
            [fenzuLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(item.mas_left).offset(0);
                make.bottom.mas_equalTo(item.mas_top).offset(-7);
                make.size.mas_equalTo(CGSizeMake(100, 30));
            }];
        }
        
        if ([LSTRING(@"洋红增益") isEqualToString:SafeStr(str)])
        {
            APChooseItem *ci = [[APChooseItem alloc] init];
            [self addSubview:ci];
            ci.label.text = LSTRING(@"视觉增强");
            [ci mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(item.mas_left).offset(0);
                make.bottom.mas_equalTo(item.mas_top).offset(-13);
                make.size.mas_equalTo(CGSizeMake(W_SCALE(200), H_SCALE(30)));
            }];
        }
        
        WS(weakSelf);
        [item setChangedBlock:^(NSString * _Nonnull str) {
            [weakSelf sendDataToDevice:code value:str];
        }];
    }
}
-(void)sendDataToDevice:(NSString *)key value:(NSString *)value
{
    if (_selectedDevArray && _selectedDevArray.count)
    {
        for (APGroupNote *node in _selectedDevArray)
        {
            NSData* sendData = node.colourDict[key];
            
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
//                APTcpSocket *tcpManager;
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
        [self createBaseView];
        [self createUI];
    }
    else//选择设备后，需要配置数据才显示界面
    {
        APGroupNote *node = _selectedDevArray[0];
        if (node.imageDict.count != 0)
        {
            [self initData];
            [self createBaseView];
            [self createUI];
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

#pragma  mark button delegate
-(void)singleTapAction
{
}

@end
