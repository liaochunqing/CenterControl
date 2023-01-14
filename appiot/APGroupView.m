//
//  APGroupView.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/16.
//

#import "APGroupView.h"
#import "APGroupNote.h"
#import "AppDelegate.h"


//CGFloat Group_Btn_W = (30);
//CGFloat Bottom_View_Height = (88);

@implementation APGroupView 

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    CGFloat x = 0;
    CGFloat y = H_SCALE(141);
    CGFloat w = Left_View_Width;
    CGFloat h = SCREEN_HEIGHT - y;

    [self setFrame:CGRectMake(x, y, w, h)];
    
    [self getDataFromDB];

    [self cteateSearchView];
    [self createButton];
    [self createTableview];
    [self createBottomView:[self getSelectedDevAndGroup]];
    
    [self refrashAllselectTitle];
    
    //创建通知
//    _notification =[NSNotification notificationWithName:Notification_Get_SelectedDev object:nil];
    //一秒后显示悬浮小球
    [self performSelector:@selector(createFloatButton) withObject:nil afterDelay:0.5];
    
    WS(weakSelf);
    [self performSelector:@selector(connectAllDev) withObject:nil afterDelay:1.5];
    [NSTimer scheduledTimerWithTimeInterval:TIME_CONNECT_DEVICE repeats:YES block:^(NSTimer * _Nonnull timer)
    {
        [weakSelf connectAllDev];
    }];
}

#pragma mark 私有方法
-(void)notifyDevSelectedChanged
{
    
    NSArray *arr =(NSArray *)[self getSelectedDevice];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:arr forKey:@"array"];
    //通过通知中心发送通知
    [kNotificationCenter postNotificationName:Notification_Get_SelectedDev object:nil userInfo:dict];
}

-(void)initData
{
    
    _data = [NSMutableArray array];
    _orgData = [NSMutableArray array];
    _allNumber = 0;
    _selectedNumber = 0;
    _errorCodeNumber = 0;
    _onlineNumber = 0;
}

/**
 * 初始化数据源
 */
-(void)getDataFromDB
{
    //1.获得数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbfileName = [doc stringByAppendingPathComponent:DB_NAME];
    //导入外部数据库.db文件
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:dbfileName] == NO)
    {
        BOOL ok = NO;
        if (dbfileName)
        {
            ok = [fm removeItemAtPath:dbfileName error:nil];
        }
        //拷贝数据库文件到指定目录
        NSString *backPath = [[NSBundle mainBundle] pathForResource:@"remote" ofType:@"db"];
        if (backPath)
        {
            ok = [fm copyItemAtPath:backPath toPath:dbfileName error:nil];
        }
//        NSLog(@"%d",ok);
    }
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:dbfileName];
    //3.打开数据库
    if ([db open])
    {
        //初始化数据容器
        [self initData];
        
        //查询设备
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM log_sn l,dev_model m WHERE l.model_id=m.id"];
//        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM log_sn"];
          while ([resultSet next])
          {
              APGroupNote *node = [APGroupNote new];
              node.isDevice = YES;

              node.name = SafeStr([resultSet stringForColumn:@"device_name"]);
              node.parentId = SafeStr([resultSet stringForColumn:@"group_id"]);
              node.nodeId = SafeStr([resultSet stringForColumn:@"gsn"]);
              node.signals = SafeStr([resultSet stringForColumn:@"signals"]);
              node.ip = SafeStr([resultSet stringForColumn:@"ip"]);
              node.temperature = SafeStr([resultSet stringForColumn:@"temperature"]);
              node.machine_running_time = SafeStr([resultSet stringForColumn:@"machine_running_time"]);
              node.light_running_time = SafeStr([resultSet stringForColumn:@"light_running_time"]);
              node.connect = SafeStr([resultSet stringForColumn:@"connect"]);
              node.supply_status = @"2";//SafeStr([resultSet stringForColumn:@"supply_status"]);
              node.shutter_status = SafeStr([resultSet stringForColumn:@"shutter_status"]);
              node.error_code = SafeStr([resultSet stringForColumn:@"new_error_code"]);
              node.device_id = SafeStr([resultSet stringForColumn:@"device_id"]);
              node.port = SafeStr([resultSet stringForColumn:@"port"]);
              node.access_protocol = SafeStr([resultSet stringForColumn:@"access_protocol"]);
              node.model_id = SafeStr([resultSet stringForColumn:@"model_id"]);
              node.model_name = SafeStr([resultSet stringForColumn:@"model"]);
              NSString *errorcode = SafeStr([resultSet stringForColumn:@"new_error_code"]);
              
              if([node.name containsString:@"测试机1"])//测试代码,方便断点用
              {
                  int i = 0;
              }
              if(errorcode.length)
              {
                  _errorCodeNumber++;
              }

              [_orgData addObject:node];
          }
        
        for (APGroupNote *node in _orgData)
        {
            // 获取控制界面的命令  control
            node.commandDict = [NSMutableDictionary dictionary];
            NSString *sqlStr = [NSString stringWithFormat:@"select l.parameter_value,i.exec_code from zk_command_mount m,zk_execlist_info i ,dev_execlist l where m.model_id=%@ and m.tab_code='control' and  m.exec_info_id=i.id and m.dev_exec_id=l.id",node.model_id];
            FMResultSet *resultSet = [db executeQuery:sqlStr];
            while ([resultSet next])
            {
                NSString *key = SafeStr([resultSet stringForColumn:@"exec_code"]);
                NSString *param = SafeStr([resultSet stringForColumn:@"parameter_value"]);
                NSData *data = [self getSendDataFromParam:param node:node];
                [node.commandDict setValue:data forKey:key];
            }
            
            // 获取监控界面的命令  ViewList
            node.monitorDict = [NSMutableDictionary dictionary];
            sqlStr = [NSString stringWithFormat:@"select l.parameter_value,i.exec_code from zk_command_mount m,zk_execlist_info i ,dev_execlist l where m.model_id=%@ and m.tab_code='ViewList' and  m.exec_info_id=i.id and m.dev_exec_id=l.id",node.model_id];
            resultSet = [db executeQuery:sqlStr];
            while ([resultSet next])
            {
                NSString *key = SafeStr([resultSet stringForColumn:@"exec_code"]);
                NSString *param = SafeStr([resultSet stringForColumn:@"parameter_value"]);
                NSData *data = [self getSendDataFromParam:param node:node];
                [node.monitorDict setValue:data forKey:key];
            }
            
            // 获取安装调节界面的命令  （镜头调节）scene
            node.sceneDict = [NSMutableDictionary dictionary];
            sqlStr = [NSString stringWithFormat:@"select l.parameter_value,i.exec_code from zk_command_mount m,zk_execlist_info i ,dev_execlist l where m.model_id=%@ and m.tab_code='scene' and  m.exec_info_id=i.id and m.dev_exec_id=l.id",node.model_id];
            resultSet = [db executeQuery:sqlStr];
            while ([resultSet next])
            {
                NSString *key = SafeStr([resultSet stringForColumn:@"exec_code"]);
                NSString *param = SafeStr([resultSet stringForColumn:@"parameter_value"]);
                NSData *data = [self getSendDataFromParam:param node:node];
                [node.sceneDict setValue:data forKey:key];
            }
            
            // 获取安装调节界面的命令  （安装配置）install_config
            node.installConfigDict = [NSMutableDictionary dictionary];
            sqlStr = [NSString stringWithFormat:@"select l.parameter_value,i.exec_code from zk_command_mount m,zk_execlist_info i ,dev_execlist l where m.model_id=%@ and m.tab_code='install_config' and  m.exec_info_id=i.id and m.dev_exec_id=l.id",node.model_id];
            resultSet = [db executeQuery:sqlStr];
            while ([resultSet next])
            {
                NSString *key = SafeStr([resultSet stringForColumn:@"exec_code"]);
                NSString *param = SafeStr([resultSet stringForColumn:@"parameter_value"]);
                NSData *data = [self getSendDataFromParam:param node:node];
                [node.installConfigDict setValue:data forKey:key];
            }
            
            // 获取安装调节界面的命令  （图像调节）image
            node.imageDict = [NSMutableDictionary dictionary];
            sqlStr = [NSString stringWithFormat:@"select l.parameter_value,i.exec_code from zk_command_mount m,zk_execlist_info i ,dev_execlist l where m.model_id=%@ and m.tab_code='image' and  m.exec_info_id=i.id and m.dev_exec_id=l.id",node.model_id];
            resultSet = [db executeQuery:sqlStr];
            while ([resultSet next])
            {
                NSString *key = SafeStr([resultSet stringForColumn:@"exec_code"]);
                NSString *param = SafeStr([resultSet stringForColumn:@"parameter_value"]);
                NSData *data = [self getSendDataFromParam:param node:node];
                [node.imageDict setValue:data forKey:key];
            }
            
            // 获取安装调节界面的命令  （ 色彩调节）colour
            node.colourDict = [NSMutableDictionary dictionary];
            sqlStr = [NSString stringWithFormat:@"select l.parameter_value,i.exec_code from zk_command_mount m,zk_execlist_info i ,dev_execlist l where m.model_id=%@ and m.tab_code='colour' and  m.exec_info_id=i.id and m.dev_exec_id=l.id",node.model_id];
            resultSet = [db executeQuery:sqlStr];
            while ([resultSet next])
            {
                NSString *key = SafeStr([resultSet stringForColumn:@"exec_code"]);
                NSString *param = SafeStr([resultSet stringForColumn:@"parameter_value"]);
                NSData *data = [self getSendDataFromParam:param node:node];
                [node.colourDict setValue:data forKey:key];
            }
            
            // 获取安装调节界面的命令  （ 设置）setup
            node.setupDict = [NSMutableDictionary dictionary];
            sqlStr = [NSString stringWithFormat:@"select l.parameter_value,i.exec_code from zk_command_mount m,zk_execlist_info i ,dev_execlist l where m.model_id=%@ and m.tab_code='setup' and  m.exec_info_id=i.id and m.dev_exec_id=l.id",node.model_id];
            resultSet = [db executeQuery:sqlStr];
            while ([resultSet next])
            {
                NSString *key = SafeStr([resultSet stringForColumn:@"exec_code"]);
                NSString *param = SafeStr([resultSet stringForColumn:@"parameter_value"]);
                NSData *data = [self getSendDataFromParam:param node:node];
                [node.setupDict setValue:data forKey:key];
            }
            
            // 获取安装调节界面的命令  （ 信号）signal
            node.signalDict = [NSMutableDictionary dictionary];
            sqlStr = [NSString stringWithFormat:@"select l.parameter_value,i.exec_code from zk_command_mount m,zk_execlist_info i ,dev_execlist l where m.model_id=%@ and m.tab_code='signal' and  m.exec_info_id=i.id and m.dev_exec_id=l.id",node.model_id];
            resultSet = [db executeQuery:sqlStr];
            while ([resultSet next])
            {
                NSString *key = SafeStr([resultSet stringForColumn:@"exec_code"]);
                NSString *param = SafeStr([resultSet stringForColumn:@"parameter_value"]);
                NSData *data = [self getSendDataFromParam:param node:node];
                [node.signalDict setValue:data forKey:key];
            }
            
            
        }
        
        //查询分组
        resultSet = [db executeQuery:@"SELECT * FROM zk_group"];
        _groupData = [NSMutableArray array];
        while ([resultSet next])
        {
            APGroupNote *node = [APGroupNote new];
            node.isDevice = NO;
            
            node.name = SafeStr([resultSet stringForColumn:@"group_name"]);
            node.parentId = SafeStr([resultSet stringForColumn:@"pid"]);
            node.nodeId = SafeStr([resultSet stringForColumn:@"id"]);
            if([node.name containsString:@"测试机1"])//测试代码,方便断点用
            {
                int i = 0;
            }
            [_groupData addObject:node];
            [_orgData addObject:node];
        }
        
        //获取modelid  和 modelname
        resultSet = [db executeQuery:@"SELECT * FROM dev_model"];
        _modelData = [NSMutableArray array];
        while ([resultSet next])
        {
            APDevModel *temp = [APDevModel new];

            temp.modelId = SafeStr([resultSet stringForColumn:@"id"]);
            temp.modelName = SafeStr([resultSet stringForColumn:@"model"]);
            [_modelData addObject:temp];
        }
        
        //关闭数据库
        [db close];
    }
    
    NSMutableArray *firstArr = [NSMutableArray array];
    NSMutableArray *secondArr = [NSMutableArray array];
    //第一次筛选
    for (APGroupNote *node in _orgData.reverseObjectEnumerator)
    {
        if ([node.parentId isEqualToString:@"0" ])
        {
//            if ([node.nodeId isEqualToString:@"228"] == NO)//测试代码 需要去掉
//                continue;
                
            node.depth = 0;//第0层
            [firstArr addObject:node];
            [_orgData removeObject:node];
        }
    }
    
    //第二次筛选
    for (int i=0; i<firstArr.count; i++)
    {
        APGroupNote *node = firstArr[i];
        [secondArr addObject:node];
        for (APGroupNote *temp in _orgData.reverseObjectEnumerator)
        {
            if ([temp.parentId isEqualToString:node.nodeId])
            {
                if (temp.isDevice) node.childNumber++;
                temp.height = 0;
                node.haveChild = YES;
                temp.depth = 1;//第1层
                temp.father = node;
                [secondArr addObject:temp];
                [_orgData removeObject:temp];
            }
        }
    }

    //第三次筛选
    for (int i=0; i<secondArr.count; i++)
    {
        APGroupNote *node = secondArr[i];
        [_data addObject:node];
        for (APGroupNote *temp in _orgData.reverseObjectEnumerator)
        {
            if ([temp.parentId isEqualToString:node.nodeId])
            {
                node.haveChild = YES;
                temp.depth = 2;//第2层
                temp.height = 0;
                temp.father = node;
                temp.grandfather = node.father;
                if (temp.isDevice)
                {
                    node.childNumber++;
                    if (temp.grandfather) temp.grandfather.childNumber++;
                }
                [_data addObject:temp];
                [_orgData removeObject:temp];
            }
        }
    }
    
}


-(NSData*)getSendDataFromParam:(NSString *)param node:(APGroupNote*)node
{
    NSString *temp = param;
    BOOL isHex = NO;
    if ([param containsString:@"appotype:\"hex\""] )
    {
        isHex = YES;
        NSArray *arr = [param componentsSeparatedByString:@"#"];
        temp = [arr lastObject];
    }
    else if ([param containsString:@"appotype:\"string\""])
    {
        NSArray *arr = [param componentsSeparatedByString:@"#"];
        temp = [arr firstObject];
    }
    
    if([node.model_id containsString:@"46"])//测试代码,方便断点用
    {
        int i = 0;
    }
    
    //去除中间的空格符
    NSString *str = [temp stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *finalStr = str;
    if (isHex == NO)
    {
        //把cr换成\r\n
        finalStr = [SafeStr(finalStr) stringByReplacingOccurrencesOfString:@"<CR>" withString:@""];
        finalStr = [finalStr stringByAppendingString:@"\r\n"];
        finalStr = [[APTool shareInstance] hexStringFromString:finalStr];
    }
    NSData *sendData = [[APTool shareInstance] convertHexStrToData:finalStr];

    return sendData;
}

-(void)cteateSearchView
{
    UITextField *filed = [[UITextField alloc] init];
    _textfiled = filed;
    ViewRadius(filed, 10);
//    filed.borderStyle = UITextBorderStyleRoundedRect;
    filed.textColor = [UIColor whiteColor];
    filed.delegate = self;
    filed.textAlignment = NSTextAlignmentCenter;
    filed.backgroundColor = ColorHex(0x29315F);
    filed.clearButtonMode = UITextFieldViewModeAlways;
    //改变搜索框中的placeholder的颜色
    NSString *holderText = @"搜索投影机/分组";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                            value:ColorHex(0xABBDD5 )
                            range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:16]
                            range:NSMakeRange(0, holderText.length)];
    filed.attributedPlaceholder = placeholder;
    
    //搜索图标
//    UIImageView *leftSearcgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 180, 15)];
//    leftSearcgImgView.image = [UIImage imageNamed:@"Vector"];
//    leftSearcgImgView.contentMode = UIViewContentModeCenter;
//    filed.leftView = leftSearcgImgView;
//    filed.leftViewMode = UITextFieldViewModeAlways;

    [self addSubview:filed];
    
    [filed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-Left_Gap);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(Left_Gap);
        make.height.mas_equalTo(H_SCALE(38));
    }];
    
}


-(void)createTableview
{
    _tableview  = [[APGroupTableView alloc] init];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.separatorStyle = NO;

    UIView *View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Left_View_Width, 0.01)];
    View.backgroundColor = [UIColor clearColor];
    _tableview.tableHeaderView = View;
    
    [self addSubview:_tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(90));
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    
    [_tableview reloadData];
//    _tableview.backgroundColor = [UIColor redColor];
}

-(void)createBottomView:(NSArray *)selectedArr
{
    if(selectedArr == nil) return;
    
    if (self.bottomView == nil)
    {
        self.bottomView = [[UIView alloc] init];
        [self addSubview:self.bottomView];
        self.bottomView.tag = 0;//表示拥有子button的个数
        self.bottomView.userInteractionEnabled = YES;
        self.bottomView.backgroundColor = ColorHex(0x1D2242 );
        ViewRadius(self.bottomView, 9);
        [self.bottomView setFrame:CGRectMake(0, self.frame.size.height, Left_View_Width, Bottom_View_Height)];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    int groupNumber = 0;
    int devNumber = 0;
    for (APGroupNote *node in selectedArr)
    {
        node.isDevice == YES ? devNumber++ : groupNumber++;
    }
    
    if((devNumber == 1 && groupNumber == 0)||
       (devNumber == 0 && groupNumber == 0))
    {
        
        for (UIView *subview in self.bottomView.subviews)
        {
            [subview removeFromSuperview];
        }
        
        NSDictionary *dict1 = @{@"string":@"编辑",
                               @"imageName":@"edit",
        };
        NSDictionary *dict2 = @{@"string":@"删除",
                               @"imageName":@"Group 11533",
        };
        NSDictionary *dict3 = @{@"string":@"移动",
                               @"imageName":@"Group 11532",
        };
        NSDictionary *dict4 = @{@"string":@"重命名",
                               @"imageName":@"Group 11531",
        };
        
        [array addObject:dict3];
        [array addObject:dict2];
        [array addObject:dict1];
        [array addObject:dict4];
    }
    else
    {
        for (UIView *subview in self.bottomView.subviews)
        {
            [subview removeFromSuperview];
        }
        
        NSDictionary *dict2 = @{@"string":@"删除",
                               @"imageName":@"Group 11533",
        };
        NSDictionary *dict3 = @{@"string":@"移动",
                               @"imageName":@"Group 11532",
        };
        
        NSDictionary *dict4 = @{@"string":@"重命名分组",
                               @"imageName":@"Group 11531",
        };
        
        [array addObject:dict3];
        [array addObject:dict2];
        
        
        if (groupNumber == 1)
        {
            [array addObject:dict4];
        }
    }
    
    CGFloat btnW = W_SCALE(50);
    CGFloat btnH = H_SCALE(60);
    CGFloat midGap = (self.bottomView.frame.size.width  - array.count*btnW)/(array.count + 1);
    CGFloat x = midGap;

    for (int i = 0; i < array.count; i++)
    {
        NSDictionary *dic = array[i];
        if (dic == nil)
        {
            continue;
        }
        NSString *str = dic[@"string"];
        NSString *strImage = dic[@"imageName"];
        CGFloat w = btnW;
        if ([str isEqualToString:@"重命名分组"])
        {
            w = btnW+W_SCALE(32);
        }
        APBottomButton *button = [[APBottomButton alloc] initWithFrame:CGRectMake(x, (Bottom_View_Height-btnH)/2, w, btnH)];
//        [button setBackgroundImage:[self imageWithColor:ColorHex(0x7877A9)] forState:UIControlStateHighlighted];
//        button.backgroundColor = [UIColor redColor];
        [self.bottomView addSubview:button];
        if ([str isEqualToString:@"重命名分组"])
        {
            button.lab.font = [UIFont systemFontOfSize:15];
        }
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
//            [button sendActionsForControlEvents:UIControlEventTouchUpInside];//代码点击
        }
        
        button.tag = i;
        [button addTarget:self action:@selector(btnBottomClick:) forControlEvents:UIControlEventTouchUpInside];

        x = x + btnW + midGap;
    }
}

-(void)createButton
{
    //全选图标
    CGFloat top = H_SCALE(52);
    self.btnLeft = [UIButton new];
    [self addSubview:self.btnLeft];
//    [self.btnLeft setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateSelected];
    [self.btnLeft setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateHighlighted];
    self.btnLeft.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [self.btnLeft setTitleColor:ColorHex(0xFFFFFF ) forState:UIControlStateNormal];
    [self.btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(Group_Btn_W, Group_Btn_W));
        make.top.mas_equalTo(self.mas_top).offset(top);
        make.left.equalTo(self.mas_left).offset(Left_Gap);
    }];
    
    [self.btnLeft setImage:[UIImage imageNamed:@"Ellipse 4"] forState:UIControlStateNormal];
//    [self.btnLeft addTarget:self action:@selector(allSelectbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //放大隐藏按钮
    UIButton *btn = [UIButton new];
//    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(allSelectbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(W_SCALE(150), Group_Btn_W));
        make.top.mas_equalTo(self.mas_top).offset(top);
        make.left.equalTo(self.mas_left).offset(0);
    }];
    
    //全选标题
    _allSelectLabel = [[UILabel alloc] init];
    _allSelectLabel.textColor = [UIColor whiteColor];
    _allSelectLabel.font = [UIFont systemFontOfSize:16];
    _allSelectLabel.textAlignment = NSTextAlignmentLeft;
    NSString *str = @"全部";
    _allSelectLabel.text = str;
    [self addSubview:_allSelectLabel];
    [_allSelectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(W_SCALE(250), Group_Btn_W));
        make.top.mas_equalTo(self.mas_top).offset(top);
        make.left.equalTo(self.btnLeft.mas_right).offset(0);
    }];

    //编辑按钮
    self.btnRight = [UIButton new];
    [self addSubview:self.btnRight];
    [self.btnRight setTitle:@"编辑" forState:UIControlStateNormal];
    self.btnRight.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [self.btnRight setTitleColor:ColorHex(0x3F6EF2) forState:UIControlStateNormal];
    [self.btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(W_SCALE(45), Group_Btn_W));
        make.top.mas_equalTo(self.mas_top).offset(top);
        make.right.equalTo(self.mas_right).offset(-Left_Gap);
    }];
    [self.btnRight addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];


}
-(void)countEveryGroupChildAndSelected
{
//    NSMutableArray *arr = [NSMutableArray array];
    if (_isFieldActive)
    {
        
    }
    else
    {
        for(APGroupNote *node in _data)
        {
            if (node.isDevice == NO)
            {
                node.childNumber = 0;
                node.childSelected = 0;
                for (APGroupNote *temp in _data)
                {
                    if (temp.isDevice)
                    {
                        if ([temp.parentId isEqualToString:node.nodeId] || (temp.father && ([temp.father.parentId isEqualToString:node.nodeId])))
                        {
                            node.childNumber++;
                            if(temp.selected) node.childSelected++;
                        }
                    }
                        
                }
            }
        }
    }
//    return  arr;
}

#pragma  mark 悬浮小球 新加设备按钮
-(void)createFloatButton
{
    if (!_floatButton)
    {
        _floatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _floatButton.frame = CGRectMake(W_SCALE(250), H_SCALE(680), W_SCALE(55), H_SCALE(55));//初始在屏幕上的位置
        [_floatButton setImage:[UIImage imageNamed:@"Group 11697"] forState:UIControlStateNormal];
        
        UIWindow *window =  [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        window.backgroundColor = [UIColor whiteColor];
        [window addSubview:_floatButton];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:
                                       self action:@selector(locationChange:)];
        pan.delaysTouchesBegan = YES;
        [_floatButton addGestureRecognizer:pan];
        [_floatButton addTarget:self action:@selector(floatbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)refrashAllselectTitle
{
    WS(weakSelf);
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        
        //执行耗时的异步操作...
        weakSelf.allNumber = 0;
        weakSelf.selectedNumber = 0;
        weakSelf.onlineNumber = 0;
        weakSelf.errorCodeNumber = 0;
        for(APGroupNote *temp in weakSelf.data)
        {
            if (temp.isDevice)
            {
                weakSelf.allNumber++;
                if (temp.selected)
                {
                    weakSelf.selectedNumber++;
                }
                if ([temp.supply_status isEqualToString:@"1"])
                {
                    weakSelf.onlineNumber++;
                }
                if (temp.error_code && temp.error_code.length > 0)
                {
                    weakSelf.errorCodeNumber++;
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //回到主线程，执行UI刷新操
            weakSelf.allSelectLabel.text = [NSString stringWithFormat:@"全部(%d/%d)", weakSelf.selectedNumber,weakSelf.allNumber];

        });
    });
}

-(void)selectedAllWithSelected:(BOOL)selected
{
    for(APGroupNote *temp in _data)
    {
        temp.selected = selected;
        if (temp.isDevice == NO)
        {
            temp.childSelected = selected ? temp.childNumber : 0;
        }
    }
    
    [_tableview reloadData];
}


-(void)deleteSelectedNode
{
    NSArray *temp1 = [self getSelectedDevAndGroup];
    if(temp1.count == 0)
    {
        NSString *t = @"提示";
        NSString *m = @"请选择要删除的设备或者分组";
        UIAlertController  *alert = [UIAlertController alertControllerWithTitle:t message:m preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action2= [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                }];
//                    [action2 setValue:[UIColor blueColor] forKey:@"titleTextColor"];
        //修改title
//                    [[APTool shareInstance] setAlterviewTitleWith:alert title:t color:[UIColor blackColor]];
//                    [[APTool shareInstance] setAlterviewMessageWith:alert message:m color:[UIColor blackColor]];
//                    [[APTool shareInstance] setAlterviewBackgroundColor:alert color:[UIColor whiteColor]];

//                    ViewRadius(alert, 5);
        [alert addAction:action2];
        AppDelegate *appDelegate = kAppDelegate;
        UIViewController *vc = appDelegate.mainVC;
        [vc presentViewController:alert animated:YES completion:nil];
    }

    NSMutableArray *deleteArray = [NSMutableArray array];//临时容器，存储将要删除的节点
    BOOL haveGroup = NO;
    
    //收集删除节点
    for (int i = 0; i < _data.count; i++)
    {
        APGroupNote *first = _data[i];
        if (first.selected)
        {
            [deleteArray addObject:first];
            if(first.isDevice)
            {
            }
            else//把分组的子节点选出来
            {
                haveGroup = YES;
                for (int j = 0; j < _data.count; j++)
                {
                    APGroupNote *temp = _data[j];
                    if ([temp.parentId isEqualToString:first.nodeId] || (temp.father && ([temp.father.parentId isEqualToString:first.nodeId])))
                    {
                        [deleteArray addObject:temp];
                    }
                }
            }
        }
    }
    
    //删除节点刷新列表
    if (deleteArray.count > 0)
    {
        WS(weakSelf);
        NSString *msg = haveGroup?@"确认删除分组以及分组内的所有设备吗":@"确认删除设备吗";
        UIAlertController  *alert = [UIAlertController alertControllerWithTitle:msg message:@"删除后无法恢复" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
        {
//            [weakSelf.data removeObjectsAtIndexes:set];
//            [weakSelf refrashAllselectTitle];
//            [weakSelf countEveryGroupChildAndSelected];
            [weakSelf deleteFromDBtaget:deleteArray];
            [weakSelf refreshTable];
        }];
                
        UIAlertAction *action2= [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                }];

        [alert addAction:action1];
        [alert addAction:action2];
        AppDelegate *appDelegate = kAppDelegate;
    //    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UIViewController *vc = appDelegate.mainVC;
        [vc presentViewController:alert animated:YES completion:nil];  //显示对话框
    }
}

//写数据到数据库
-(void)deleteFromDBtaget:(NSArray *)array
{
    //1.获得数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbfileName = [doc stringByAppendingPathComponent:DB_NAME];
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:dbfileName];
    //3.打开数据库
    if ([db open])
    {
        NSArray *tempArray = [self getSelectedDevAndGroup];
        for (APGroupNote *node in tempArray)
        {
            //释放node上的socket
            if(node.tcpManager && node.tcpManager.socket && node.tcpManager.socket.isConnected)
            {
                [node.tcpManager.socket disconnect];
                node.tcpManager.socket = nil;
            }
            
            NSString *tableName = node.isDevice? @"log_sn" : @"zk_group";
            NSString *field =  node.isDevice? @"gsn" : @"id";
            NSString *keyStr = node.nodeId;
            NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where %@='%@'",tableName,field,keyStr];
            BOOL ret = [db executeUpdate:sqlStr];
            if  (ret)
            {
//                AppDelegate *appDelegate = kAppDelegate;
//                APGroupView *vc = appDelegate.mainVC.leftView.groupView;
//                if (vc && [vc isKindOfClass:[APGroupView class]])
//                {
//                    [vc refreshTable];
//                }
                NSLog(@"删除数据库成功");
            }
            else
            {
                NSLog(@"删除数据库错误");
            }
        }
              
        //关闭数据库
        [db close];
    }
}


//设置cell展开折叠
-(void)setExpend:(int)row
{
    WS(weakSelf);
    APGroupNote *node = weakSelf.data[row];
    
    if (node.expand == YES)
    {
        node.expand = !node.expand;
        for (int i = 0; i < _data.count; i++)
        {
            APGroupNote *second = _data[i];
            
            if ([second.parentId isEqualToString:node.nodeId] || (second.father && [second.father.parentId isEqualToString:node.nodeId]) )
            {
                second.height = 0;
                
                 NSArray *rowArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]];
                 [weakSelf.tableview reloadRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
    else
    {
        node.expand = !node.expand;
        for (int i = 0; i < _data.count; i++)
        {
            APGroupNote *second = _data[i];
            if ([second.parentId isEqualToString:node.nodeId])
            {
                second.height = Group_Cell_Height;
                
                 NSArray *rowArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]];
                 [weakSelf.tableview reloadRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationAutomatic];
                
                if(second.expand == YES)
                {
                    for (int k = 0; k < _data.count; k++)
                    {
                        APGroupNote *third = _data[k];
                        if([third.parentId isEqualToString:second.nodeId])
                        {
                            third.height = Group_Cell_Height;
                            
                             NSArray *rowArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:k inSection:0]];
                             [weakSelf.tableview reloadRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationAutomatic];
                        }
                    }
                }
            }
        }
    }
    
    NSArray *rowArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]];
    [weakSelf.tableview reloadRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationAutomatic];
//    [weakSelf.tableview reloadData];
}

//隐藏编辑按钮
-(void)setEditVailable
{
    _btnLeft.hidden = _btnRight.hidden = NO;
    
}
//显示编辑按钮
-(void)setEditUnavailable
{
    _btnLeft.hidden = _btnRight.hidden = YES;
}




-(void)locationChange:(UIPanGestureRecognizer*)p{
    CGFloat HEIGHT=_floatButton.frame.size.height;
    CGFloat WIDTH=_floatButton.frame.size.width;
    BOOL isOver = NO;
    CGPoint panPoint = [p locationInView:[UIApplication sharedApplication].windows[0]];
    CGRect frame = CGRectMake(panPoint.x, panPoint.y, HEIGHT, WIDTH);
//    NSLog(@"%f--panPoint.x-%f-panPoint.y-", panPoint.x, panPoint.y);
    if(p.state == UIGestureRecognizerStateChanged){
        _floatButton.center = CGPointMake(panPoint.x, panPoint.y);
    }
    else if(p.state == UIGestureRecognizerStateEnded){
        if (panPoint.x + WIDTH > Left_View_Width) {
            frame.origin.x = Left_View_Width - WIDTH;
            isOver = YES;
        } else if (panPoint.y + HEIGHT > SCREEN_HEIGHT) {
            frame.origin.y = SCREEN_HEIGHT - 2*HEIGHT;
            isOver = YES;
        } else if(panPoint.x - WIDTH / 2< 0) {
            frame.origin.x = 0;
            isOver = YES;
        } else if(panPoint.y - HEIGHT / 2 < 0) {
            frame.origin.y = 0;
            isOver = YES;
        }
        WS(weakSelf);
        if (isOver) {
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.floatButton.frame = frame;
            }];
        }
    }
}

#pragma  mark 对外接口
-(void)refreshTable
{
    [self getDataFromDB];
    [self refrashAllselectTitle];
    [self notifyDevSelectedChanged];
    [_tableview reloadData];
    [self createBottomView:[self getSelectedDevAndGroup]];

}

-(NSArray *)getSelectedDevice
{
    NSMutableArray *arr = [NSMutableArray array];
//    if (_isFieldActive)
//    {
//        for(APGroupNote *temp in _filteredData)
//        {
//            if (temp.isDevice && temp.selected)
//            {
//                [arr addObject:temp];
//            }
//        }
//    }
//    else
//    {
        for(APGroupNote *temp in _data)
        {
            if (temp.isDevice && temp.selected)
            {
                [arr addObject:temp];
            }
        }
//    }
    
    return  arr;
}



-(NSArray *)getSelectedDevAndGroup
{
    NSMutableArray *arr = [NSMutableArray array];
    for(APGroupNote *temp in _data)
    {
        if (temp.selected)
        {
            [arr addObject:temp];
        }
    }
    
    return  arr;
}

-(NSArray *)getAllDevice
{
    NSMutableArray *arr = [NSMutableArray array];
    for(APGroupNote *temp in _data)
    {
        if (temp.isDevice )
        {
            [arr addObject:temp];
        }
    }
    
    return  arr;
}

//如果有组需要移动， 只需要改变组的父id即可
-(NSArray *)getNeedMoveDevAndGroup
{
    //被选中的所有
    NSMutableArray *selectedArr = [NSMutableArray array];
    for(APGroupNote *temp in _data)
    {
        if (temp.selected)
        {
            [selectedArr addObject:temp];
        }
    }
    
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];//临时容器，存储将要删除的节点

    //需要帅选掉的
//    NSMutableArray *tempArray = [NSMutableArray array];
    for (APGroupNote* node in selectedArr)
    {
        if(node.isDevice == NO)
        {
            for (int i = 0; i < selectedArr.count; i++)
            {
                APGroupNote *temptemp = selectedArr[i];
                if ([temptemp.parentId isEqualToString:node.nodeId] || (temptemp.father && ([temptemp.father.parentId isEqualToString:node.nodeId])))
                {
                    [set addIndex:i];
                }
            }
        }
    }
 
    [selectedArr removeObjectsAtIndexes:set];
    return  selectedArr;
}

#pragma mark 连接设备获取数据
-(void)connectAllDev
{
    for (int i = 0; i<self.data.count; i++)
    {
        APGroupNote *node = self.data[i];
        if(node.isDevice)
        {
            [self getDataFromDevice:[NSNumber numberWithInt:i]];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableview performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
    });
}

-(void)getDataFromDevice:(NSNumber*)number
{
    int row = [number intValue];
    if(self.data == nil || self.data.count <= row) return;
    APGroupNote *node = self.data[row];

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
    if(self.data == nil || self.data.count <= row) return;
    WS(weakSelf);

    APGroupNote *node = weakSelf.data[row];
    NSData* tcpdata = node.monitorDict[key];

    NSString *sss = [[NSString alloc] initWithData:tcpdata encoding:NSUTF8StringEncoding];

//                NSLog(@"发送数据：%@",sss);
    APTcpSocket *tcpManager;
    if (node.tcpManager == nil)
    {
        tcpManager = [APTcpSocket new];
        node.tcpManager = tcpManager;
    }
    node.tcpManager.senddata = [NSData dataWithData:tcpdata];
    node.tcpManager.ip = node.ip;
    node.tcpManager.port = node.port.intValue;
    [node.tcpManager connectToHost];
    
    //连接失败
    [node.tcpManager setDidDisconnectBlock:^(NSString * _Nonnull message) {
        if(weakSelf.data && weakSelf.data.count > row)
        {
            APGroupNote *node = weakSelf.data[row];
        
            if(node)
            {
                node.connect = @"2";
                node.supply_status = @"2";
                node.shutter_status = @"2";
            }
        }
            
    }];
    
    //连接成功
    [node.tcpManager setDidConnectedBlock:^(NSString * _Nonnull message) {
        if(weakSelf.data && weakSelf.data.count > row)
        {
            APGroupNote *node = weakSelf.data[row];
            //网络已经连接
            node.connect = @"1";
            node.supply_status = @"1";
        }
        
    }];
    
    [node.tcpManager setSocketMessageBlock:^(NSString * _Nonnull message) {
           if(message)
           {
               if(weakSelf.data == nil || weakSelf.data.count <= row) return;

               APGroupNote *tempNode = weakSelf.data[row];
               NSArray *temparray = [message componentsSeparatedByString:@"\r\n"];
               for (NSString *string in temparray)
               {
                   if (string.length == 0) continue;
                   
                   NSArray *arr = [string componentsSeparatedByString:@"#"];
                   NSString *firstStr = [arr firstObject];
                   NSString *lastStr = [arr lastObject];
    //                       APGroupNote *tempNode = weakSelf.data[row];
//                   NSLog(@"ip = %@(%@)收到数据:\n%@",tempNode.ip,tempNode.name,message);

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
                           tempNode.supply_status = @"3";
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


#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    _isFieldActive = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0)
    {
        _isFieldActive = NO;
        [_tableview reloadData];
    }
    
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver（text）对应的键盘往下收

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
 {
      [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver（text）对应的键盘往下收
      return YES;
 }
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
//返回一个BOOL值指明是否允许根据用户请求清除内容
//可以设置在特定条件下才允许清除内容
    
//    [textField resignFirstResponder];
    _filteredData = [_data mutableCopy];
    [_tableview reloadData];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//        if ([string isEqualToString:@"\n"]) { //按会车可以改变
//                return YES;
//            }

    NSString * searchText = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (_filteredData && _filteredData.count)
    {
        [_filteredData removeAllObjects];
    }
    else
    {
        _filteredData = [NSMutableArray array];
    }
    
    if (searchText.length > 0)
    {
        _isFieldActive = YES;

        // 将搜索的结果存放到数组中
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[c] %@", searchText];
        _filteredData = [[_data filteredArrayUsingPredicate:searchPredicate] mutableCopy];
        [_tableview reloadData];

        //寻找父节点
    }
    else
    {
        _isFieldActive = NO;
        [_tableview reloadData];
    }

    [_tableview reloadData];
    return YES;

}
#pragma mark UITableViewDelegate/UITableViewDataSource
 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //控制器使用的时候，就是点击了搜索框的时候
    if (_isFieldActive)
    {
        [self setEditUnavailable];
        return _filteredData.count;
    }
    
    [self setEditVailable];
    return _data.count;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *NODE_CELL_ID = @"node_cell_id";

    APGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:NODE_CELL_ID];
    if (!cell) {
        cell = [[APGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NODE_CELL_ID];
    }
    APGroupNote *node;
    if (_isFieldActive)
    {
        node = [_filteredData objectAtIndex:indexPath.row];
    }
    else
    {
        node = [_data objectAtIndex:indexPath.row];
    }

    [cell updateCellWithData:node index:(int)indexPath.row];
    
    WS(weakSelf);
    [cell setBtnClickBlock:^(BOOL index) {
        [weakSelf setExpend:(int)indexPath.row];
    }];
    return cell;
}


 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row ;
    APGroupNote *node = _data[row];
    if (node && node.height == 0)
    {
        return node.height;
    }
    
    return Group_Cell_Height;
}
 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row ;
    
    //搜索列表
    if (_isFieldActive)
    {
        APGroupNote *tempnode = _filteredData[row];
        if (tempnode == nil) return;
        
        APGroupCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(cell.selectBtn)
        {
            //本节点被选中
            cell.selectBtn.selected = !cell.selectBtn.selected;
            NSString *selectIamge = cell.selectBtn.selected?@"all" : @"Ellipse 4";
            [cell.selectBtn setImage:[UIImage imageNamed:selectIamge] forState:UIControlStateNormal];
            tempnode.selected = cell.selectBtn.selected;
            
            if (tempnode.selected == NO)
            {
                if (tempnode.father)
                {
                    tempnode.father.selected = NO;
                }
                
                if (tempnode.grandfather)
                {
                    tempnode.grandfather.selected = NO;
                }
            }
            [tableView reloadData];
        }
    }
    else//正常列表
    {
        APGroupNote *node = _data[row];
        if (node == nil) return;
        
        APGroupCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(cell.selectBtn)
        {
            //本节点被选中
            cell.selectBtn.selected = !cell.selectBtn.selected;
            NSString *selectIamge = cell.selectBtn.selected?@"all" : @"Ellipse 4";
            [cell.selectBtn setImage:[UIImage imageNamed:selectIamge] forState:UIControlStateNormal];
            node.selected = cell.selectBtn.selected;

            if (node.isDevice == NO)
            {
                //如果是组并且有孩子，则所有孩子都被选中
                for(APGroupNote *temp in _data)
                {
                    if ([temp.parentId isEqualToString:node.nodeId] || (temp.father && ([temp.father.parentId isEqualToString:node.nodeId])))
                    {
                        temp.selected = cell.selectBtn.selected;
                    }
                }
            }
            
            //设备和分组不被选中，则他所在的分组也不选中
            if (node.selected == NO)
            {
                if (node.father)
                {
                    node.father.selected = NO;
                }
                
                if (node.grandfather)
                {
                    node.grandfather.selected = NO;
                }
            }
            
            [self refrashAllselectTitle];
            [self countEveryGroupChildAndSelected];
            [tableView reloadData];
        }
    }
    
    [self notifyDevSelectedChanged];
    [self createBottomView:[self getSelectedDevAndGroup]];

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark button响应
-(void)btnBottomClick:(APBottomButton *)btn
{
    NSString *string = btn.lab.text;
    if ([@"编辑" isEqualToString:string])//按钮编辑
    {
        NSArray *temp = [self getSelectedDevice];
        if(temp.count != 1)
        {
            NSString *t = @"提示";
            NSString *m = @"请选中需要编辑的设备";
            UIAlertController  *alert = [UIAlertController alertControllerWithTitle:t message:m preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action2= [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    }];
//                    [action2 setValue:[UIColor blueColor] forKey:@"titleTextColor"];
            //修改title
//                    [[APTool shareInstance] setAlterviewTitleWith:alert title:t color:[UIColor blackColor]];
//                    [[APTool shareInstance] setAlterviewMessageWith:alert message:m color:[UIColor blackColor]];
//                    [[APTool shareInstance] setAlterviewBackgroundColor:alert color:[UIColor whiteColor]];

//                    ViewRadius(alert, 5);
            [alert addAction:action2];
            AppDelegate *appDelegate = kAppDelegate;
            UIViewController *vc = appDelegate.mainVC;
            [vc presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            [_editDevView removeFromSuperview];
//            _editDevView = nil;
            _editDevView = [[APAPEditDeviceView alloc] init];
            AppDelegate *appDelegate = kAppDelegate;
            UIViewController *vc = appDelegate.mainVC;
            [vc.view addSubview:_editDevView];
            [vc.view bringSubviewToFront:_editDevView];
            _editDevView.groupData = [NSMutableArray arrayWithArray:self.groupData];
            _editDevView.modelData = [NSMutableArray arrayWithArray:self.modelData];
            _editDevView.deviceInfo = temp[0];
            [_editDevView setDefaultValue];
            //ok按钮
            WS(weakSelf);
            [_editDevView setOkBtnClickBlock:^(BOOL index) {
                [weakSelf.editDevView removeFromSuperview];
                                weakSelf.floatButton.hidden = NO;

            }];
            //取消按钮
            [_editDevView setCancelBtnClickBlock:^(BOOL index) {
                [weakSelf.editDevView removeFromSuperview];

                weakSelf.floatButton.hidden = NO;

            }];
            
            self.floatButton.hidden = YES;
        }
    }
    else if ([@"删除" isEqualToString:string])//删除
    {
        [self deleteSelectedNode];
    }
    else if ([@"移动" isEqualToString:string])//移动
    {
        NSArray *temp = [self getSelectedDevAndGroup];
        if(temp.count == 0)
        {
            NSString *t = @"提示";
            NSString *m = @"请选择要移动的设备或者分组";
            UIAlertController  *alert = [UIAlertController alertControllerWithTitle:t message:m preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action2= [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    }];
//                    [action2 setValue:[UIColor blueColor] forKey:@"titleTextColor"];
            //修改title
//                    [[APTool shareInstance] setAlterviewTitleWith:alert title:t color:[UIColor blackColor]];
//                    [[APTool shareInstance] setAlterviewMessageWith:alert message:m color:[UIColor blackColor]];
//                    [[APTool shareInstance] setAlterviewBackgroundColor:alert color:[UIColor whiteColor]];

//                    ViewRadius(alert, 5);
            [alert addAction:action2];
            AppDelegate *appDelegate = kAppDelegate;
            UIViewController *vc = appDelegate.mainVC;
            [vc presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            [_moveView removeFromSuperview];
//            _moveView = nil;
            _moveView = [[APMoveDevAndGroupView alloc] init];
            AppDelegate *appDelegate = kAppDelegate;
            UIViewController *vc = appDelegate.mainVC;
            [vc.view addSubview:_moveView];
            [vc.view bringSubviewToFront:_moveView];
            _moveView.groupData = [NSMutableArray arrayWithArray:self.groupData];
            _moveView.selectedData = [NSMutableArray arrayWithArray:[self getNeedMoveDevAndGroup]];
            [_moveView setDefaultValue];

            //ok按钮
            WS(weakSelf);
            [_moveView setOkBtnClickBlock:^(BOOL index) {
                [weakSelf.editDevView removeFromSuperview];
                weakSelf.floatButton.hidden = NO;
                [weakSelf refreshTable];

            }];
            //取消按钮
            [_moveView setCancelBtnClickBlock:^(BOOL index) {
                [weakSelf.editDevView removeFromSuperview];
                weakSelf.floatButton.hidden = NO;
            }];
            
            self.floatButton.hidden = YES;
        }
    }
    else if ([@"重命名" isEqualToString:string])//重命名
    {
        NSArray *temp = [self getSelectedDevice];

        if(temp.count == 0)
        {
            NSString *t = @"提示";
            NSString *m = @"未选中";
            UIAlertController  *alert = [UIAlertController alertControllerWithTitle:t message:m preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action2= [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    }];
            [alert addAction:action2];
            AppDelegate *appDelegate = kAppDelegate;
            UIViewController *vc = appDelegate.mainVC;
            [vc presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            
            [_renameView removeFromSuperview];
//            _renameView = nil;
            _renameView = [[APRenameView alloc] init];
            AppDelegate *appDelegate = kAppDelegate;
            UIViewController *vc = appDelegate.mainVC;
            [vc.view addSubview:_renameView];
            [vc.view bringSubviewToFront:_renameView];
            [_renameView setDefaultValue:temp[0]];
            
            //ok按钮
            WS(weakSelf);
            [_renameView setOkBtnClickBlock:^(BOOL index) {
                [weakSelf.renameView removeFromSuperview];
                weakSelf.floatButton.hidden = NO;
                [weakSelf refreshTable];
                
            }];
            //取消按钮
            [_renameView setCancelBtnClickBlock:^(BOOL index) {
                [weakSelf.renameView removeFromSuperview];
                weakSelf.floatButton.hidden = NO;
            }];
            
            self.floatButton.hidden = YES;
        }
        
    }
    else if ([@"重命名分组" isEqualToString:string])//重命名分组
    {
        NSArray *temp = [self getSelectedDevAndGroup];
        
        if(temp.count == 0)
        {
            NSString *t = @"提示";
            NSString *m = @"未选中";
            UIAlertController  *alert = [UIAlertController alertControllerWithTitle:t message:m preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action2= [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }];
            [alert addAction:action2];
            AppDelegate *appDelegate = kAppDelegate;
            UIViewController *vc = appDelegate.mainVC;
            [vc presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            APGroupNote *tempNode = [APGroupNote new];
            for (APGroupNote *node in temp)
            {
                if(node.isDevice == NO)
                {
                    tempNode = node;
                }
            }
            
            [_renameGroupView removeFromSuperview];
//            _renameGroupView = nil;
            _renameGroupView = [[APRenameGroupView alloc] init];
            AppDelegate *appDelegate = kAppDelegate;
            UIViewController *vc = appDelegate.mainVC;
            [vc.view addSubview:_renameGroupView];
            [vc.view bringSubviewToFront:_renameGroupView];
            [_renameGroupView setDefaultValue:tempNode];
            
            //ok按钮
            WS(weakSelf);
            [_renameGroupView setOkBtnClickBlock:^(BOOL index) {
                [weakSelf.renameGroupView removeFromSuperview];
                weakSelf.floatButton.hidden = NO;
                [weakSelf refreshTable];
                
            }];
            //取消按钮
            [_renameGroupView setCancelBtnClickBlock:^(BOOL index) {
                [weakSelf.renameGroupView removeFromSuperview];
                weakSelf.floatButton.hidden = NO;
            }];
            
            self.floatButton.hidden = YES;
        }
    }
}

-(void)allSelectbtnClick:(UIButton *)btn
{
//    if (btn == self.btnLeft)
    {
        
        self.btnLeft.selected = !self.btnLeft.selected;
        NSString *selectIamge = self.btnLeft.selected?@"all" : @"Ellipse 4";
        [self.btnLeft setImage:[UIImage imageNamed:selectIamge] forState:UIControlStateNormal];
        
        [self selectedAllWithSelected:self.btnLeft.selected];
        [self refrashAllselectTitle];
        [self notifyDevSelectedChanged];
        [self createBottomView:[self getSelectedDevAndGroup]];

    }
}
-(void)editBtnClick:(UIButton *)btn
{
    if (btn == self.btnRight)
    {
        self.btnRight.selected = !self.btnRight.selected;
        if(self.btnRight.selected == YES)
        {
            [self.btnRight setTitle:@"完成编辑" forState:UIControlStateNormal];
            [self.btnRight mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake(70, Group_Btn_W));
            }];
            
            if (self.bottomView)
            {
                CGFloat w = self.frame.size.width;
                [UIView animateWithDuration:0.3 animations:^{
                    [self.bottomView setFrame:CGRectMake(0, self.frame.size.height - Bottom_View_Height, w, Bottom_View_Height)];
//                    self.bottomView.hidden = NO;
                    [self.bottomView.superview layoutIfNeeded];//强制绘制
                }];
            }
//            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
//                            make.right.mas_equalTo(self.mas_right).offset(0);
//                make.left.mas_equalTo(self.mas_left).offset(0);
//                make.bottom.mas_equalTo(self.mas_bottom).offset(0);
//                make.height.mas_equalTo(Bottom_View_Height);
//            }];
            [_tableview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.mas_bottom).offset(-Bottom_View_Height);
            }];
        }
        else
        {
            [self.btnRight setTitle:@"编辑" forState:UIControlStateNormal];
            [self.btnRight mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake(45, Group_Btn_W));
            }];
            
            CGFloat w = self.frame.size.width;

            if (self.bottomView)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    [self.bottomView setFrame:CGRectMake(0, self.frame.size.height, w, Bottom_View_Height)];
                    [self.bottomView.superview layoutIfNeeded]; // 强制绘制
                }];
                
//                [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
//                                make.right.mas_equalTo(self.mas_right).offset(0);
//                    make.left.mas_equalTo(self.mas_left).offset(0);
//                    make.top.mas_equalTo(self.mas_bottom).offset(0);
//                    make.height.mas_equalTo(Bottom_View_Height);
//                }];
                [_tableview mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.mas_bottom).offset(0);
                }];
            }
        }
    }
 
}
-(void)floatbtnClick:(UIButton *)btn
{
    if(btn)
    {
        [_floatButton setImage:[UIImage imageNamed:@"devnewicom"] forState:UIControlStateNormal];

        LFPopupMenuItem *item1 = [LFPopupMenuItem createWithTitle:@"新建投影机" image:[UIImage imageNamed:@"icon_menu_record_normal"]];
            LFPopupMenuItem *item2 = [LFPopupMenuItem createWithTitle:@"新建分组" image:[UIImage imageNamed:@"icon_menu_shoot_normal"]];
//            LFPopupMenuItem *item3 = [LFPopupMenuItem createWithTitle:@"相册" image:[UIImage imageNamed:@"icon_menu_album_normal"]];
        NSArray *array = @[item1, item2];

        LFPopupMenu *menu = [[LFPopupMenu alloc] init];
        WS(weakSelf);
        [menu configWithItems:array action:^(NSInteger index) {
                               NSLog(@"点击了第%zi个",index);
            if(index == 0)//新增投影机
            {
//                [weakSelf newDeviceView];
                weakSelf.devView = [[APNewDeviceView alloc] init];
                AppDelegate *appDelegate = kAppDelegate;
                UIViewController *vc = appDelegate.mainVC;
                [vc.view addSubview:weakSelf.devView];
                [vc.view bringSubviewToFront:weakSelf.devView];
                weakSelf.devView.groupData = [NSMutableArray arrayWithArray:weakSelf.groupData];
                weakSelf.devView.modelData = [NSMutableArray arrayWithArray:weakSelf.modelData];

                //ok按钮
                [weakSelf.devView setOkBtnClickBlock:^(BOOL index) {
                    [weakSelf.devView removeFromSuperview];
                                    weakSelf.floatButton.hidden = NO;

                }];
                //取消按钮
                [weakSelf.devView setCancelBtnClickBlock:^(BOOL index) {
                    [weakSelf.devView removeFromSuperview];

                    weakSelf.floatButton.hidden = NO;

                }];
                
                weakSelf.floatButton.hidden = YES;

            }
            else if (index == 1)//新增分组
            {
                
                weakSelf.createGroupView = [[APNewGroupView alloc] init];
                AppDelegate *appDelegate = kAppDelegate;
                UIViewController *vc = appDelegate.mainVC;
                [vc.view addSubview:weakSelf.createGroupView];
                [vc.view bringSubviewToFront:weakSelf.createGroupView];
                weakSelf.createGroupView.groupData = [NSMutableArray arrayWithArray:weakSelf.groupData];
//                weakSelf.devView.modelData = [NSMutableArray arrayWithArray:weakSelf.modelData];

                //ok按钮
                [weakSelf.createGroupView setOkBtnClickBlock:^(BOOL index) {
                    [weakSelf.createGroupView removeFromSuperview];
                                    weakSelf.floatButton.hidden = NO;

                }];
                //取消按钮
                [weakSelf.createGroupView setCancelBtnClickBlock:^(BOOL index) {
                    [weakSelf.createGroupView removeFromSuperview];

                    weakSelf.floatButton.hidden = NO;

                }];
                
                weakSelf.floatButton.hidden = YES;
            }
        }];
            
        [menu showArrowToView:self.floatButton];
        
        [menu setDismissComplete:^{
            [weakSelf.floatButton setImage:[UIImage imageNamed:@"Group 11697"] forState:UIControlStateNormal];

        }];
    }
}
@end
