//
//  APRenameView.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/30.
//

#import "APRenameView.h"
#import "AppDelegate.h"

@implementation APRenameView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        self.groupInfo = [APGroupNote new];
//        self.groupData = [NSMutableArray array];
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
    
    UIView *_baseview = [UIView new];
    _baseview.backgroundColor = [UIColor whiteColor];
    ViewRadius(_baseview, 10);
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction)];
//    [_baseview addGestureRecognizer:singleTap];
    [self addSubview:_baseview];
    [_baseview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
//        make.centerY.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(120));
        make.size.mas_equalTo(CGSizeMake(W_SCALE(400), H_SCALE(250)));
    }];
 
    UILabel *namelab = [[UILabel alloc] init];
    [_baseview addSubview:namelab];
    namelab.text = @"重命名";
    namelab.textAlignment =  NSTextAlignmentCenter;
    namelab.font = [UIFont systemFontOfSize:20];
    namelab.textColor = ColorHex(0x1D2242);
    [namelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_baseview.mas_top).offset(Left_Gap);
        make.centerX.mas_equalTo(_baseview);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(176), H_SCALE(22)));
    }];
    
    UIImageView *im = [[UIImageView alloc] init];
    im.image = [UIImage imageNamed:@"dev"];
    [_baseview addSubview:im];
    [im mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(namelab.mas_bottom).offset(3*Left_Gap);
        make.centerX.mas_equalTo(_baseview);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(85), H_SCALE(30)));
    }];
    
    /*************************************************投影机名称*********************************************/
    
    _nameField = [UITextField new];
    _nameField.delegate = self;
    _nameField.textColor = contentColor;
    _nameField.textAlignment = NSTextAlignmentCenter;
    [_nameField becomeFirstResponder];
    _nameField.font = [UIFont systemFontOfSize:contentFontSize];
    _nameField.backgroundColor = ColorHexAlpha(0xABBDD5, 0.5);
    //改变搜索框中的placeholder的颜色
    NSString *holderText1 = @"请输入名称";
    NSMutableAttributedString *placeholder1 = [[NSMutableAttributedString alloc] initWithString:holderText1];
    [placeholder1 addAttribute:NSForegroundColorAttributeName
                            value:ColorHex(0xABBDD5 )
                            range:NSMakeRange(0, holderText1.length)];
    [placeholder1 addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:labelFontSize]
                            range:NSMakeRange(0, holderText1.length)];
    _nameField.attributedPlaceholder = placeholder1;
//    ViewBorderRadius(_nameField, 5, 1, ColorHex(0xABBDD5 ));
    ViewRadius(_nameField, 3);
    [_baseview addSubview:_nameField];

    [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(namelab.mas_bottom).offset(top_Gap);
//        make.centerY.mas_equalTo(_baseview);
        make.top.mas_equalTo(im.mas_bottom).offset(2*Left_Gap);
        make.right.mas_equalTo(_baseview.mas_right).offset(-Left_Gap);
        make.left.mas_equalTo(_baseview.mas_left).offset(Left_Gap);
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
        NSString *sqlStr = [NSString stringWithFormat:@"UPDATE log_sn set device_name='%@' where gsn=='%@'",_deviceInfo.name,_deviceInfo.nodeId];
        
//        NSString *sqlStr = [NSString stringWithFormat:@"UPDATE log_sn set ip='%@' where gsn=='%@'",_deviceInfo.ip, _deviceInfo.nodeId];
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

#pragma mark 对外接口
-(void)setDefaultValue:(id)node
{
    APGroupNote *temp = (APGroupNote*)node;
    //设置默认值
    _nameField.text = SafeStr(temp.name);
    _deviceInfo = [APGroupNote new];
    _deviceInfo.name = temp.name;
    _deviceInfo.nodeId = temp.nodeId;
}
#pragma  mark textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

//写你要实现的：页面跳转的相关代码
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _deviceInfo.name = textField.text;
}


#pragma  mark button delegate

-(void)newDevBtnClick:(UIButton *)btn
{
    if(btn.tag == 0)//确定
    {
        if(_nameField.text.length == 0)
        {
                    
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"名称不能空"
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


@end
