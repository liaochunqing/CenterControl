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
    _baseview = [UIView new];
    _baseview.backgroundColor = [UIColor whiteColor];
    ViewRadius(_baseview, 10);
    [self addSubview:_baseview];
    [_baseview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(400), H_SCALE(550)));
    }];
 
    UILabel *namelab = [[UILabel alloc] init];
    [_baseview addSubview:namelab];
    namelab.text = @"新增投影机";
    namelab.font = [UIFont systemFontOfSize:18];
    namelab.textColor = ColorHex(0x1D2242);
    [namelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_baseview.mas_top).offset(Left_Gap);
        make.centerX.mas_equalTo(_baseview);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(176), H_SCALE(22)));
    }];
    
    CGFloat lineH = H_SCALE(30);
    CGFloat labelW = W_SCALE(100);
    CGFloat textLeft = labelW + 2*Left_Gap;
    
    
    UILabel *fenzuLab = [[UILabel alloc] init];
    [_baseview addSubview:fenzuLab];
    fenzuLab.text = @"投影机分组";
    fenzuLab.font = [UIFont systemFontOfSize:16];
    fenzuLab.textColor = ColorHex(0xCCCCCC);
    [fenzuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(namelab.mas_bottom).offset(top_Gap);
        make.left.mas_equalTo(_baseview.mas_left).offset(Left_Gap);
        make.size.mas_equalTo(CGSizeMake(labelW, lineH));
    }];
    //投影机分组的btn
//    UIButton *btn = [UIButton new];
    _groupField = [UITextField new];
    _groupField.delegate = self;
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

#pragma  mark textfield delegate


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

//写你要实现的：页面跳转的相关代码
    [self groupBtnClick:nil];
    return NO;

}


#pragma  mark button delegate
-(void)groupBtnClick:(UIButton *)btn
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
        _groupTableView.hidden = !_groupTableView.hidden;
    }
    
    if (_groupTableView)
    {
        NSString *name = _groupTableView.hidden?@"Vector(1)" : @"Vector(2)";
        _groupExpendIm.image = [UIImage imageNamed:name];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
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
    else
    {
//        node = [_data objectAtIndex:indexPath.row];
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
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.1;
//}



@end
