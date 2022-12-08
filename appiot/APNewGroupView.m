//
//  APNewGroupView.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/8.
//

#import "APNewGroupView.h"
#import "AppDelegate.h"

@implementation APNewGroupView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.groupInfo = [APGroupNote new];
//        self.protocolData = [NSMutableArray arrayWithObjects:@"TCP",@"UDP",@"MQTT", nil];
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    
    CGFloat lineH = H_SCALE(35);//行高
    CGFloat labelW = W_SCALE(96);//左侧标题控件的宽度
    CGFloat labelFontSize = 14;
    UIColor *labelColor = ColorHex(0x434343);
    CGFloat textLeft = labelW + 2*Left_Gap;//右侧控件与父控件的左侧距离
    
    CGFloat contentFontSize = 14;
    UIColor *contentColor = ColorHex(0x434343);
    
    _baseview = [UIView new];
    _baseview.backgroundColor = [UIColor whiteColor];
    ViewRadius(_baseview, 10);
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction)];
    [_baseview addGestureRecognizer:singleTap];
    [self addSubview:_baseview];
    [_baseview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
//        make.centerY.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top).offset(-H_SCALE(600));
        make.size.mas_equalTo(CGSizeMake(W_SCALE(400), H_SCALE(250)));
    }];
 
    UILabel *namelab = [[UILabel alloc] init];
    [_baseview addSubview:namelab];
    namelab.text = @"新增分组";
    namelab.textAlignment =  NSTextAlignmentCenter;
    namelab.font = [UIFont systemFontOfSize:20];
    namelab.textColor = ColorHex(0x1D2242);
    [namelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_baseview.mas_top).offset(Left_Gap);
        make.centerX.mas_equalTo(_baseview);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(176), H_SCALE(22)));
    }];
    
    
    UILabel *fenzuLab = [[UILabel alloc] init];
    [_baseview addSubview:fenzuLab];
    fenzuLab.text = @"加入分组";
    fenzuLab.font = [UIFont systemFontOfSize:labelFontSize];
    fenzuLab.textColor = labelColor;
    [fenzuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(namelab.mas_bottom).offset(top_Gap*2);
        make.left.mas_equalTo(_baseview.mas_left).offset(Left_Gap);
        make.size.mas_equalTo(CGSizeMake(labelW, lineH));
    }];
    
    //投影机分组的textfield
    _groupField = [UITextField new];
    _groupField.delegate = self;
    _groupField.textColor =contentColor;
    _groupField.textAlignment = NSTextAlignmentCenter;
    _groupField.font = [UIFont systemFontOfSize:contentFontSize];
//    _groupField.placeholder = @"请选择要加入的分组";
    ViewBorderRadius(_groupField, 5, 1, ColorHex(0xABBDD5 ));
    [_baseview addSubview:_groupField];
    NSString *holderText = @"请选择要加入的分组";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                            value:ColorHex(0xABBDD5 )
                            range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:labelFontSize]
                            range:NSMakeRange(0, holderText.length)];
    _groupField.attributedPlaceholder = placeholder;

    [_groupField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(namelab.mas_bottom).offset(top_Gap*2);
        make.right.mas_equalTo(_baseview.mas_right).offset(-Left_Gap);
        make.left.mas_equalTo(_baseview.mas_left).offset(textLeft);
        make.height.mas_equalTo(lineH);
    }];
    //展开箭头图标的创建
    _groupExpendIm = [UIImageView new];
    _groupExpendIm.contentMode=UIViewContentModeScaleAspectFill;
    [_groupField addSubview:_groupExpendIm];
    NSString *name = @"Vector(2)";
    _groupExpendIm.image = [UIImage imageNamed:name];
    [_groupExpendIm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_groupField);
        make.right.mas_equalTo(_groupField.mas_right).offset(-Left_Gap);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(12), W_SCALE(6)));
    }];

    /*************************************************投影机名称*********************************************/

    //投影机名字
    UILabel *devname = [[UILabel alloc] init];
    [_baseview addSubview:devname];
    devname.text = @"新建分组名称";
    devname.font = [UIFont systemFontOfSize:labelFontSize];
    devname.textColor = labelColor;
    [devname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(fenzuLab.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(_baseview.mas_left).offset(Left_Gap);
        make.size.mas_equalTo(CGSizeMake(labelW, lineH));
    }];
    
    _nameField = [UITextField new];
    _nameField.delegate = self;
    _nameField.textColor = contentColor;
    _nameField.textAlignment = NSTextAlignmentCenter;

    _nameField.font = [UIFont systemFontOfSize:contentFontSize];
//    _nameField.placeholder = @"请输入分组名称";
    //改变搜索框中的placeholder的颜色
    NSString *holderText1 = @"请输入分组名称";
    NSMutableAttributedString *placeholder1 = [[NSMutableAttributedString alloc] initWithString:holderText1];
    [placeholder1 addAttribute:NSForegroundColorAttributeName
                            value:ColorHex(0xABBDD5 )
                            range:NSMakeRange(0, holderText1.length)];
    [placeholder1 addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:labelFontSize]
                            range:NSMakeRange(0, holderText1.length)];
    _nameField.attributedPlaceholder = placeholder1;
    ViewBorderRadius(_nameField, 5, 1, ColorHex(0xABBDD5 ));
    [_baseview addSubview:_nameField];

    [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(fenzuLab.mas_bottom).offset(top_Gap);
        make.right.mas_equalTo(_baseview.mas_right).offset(-Left_Gap);
        make.left.mas_equalTo(_baseview.mas_left).offset(textLeft);
        make.height.mas_equalTo(lineH);
    }];
    
    UIButton *okbtn = [UIButton new];
    [_baseview addSubview:okbtn];
//    [okbtn setBackgroundColor:[UIColor blueColor] forState:UIControlStateNormal];
    okbtn.backgroundColor = [UIColor blueColor];
    ViewBorderRadius(okbtn, 5, 0.8, [UIColor grayColor]);
    [okbtn setTitle:@"确定" forState:UIControlStateNormal];
    okbtn.tag = 0;
    [okbtn addTarget:self action:@selector(newDevBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [okbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(W_SCALE(100), H_SCALE(40)));
        make.bottom.mas_equalTo(_baseview.mas_bottom).offset(-top_Gap);
        make.right.mas_equalTo(_baseview.mas_right).offset(-W_SCALE(55));
    }];

    UIButton *cancelbtn = [UIButton new];
    [_baseview addSubview:cancelbtn];
    ViewBorderRadius(cancelbtn, 5, 0.8, [UIColor grayColor]);
    [cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbtn setTitleColor:ColorHex(0x1D2242) forState:UIControlStateNormal];
    cancelbtn.tag = 1;
    [cancelbtn addTarget:self action:@selector(newDevBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(W_SCALE(100), H_SCALE(40)));
        make.bottom.mas_equalTo(_baseview.mas_bottom).offset(-top_Gap);
        make.left.mas_equalTo(_baseview.mas_left).offset(W_SCALE(55));
    }];
    
}

-(void)setGroupTable
{
    if (_groupTableView == nil)
    {
        _groupTableView = [[UITableView alloc] init];
        _groupTableView.dataSource = self;
        _groupTableView.delegate = self;
        _groupTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _groupTableView.backgroundColor = [UIColor whiteColor];
        ViewBorderRadius(_groupTableView, 5, 1, ColorHex(0xABBDD5 ));
        [self addSubview:_groupTableView];
        [_groupTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_groupField.frame.size.width);
            make.top.mas_equalTo(_groupField.mas_bottom).offset(0);
            make.left.mas_equalTo(_groupField.mas_left).offset(0);
            make.bottom.mas_equalTo(_baseview.mas_bottom).offset(-top_Gap);
        }];
    }
    else
    {
//        _groupTableView.hidden = !_groupTableView.hidden;
        [_groupTableView removeFromSuperview];
        _groupTableView = nil;
    }
    
//    if (_groupTableView)
    {
        NSString *name = _groupTableView?@"Vector(1)" : @"Vector(2)";
        _groupExpendIm.image = [UIImage imageNamed:name];
    }
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
        NSString *sqlStr = [NSString stringWithFormat:@"insert into zk_group (group_name,pid) values ('%@','%@')",_groupInfo.name, _groupInfo.parentId];
        BOOL ret = [db executeUpdate:sqlStr];
        if  (ret)
        {
            AppDelegate *appDelegate = kAppDelegate;
            APGroupView *vc = appDelegate.mainVC.leftView.groupView;
            if (vc && [vc isKindOfClass:[APGroupView class]])
            {
                [vc refreshTable];
            }
        }
        else
        {
            NSLog(@"插入数据库错误");
        }
              
        //关闭数据库
        [db close];
    }
}

#pragma  mark textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

//写你要实现的：页面跳转的相关代码
    if (textField == _groupField)
    {
        [self setGroupTable];
        return NO;
    }
    return YES;
}
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _nameField )
    {
        _groupInfo.name = SafeStr(textField.text);
    }
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
    if(_groupTableView)
    {
        [_groupTableView removeFromSuperview];
        _groupTableView = nil;
        NSString *name = _groupTableView?@"Vector(1)" : @"Vector(2)";
        _groupExpendIm.image = [UIImage imageNamed:name];
    }
}

-(void)newDevBtnClick:(UIButton *)btn
{
    if(btn.tag == 0)//确定
    {
        self.okBtnClickBlock(0);
        [self writeDB];
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
    int count = 0;
    if (tableView == _groupTableView)
    {
        return _groupData.count;
    }
    
    return count;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *NODE_CELL_ID = @"APNewDeviceView";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NODE_CELL_ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NODE_CELL_ID];
    }
    
    [cell.textLabel setTextColor:[UIColor blackColor]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.backgroundColor = [UIColor whiteColor];
    //设置被选中颜色
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = ColorHex(0x29315F );//
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
    NSUInteger row = indexPath.row ;
    
    //
    if (tableView == _groupTableView)
    {
        APGroupNote *node = _groupData[row];
        _groupField.text = node.name;
        _groupInfo.parentId = node.nodeId;
        [self setGroupTable];
    }
}

@end
