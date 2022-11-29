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
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM zk_group"];
        // 遍历结果集
          while ([resultSet next])
          {
              APGroupNote *node = [APGroupNote new];
              node.isDevice = NO;

              node.name = SafeStr([resultSet stringForColumn:@"group_name"]);
              node.parentId = SafeStr([resultSet stringForColumn:@"pid"]);
              node.nodeId = SafeStr([resultSet stringForColumn:@"id"]);
              [_orgData addObject:node];
          }
        
        resultSet = [db executeQuery:@"SELECT * FROM log_sn"];
        // 遍历结果集
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

#pragma mark 方法
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
    AppDelegate *appDelegate = kAppDelegate;
    APMonitorView *vc = appDelegate.mainVC.centerView.monitorView;
    if (vc && [vc isKindOfClass:[APMonitorView class]])
    {
        NSArray *temp = [self getSelectedNode];
        [vc refreshTable:temp];
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
    
    //收集删除节点
    for (int i = 0; i < _data.count; i++)
    {
        APGroupNote *first = _data[i];
        if (first.selected)//第一层
        {
            for (int k = 0; k < _data.count; k++)
            {
                APGroupNote *second = _data[k];
                if([second.parentId isEqualToString:first.nodeId])
                {
                    for (int j = 0; j < _data.count; j++)
                    {
                        APGroupNote *third = _data[j];
                        if ([third.parentId isEqualToString:second.nodeId])
                        {
                            [set addIndex:j];
                        }
                    }
                    [set addIndex:k];
                }
            }
            [set addIndex:i];
        }
    }

    
    //删除节点刷新列表
    if (set.count > 0)
    {
        WS(weakSelf);
        UIAlertController  *alert = [UIAlertController alertControllerWithTitle:@"确认删除" message:@"删除后无法恢复" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
        {
            [weakSelf.data removeObjectsAtIndexes:set];
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
        return;
    }
    else
    {
//        node = [_data objectAtIndex:indexPath.row];
    }
    
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

        if (node.isDevice)
        {
            if (node.father)
                cell.selectBtn.selected ? node.father.childSelected++ : node.father.childSelected--;
            if (node.grandfather)
                cell.selectBtn.selected ? node.grandfather.childSelected++ : node.grandfather.childSelected--;
            
            
        }
        else
        {
            //如果是组并且有孩子，则所有孩子都被选中
            if (node.haveChild == YES)
            {
                for(APGroupNote *temp in _data)
                {
                    if ([temp.parentId isEqualToString:node.nodeId] || (temp.father && ([temp.father.parentId isEqualToString:node.nodeId])))
                    {
                        if (temp.father && temp.isDevice)
                        {
                            cell.selectBtn.selected ? temp.father.childSelected++ : temp.father.childSelected--;
                            if (temp.father.childSelected > temp.father.childNumber)
                                temp.father.childSelected = temp.father.childNumber;
                            if (temp.father.childSelected < 0)
                                temp.father.childSelected = 0;
                        }
                        if (temp.grandfather && temp.isDevice && temp.selected != cell.selectBtn.selected)
                        {
                            cell.selectBtn.selected ? temp.grandfather.childSelected++ : temp.grandfather.childSelected--;
                            if (temp.grandfather.childSelected > temp.grandfather.childNumber)
                                temp.grandfather.childSelected = temp.grandfather.childNumber;
                            if (temp.grandfather.childSelected < 0)
                                temp.grandfather.childSelected = 0;
                        }
                        
                        temp.selected = cell.selectBtn.selected;

                    }
                }
            }
        }
        [tableView reloadData];
        [self refrashAllselectTitle];
        [self refrashMonitorTable];
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


@end
