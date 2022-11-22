//
//  APGroupView.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/16.
//

#import "APGroupView.h"
#import "APGroupNote.h"


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
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;       // return NO to disallow editing.
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
//        for (int i = 0; i < _filteredData.count; i++)
//        {
//            APGroupNote *node = _filteredData[i];
//            if (node.parentId != -1)
//            {
//                for (int k = 0; k < _data.count; k++)
//                {
//                    APGroupNote *temp = _data[k];
//                    if (node.parentId == temp.nodeId)
//                    {
//                        temp.height = Group_Cell_Height;
//                        temp.expand = YES;
//                        [_filteredData addObject:temp];
//
//                        if (temp.parentId != -1)
//                        {
//                            for (int j = 0; j < _data.count; j++)
//                            {
//                                APGroupNote *temptemp = _data[k];
//                                if (temp.parentId == temptemp.nodeId)
//                                {
//                                    temptemp.height = Group_Cell_Height;
//                                    temptemp.expand = YES;
//                                    [_filteredData addObject:temptemp];
//                                    break;
//                                }
//                            }
//                            break;
//                        }
//
//                    }
//                }
//            }
//        }
    }
    else
    {
//        _filteredData = [_data mutableCopy];
        _isFieldActive = NO;
        [_tableview reloadData];
    }

    [_tableview reloadData];
    return YES;

}
-(void)createTableview
{
    //----------------------------------中国的省地市关系图3,2,1--------------------------------------------
    APGroupNote *country1 = [[APGroupNote alloc] initWithParentId:-1 nodeId:0 imageName:@"Group 11674" name:@"展厅1" depth:0 height:Group_Cell_Height expand:YES selected:NO];
    APGroupNote *province1 = [[APGroupNote alloc] initWithParentId:0 nodeId:1 imageName:@"Group 11674" name:@"展厅1-1" depth:1 height:Group_Cell_Height expand:YES selected:NO];
    APGroupNote *city1 = [[APGroupNote alloc] initWithParentId:1 nodeId:2 imageName:@"Group 11661" name:@"投影机1001" depth:2 height:Group_Cell_Height expand:NO selected:NO];
    APGroupNote *city2 = [[APGroupNote alloc] initWithParentId:-1 nodeId:3 imageName:@"Group 11674" name:@"展厅2" depth:0 height:Group_Cell_Height expand:NO selected:NO];
    APGroupNote *city3 = [[APGroupNote alloc] initWithParentId:-1 nodeId:4 imageName:@"Group 11674" name:@"展厅3" depth:0 height:Group_Cell_Height expand:NO selected:NO];
    APGroupNote *province2 = [[APGroupNote alloc] initWithParentId:-1 nodeId:5 imageName:@"Group 11674" name:@"展厅4" depth:0 height:Group_Cell_Height expand:NO selected:NO];
    APGroupNote *city4 = [[APGroupNote alloc] initWithParentId:-1 nodeId:6 imageName:@"Group 11674" name:@"展厅5" depth:0 height:Group_Cell_Height expand:NO selected:NO];
//    APGroupNote *city5 = [[APGroupNote alloc] initWithParentId:5 nodeId:7 name:@"广州" depth:2 expand:NO];
//    APGroupNote *province3 = [[APGroupNote alloc] initWithParentId:0 nodeId:8 name:@"浙江" depth:1 expand:NO];
//    APGroupNote *city6 = [[APGroupNote alloc] initWithParentId:8 nodeId:9 name:@"杭州" depth:2 expand:NO];
//    //----------------------------------美国的省地市关系图0,1,2--------------------------------------------
//    APGroupNote *country2 = [[APGroupNote alloc] initWithParentId:-1 nodeId:10 name:@"美国" depth:0 expand:YES];
//    APGroupNote *province4 = [[APGroupNote alloc] initWithParentId:10 nodeId:11 name:@"纽约州" depth:1 expand:NO];
//    APGroupNote *province5 = [[APGroupNote alloc] initWithParentId:10 nodeId:12 name:@"德州" depth:1 expand:NO];
//    APGroupNote *city7 = [[APGroupNote alloc] initWithParentId:12 nodeId:13 name:@"休斯顿" depth:2 expand:NO];
//    APGroupNote *province6 = [[APGroupNote alloc] initWithParentId:10 nodeId:14 name:@"加州" depth:1 expand:NO];
//    APGroupNote *city8 = [[APGroupNote alloc] initWithParentId:14 nodeId:15 name:@"洛杉矶" depth:2 expand:NO];
//    APGroupNote *city9 = [[APGroupNote alloc] initWithParentId:14 nodeId:16 name:@"旧金山" depth:2 expand:NO];
//
//    //----------------------------------日本的省地市关系图0,1,2--------------------------------------------
//    APGroupNote *country3 = [[APGroupNote alloc] initWithParentId:-1 nodeId:17 name:@"日本" depth:0 expand:YES];
    NSArray *data = [NSArray arrayWithObjects:country1,province1,city1,city2,city3,province2,city4,nil];
    
    
    _tableview  = [[APGroupTableView alloc] init];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    [self addSubview:_tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Left_View_Width);
        make.top.mas_equalTo(self.mas_top).offset(80);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    
    [self createTempData:data];
    
}


/**
 * 初始化数据源
 */
-(void)createTempData : (NSArray *)data{
//    _tempData = [NSMutableArray array];
    _data = [NSMutableArray array];

    
    for (int i=0; i<data.count; i++)
    {
        APGroupNote *node = [data objectAtIndex:i];
        [_data addObject:node];

//        if (node.expand) {
//            [_tempData addObject:node];
//        }
    }
//    return _tempData;
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
    NSDictionary *dict4 = @{@"string":@"。。。",
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
    
    self.btnLeft = [UIButton new];
    [self addSubview:self.btnLeft];
//    [self.btnLeft setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateSelected];
    [self.btnLeft setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
    [self.btnLeft setTitle:@"全选" forState:UIControlStateNormal];
    ViewBorderRadius(self.btnLeft, 8, 1, ColorHex(0x4870EA));
    self.btnLeft.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [self.btnLeft setTitleColor:ColorHex(0xFFFFFF ) forState:UIControlStateNormal];
    [self.btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(57, Group_Btn_W));
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(45));
        make.left.equalTo(self.mas_left).offset(Left_Gap);
    }];
    [self.btnLeft addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    self.btnRight = [UIButton new];
    [self addSubview:self.btnRight];
    [self.btnRight setTitle:@"编辑" forState:UIControlStateNormal];
    self.btnRight.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [self.btnRight setTitleColor:ColorHex(0x3F6EF2) forState:UIControlStateNormal];
    [self.btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(W_SCALE(45), Group_Btn_W));
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(45));
        make.right.equalTo(self.mas_right).offset(-Left_Gap);
    }];
    [self.btnRight addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];


}

#pragma mark 方法
-(void)selectedAllWithSelected:(BOOL)selected
{
    for (int k = 0; k < _data.count; k++)
    {
        APGroupNote *node = _data[k];
        node.selected = selected;
    }
    [_tableview reloadData];
}

#pragma  mark UISearchBarDelegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchText = searchController.searchBar.text;
    
    if (searchText.length>0)
    {
        if (_filteredData && _filteredData.count)
        {
            [_filteredData removeAllObjects];
        }
        else
        {
            _filteredData = [NSMutableArray array];
        }
        // 将搜索的结果存放到数组中
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[c] %@", searchText];
        _filteredData = [[self.data filteredArrayUsingPredicate:searchPredicate] mutableCopy];
        
        WS(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableview reloadData];
        });
    };
}
#pragma mark *** UITableViewDelegate/UITableViewDataSource ***
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    if (_searchController.active) {
//         return 1;
//    }
//    return 1;
//}
 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //控制器使用的时候，就是点击了搜索框的时候
    if (_isFieldActive)
    {
        return _filteredData.count;
    }
    
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

    [cell updateCellWithData:node];
    
//    WS(weakSelf);
    __block APGroupNote *temp = [_data objectAtIndex:indexPath.row];
    [cell setBtnClickBlock:^(BOOL index) {
        
        temp.selected = index;
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
    
    return 40;
}
 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row ;
    APGroupNote *node = _data[row];
    if (node == nil) return;
    
    if (node.expand == YES)
    {
        node.expand = !node.expand;
        for (int i = 0; i < _data.count; i++)
        {
            APGroupNote *second = _data[i];
            if (second.parentId == node.nodeId)
            {
                second.height = 0;
                
                for (int k = 0; k < _data.count; k++)
                {
                    APGroupNote *third = _data[k];
                    if (third.parentId == second.nodeId)
                    {
                        third.height = 0;
                    }
                }
            }
        }
    }
    else
    {
        node.expand = !node.expand;
        for (int i = 0; i < _data.count; i++)
        {
            APGroupNote *second = _data[i];
            if (second.parentId == node.nodeId)
            {
                second.height = Group_Cell_Height;
                if(second.expand == YES)
                {
                    for (int k = 0; k < _data.count; k++)
                    {
                        APGroupNote *third = _data[k];
                        if (third.parentId == second.nodeId)
                        {
                            third.height = Group_Cell_Height;
                        }
                    }
                }
            }
        }
    }
    
    [tableView reloadData];
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
                [_tableview deleteSelectedNode];
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
        if(self.btnLeft.selected == YES)
        {
            [self.btnLeft setTitle:@"取消全选" forState:UIControlStateNormal];
            [self.btnLeft mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake(90, Group_Btn_W));
            }];
        }
        else
        {
            [self.btnLeft setTitle:@"全选" forState:UIControlStateNormal];
            [self.btnLeft mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake(57, Group_Btn_W));
            }];
        }
        
        [self selectedAllWithSelected:self.btnLeft.selected];
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
                    [self.bottomView.superview layoutIfNeeded]; // 强制绘制 (重点是这句)
                }];
            }
        }
    }
 
}


@end
