//
//  APSetNumberItem.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/15.
//

#import "APSetNumberItem.h"

@implementation APSetNumberItem


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createItem];
    }
    return self;
}


-(void)createItem
{
    
    CGFloat lineH = H_SCALE(30);//行高
    CGFloat labelW = W_SCALE(74);//左侧标题控件的宽度
    CGFloat labelFontSize = 15;
    UIColor *labelColor = ColorHex(0xA1A7C1);
    CGFloat textW = W_SCALE(72);
    CGFloat contentFontSize = 14;
    UIColor *contentColor = [UIColor whiteColor];//ColorHex(0xA1A7C1);
    
    UILabel *fenzuLab = [[UILabel alloc] init];
    _label = fenzuLab;
    fenzuLab.text = @"亮度对比";
    [self addSubview:fenzuLab];
    fenzuLab.font = [UIFont systemFontOfSize:labelFontSize];
    fenzuLab.textColor = labelColor;
    [fenzuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(labelW, lineH));
    }];
    
    
    _slider = [[UISlider alloc] init];
    _slider.value = 0;
    _slider.minimumValue = 0;
    _slider.maximumValue = 100;
    _slider.continuous = NO;
    [_slider addTarget:self action:@selector(sliderValueChange) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_slider];
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(_label.mas_right).offset(Left_Gap);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(200), lineH));
    }];
    
    
    _field = [UITextField new];
    _field.delegate = self;
    _field.textColor =contentColor;
    _field.textAlignment = NSTextAlignmentCenter;
    _field.font = [UIFont systemFontOfSize:contentFontSize];
    _field.keyboardType = UIKeyboardTypePhonePad;
    ViewBorderRadius(_field, 5, 1, ColorHex(0xADACA8));
    [self addSubview:_field];
    NSString *holderText = @"0";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                            value:ColorHex(0xABBDD5 )
                            range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:labelFontSize]
                            range:NSMakeRange(0, holderText.length)];
    _field.attributedPlaceholder = placeholder;

    [_field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.width.mas_equalTo(textW);
        make.height.mas_equalTo(lineH);
    }];
}

#pragma  mark sliderValueChange
-(void)sliderValueChange
{
//    NSLog(@"%d",(int)_slider.value);
    _field.text = [NSString stringWithFormat:@"%d",(int)_slider.value];
}

#pragma  mark textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

//写你要实现的：页面跳转的相关代码

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


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
//    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound)
//    {
//        return NO;
//    }
//
//    NSString * searchText = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
//
//    return YES;
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *regexStr = @"^\\d{0,3}$";
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@", regexStr];
        if([predicate evaluateWithObject:text] && [text integerValue] <= 100){
            [_slider setValue:text.intValue animated:YES];
            return YES;
        }
        return NO;

}

#pragma mark 对外接口
-(void)setDefaultValue:(NSArray *)array
{
    if (array == nil || array.count == 0)
        return;
//
//    _selectedDevArray = [NSMutableArray arrayWithArray:array];
//
//    //设置默认值
//    //1.获得数据库文件的路径
//    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *dbfileName = [doc stringByAppendingPathComponent:DB_NAME];
//    //2.获得数据库
//    FMDatabase *db = [FMDatabase databaseWithPath:dbfileName];
//    //3.打开数据库
//    if ([db open])
//    {
//        //初始化数据容器
//        _groupData = [NSMutableArray array];
//        _modelData = [NSMutableArray array];
//
//        // 获取安装调节界面的命令  （安装配置）install_config
//        APGroupNote *node = array[0];
//        NSString* sqlStr = [NSString stringWithFormat:@"select l.exec_name,i.exec_code from zk_command_mount m,zk_execlist_info i ,dev_execlist l where m.model_id=%@ and m.tab_code='install_config' and  m.exec_info_id=i.id and m.dev_exec_id=l.id",node.model_id];
//        FMResultSet *resultSet = [db executeQuery:sqlStr];
//        while ([resultSet next])
//        {
//            NSString *exec_code = SafeStr([resultSet stringForColumn:@"exec_code"]);
//            NSString *exec_name = SafeStr([resultSet stringForColumn:@"exec_name"]);
//            if ([exec_code containsString:@"ImageScale-"])
//            {
//                NSDictionary *dict = [NSDictionary dictionaryWithObject:exec_name forKey:exec_code];
//                [_groupData addObject:dict];
//            }
//            else if ([exec_code containsString:@"wayToInstall-"])
//            {
//                NSDictionary *dict = [NSDictionary dictionaryWithObject:exec_name forKey:exec_code];
//                [_modelData addObject:dict];
//            }
//        }
//        //关闭数据库
//        [db close];
//    }
//
//    if(_groupData && _groupData.count)
//    {
//        [self createScaleView];
//        NSDictionary *dict = _groupData[0];
//        _groupField.text = [dict allValues][0] ;
//    }
//    if(_modelData && _modelData.count)
//    {
//        [self createInstallTypeView];
//        NSDictionary *dict = _modelData[0];
//        _modelField.text = [dict allValues][0] ;
//    }
}


@end
