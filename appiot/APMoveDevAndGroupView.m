//
//  APMoveDevAndGroupView.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/9.
//

#import "APMoveDevAndGroupView.h"
#import "AppDelegate.h"
@implementation APMoveDevAndGroupView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.movetoGroupNode = [APGroupNote new];
        self.selectedData = [NSMutableArray array];
        self.groupData = [NSMutableArray array];
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    CGFloat lineH = H_SCALE(35);//行高
//    CGFloat labelW = W_SCALE(96);//左侧标题控件的宽度
    CGFloat labelFontSize = 14;
    UIColor *labelColor = ColorHex(0x434343);
//    CGFloat textLeft = labelW + 2*Left_Gap;//右侧控件与父控件的左侧距离
    
//    CGFloat contentFontSize = 14;
//    UIColor *contentColor = ColorHex(0x434343);
    
    _baseview = [UIView new];
    _baseview.backgroundColor = [UIColor whiteColor];
    ViewRadius(_baseview, 10);
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction)];
//    [_baseview addGestureRecognizer:singleTap];
    [self addSubview:_baseview];
    [_baseview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
//        make.centerY.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(120));
        make.size.mas_equalTo(CGSizeMake(W_SCALE(400), H_SCALE(550)));
    }];
 
    UILabel *namelab = [[UILabel alloc] init];
    [_baseview addSubview:namelab];
    namelab.text = @"移动至";
    namelab.textAlignment =  NSTextAlignmentCenter;
    namelab.font = [UIFont systemFontOfSize:20];
    namelab.textColor = ColorHex(0x1D2242);
    [namelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_baseview.mas_top).offset(Left_Gap);
        make.centerX.mas_equalTo(_baseview);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(176), H_SCALE(22)));
    }];
    
    
    UILabel *fenzuLab = [[UILabel alloc] init];
    _titleLab = fenzuLab;
    [_baseview addSubview:fenzuLab];
    fenzuLab.text = [NSString stringWithFormat:@"已选择%d个投影机",(int)_selectedData.count];
    fenzuLab.font = [UIFont systemFontOfSize:labelFontSize];
    fenzuLab.textColor = labelColor;
    [fenzuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(namelab.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(_baseview.mas_left).offset(Left_Gap);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(300), lineH));
    }];
    /************************************分割线****************************************************/
    UIImageView* line = [[UIImageView alloc] init];
    line.backgroundColor = ColorHex(0x8E8E92);
    [_baseview addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_baseview.mas_left).offset(0);
        make.right.mas_equalTo(_baseview.mas_right).offset(0);
        make.top.mas_equalTo(fenzuLab.mas_bottom).offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    if (_groupTableView == nil)
    {
        _groupTableView = [[UITableView alloc] init];
        _groupTableView.dataSource = self;
        _groupTableView.delegate = self;
        _groupTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _groupTableView.backgroundColor = [UIColor whiteColor];
//        _groupTableView.showsVerticalScrollIndicator = YES;
//        _groupTableView.showsHorizontalScrollIndicator = YES;
//        [_groupTableView flashScrollIndicators];
//        ViewBorderRadius(_groupTableView, 5, 1, ColorHex(0xABBDD5 ));
        [_baseview addSubview:_groupTableView];
        [_groupTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_baseview.mas_right).offset(0);
            make.top.mas_equalTo(line.mas_bottom).offset(5);
            make.left.mas_equalTo(_baseview.mas_left).offset(0);
            make.bottom.mas_equalTo(_baseview.mas_bottom).offset(-2*top_Gap- W_SCALE(33));
        }];
    }
    /************************************分割线****************************************************/
        line = [[UIImageView alloc] init];
        line.backgroundColor = ColorHex(0x8E8E92);
        [_baseview addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_baseview.mas_left).offset(0);
            make.right.mas_equalTo(_baseview.mas_right).offset(0);
            make.top.mas_equalTo(_groupTableView.mas_bottom).offset(0);
            make.height.mas_equalTo(0.5);
        }];
    
    
    UIButton *okbtn = [UIButton new];
    [_baseview addSubview:okbtn];
//    okbtn.backgroundColor = ColorHex(0x007AFF);
    //    ViewBorderRadius(okbtn, 5, 0.8, [UIColor grayColor]);
        ViewRadius(okbtn, 5);
    [okbtn setTitle:@"移动至此" forState:UIControlStateNormal];
    okbtn.enabled = NO;
    okbtn.backgroundColor = ColorHex(0xABBDD5);
    okbtn.tag = 0;
    _moveBtn = okbtn;
    [okbtn addTarget:self action:@selector(newDevBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [okbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(W_SCALE(90), H_SCALE(33)));
        make.bottom.mas_equalTo(_baseview.mas_bottom).offset(-top_Gap);
        make.right.mas_equalTo(_baseview.mas_right).offset(-W_SCALE(70));
    }];

    UIButton *cancelbtn = [UIButton new];
    [_baseview addSubview:cancelbtn];
    ViewBorderRadius(cancelbtn, 5, 0.8, [UIColor grayColor]);
    [cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbtn setTitleColor:ColorHex(0x1D2242) forState:UIControlStateNormal];
    cancelbtn.tag = 1;
    [cancelbtn addTarget:self action:@selector(newDevBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(W_SCALE(90), H_SCALE(33)));
        make.bottom.mas_equalTo(_baseview.mas_bottom).offset(-top_Gap);
        make.left.mas_equalTo(_baseview.mas_left).offset(W_SCALE(70));
    }];
    
}
-(void)setDefaultValue
{
    _titleLab.text = [NSString stringWithFormat:@"已选择%d个设备",(int)_selectedData.count];
}

//保存数据到数据库
-(void)writeDB
{
    //1.获得数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbfileName = [doc stringByAppendingPathComponent:DB_NAME];
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:dbfileName];
    //3.打开数据库
    if ([db open])
    {
        for (APGroupNote *node in _selectedData)
        {
            NSString *sqlStr = @"";
            if (node.isDevice)
            {
                sqlStr = [NSString stringWithFormat:@"UPDATE log_sn set group_id='%@' where gsn=='%@'",_movetoGroupNode.nodeId,node.nodeId];
            }
            else
            {
                sqlStr = [NSString stringWithFormat:@"UPDATE zk_group set pid='%@' where id=='%@'",_movetoGroupNode.nodeId,node.nodeId];
            }
            
            
            BOOL ret = [db executeUpdate:sqlStr];
            if  (ret)
            {
                NSLog(@"操作数据库成功");
//                AppDelegate *appDelegate = kAppDelegate;
//                APGroupView *vc = appDelegate.mainVC.leftView.groupView;
//                if (vc && [vc isKindOfClass:[APGroupView class]])
//                {
//                    [vc refreshTable];
//                }
                
            }
            else
            {
                NSLog(@"操作数据库错误");
            }
            
        }
        
              
        //关闭数据库
        [db close];
    }
}
#pragma  mark button delegate

-(void)newDevBtnClick:(UIButton *)btn
{
    if(btn.tag == 0)//确定
    {
        if(_movetoGroupNode.nodeId != nil)
        {
            [self writeDB];
            self.okBtnClickBlock(0);
        }
        else
        {
            self.cancelBtnClickBlock(1);
        }
    }
    else if(btn.tag == 1)
    {
        self.cancelBtnClickBlock(1);
    }
    
    [self removeFromSuperview];
}

#pragma mark *** UITableViewDelegate/UITableViewDataSource ***
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _groupData.count;

}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *NODE_CELL_ID = @"APNewDeviceView";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NODE_CELL_ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NODE_CELL_ID];
    }
    NSInteger row = [indexPath row];

    NSInteger oldRow = [self.lastPath row];

    if (row == oldRow && self.lastPath!=nil)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [cell.textLabel setTextColor:[UIColor blackColor]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.backgroundColor = [UIColor whiteColor];
    //设置被选中颜色
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = ColorHexAlpha(0x29315F, 0.2);//
    cell.imageView.image = [UIImage imageNamed:@"Group 11674"];
    if (tableView == _groupTableView)
    {
        APGroupNote *node = _groupData[indexPath.row];
        cell.textLabel.text = node.name;
    }
    return cell;
}


 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return H_SCALE(40);
}
 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSUInteger row = indexPath.row ;
    NSInteger newRow = [indexPath row];

    NSInteger oldRow = (self.lastPath !=nil)?[self.lastPath row]:-1;
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];

    if (newRow != oldRow)
    {
        
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastPath];
        
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        self.lastPath = indexPath;
    }
    else
    {        
        newCell.accessoryType = newCell.accessoryType == UITableViewCellAccessoryCheckmark?UITableViewCellAccessoryNone:UITableViewCellAccessoryCheckmark;
    }
    //
    if (newCell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        APGroupNote *node = _groupData[newRow];
        _movetoGroupNode.nodeId = node.nodeId;
        _moveBtn.enabled = YES;
        _moveBtn.backgroundColor = ColorHex(0x007AFF);
    }
    else if (newCell.accessoryType == UITableViewCellAccessoryNone)
    {
        _moveBtn.enabled = NO;
        _moveBtn.backgroundColor = ColorHex(0xABBDD5);
    }
}



@end
