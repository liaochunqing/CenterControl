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
    
    CGFloat lineH = H_SCALE(30);//行高
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
        make.top.mas_equalTo(namelab.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(_baseview.mas_left).offset(Left_Gap);
        make.size.mas_equalTo(CGSizeMake(labelW, lineH));
    }];
    
    //投影机分组的textfield
    _groupField = [UITextField new];
    _groupField.delegate = self;
    _groupField.textColor =contentColor;
    _groupField.textAlignment = NSTextAlignmentCenter;
    _groupField.font = [UIFont systemFontOfSize:contentFontSize];
    _groupField.placeholder = @"请选择投影机的分组";
    ViewBorderRadius(_groupField, 5, 1, ColorHex(0xABBDD5 ));
    [_baseview addSubview:_groupField];

    [_groupField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(namelab.mas_bottom).offset(top_Gap);
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

    
    //投影机名字
    UILabel *devname = [[UILabel alloc] init];
    [_baseview addSubview:devname];
    devname.text = @"投影机名称";
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

    _nameField.font = [UIFont systemFontOfSize:14];
    _nameField.placeholder = @"请输入投影机名称";
    ViewBorderRadius(_nameField, 5, 1, ColorHex(0xABBDD5 ));
    [_baseview addSubview:_nameField];

    [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(fenzuLab.mas_bottom).offset(top_Gap);
        make.right.mas_equalTo(_baseview.mas_right).offset(-Left_Gap);
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
        make.left.mas_equalTo(_baseview.mas_left).offset(Left_Gap);
        make.size.mas_equalTo(CGSizeMake(labelW, lineH));
    }];
    
    //投影机分组的textfield
    _modelField = [UITextField new];
    _modelField.delegate = self;
    _modelField.textColor =contentColor;
    _modelField.textAlignment = NSTextAlignmentCenter;

    _modelField.font = [UIFont systemFontOfSize:contentFontSize];
    _modelField.placeholder = @"请选择机型";
    ViewBorderRadius(_modelField, 5, 1, ColorHex(0xABBDD5 ));
    [_baseview addSubview:_modelField];

    [_modelField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(devname.mas_bottom).offset(top_Gap);
        make.right.mas_equalTo(_baseview.mas_right).offset(-Left_Gap);
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
        make.right.mas_equalTo(_baseview.mas_right).offset(-W_SCALE(50));
    }];

    UIButton *cancelbtn = [UIButton new];
    [_baseview addSubview:cancelbtn];
    ViewBorderRadius(cancelbtn, 5, 0.8, [UIColor grayColor]);
    [cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbtn setTitleColor:ColorHex(0xCCCCCC) forState:UIControlStateNormal];
    cancelbtn.tag = 1;
    [cancelbtn addTarget:self action:@selector(newDevBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(W_SCALE(100), H_SCALE(40)));
        make.bottom.mas_equalTo(_baseview.mas_bottom).offset(-top_Gap);
        make.left.mas_equalTo(_baseview.mas_left).offset(W_SCALE(50));
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


#pragma  mark textfield delegate


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

//写你要实现的：页面跳转的相关代码
    if (textField == _groupField)
    {
        [self setGroupTable];
        return NO;
    }
    else if(textField == _nameField)
    {
        return YES;
    }
    else if(textField == _modelField)
    {
        [self setModelTable];
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _nameField )
    {
        _deviceInfo.name = SafeStr(textField.text);
    }
}

#pragma  mark button delegate
-(void)singleTapAction
{
    if(_groupTableView)
    {
        [_groupTableView removeFromSuperview];
        _groupTableView = nil;
    }
    
    if(_modelTableView)
    {
        [_modelTableView removeFromSuperview];
        _modelTableView = nil;
    }
}

-(void)newDevBtnClick:(UIButton *)btn
{
    if(btn.tag == 0)//确定
    {
        self.okBtnClickBlock(0);
    }
    else if(btn.tag == 1)
    {
        self.cancelBtnClickBlock(1);
    }
    
    [self removeFromSuperview];
}

#pragma mark *** UITableViewDelegate/UITableViewDataSource ***
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
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
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.1;
//}



@end
