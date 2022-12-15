//
//  APImageView.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/15.
//

#import "APImageView.h"

@implementation APImageView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


-(void)createUI
{

    APSetNumberItem *numberItem = [APSetNumberItem new];
//    numberItem.backgroundColor = [UIColor redColor];
    [self addSubview:numberItem];
    [numberItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(top_Gap);
        make.left.mas_equalTo(self.mas_left).offset(Left_Gap);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(385), H_SCALE(30)));
    }];
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


//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
#pragma  mark button delegate
-(void)singleTapAction
{
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
}

@end
