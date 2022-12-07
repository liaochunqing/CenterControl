//
//  APMonitorView.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/23.
//

#import "APMonitorView.h"
#import "AppDelegate.h"

#define Monitor_getdatafromnet_clock (3)//定时秒 获取数据

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
    
    [self getDataFromLeftView];
    
    WS(weakSelf);
//    self.isFocused
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:Monitor_getdatafromnet_clock repeats:YES block:^(NSTimer * _Nonnull timer)
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
    }];

}
//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//}

//viewWillDisappear

-(void)createTableview
{
    _data = [NSMutableArray array];
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

#pragma mark 方法
-(void)getDataFromNetwork:(APGroupNote *)node row:(int)row
{
//    for (APGroupNote *node in _data)
    {
        NSData * sendData = node.monitorDict[Monitor_device_info];
        
        if ([@"tcp" compare:node.access_protocol options:NSCaseInsensitiveSearch |NSNumericSearch] ==NSOrderedSame)
        {
            _tcpManager = [APTcpSocket shareManager];
            [_tcpManager connectToHost:node.ip Port:[node.port intValue]];
            [_tcpManager sendData:sendData];
            WS(weakSelf);
//
//            NSString *lll = @"appp#system: On, lightsource: Off,runtime: 180.5 H, temperature: 26, NtcCw1: 31, NtcBlueLaser1: 30, NtcBlueLaser2: 30, NtcDmd1: 18, NtcPowerSupply: 26, productinfo: modelname: L7, brandName: APPO, machinesn: SP002148000038";
            
            [_tcpManager setSocketMessageBlock:^(NSString * _Nonnull message) {
                   if(message)
                   {
                       NSArray *arr = [message componentsSeparatedByString:@"#"];
                       NSString *str = [arr lastObject];
                       arr = [str componentsSeparatedByString:@","];
                       
                       APGroupNote *tempNode = weakSelf.data[row];
                       for (NSString *temp in arr)
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
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                          // UI更新代码
                           NSArray *rowArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]];
                           [weakSelf.tableview reloadRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationFade];
                       });
                   }
            }];
        }
        else if ([@"udp" compare:node.access_protocol options:NSCaseInsensitiveSearch |NSNumericSearch] ==NSOrderedSame)
        {
            _udpManager = [APUdpSocket sharedInstance];
            _udpManager.host = node.ip;
            _udpManager.port = [node.port intValue];
            [_udpManager createClientUdpSocket];
            [_udpManager broadcast:sendData];
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
    if(_data.count)
    {
        _titleLab.text = [NSString stringWithFormat:@"设备监测(%d)", (int)_data.count];
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
