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
//    self.backgroundColor = ColorHex(0x161635);
    _data = [NSMutableArray array];
    _orgData = [NSMutableArray array];
    _allNumber = 0;
    _selectedNumber = 0;
    
    [self cteateSearchView];
    [self createButton];
    [self createTableview];
    [self createBottomView];
    
    //一秒后显示悬浮小球
    [self performSelector:@selector(createFloatButton) withObject:nil afterDelay:1];
}



-(void)cteateSearchView
{
    UITextField *filed = [[UITextField alloc] initWithFrame:CGRectMake(Left_Gap, 0, Left_View_Width - 2*Left_Gap, H_SCALE(38))];
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
                            value:[UIColor whiteColor]
                            range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:16]
                            range:NSMakeRange(0, holderText.length)];
    filed.attributedPlaceholder = placeholder;

    [self addSubview:filed];

}
-(void)createTableview
{    _tableview  = [[APGroupTableView alloc] init];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.separatorStyle = NO;

    UIView *View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Left_View_Width, 0.01)];
    View.backgroundColor = [UIColor clearColor];
    _tableview.tableHeaderView = View;
    
    [self addSubview:_tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Left_View_Width);
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(90));
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    
    [self createData];
}

-(NSData*)getSendDataFromParam:(NSString *)param
{
    NSString *temp = param;
    if ([param containsString:@"appotype:\"hex\""] )
    {
        NSArray *arr = [param componentsSeparatedByString:@"#"];
        temp = [arr lastObject];
    }
    else if ([param containsString:@"appotype:\"string\""])
    {
        NSArray *arr = [param componentsSeparatedByString:@"#"];
        temp = [arr firstObject];
    }
    
    NSString *str = [SafeStr(temp) stringByReplacingOccurrencesOfString:@"<CR>" withString:@"\r"];
    NSString *hex = [[APTool shareInstance] hexStringFromString:str];
    NSData *sendData = [[APTool shareInstance] convertHexStrToData:hex];
    
    return sendData;
}

/**
 * 初始化数据源
 */
-(void)createData
{
    //1.获得数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbfileName = [doc stringByAppendingPathComponent:DB_NAME];
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:dbfileName];
    //3.打开数据库
    if ([db open])
    {
        //查询设备
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM log_sn"];
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
              node.supply_status = SafeStr([resultSet stringForColumn:@"supply_status"]);
              node.shutter_status = SafeStr([resultSet stringForColumn:@"shutter_status"]);
              node.error_code = SafeStr([resultSet stringForColumn:@"new_error_code"]);
              node.device_id = SafeStr([resultSet stringForColumn:@"device_id"]);
              node.port = SafeStr([resultSet stringForColumn:@"port"]);
              node.access_protocol = SafeStr([resultSet stringForColumn:@"access_protocol"]);
              node.model_id = SafeStr([resultSet stringForColumn:@"model_id"]);

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
                NSData *data = [self getSendDataFromParam:param];
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
                NSData *data = [self getSendDataFromParam:param];
                [node.monitorDict setValue:data forKey:key];
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
            [_groupData addObject:node];
            [_orgData addObject:node];
        }
        
        //关闭数据库
        [db close];
    }
    
    NSMutableArray *firstArr = [NSMutableArray array];
    NSMutableArray *secondArr = [NSMutableArray array];
    for (APGroupNote *node in _orgData.reverseObjectEnumerator)
    {
        if ([node.parentId isEqualToString:@"0" ])
        {
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
//                temp.grandfatherId = node.parentId;
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
    
    [_tableview reloadData];
}


-(void)countChildNumberAndSelected
{
    for (APGroupNote *node in _data) {
        if (node.isDevice == NO && node.haveChild)
        {
            for (APGroupNote *temp in _data)
            {
                if(temp.isDevice)
                {
//                    if ([temp.parentId isEqualToString:node.nodeId] || [temp.grandfatherId isEqualToString:node.nodeId] )
//                    {
//                        node.childNumber++;
//                    }
                }
            }
        }
    }
}

-(void)createBottomView
{
    self.bottomView = [[UIView alloc] init];
    [self addSubview:self.bottomView];
    self.bottomView.userInteractionEnabled = YES;
    self.bottomView.backgroundColor = ColorHex(0x1D2242 );
//    self.bottomView.hidden = YES;
    [self.bottomView setFrame:CGRectMake(0, self.frame.size.height, Left_View_Width, Bottom_View_Height)];
    
    NSDictionary *dict1 = @{@"string":@"重命名",
                           @"imageName":@"Group 11531",
    };
    NSDictionary *dict2 = @{@"string":@"删除",
                           @"imageName":@"Group 11533",
    };
    NSDictionary *dict3 = @{@"string":@"移动",
                           @"imageName":@"Group 11532",
    };
    NSDictionary *dict4 = @{@"string":@"更多",
                           @"imageName":@"Group 11531",
    };
    
    
    NSArray *array = [NSArray arrayWithObjects:dict1, dict2, dict3, dict4,nil];
    
    CGFloat btnW = W_SCALE(50);
    CGFloat btnH = H_SCALE(60);
    CGFloat edgeGap = 2*Left_Gap;
    CGFloat x = edgeGap;
    CGFloat midGap = (Left_View_Width - 2*edgeGap - array.count*btnW)/(array.count - 1);

    for (int i = 0; i < array.count; i++)
    {
        NSDictionary *dic = array[i];
        if (dic == nil)
        {
            continue;
        }
        NSString *str = dic[@"string"];
        NSString *strImage = dic[@"imageName"];
        APBottomButton *button = [[APBottomButton alloc] initWithFrame:CGRectMake(x, (Bottom_View_Height-btnH)/2, btnW, btnH)];
//        [button setBackgroundImage:[self imageWithColor:ColorHex(0x7877A9)] forState:UIControlStateHighlighted];
//        button.backgroundColor = [UIColor redColor];
        [self.bottomView addSubview:button];

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

        x += btnW + midGap;
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
    [self.btnLeft addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
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
    [self.btnRight addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];


}
//悬浮小球 新加设备按钮
-(void)createFloatButton
{
    if (!_floatButton)
    {
        _floatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _floatButton.frame = CGRectMake(W_SCALE(250), H_SCALE(700), W_SCALE(55), H_SCALE(55));//初始在屏幕上的位置
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


-(void)locationChange:(UIPanGestureRecognizer*)p{
    CGFloat HEIGHT=_floatButton.frame.size.height;
    CGFloat WIDTH=_floatButton.frame.size.width;
    BOOL isOver = NO;
    CGPoint panPoint = [p locationInView:[UIApplication sharedApplication].windows[0]];
    CGRect frame = CGRectMake(panPoint.x, panPoint.y, HEIGHT, WIDTH);
    NSLog(@"%f--panPoint.x-%f-panPoint.y-", panPoint.x, panPoint.y);
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
#pragma mark 方法
-(void)countEveryGroupChildAndSelected
{
    NSMutableArray *arr = [NSMutableArray array];
    if (_isFieldActive)
    {
//        for(APGroupNote *temp in _filteredData)
//        {
//            if (temp.isDevice && temp.selected)
//            {
//                [arr addObject:temp];
//            }
//        }
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

-(NSArray *)getSelectedNode
{
    NSMutableArray *arr = [NSMutableArray array];
    if (_isFieldActive)
    {
        for(APGroupNote *temp in _filteredData)
        {
            if (temp.isDevice && temp.selected)
            {
                [arr addObject:temp];
            }
        }
    }
    else
    {
        for(APGroupNote *temp in _data)
        {
            if (temp.isDevice && temp.selected)
            {
                [arr addObject:temp];
            }
        }
    }
    
    
    return  arr;
}

-(void)refrashMonitorTable
{
    NSArray *temp = [self getSelectedNode];

    AppDelegate *appDelegate = kAppDelegate;
    APMonitorView *vc = appDelegate.mainVC.centerView.monitorView;
    if (vc && [vc isKindOfClass:[APMonitorView class]])
    {
        [vc refreshTable:temp];
    }
    
    APCommandView *cvc = appDelegate.mainVC.centerView.commandView;
    if (cvc && [cvc isKindOfClass:[APCommandView class]])
    {
        [cvc refreshSelectedList:temp];
    }
}

-(void)refrashAllselectTitle
{
    WS(weakSelf);
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        
        //执行耗时的异步操作...
        weakSelf.selectedNumber = 0;
        weakSelf.allNumber = 0;
        for(APGroupNote *temp in weakSelf.data)
        {
            if (temp.isDevice)
            {
                weakSelf.allNumber++;
                if (temp.selected)
                {
                    weakSelf.selectedNumber++;
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
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];//临时容器，存储将要删除的节点
    BOOL haveGroup = NO;
    
    //收集删除节点
    for (int i = 0; i < _data.count; i++)
    {
        APGroupNote *first = _data[i];
        if (first.selected)
        {
            [set addIndex:i];
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
                        [set addIndex:j];
                    }
                }
            }
        }
        
//        if (first.selected)//第一层
//        {
//            for (int k = 0; k < _data.count; k++)
//            {
//                APGroupNote *second = _data[k];
//                if([second.parentId isEqualToString:first.nodeId])
//                {
//                    for (int j = 0; j < _data.count; j++)
//                    {
//                        APGroupNote *third = _data[j];
//                        if ([third.parentId isEqualToString:second.nodeId])
//                        {
//                            [set addIndex:j];
//                        }
//                    }
//                    [set addIndex:k];
//                }
//            }
//            [set addIndex:i];
//        }
    }

    
    //删除节点刷新列表
    if (set.count > 0)
    {
        WS(weakSelf);
        NSString *msg = haveGroup?@"确认删除分组以及分组内的所有设备吗":@"确认删除设备吗";
        UIAlertController  *alert = [UIAlertController alertControllerWithTitle:msg message:@"删除后无法恢复" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
        {
            [weakSelf.data removeObjectsAtIndexes:set];
            [weakSelf refrashAllselectTitle];
            [weakSelf countEveryGroupChildAndSelected];
            [weakSelf.tableview reloadData];
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
                if(second.expand == YES)
                {
                    for (int k = 0; k < _data.count; k++)
                    {
                        APGroupNote *third = _data[k];
                        if([third.parentId isEqualToString:second.nodeId])
                        {
                            third.height = Group_Cell_Height;
                        }
                    }
                }
            }
        }
    }
    [weakSelf.tableview reloadData];
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
    
    [textField resignFirstResponder];
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
#pragma mark *** UITableViewDelegate/UITableViewDataSource ***
 
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
            
            [tableView reloadData];
            [self refrashMonitorTable];
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
                if (node.haveChild == YES)
                {
                    for(APGroupNote *temp in _data)
                    {
                        if ([temp.parentId isEqualToString:node.nodeId] || (temp.father && ([temp.father.parentId isEqualToString:node.nodeId])))
                        {
                            temp.selected = cell.selectBtn.selected;
                        }
                    }
                }
            }
            [self refrashAllselectTitle];
            [self refrashMonitorTable];
            [self countEveryGroupChildAndSelected];
            [tableView reloadData];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

#pragma button响应
-(void)btnBottomClick:(UIButton *)btn
{
    if(btn)
    {
        
        switch (btn.tag) {
            case 0://按钮重命名
            {
//                [self createCommandView];
            }
                break;
            case 1://删除
            {
                [self deleteSelectedNode];
            }
                break;
            case 2://移动
            {
//                [self creatCenterChuangeView];
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)btnClick:(UIButton *)btn
{
    if (btn == self.btnLeft)
    {
        
        self.btnLeft.selected = !self.btnLeft.selected;
        NSString *selectIamge = self.btnLeft.selected?@"all" : @"Ellipse 4";
        [self.btnLeft setImage:[UIImage imageNamed:selectIamge] forState:UIControlStateNormal];
        
        
        [self selectedAllWithSelected:self.btnLeft.selected];
        
        [self refrashAllselectTitle];
        [self refrashMonitorTable];

//        if(self.btnLeft.selected == YES)
//        {
//            [self.btnLeft setTitle:@"取消全选" forState:UIControlStateNormal];
//            [self.btnLeft mas_updateConstraints:^(MASConstraintMaker *make) {
//                            make.size.mas_equalTo(CGSizeMake(90, Group_Btn_W));
//            }];
//        }
//        else
//        {
//            [self.btnLeft setTitle:@"全选" forState:UIControlStateNormal];
//            [self.btnLeft mas_updateConstraints:^(MASConstraintMaker *make) {
//                            make.size.mas_equalTo(CGSizeMake(57, Group_Btn_W));
//            }];
//        }
        
    }
    
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
                [UIView animateWithDuration:0.3 animations:^{
                    [self.bottomView setFrame:CGRectMake(0, self.frame.size.height - Bottom_View_Height, Left_View_Width, Bottom_View_Height)];
//                    self.bottomView.hidden = NO;
                    [self.bottomView.superview layoutIfNeeded];//强制绘制
                }];
                
            }
        }
        else
        {
            [self.btnRight setTitle:@"编辑" forState:UIControlStateNormal];
            [self.btnRight mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake(45, Group_Btn_W));
            }];
            
            if (self.bottomView)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    [self.bottomView setFrame:CGRectMake(0, self.frame.size.height, Left_View_Width, Bottom_View_Height)];
                    [self.bottomView.superview layoutIfNeeded]; // 强制绘制
                }];
            }
        }
    }
 
}
-(void)floatbtnClick:(UIButton *)btn
{
    if(btn)
    {
        LFPopupMenuItem *item1 = [LFPopupMenuItem createWithTitle:@"新建投影机" image:[UIImage imageNamed:@"icon_menu_record_normal"]];
            LFPopupMenuItem *item2 = [LFPopupMenuItem createWithTitle:@"新建分组" image:[UIImage imageNamed:@"icon_menu_shoot_normal"]];
//            LFPopupMenuItem *item3 = [LFPopupMenuItem createWithTitle:@"相册" image:[UIImage imageNamed:@"icon_menu_album_normal"]];
        NSArray *array = @[item1, item2];

        LFPopupMenu *menu = [[LFPopupMenu alloc] init];
        WS(weakSelf);
        [menu configWithItems:array action:^(NSInteger index) {
                               NSLog(@"点击了第%zi个",index);
            if(index == 0)
            {
                [weakSelf newDeviceView];
            }
                           }];
            
        [menu showArrowToView:self.floatButton];
    }
}

-(void)groupBtnClick:(UIButton *)btn
{
    if(btn)
    {
        NSMutableArray *array = [NSMutableArray array];
        for (APGroupNote *temp in _groupData)
        {
            LFPopupMenuItem *item = [LFPopupMenuItem createWithTitle:temp.name image:[UIImage imageNamed:@"icon_menu_record_normal"]];
            [array addObject:item];
        }
        

        LFPopupMenu *menu = [[LFPopupMenu alloc] init];
        menu.minWidth = btn.frame.size.width;
        WS(weakSelf);
        [menu configWithItems:array action:^(NSInteger index)
         {
            NSLog(@"点击了第%zi个",index);
            if(index == 0)
            {
//                [weakSelf newDeviceView];
            }
        }];
            
        [menu showArrowToView:btn];
    }
}

-(void)newDevBtnClick:(UIButton *)btn
{
    if(btn.tag == 0)//确定
    {

    }
    else if(btn.tag == 1)
    {
    }
    
    [_devView removeFromSuperview];
    _floatButton.hidden = NO;
}
-(void)newDeviceView
{
    _floatButton.hidden = YES;
    
    _devView = [[UIView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    _devView.backgroundColor = [UIColor clearColor];
    AppDelegate *appDelegate = kAppDelegate;
    UIViewController *vc = appDelegate.mainVC;
    [vc.view addSubview:_devView];
    [vc.view bringSubviewToFront:_devView];
    
    UIView *baseview = [UIView new];
    baseview.backgroundColor = [UIColor whiteColor];
    ViewRadius(baseview, 10);
    [_devView addSubview:baseview];
    [baseview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_devView);
        make.centerY.mas_equalTo(_devView);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(400), H_SCALE(550)));
    }];
 
    UILabel *namelab = [[UILabel alloc] init];
    [baseview addSubview:namelab];
    namelab.text = @"新增投影机";
    namelab.font = [UIFont systemFontOfSize:20];
    namelab.textColor = ColorHex(0x1D2242);
    [namelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(baseview.mas_top).offset(Left_Gap);
        make.left.mas_equalTo(baseview.mas_left).offset(Left_Gap);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(176), H_SCALE(22)));
    }];
    
    CGFloat lineH = H_SCALE(30);
    CGFloat labelW = W_SCALE(100);
    CGFloat textLeft = labelW + 2*Left_Gap;
    
    
    UILabel *fenzuLab = [[UILabel alloc] init];
    [baseview addSubview:fenzuLab];
    fenzuLab.text = @"投影机分组";
    fenzuLab.font = [UIFont systemFontOfSize:16];
    fenzuLab.textColor = ColorHex(0xCCCCCC);
    [fenzuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(namelab.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(baseview.mas_left).offset(Left_Gap);
        make.size.mas_equalTo(CGSizeMake(labelW, lineH));
    }];
    //投影机分组的btn
    UIButton *btn = [UIButton new];
    ViewBorderRadius(btn, 5, 1, [UIColor grayColor]);
    [baseview addSubview:btn];

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(namelab.mas_bottom).offset(top_Gap);
        make.right.mas_equalTo(baseview.mas_right).offset(-Left_Gap);
        make.left.mas_equalTo(baseview.mas_left).offset(textLeft);
        make.height.mas_equalTo(lineH);
    }];
    [btn addTarget:self action:@selector(groupBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //展开箭头图标的创建
    UIImageView * expendIm = [UIImageView new];
    expendIm.contentMode=UIViewContentModeScaleAspectFill;
    [btn addSubview:expendIm];
    NSString *name = btn.selected?@"Vector(2)" : @"Vector(1)";
    expendIm.image = [UIImage imageNamed:name];
    [expendIm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btn);
        make.right.mas_equalTo(btn.mas_right).offset(-Left_Gap);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(12), W_SCALE(6)));
    }];

    
    UIButton *okbtn = [UIButton new];
    [baseview addSubview:okbtn];
//    [okbtn setBackgroundColor:[UIColor blueColor] forState:UIControlStateNormal];
    okbtn.backgroundColor = [UIColor blueColor];
    ViewBorderRadius(okbtn, 5, 0.8, [UIColor grayColor]);
    [okbtn setTitle:@"确定" forState:UIControlStateNormal];
    okbtn.tag = 0;
    [okbtn addTarget:self action:@selector(newDevBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [okbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(W_SCALE(100), H_SCALE(40)));
        make.bottom.mas_equalTo(baseview.mas_bottom).offset(-top_Gap);
        make.right.mas_equalTo(baseview.mas_right).offset(-W_SCALE(50));
    }];

    UIButton *cancelbtn = [UIButton new];
    [baseview addSubview:cancelbtn];
    ViewBorderRadius(cancelbtn, 5, 0.8, [UIColor grayColor]);
    [cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbtn setTitleColor:ColorHex(0xCCCCCC) forState:UIControlStateNormal];
    cancelbtn.tag = 1;
    [cancelbtn addTarget:self action:@selector(newDevBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(W_SCALE(100), H_SCALE(40)));
        make.bottom.mas_equalTo(baseview.mas_bottom).offset(-top_Gap);
        make.left.mas_equalTo(baseview.mas_left).offset(W_SCALE(50));
    }];
    



//    UIImageView *imzhan = [[UIImageView alloc] init];
//    imzhan.image = [UIImage imageNamed:imgName];
//    [firtRow addSubview:imzhan];
//    [imzhan mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(firtRow);
//        make.right.mas_equalTo(zhan.mas_left).offset(-3);
//        make.size.mas_equalTo(CGSizeMake(W_SCALE(16), H_SCALE(16)));
//    }];
//
//
//
//
//    //详情箭头图标
//    UIImageView *arror = [[UIImageView alloc] init];
//    arror.image = [UIImage imageNamed:@"arrorright"];
//    [self.contentView addSubview:arror];
//    [arror mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.contentView);
//        make.right.mas_equalTo(self.contentView.mas_right).offset(-Left_Gap);
//        make.size.mas_equalTo(CGSizeMake(W_SCALE(6), H_SCALE(12)));
//
//    }];
//
//    //底部分割线
//    UIImageView *bottomLine = [[UIImageView alloc] init];
//    bottomLine.backgroundColor = ColorHex(0x333A55);
//    [self.contentView addSubview:bottomLine];
//    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(1);
//        make.left.mas_equalTo(self.contentView.mas_left).offset(Left_Gap);
//        make.right.mas_equalTo(self.contentView.mas_right).offset(0);
//        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
//    }];
}
@end
