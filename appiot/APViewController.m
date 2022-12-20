//
//  APViewController.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/14.
//

#import "APViewController.h"



@interface APViewController ()

@end

@implementation APViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ColorHex(0x8E8E92);
    [self createLoginView];
//    [self creatLeftView];
//    [self creatCenterView];
}

-(void)createLoginView
{
    UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _loginView = im;
    im.image = [UIImage imageNamed:@"login"];
    im.userInteractionEnabled = YES;
    [self.view addSubview:im];
    
    UIView *baseview = [[UIView alloc] initWithFrame:CGRectMake(W_SCALE(375), H_SCALE(98), W_SCALE(443), H_SCALE(543))];
    baseview.backgroundColor = [UIColor whiteColor];
    ViewRadius(baseview, 10);
    [im addSubview:baseview];
    
    
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = [UIImage imageNamed:@"Group 11705"];
    [baseview addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(baseview.mas_top).offset(36);
        make.centerX.mas_equalTo(baseview);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(105), H_SCALE(105)));
    }];
    
    UILabel *fenzuLab = [[UILabel alloc] init];
    fenzuLab.text = @"欢迎登录";
    fenzuLab.textAlignment = NSTextAlignmentCenter;
    [baseview addSubview:fenzuLab];
    fenzuLab.font = [UIFont systemFontOfSize:24];
    fenzuLab.textColor = ColorHex(0x3F6EF2 );
    [fenzuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(baseview.mas_top).offset(179);
        make.centerX.mas_equalTo(baseview);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(200), H_SCALE(50)));
    }];
    
    UIButton *okbtn = [UIButton new];
    [baseview addSubview:okbtn];
    okbtn.backgroundColor = ColorHex(0x3F6EF2);
    okbtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [okbtn setTitleColor:ColorHex(0xFFFFFF ) forState:UIControlStateNormal];
    ViewRadius(okbtn, 5);
    [okbtn setBackgroundImage:[[APTool shareInstance] imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];

    [okbtn setTitle:@"登录" forState:UIControlStateNormal];
    [okbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [okbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(W_SCALE(330), H_SCALE(52)));
        make.top.mas_equalTo(baseview.mas_top).offset(400);
        make.left.mas_equalTo(baseview.mas_left).offset(W_SCALE(57));
    }];
    
    //
    CGFloat lineH = H_SCALE(35);//行高
    CGFloat lineW = W_SCALE(330);//宽度
    CGFloat fontSize = 18;
    UIColor *color = ColorHex(0xA1A7C1);
    
    _nameField = [UITextField new];
    _nameField.delegate = self;
    _nameField.textColor = [UIColor whiteColor];
    _nameField.textAlignment = NSTextAlignmentLeft;
    _nameField.font = [UIFont systemFontOfSize:fontSize];
//    _nameField.placeholder = @"请输入账号";
    [baseview addSubview:_nameField];
    
    //改变搜索框中的placeholder的颜色
    NSString *holderText = @"请输入账号";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                            value:color
                            range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:fontSize]
                            range:NSMakeRange(0, holderText.length)];
    _nameField.attributedPlaceholder = placeholder;
    
    [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(baseview.mas_top).offset(H_SCALE(252));
        make.centerX.mas_equalTo(baseview);
        make.height.mas_equalTo(lineH);
        make.width.mas_equalTo(lineW);
    }];
    
    UIImageView *line = [[UIImageView alloc] init];
    line.backgroundColor = ColorHex(0xABBDD5);
    [_nameField addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameField.mas_left).offset(0);
        make.right.mas_equalTo(_nameField.mas_right).offset(0);
        make.bottom.mas_equalTo(_nameField.mas_bottom).offset(0);
        make.height.mas_equalTo(1);
    }];
    
    _pwField = [UITextField new];
    _pwField.delegate = self;
    _pwField.textColor = [UIColor whiteColor];
    _pwField.textAlignment = NSTextAlignmentLeft;
    _pwField.font = [UIFont systemFontOfSize:fontSize];
//    _pwField.placeholder = @"请输入密码";
    [baseview addSubview:_pwField];
    holderText = @"请输入密码";
    placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                            value:color
                            range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:fontSize]
                            range:NSMakeRange(0, holderText.length)];
    _pwField.attributedPlaceholder = placeholder;
    
    [_pwField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(baseview.mas_top).offset(H_SCALE(329));
        make.centerX.mas_equalTo(baseview);
        make.height.mas_equalTo(lineH);
        make.width.mas_equalTo(lineW);
    }];
    
    line = [[UIImageView alloc] init];
    line.backgroundColor = ColorHex(0xABBDD5);
    [_pwField addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_pwField.mas_left).offset(0);
        make.right.mas_equalTo(_pwField.mas_right).offset(0);
        make.bottom.mas_equalTo(_pwField.mas_bottom).offset(0);
        make.height.mas_equalTo(1);
    }];

}

//左侧view创建
-(void)creatLeftView
{
    self.leftView = [[APLeftView alloc] init];
    [self.view addSubview:self.leftView];
}

//右边view创建
-(void)creatCenterView
{
    self.centerView = [[APCenterView alloc] init];
    [self.view addSubview:self.centerView];
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
//    if (self.changedBlock)
//    {
//        self.changedBlock(SafeStr(_field.text));
//    }
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
    
//    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
//        NSString *regexStr = @"^\\d{0,3}$";
//
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@", regexStr];
//        if([predicate evaluateWithObject:text] && [text integerValue] <= 100){
//            [_slider setValue:text.intValue animated:YES];
//            return YES;
//        }
//        return NO;
    return YES;
}


#pragma button响应函数
-(void)btnClick:(UIButton *)btn
{
    if (_loginView)
    {
        [_loginView removeFromSuperview];
    }
    
    [self creatLeftView];
    [self creatCenterView];
}

@end
