//
//  APChooseItem.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/16.
//

#import "APChooseItem.h"
#define H_CELL H_SCALE(35)

@implementation APChooseItem


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


-(void)createUI
{
    [self createScaleView];
}

-(void)createScaleView
{
    CGFloat lineH = H_SCALE(30);//行高
    CGFloat labelW = W_SCALE(96);//左侧标题控件的宽度
    CGFloat labelFontSize = 15;
    UIColor *labelColor = ColorHex(0xA1A7C1);
    
    CGFloat textW = W_SCALE(115);
    CGFloat contentFontSize = 14;
    UIColor *contentColor = ColorHex(0xA1A7C1);
    
    
    /*************************************************画面比例*********************************************/
    
    _label = [[UILabel alloc] init];
    [self addSubview:_label];
    _label.text = @"动态对比度";
    _label.font = [UIFont systemFontOfSize:labelFontSize];
    _label.textColor = labelColor;
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(labelW, lineH));
    }];
    
    //投影机分组的textfield
    _field = [UITextField new];
    _field.delegate = self;
    _field.textColor =contentColor;
    _field.textAlignment = NSTextAlignmentCenter;
    _field.font = [UIFont systemFontOfSize:contentFontSize];
    _field.placeholder = @"请选择";
    ViewBorderRadius(_field, 5, 1, ColorHex(0xADACA8));
    [self addSubview:_field];
    
    [_field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(_label.mas_right).offset(Left_Gap);
        make.height.mas_equalTo(lineH);
        make.width.mas_equalTo(textW);
    }];
    //展开箭头图标的创建
    _expendIm = [UIImageView new];
    _expendIm.contentMode=UIViewContentModeScaleAspectFill;
    [self addSubview:_expendIm];
    NSString *name = @"Vector(2)";
    _expendIm.image = [UIImage imageNamed:name];
    [_expendIm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_field);
        make.right.mas_equalTo(_field.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(12), W_SCALE(6)));
    }];
}

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView*view = [super hitTest:point withEvent:event];
    if(view ==nil)
    {
        for(UIView*subView in self.subviews)
        {
            CGPoint myPoint = [subView convertPoint:point fromView:self];
            if(CGRectContainsPoint(subView.bounds, myPoint))
            {
                return subView;
            }
        }
    }
    return view;
}
#pragma  mark 私有方法
-(void)setTableStatus
{
    if (_tableView == nil)
    {
        CGFloat h = _dataArray.count * H_CELL;
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.alpha = 1;
        ViewRadius(_tableView, 5);
//        ViewBorderRadius(_tableView, 5, 1, ColorHex(0xABBDD5 ));
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_field.frame.size.width);
            make.top.mas_equalTo(_field.mas_bottom).offset(0);
            make.left.mas_equalTo(_field.mas_left).offset(0);
            make.height.mas_equalTo(h);
        }];
        [self.superview bringSubviewToFront:self];
    }
    else
    {
        [_tableView removeFromSuperview];
        _tableView = nil;
    }
    
    NSString *name = _tableView?@"Vector(1)" : @"Vector(2)";
    _expendIm.image = [UIImage imageNamed:name];
}


-(void)sendDataToDevice:(NSString *)key
{

}
#pragma mark 对外接口
-(void)setDefaultValue:(NSArray *)array
{
    if (array == nil || array.count == 0)
        return;
    //设置默认值

    _dataArray = [NSMutableArray arrayWithArray:array];
    id string = _dataArray[0];
//    if ([string isKindOfClass:[NSString class]])
    {
        _field.text = SafeStr(string);
    }
    
}

#pragma  mark textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

//写你要实现的：页面跳转的相关代码
//    if (textField == _groupField)
    {
        [self setTableStatus];
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
//-(void)singleTapAction
//{
//    if(_groupTableView)
//    {
//        [_groupTableView removeFromSuperview];
//        _groupTableView = nil;
//        NSString *name = _groupTableView?@"Vector(1)" : @"Vector(2)";
//        _groupExpendIm.image = [UIImage imageNamed:name];
//    }
//
//    if(_modelTableView)
//    {
//        [_modelTableView removeFromSuperview];
//        _modelTableView = nil;
//        NSString *name = _modelTableView?@"Vector(1)" : @"Vector(2)";
//        _modelExpendIm.image = [UIImage imageNamed:name];
//    }
//}

#pragma mark *** UITableViewDelegate/UITableViewDataSource ***
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    int count = 0;
    
    return _dataArray.count;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *NODE_CELL_ID = @"AchoseView";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NODE_CELL_ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NODE_CELL_ID];
    }
    
    [cell.textLabel setTextColor:[UIColor blackColor]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.backgroundColor = [UIColor whiteColor];
    cell.alpha = 1;
    //设置被选中颜色
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = ColorHex(0x29315F );//
//    if (tableView == _groupTableView)
    {
//        NSDictionary *dict = _dataArray[indexPath.row];
        NSString *str = _dataArray[indexPath.row];
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
    NSString *str = _dataArray[indexPath.row];
    _field.text = SafeStr(str);
    [self setTableStatus];
    
    if (self.cellClickBlock)
    {
        self.cellClickBlock(SafeStr(str));

    }
}



//
//-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
//{
//    UIView *view = [super hitTest:point withEvent:event];
//
//    if (view == nil)
//    {
//          //将坐标由当前视图发送到 指定视图 fromView是无法响应的范围小父视图
//
//         CGPoint stationPoint = [_tableView convertPoint:point fromView:self];
//
//        if (CGRectContainsPoint(_tableView.bounds, stationPoint))
//        {
//                     view = _tableView;
//        }
//
//    }
//    return view;
//}
@end
