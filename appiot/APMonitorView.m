//
//  APMonitorView.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/23.
//

#import "APMonitorView.h"
#import "AppDelegate.h"

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
    
    [self createTitleView];
    [self createTableview];
    
    [self getData];
}

-(void)refreshTitle
{
    if(_data.count)
    {
        _titleLab.text = [NSString stringWithFormat:@"设备监测(%d)", (int)_data.count];
    }
}

-(void)getData
{
    AppDelegate *appDelegate = kAppDelegate;
    APGroupView *vc = appDelegate.mainVC.leftView.groupView;
    if (vc && [vc isKindOfClass:[APGroupView class]])
    {
        NSArray *temp = [vc getSelectedNode];
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



-(void)refreshTable:(NSArray *)arr
{
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
    
    for (APGroupNote *node in _data)
    {
//        APTcpSocket *tcpManager = [[APTcpSocket alloc] init];
//        [tcpManager connectToHost:node.ip Port:[node.port intValue]];
        
//        APTool *tool = [APTool shareInstance];
//        NSString *str  = [tool stringFromHexString:@"41542B646576696365496E666F3F0D"];
//        NSString *hex = [tool hexStringFromString:@"AT+deviceInfo?\r"];
//        NSData *data = [tool convertHexStrToData:hex];
//
//        [tcpManager sendData:data];
//        GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//        socket.delegate = self;
        GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        NSError *error = nil;
        if (![socket connectToHost:node.ip onPort:[node.port intValue] error:&error]) {
//            //该方法异步
            NSLog(@"%@",  @"连接服务器失败");
        }

    }
}
//41 54 2B 64 65 76 69 63 65 49 6E 66 6F 3F 0D
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSString *message = [NSString stringWithFormat:@"DidConnectToHost.Host:%@--Port:%hu",host,port];
    NSLog(@"%@",message);
    APTool *tool = [APTool shareInstance];
        NSString *str  = @"41542B646576696365496E666F3F0D";
    NSString *hex = [tool hexStringFromString:@"AT+deviceInfo?\r"];
    NSData *data = [tool convertHexStrToData:str];
//    NSData* xmlData = [str dataUsingEncoding:NSUTF8StringEncoding];
        [sock writeData:data withTimeout:-1 tag:1];//这里tag没用到

        [sock readDataWithTimeout:-1 tag:1];
//    [sock readDataToLength:1000 withTimeout:-1 tag:1];

}

#pragma mark 已经向服务器发送数据
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSString *message = [NSString stringWithFormat:@"DidWriteDataWithTag:%ld",tag];
    NSLog(@"%@",message);
    // 读取数据
    [sock readDataWithTimeout:-1 tag:tag];
}

#pragma mark 服务器返回数据

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *receiverStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"读取数据：%s %@",__func__,receiverStr);
}
-(void)createTableview
{
//    APMonitorModel *node1 = [APMonitorModel new];
//    APMonitorModel *node2 = [APMonitorModel new];
    APGroupNote *node3 = [APGroupNote new];
    _data = [NSMutableArray arrayWithArray:[NSArray arrayWithObjects:node3,nil]];
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
    
//    [self createTempData:data];
    
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
    zhan.textColor = [UIColor whiteColor];
    [zhan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).offset(W_SCALE(618));
        make.top.mas_equalTo(view.mas_top).offset(0);
        make.width.mas_equalTo(W_SCALE(75));
        make.bottom.mas_equalTo(view.mas_bottom).offset(0);
    }];
    
    UILabel *cuo = [[UILabel alloc] init];
    [view addSubview:cuo];
    cuo.text = @"错误码";
    cuo.font = [UIFont systemFontOfSize:16];
    cuo.textColor = [UIColor whiteColor];
    [cuo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).offset(W_SCALE(768));
        make.top.mas_equalTo(view.mas_top).offset(0);
        make.width.mas_equalTo(W_SCALE(56));
        make.bottom.mas_equalTo(view.mas_bottom).offset(0);
    }];
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
