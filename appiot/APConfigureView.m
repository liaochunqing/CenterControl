//
//  APConfigureView.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/15.
//

#import "APConfigureView.h"

#define H_CELL H_SCALE(35)

@implementation APConfigureView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ColorHex(0x1D2242);

        [self createUI];
    }
    return self;
}


-(void)createUI
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

-(void)createScaleView
{
    CGFloat lineH = H_SCALE(30);//行高
    CGFloat labelW = W_SCALE(96);//左侧标题控件的宽度
    CGFloat labelFontSize = 16;
    UIColor *labelColor = ColorHex(0xA1A7C1);
    CGFloat textW = W_SCALE(135);
    
    CGFloat contentFontSize = 14;
    UIColor *contentColor = ColorHex(0xA1A7C1);
    
    
    /*************************************************画面比例*********************************************/
    
    UILabel *fenzuLab = [[UILabel alloc] init];
    [self addSubview:fenzuLab];
    fenzuLab.text = @"画面比例";
    fenzuLab.font = [UIFont systemFontOfSize:labelFontSize];
    fenzuLab.textColor = labelColor;
    [fenzuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(top_Gap);
        make.left.mas_equalTo(self.mas_left).offset(Left_Gap);
        make.size.mas_equalTo(CGSizeMake(labelW, lineH));
    }];
    
    //投影机分组的textfield
    _groupField = [UITextField new];
    _groupField.delegate = self;
    _groupField.textColor =contentColor;
    _groupField.textAlignment = NSTextAlignmentCenter;
    _groupField.font = [UIFont systemFontOfSize:contentFontSize];
    _groupField.placeholder = @"请选择";
    ViewBorderRadius(_groupField, 5, 1, ColorHex(0xABBDD5 ));
    [self addSubview:_groupField];
    
    [_groupField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(top_Gap);
        make.left.mas_equalTo(fenzuLab.mas_right).offset(Left_Gap);
        make.height.mas_equalTo(lineH);
        make.width.mas_equalTo(textW);
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
}
-(void)createInstallTypeView
{
    
    CGFloat lineH = H_SCALE(30);//行高
    CGFloat labelW = W_SCALE(96);//左侧标题控件的宽度
    CGFloat labelFontSize = 16;
    UIColor *labelColor = ColorHex(0xA1A7C1);
    CGFloat textW = W_SCALE(135);
    
    CGFloat contentFontSize = 14;
    UIColor *contentColor = ColorHex(0xA1A7C1);
    
    /*************************************************安装方式*********************************************/

    UILabel *jixingLab = [[UILabel alloc] init];
    [self addSubview:jixingLab];
    jixingLab.text = @"安装方式";
    jixingLab.font = [UIFont systemFontOfSize:labelFontSize];
    jixingLab.textColor = labelColor;
    [jixingLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_groupField.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(self.mas_left).offset(Left_Gap);
        make.size.mas_equalTo(CGSizeMake(labelW, lineH));
    }];
    
    //投影机分组的textfield
    _modelField = [UITextField new];
    _modelField.delegate = self;
    _modelField.textColor =contentColor;
    _modelField.textAlignment = NSTextAlignmentCenter;

    _modelField.font = [UIFont systemFontOfSize:contentFontSize];
    _modelField.placeholder = @"请选择";
    ViewBorderRadius(_modelField, 5, 1, ColorHex(0xABBDD5 ));
    [self addSubview:_modelField];

    [_modelField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_groupField.mas_bottom).offset(top_Gap);
            make.left.mas_equalTo(jixingLab.mas_right).offset(Left_Gap);
            make.height.mas_equalTo(lineH);
            make.width.mas_equalTo(textW);
    }];
    //展开箭头图标的创建
    _modelExpendIm = [UIImageView new];
    _modelExpendIm.contentMode=UIViewContentModeScaleAspectFill;
    [_modelField addSubview:_modelExpendIm];
    NSString* name = @"Vector(2)";
    _modelExpendIm.image = [UIImage imageNamed:name];
    [_modelExpendIm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_modelField);
        make.right.mas_equalTo(_modelField.mas_right).offset(-Left_Gap);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(12), W_SCALE(6)));
    }];

}



#pragma  mark 私有方法
-(void)setGroupTable
{
    if (_groupTableView == nil)
    {
        CGFloat h = _groupData.count * H_CELL;
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
            make.height.mas_equalTo(h);
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

-(void)setModelTable
{
    if (_modelTableView == nil)
    {
        CGFloat h = _modelData.count * H_CELL;

        _modelTableView = [[UITableView alloc] init];
        _modelTableView.dataSource = self;
        _modelTableView.delegate = self;
        _modelTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _modelTableView.backgroundColor = [UIColor whiteColor];
        ViewBorderRadius(_modelTableView, 5, 1, ColorHex(0xABBDD5 ));
        [self addSubview:_modelTableView];
        [_modelTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_modelField.frame.size.width);
            make.top.mas_equalTo(_modelField.mas_bottom).offset(0);
            make.left.mas_equalTo(_modelField.mas_left).offset(0);
            make.height.mas_equalTo(h);
        }];
    }
    else
    {
//        _groupTableView.hidden = !_groupTableView.hidden;
        [_modelTableView removeFromSuperview];
        _modelTableView = nil;
    }
    
//    if (_groupTableView)
    {
        NSString *name = _modelTableView?@"Vector(1)" : @"Vector(2)";
        _modelExpendIm.image = [UIImage imageNamed:name];
    }
}

-(void)sendDataToDevice:(NSString *)key
{
    if (_selectedDevArray && _selectedDevArray.count)
    {
        for (APGroupNote *node in _selectedDevArray)
        {
            NSData* sendData = node.installConfigDict[key];
            if (sendData == nil)
                continue;
            
            if ([@"tcp" compare:node.access_protocol options:NSCaseInsensitiveSearch |NSNumericSearch] ==NSOrderedSame)
            {
                NSLog(@"%@,ip=%@,port=%@,发送数据：%@",node.access_protocol,node.ip,node.port,sendData);

                APTcpSocket *tcpManager = [APTcpSocket shareManager];
                [tcpManager connectToHost:node.ip Port:[node.port intValue]];
                [tcpManager sendData:sendData];
            }
            else if ([@"udp" compare:node.access_protocol options:NSCaseInsensitiveSearch |NSNumericSearch] ==NSOrderedSame)
            {
                NSLog(@"%@,ip=%@,port=%@,发送数据：%@",node.access_protocol,node.ip,node.port,sendData);
                NSString *sss = [[NSString alloc] initWithData:sendData encoding:NSUTF8StringEncoding];

                APUdpSocket *udpManager = [APUdpSocket sharedInstance];
                udpManager.host = node.ip;//@"255.255.255.255";
                udpManager.port = [node.port intValue];
                [udpManager createClientUdpSocket];
                [udpManager sendMessage:sendData];
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
        [self createScaleView];
        [self createInstallTypeView];
        
        return;;
    }
    
    
    //1.获得数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbfileName = [doc stringByAppendingPathComponent:DB_NAME];
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:dbfileName];
    //3.打开数据库
    if ([db open])
    {
        //初始化数据容器
        _groupData = [NSMutableArray array];
        _modelData = [NSMutableArray array];

        // 获取安装调节界面的命令  （安装配置）install_config
        APGroupNote *node = _selectedDevArray[0];
        NSString* sqlStr = [NSString stringWithFormat:@"select l.exec_name,i.exec_code from zk_command_mount m,zk_execlist_info i ,dev_execlist l where m.model_id=%@ and m.tab_code='install_config' and  m.exec_info_id=i.id and m.dev_exec_id=l.id",node.model_id];
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while ([resultSet next])
        {
            NSString *exec_code = SafeStr([resultSet stringForColumn:@"exec_code"]);
            NSString *exec_name = SafeStr([resultSet stringForColumn:@"exec_name"]);
            if ([exec_code containsString:@"ImageScale-"])
            {
                NSDictionary *dict = [NSDictionary dictionaryWithObject:exec_name forKey:exec_code];
                [_groupData addObject:dict];
            }
            else if ([exec_code containsString:@"wayToInstall-"])
            {
                NSDictionary *dict = [NSDictionary dictionaryWithObject:exec_name forKey:exec_code];
                [_modelData addObject:dict];
            }
        }
        //关闭数据库
        [db close];
    }

    if(_groupData && _groupData.count)
    {
        [self createScaleView];
        NSDictionary *dict = _groupData[0];
        _groupField.text = [dict allValues][0] ;
    }
    if(_modelData && _modelData.count)
    {
        [self createInstallTypeView];
        NSDictionary *dict = _modelData[0];
        _modelField.text = [dict allValues][0] ;
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
    else if(textField == _modelField)
    {
        [self setModelTable];
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
    [textField resignFirstResponder];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [textField resignFirstResponder];
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
    
    if(_modelTableView)
    {
        [_modelTableView removeFromSuperview];
        _modelTableView = nil;
        NSString *name = _modelTableView?@"Vector(1)" : @"Vector(2)";
        _modelExpendIm.image = [UIImage imageNamed:name];
    }
}

#pragma mark *** UITableViewDelegate/UITableViewDataSource ***
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    if (tableView == _groupTableView)
    {
        return _groupData.count;
    }
    else if (tableView == _modelTableView)
    {
        return _modelData.count;
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
        NSDictionary *dict = _groupData[indexPath.row];
        NSString *str = [dict allValues][0];
        cell.textLabel.text = SafeStr(str);
    }
    else if(tableView == _modelTableView)
    {
        NSDictionary *dict = _modelData[indexPath.row];
        NSString *str = [dict allValues][0];
        cell.textLabel.text = SafeStr(str);
    }
    return cell;
}


 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return H_CELL;
}
 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSUInteger row = indexPath.row ;
    //
    if (tableView == _groupTableView)
    {
        NSDictionary *dict = _groupData[indexPath.row];
        NSString *str = [dict allValues][0];
        NSString *key = [dict allKeys][0];
        _groupField.text = SafeStr(str);
        [self setGroupTable];
        [self sendDataToDevice:SafeStr(key)];
    }
    else if (tableView == _modelTableView)
    {
        NSDictionary *dict = _modelData[indexPath.row];
        NSString *str = [dict allValues][0];
        NSString *key = [dict allKeys][0];
        _modelField.text = SafeStr(str);
        [self setModelTable];
        [self sendDataToDevice:SafeStr(key)];
    }
}

@end
