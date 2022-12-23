//
//  APViewController.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/14.
//

#import "APViewController.h"
#import "AppDelegate.h"


@interface APViewController ()

@end

@implementation APViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ColorHex(0x8E8E92);
    
#if 1//是否需要登录界面
    [self createLoginView];
#else
    [self creatLeftView];
    [self creatCenterView];
#endif
}

-(void)createLoginView
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification  object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification  object:nil];
    
    UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bkView = im;
    im.image = [UIImage imageNamed:@"login"];
    im.userInteractionEnabled = YES;
    [self.view addSubview:im];
    
    UIView *baseview = [[UIView alloc] initWithFrame:CGRectMake(W_SCALE(375), H_SCALE(98), W_SCALE(443), H_SCALE(543))];
    baseview.backgroundColor = [UIColor whiteColor];
    ViewRadius(baseview, 10);
    [im addSubview:baseview];
    _loginView = baseview;
    
    
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
    _nameField.keyboardType = UIKeyboardTypeEmailAddress;
    _nameField.textColor = [UIColor blackColor];
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
    _pwField.keyboardType = UIKeyboardTypeEmailAddress;
    _pwField.secureTextEntry = YES;
    _pwField.textColor = [UIColor blackColor];
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
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    return YES;
}


#pragma button响应函数
-(void)btnClick:(UIButton *)btn
{
    if (([_pwField.text isEqualToString:@"admin"] && [_nameField.text isEqualToString:@"admin"])
         || ([_pwField.text isEqualToString:@""] && [_nameField.text isEqualToString:@""]))
    {
        if (_bkView)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

            [_bkView removeFromSuperview];
        }
        
        [self creatLeftView];
        [self creatCenterView];
    }
    else
    {
        NSString *t = @"提示";
        NSString *m = @"账号或密码不正确";
        UIAlertController  *alert = [UIAlertController alertControllerWithTitle:t message:m preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action2= [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                }];
//                    [action2 setValue:[UIColor blueColor] forKey:@"titleTextColor"];
        //修改title
//        [[APTool shareInstance] setAlterviewTitleWith:alert title:t color:[UIColor blackColor]];
//        [[APTool shareInstance] setAlterviewMessageWith:alert message:m color:[UIColor blackColor]];
//        [[APTool shareInstance] setAlterviewBackgroundColor:alert color:[UIColor whiteColor]];

//                    ViewRadius(alert, 5);
        [alert addAction:action2];
        AppDelegate *appDelegate = kAppDelegate;
        UIViewController *vc = appDelegate.mainVC;
        [vc presentViewController:alert animated:YES completion:nil];
    }
}

-(void)keyboardDidShow:(NSNotification *)aNotification
{
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = weakSelf.loginView.frame;
        frame.origin.y = H_SCALE(98-200);
        [weakSelf.loginView setFrame:frame];
    } completion:^(BOOL finished) {
        
    }];
}


-(void)keyboardDidHide:(NSNotification *)aNotification
{
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = weakSelf.loginView.frame;
        frame.origin.y = H_SCALE(98);
        [weakSelf.loginView setFrame:frame];
    } completion:^(BOOL finished) {
        
    }];
}
@end
