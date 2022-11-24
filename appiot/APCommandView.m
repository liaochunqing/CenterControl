//
//  APCommandView.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/14.
//

#import "APCommandView.h"

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
    NSDictionary *dict2 = @{@"string":@"网络",
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
    
    NSDictionary *dict7 = @{@"string":@"橙",
                            @"color":ColorHex(0x493C39),
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
    CGFloat midGap = W_SCALE(20);
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
    NSDictionary *dict1 = @{@"string":@"设备总数",
                           @"number":@"77777",
                            @"imageName":@"Group 215",
    };
    NSDictionary *dict2 = @{@"string":@"在线设备数",
                           @"number":@"88888",
                            @"imageName":@"Group 216",
    };
    NSDictionary *dict3 = @{@"string":@"离线设备数",
                           @"number":@"99999",
                            @"imageName":@"Group 217",
    };
    NSDictionary *dict4 = @{@"string":@"异常设备",
                           @"number":@"23",
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

#pragma button回调

-(void)btnTestClick:(UIButton *)btn
{
    if(btn)
    {
        if (btn.tag == 0)//按钮“控制”
        {
        }
        else
        {
            
        }
    }
}

-(void)btnRefreshClick:(UIButton *)btn
{
    if(btn)
    {
        if (btn.tag == 0)//按钮“控制”
        {
        }
        else
        {
            
        }
    }
}
-(void)btnSwithClick:(UIButton *)btn
{
    if(btn)
    {
        switch (btn.tag) {
            case 0://按钮“开机”
            {
                
            }
                break;
            case 1://按钮“机型”
            {
                
            }
                break;
            case 2://按钮“开快门”
            {
                APUdpSocket *sockManager = [APUdpSocket sharedInstance];
                sockManager.host = @"255.255.255.255";
                sockManager.port = 5050;
                [sockManager createClientUdpSocket];
                NSString *m = @"AD0000002F0000000000000000000000000000DC";
                [sockManager broadcast:m];
//                [sockManager sendMessage:@"AD0000002F0000000000000000000000000000DC"];
            }
                break;
                
            case 3://按钮“关快门”
            {
                APUdpSocket *sockManager = [APUdpSocket sharedInstance];
//                sockManager.host = @"192.168.1.219";
                sockManager.port = 5050;
                [sockManager createClientUdpSocket];
                NSString *m = @"AD0000002F0100000000000000000000000000DD";
                [sockManager broadcast:m];
            }
                break;
                
            default:
                break;
        }
    }
}
@end
