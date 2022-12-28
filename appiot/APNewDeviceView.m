//
//  APNewDeviceView.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/5.
//

#import "APNewDeviceView.h"
#import "AppDelegate.h"

@implementation APNewDeviceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.deviceInfo = [APGroupNote new];
        self.protocolData = [NSMutableArray arrayWithObjects:@"TCP",@"UDP",@"MQTT", nil];
        [self createUI];
    }
    return self;
}


-(void)createUI
{
    
    [self newDeviceView];
}

-(void)newDeviceView
{
    
    CGFloat lineH = H_SCALE(35);//行高
    CGFloat labelW = W_SCALE(96);//左侧标题控件的宽度
    CGFloat labelLeft = W_SCALE(30);//左侧控件与父控件的左侧距离
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
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(400), H_SCALE(550)));
    }];
 
    UILabel *namelab = [[UILabel alloc] init];
    [_baseview addSubview:namelab];
    namelab.text = @"新增投影机";
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
    fenzuLab.text = @"投影机分组";
    fenzuLab.font = [UIFont systemFontOfSize:labelFontSize];
    fenzuLab.textColor = labelColor;
    [fenzuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(namelab.mas_bottom).offset(W_SCALE(30));
        make.left.mas_equalTo(_baseview.mas_left).offset(labelLeft);
        make.size.mas_equalTo(CGSizeMake(labelW, lineH));
    }];
    
    //投影机分组的textfield
    _groupField = [UITextField new];
    _groupField.delegate = self;
    _groupField.textColor =contentColor;
    _groupField.textAlignment = NSTextAlignmentCenter;
    _groupField.font = [UIFont systemFontOfSize:contentFontSize];
//    _groupField.placeholder = @"请选择投影机的分组";
    
    NSString *holderText = @"请选择投影机的分组";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                            value:ColorHex(0xABBDD5 )
                            range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:labelFontSize]
                            range:NSMakeRange(0, holderText.length)];
    _groupField.attributedPlaceholder = placeholder;
    ViewBorderRadius(_groupField, 5, 1, ColorHex(0xABBDD5 ));
    [_baseview addSubview:_groupField];

    [_groupField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(namelab.mas_bottom).offset(W_SCALE(30));
        make.right.mas_equalTo(_baseview.mas_right).offset(-W_SCALE(30));
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
    devname.text = @"投影机名称";
    devname.font = [UIFont systemFontOfSize:labelFontSize];
    devname.textColor = labelColor;
    [devname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(fenzuLab.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(_baseview.mas_left).offset(labelLeft);
        make.size.mas_equalTo(CGSizeMake(labelW, lineH));
    }];
    
    _nameField = [UITextField new];
    _nameField.delegate = self;
    _nameField.textColor = contentColor;
    _nameField.textAlignment = NSTextAlignmentCenter;

    _nameField.font = [UIFont systemFontOfSize:contentFontSize];
//    _nameField.placeholder = @"请输入投影机名称";
    holderText = @"请输入投影机名称";
    placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                            value:ColorHex(0xABBDD5 )
                            range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:labelFontSize]
                            range:NSMakeRange(0, holderText.length)];
    _nameField.attributedPlaceholder = placeholder;
    ViewBorderRadius(_nameField, 5, 1, ColorHex(0xABBDD5 ));
    [_baseview addSubview:_nameField];

    [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(fenzuLab.mas_bottom).offset(top_Gap);
        make.right.mas_equalTo(_baseview.mas_right).offset(-W_SCALE(30));
        make.left.mas_equalTo(_baseview.mas_left).offset(textLeft);
        make.height.mas_equalTo(lineH);
    }];
 /**************************************************机型*********************************************/
    UILabel *jixingLab = [[UILabel alloc] init];
    [_baseview addSubview:jixingLab];
    jixingLab.text = @"机型";
    jixingLab.font = [UIFont systemFontOfSize:labelFontSize];
    jixingLab.textColor = labelColor;
    [jixingLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(devname.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(_baseview.mas_left).offset(labelLeft);
        make.size.mas_equalTo(CGSizeMake(labelW, lineH));
    }];
    
    //投影机分组的textfield
    _modelField = [UITextField new];
    _modelField.delegate = self;
    _modelField.textColor =contentColor;
    _modelField.textAlignment = NSTextAlignmentCenter;

    _modelField.font = [UIFont systemFontOfSize:contentFontSize];
//    _modelField.placeholder = @"请选择机型";
    
    holderText = @"请选择机型";
    placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                            value:ColorHex(0xABBDD5 )
                            range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:labelFontSize]
                            range:NSMakeRange(0, holderText.length)];
    _modelField.attributedPlaceholder = placeholder;
    ViewBorderRadius(_modelField, 5, 1, ColorHex(0xABBDD5 ));
    [_baseview addSubview:_modelField];

    [_modelField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(devname.mas_bottom).offset(top_Gap);
        make.right.mas_equalTo(_baseview.mas_right).offset(-W_SCALE(30));
        make.left.mas_equalTo(_baseview.mas_left).offset(textLeft);
        make.height.mas_equalTo(lineH);
    }];
    //展开箭头图标的创建
    _modelExpendIm = [UIImageView new];
    _modelExpendIm.contentMode=UIViewContentModeScaleAspectFill;
    [_modelField addSubview:_modelExpendIm];
    name = @"Vector(2)";
    _modelExpendIm.image = [UIImage imageNamed:name];
    [_modelExpendIm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_modelField);
        make.right.mas_equalTo(_modelField.mas_right).offset(-Left_Gap);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(12), W_SCALE(6)));
    }];
    
    /*************************************************投影机ID*********************************************/
    UILabel *devid = [[UILabel alloc] init];
    [_baseview addSubview:devid];
    devid.text = @"投影机ID";
    devid.font = [UIFont systemFontOfSize:labelFontSize];
    devid.textColor = labelColor;
    [devid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(jixingLab.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(_baseview.mas_left).offset(labelLeft);
        make.size.mas_equalTo(CGSizeMake(labelW, lineH));
    }];
    
    _idField = [UITextField new];
    _idField.delegate = self;
    _idField.textColor = contentColor;
    _idField.textAlignment = NSTextAlignmentCenter;
    _idField.keyboardType = UIKeyboardTypePhonePad;
    _idField.font = [UIFont systemFontOfSize:contentFontSize];
//    _idField.placeholder = @"请输入投影机的ID";
    
    holderText = @"请输入投影机的ID";
    placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                            value:ColorHex(0xABBDD5 )
                            range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:labelFontSize]
                            range:NSMakeRange(0, holderText.length)];
    _idField.attributedPlaceholder = placeholder;
    ViewBorderRadius(_idField, 5, 1, ColorHex(0xABBDD5 ));
    [_baseview addSubview:_idField];

    [_idField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(jixingLab.mas_bottom).offset(top_Gap);
        make.right.mas_equalTo(_baseview.mas_right).offset(-W_SCALE(30));
        make.left.mas_equalTo(_baseview.mas_left).offset(textLeft);
        make.height.mas_equalTo(lineH);
    }];
    
    /*************************网络设置**********************************/
    UILabel *netlab = [[UILabel alloc] init];
    [_baseview addSubview:netlab];
    netlab.text = @"网络设置";
//    netlab.textAlignment =  NSTextAlignmentCenter;
    netlab.font = [UIFont boldSystemFontOfSize:16];
    netlab.textColor = ColorHex(0x1D2242);
    [netlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_idField.mas_bottom).offset(W_SCALE(45));
        make.left.mas_equalTo(_baseview.mas_left).offset(labelLeft);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(176), H_SCALE(22)));
    }];
    
    /*************************接入协议**********************************/
    UILabel *protocolLab = [[UILabel alloc] init];
    [_baseview addSubview:protocolLab];
    protocolLab.text = @"接入协议";
    protocolLab.font = [UIFont systemFontOfSize:labelFontSize];
    protocolLab.textColor = labelColor;
    [protocolLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(netlab.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(_baseview.mas_left).offset(labelLeft);
        make.size.mas_equalTo(CGSizeMake(labelW, lineH));
    }];
    
    //投影机分组的textfield
    _protocolField = [UITextField new];
    _protocolField.delegate = self;
    _protocolField.textColor =contentColor;
    _protocolField.textAlignment = NSTextAlignmentCenter;
    _protocolField.font = [UIFont systemFontOfSize:contentFontSize];
//    _protocolField.placeholder = @"请选择接入协议";
    
    holderText = @"请选择接入协议";
    placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                            value:ColorHex(0xABBDD5 )
                            range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:labelFontSize]
                            range:NSMakeRange(0, holderText.length)];
    _protocolField.attributedPlaceholder = placeholder;
    ViewBorderRadius(_protocolField, 5, 1, ColorHex(0xABBDD5 ));
    [_baseview addSubview:_protocolField];

    [_protocolField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(netlab.mas_bottom).offset(top_Gap);
        make.right.mas_equalTo(_baseview.mas_right).offset(-W_SCALE(30));
        make.left.mas_equalTo(_baseview.mas_left).offset(textLeft);
        make.height.mas_equalTo(lineH);
    }];
    //展开箭头图标的创建
    _protocolExpendIm = [UIImageView new];
    _protocolExpendIm.contentMode=UIViewContentModeScaleAspectFill;
    [_protocolField addSubview:_protocolExpendIm];
    name = @"Vector(2)";
    _protocolExpendIm.image = [UIImage imageNamed:name];
    [_protocolExpendIm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_protocolField);
        make.right.mas_equalTo(_protocolField.mas_right).offset(-Left_Gap);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(12), W_SCALE(6)));
    }];

    
    /*************************IP**********************************/
    UILabel *iplab = [[UILabel alloc] init];
    [_baseview addSubview:iplab];
    iplab.text = @"IP地址";
    iplab.font = [UIFont systemFontOfSize:labelFontSize];
    iplab.textColor = labelColor;
    [iplab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(protocolLab.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(_baseview.mas_left).offset(labelLeft);
        make.size.mas_equalTo(CGSizeMake(labelW, lineH));
    }];
    
    _ipField = [UITextField new];
    _ipField.delegate = self;
    _ipField.textColor = contentColor;
    _ipField.textAlignment = NSTextAlignmentCenter;
    _ipField.keyboardType = UIKeyboardTypeDecimalPad;

    _ipField.font = [UIFont systemFontOfSize:contentFontSize];
//    _ipField.placeholder = @"请输入投影机的ip";
    
    holderText = @"请输入投影机的ip";
    placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                            value:ColorHex(0xABBDD5 )
                            range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:labelFontSize]
                            range:NSMakeRange(0, holderText.length)];
    _ipField.attributedPlaceholder = placeholder;
    ViewBorderRadius(_ipField, 5, 1, ColorHex(0xABBDD5 ));
    [_baseview addSubview:_ipField];

    [_ipField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(protocolLab.mas_bottom).offset(top_Gap);
        make.right.mas_equalTo(_baseview.mas_right).offset(-W_SCALE(30));
        make.left.mas_equalTo(_baseview.mas_left).offset(textLeft);
        make.height.mas_equalTo(lineH);
    }];
    /*************************端口**********************************/
    UILabel *portLab = [[UILabel alloc] init];
    [_baseview addSubview:portLab];
    portLab.text = @"端口";
    portLab.font = [UIFont systemFontOfSize:labelFontSize];
    portLab.textColor = labelColor;
    [portLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iplab.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(_baseview.mas_left).offset(labelLeft);
        make.size.mas_equalTo(CGSizeMake(labelW, lineH));
    }];
    
    _portField = [UITextField new];
    _portField.delegate = self;
    _portField.textColor = contentColor;
    _portField.textAlignment = NSTextAlignmentCenter;
    _portField.keyboardType = UIKeyboardTypeDecimalPad;
    _portField.font = [UIFont systemFontOfSize:contentFontSize];
//    _portField.placeholder = @"请输入投影机的端口";
    
    holderText = @"请输入投影机的端口";
    placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                            value:ColorHex(0xABBDD5 )
                            range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:labelFontSize]
                            range:NSMakeRange(0, holderText.length)];
    _portField.attributedPlaceholder = placeholder;
    ViewBorderRadius(_portField, 5, 1, ColorHex(0xABBDD5 ));
    [_baseview addSubview:_portField];

    [_portField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iplab.mas_bottom).offset(top_Gap);
        make.right.mas_equalTo(_baseview.mas_right).offset(-W_SCALE(30));
        make.left.mas_equalTo(_baseview.mas_left).offset(textLeft);
        make.height.mas_equalTo(lineH);
    }];
    
    
    
    UIButton *okbtn = [UIButton new];
    [_baseview addSubview:okbtn];
//    [okbtn setBackgroundColor:[UIColor blueColor] forState:UIControlStateNormal];
    okbtn.backgroundColor = ColorHex(0x007AFF);
//    ViewBorderRadius(okbtn, 5, 0.8, [UIColor grayColor]);
    ViewRadius(okbtn, 5);
    [okbtn setTitle:@"确定" forState:UIControlStateNormal];
    okbtn.tag = 0;
    [okbtn addTarget:self action:@selector(newDevBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [okbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(W_SCALE(90), H_SCALE(33)));
        make.bottom.mas_equalTo(_baseview.mas_bottom).offset(-top_Gap);
        make.right.mas_equalTo(_baseview.mas_right).offset(-W_SCALE(75));
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
        make.left.mas_equalTo(_baseview.mas_left).offset(W_SCALE(75));
    }];
    
}

#pragma  mark 私有方法
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
            make.bottom.mas_equalTo(_baseview.mas_bottom).offset(-H_SCALE(100));
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
            make.bottom.mas_equalTo(_baseview.mas_bottom).offset(-H_SCALE(100));
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


-(void)setProtocolTable
{
    if (_protocolTableView == nil)
    {
        
        _protocolTableView = [[UITableView alloc] init];
        _protocolTableView.dataSource = self;
        _protocolTableView.delegate = self;
        _protocolTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _protocolTableView.backgroundColor = [UIColor whiteColor];
        ViewBorderRadius(_protocolTableView, 5, 1, ColorHex(0xABBDD5 ));
        [self addSubview:_protocolTableView];
        [_protocolTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_protocolField.frame.size.width);
            make.top.mas_equalTo(_protocolField.mas_bottom).offset(0);
            make.left.mas_equalTo(_protocolField.mas_left).offset(0);
            make.bottom.mas_equalTo(_baseview.mas_bottom).offset(-H_SCALE(100));
        }];
    }
    else
    {
//        _groupTableView.hidden = !_groupTableView.hidden;
        [_protocolTableView removeFromSuperview];
        _protocolTableView = nil;
    }
    
//    if (_groupTableView)
    {
        NSString *name = _protocolTableView?@"Vector(1)" : @"Vector(2)";
        _protocolExpendIm.image = [UIImage imageNamed:name];
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
        NSString *sqlStr = [NSString stringWithFormat:@"insert into log_sn (group_id,device_name,model_id,gsn,access_protocol,ip,port) values ('%@','%@','%@','%@','%@','%@','%@')",_deviceInfo.parentId, _deviceInfo.name, _deviceInfo.model_id ,_deviceInfo.nodeId, _deviceInfo.access_protocol, _deviceInfo.ip, _deviceInfo.port];
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
        [_nameField resignFirstResponder];
        [_ipField resignFirstResponder];
        [_portField resignFirstResponder];
        [self setGroupTable];
        return NO;
    }
    else if(textField == _modelField)
    {
        [_nameField resignFirstResponder];
        [_ipField resignFirstResponder];
        [_portField resignFirstResponder];
        [self setModelTable];
        return NO;
    }
    else if(textField == _protocolField)
    {
        [_nameField resignFirstResponder];
        [_ipField resignFirstResponder];
        [_portField resignFirstResponder];
        [self setProtocolTable];
        return NO;
    }
    
    return YES;
}
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _ipField || textField == _portField)
    {
        
        WS(weakSelf);
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = weakSelf.baseview.frame;
            frame.origin.y -= H_SCALE(250);
            [weakSelf.baseview setFrame:frame];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _nameField )
    {
        _deviceInfo.name = SafeStr(textField.text);
    }
    else if (textField == _idField )
    {
        _deviceInfo.nodeId = SafeStr(textField.text);
    }
    else if (textField == _ipField )
    {
        _deviceInfo.ip = SafeStr(textField.text);
    }
    else if (textField == _portField )
    {
        _deviceInfo.port = SafeStr(textField.text);
    }
    
    //动画
    if (textField == _ipField || textField == _portField)
    {
        
        WS(weakSelf);
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = weakSelf.baseview.frame;
            frame.origin.y += H_SCALE(250);
            [weakSelf.baseview setFrame:frame];
        } completion:^(BOOL finished) {
            
        }];
    }
    
    [textField resignFirstResponder];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _idField)
    {
        NSCharacterSet*cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest) {
             
//                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                message:@"请输入数字"
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"确定"
//                                                      otherButtonTitles:nil];
//
//                [alert show];
            return NO;
                     
                }
    }
    else if (textField == _ipField)
    {
        NSString* ipEntered;
            if (![string isEqualToString:@""]) {

                ipEntered=[NSString stringWithFormat:@"%@%@",[textField.text substringToIndex: range.location],string];
            }

            NSString* validIPRegEx = @"^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])[.]){0,3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])?$";
            NSPredicate * emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validIPRegEx];
            if ([string isEqualToString:@""]) {

                return YES;
            }
            else if ([emailTest evaluateWithObject:ipEntered]){

                return YES;

            }
            else{

                return NO;
            }
    }
 
    
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
    if(_protocolTableView)
    {
        [_protocolTableView removeFromSuperview];
        _protocolTableView = nil;
        NSString *name = _protocolTableView?@"Vector(1)" : @"Vector(2)";
        _protocolExpendIm.image = [UIImage imageNamed:name];
    }
}

-(void)newDevBtnClick:(UIButton *)btn
{
    if(btn.tag == 0)//确定
    {
        if(_groupField.text.length == 0 ||
           _nameField.text.length == 0 ||
           _idField.text.length == 0 ||
           _protocolField.text.length == 0 ||
           _ipField.text.length == 0 ||
           _portField.text.length == 0 ||
           _modelField.text.length == 0)
        {
                    
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请补全信息"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];

            [alert show];
            return;
        }
        
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
    else if (tableView == _modelTableView)
    {
        return _modelData.count;
    }
    else if (tableView == _protocolTableView)
    {
        return _protocolData.count;
    }
    
    return count;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *NODE_CELL_ID = @"APNewDeviceView";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NODE_CELL_ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NODE_CELL_ID];
    }
    
//    for (UIView *subview in cell.contentView.subviews)
//    {
//        [subview removeFromSuperview];
//    }
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
    else if(tableView == _modelTableView)
    {
        APDevModel *node = _modelData[indexPath.row];

        cell.textLabel.text = node.modelName;
        
    }
    else if(tableView == _protocolTableView)
    {
        NSString *str = _protocolData[indexPath.row];

        cell.textLabel.text = SafeStr(str);
        
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
        _deviceInfo.parentId = node.nodeId;
        [self setGroupTable];
    }
    else if (tableView == _modelTableView)
    {
        APDevModel *node = _modelData[row];
        _modelField.text = node.modelName;
        _deviceInfo.model_id = node.modelId;
        [self setModelTable];
    }
    else if (tableView == _protocolTableView)
    {
        NSString *str = _protocolData[indexPath.row];
        _protocolField.text = SafeStr(str);
        _deviceInfo.access_protocol = SafeStr(str);
        [self setProtocolTable];
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.1;
//}



@end
