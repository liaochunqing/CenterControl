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
        [self initData];
        [self createUI];
        [self createChooseItems];
    }
    return self;
}

-(void)initData
{
    NSDictionary *dict = @{@"Standard":@"标准",@"Cinema":@"影院",@"REC709":@"REC709",@"DICOM":@"DICOM",@"LowLatency":@"低延迟",@"Customize":@"自定义",
    };
    _sceneModeDict = [NSMutableDictionary dictionaryWithDictionary:dict];
}


-(void)createUI
{
    CGFloat w = W_SCALE(385);
    CGFloat h = H_SCALE(30);
    CGFloat h_gap = H_SCALE(30);

    NSDictionary *dict1 = @{@"string":@"亮度",
                           @"imageName":@"Group 11715",
                            @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(15), H_SCALE(25) , w,h)],
    };
    NSDictionary *dict2 = @{@"string":@"对比度",
                            @"imageName":@"Group 11706",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(15), H_SCALE(25)+(h+h_gap),w,h)],
    };
    NSDictionary *dict3 = @{@"string":@"饱和度",
                            @"imageName":@"Group 11707",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(15), H_SCALE(25)+(h+h_gap)*2, w,h)],
    };
    NSDictionary *dict4 = @{@"string":@"锐度",
                            @"imageName":@"Group 11708",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(15), H_SCALE(25)+(h+h_gap)*3, w,h)],
    };
    
    NSDictionary *dict5 = @{@"string":@"红色增益",
                            @"imageName":@"Group 11708",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(15), H_SCALE(395), w,h)],
    };
    
    NSDictionary *dict6 = @{@"string":@"绿色增益",
                            @"imageName":@"Group 11706",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(15), H_SCALE(395)+(h+h_gap), w,h)],
    };
    
    NSDictionary *dict7 = @{@"string":@"蓝色增益",
                            @"imageName":@"Group 11708",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(15), H_SCALE(395)+(h+h_gap)*2, w,h)],
    };
    
    
    NSArray *array = [NSArray arrayWithObjects:dict1, dict2, dict3, dict4,dict5,dict6,dict7,nil];
    for (int i = 0; i < array.count; i++)
    {
        NSDictionary *dic = array[i];
        if (dic == nil)
        {
            continue;
        }
        NSString *str = dic[@"string"];
//        NSString *imgStr = dic[@"imageName"];
        CGRect rect = [dic[@"frame"] CGRectValue];
        
        APSetNumberItem *item = [[APSetNumberItem alloc] initWithFrame:rect];
        item.label.text = str;
        
//        ViewRadius(button, 3);
//        [button setBackgroundImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
//        button.tag = i;
//        [button addTarget:self action:@selector(btnDirectionClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
    }
}

-(void)createChooseItems
{
    CGFloat w = W_SCALE(200);
    CGFloat h = H_SCALE(30);
    CGFloat h_gap = H_SCALE(30);
    
    NSDictionary *dict1 = @{@"string":@"场景模式",
                           @"data":_sceneModeDict,
                            @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(507), H_SCALE(25) , w,h)],
    };
    NSDictionary *dict2 = @{@"string":@"动态对比度",
                            @"data":@"Group 11706",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(507), H_SCALE(25)+(h+h_gap),w,h)],
    };
    NSDictionary *dict3 = @{@"string":@"对比度增强",
                            @"data":@"Group 11707",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(507), H_SCALE(25)+(h+h_gap)*2, w,h)],
    };
    NSDictionary *dict4 = @{@"string":@"画面比例",
                            @"data":@"Group 11708",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(507), H_SCALE(25)+(h+h_gap)*3, w,h)],
    };
    
    NSDictionary *dict5 = @{@"string":@"gamma调节",
                            @"data":@"Group 11708",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(15), H_SCALE(275), w,h)],
    };
    
    NSDictionary *dict6 = @{@"string":@"色温调节",
                            @"data":@"Group 11706",
                             @"frame":[NSValue valueWithCGRect:CGRectMake(W_SCALE(15), H_SCALE(275)+(h+h_gap), w,h)],
    };
    
    NSArray *array = [NSArray arrayWithObjects:dict1, dict2, dict3, dict4,dict5,dict6,nil];
    for (int i = 0; i < array.count; i++)
    {
        NSDictionary *dic = array[i];
        if (dic == nil)
        {
            continue;
        }
        NSString *str = dic[@"string"];
        NSDictionary* dict = dic[@"data"];
        CGRect rect = [dic[@"frame"] CGRectValue];
        
        
        
        APChooseItem *item = [[APChooseItem alloc] initWithFrame:rect];
        [self addSubview:item];
        item.label.text = str;

        if(dict && dict.count && [dict isKindOfClass:[NSDictionary class]])
        {
            NSArray *allvalue = [_sceneModeDict allValues];
            NSArray *keys = [dict allKeys];
            [item setDefaultValue:allvalue];
        }
    }
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
    _selectedDevArray = [NSMutableArray arrayWithArray:array];
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
