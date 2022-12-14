//
//  APLeftView.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/14.
//

#import "APLeftView.h"
#import "APLeftPageButton.h"


#define btn_setting 100
#define btn_expend  101
#define btn_allSelected 102
#define btn_edit 103
#define btn_rename  104
#define btn_delete 105
#define btn_move 106


@implementation APLeftView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

//左侧view创建
-(void)createUI
{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = Left_View_Width;
    CGFloat h = SCREEN_HEIGHT;
    [self setFrame:CGRectMake(x, y, w, h)];
    self.backgroundColor = ColorHex(0x161635);

    [self createTitleView];
    [self createScrollMenu];
}


-(void)createTitleView
{
    self.topView = [[UILabel alloc] init];
    [self addSubview:self.topView];
    self.topView.backgroundColor = [UIColor clearColor];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(H_SCALE(35));
        make.right.equalTo(self).offset(0);
        make.height.mas_greaterThanOrEqualTo(H_SCALE(25));
    }];
    
    UILabel *titleLabel = [UILabel new];
    [self.topView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).offset(15);
        make.top.equalTo(self.topView).offset(0);
        make.bottom.equalTo(self.topView).offset(0);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    titleLabel.text = @"中控管理平台";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    
    self.btnRight = [UIButton new];
    [self.topView addSubview:self.btnRight];
    [self.btnRight setBackgroundImage:[UIImage imageNamed:@"Icon1"] forState:UIControlStateNormal];
//    self.btnRight.backgroundColor = [UIColor yellowColor];
    [self.btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(W_SCALE(22), H_SCALE(22)));
        make.centerY.mas_equalTo(self.topView);
        make.right.mas_equalTo(self.topView.mas_right).offset(-Left_Gap);
    }];
    [self.btnRight addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    self.btnLeft = [UIButton new];
    [self.topView addSubview:self.btnLeft];
    [self.btnLeft setBackgroundImage:[UIImage imageNamed:@"Group 11702"] forState:UIControlStateNormal];
    [self.btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(W_SCALE(22), H_SCALE(22)));
        make.centerY.mas_equalTo(self.topView);
        make.right.equalTo(self.btnRight.mas_left).offset(-W_SCALE(20));
    }];
}

- (void)createScrollMenu
{
    UIView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, H_SCALE(70), Left_View_Width, H_SCALE(60))];
    scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:scrollView];

    NSArray *array = [NSArray arrayWithObjects:@"分组", @"机型", @"图纸",nil];
    CGFloat midGap = (Left_View_Width - 2*Left_Gap - array.count*Page_Btn_W)/(array.count - 1);
    self.pageBtnArray = [NSMutableArray array];
    int x = Left_Gap;
    for (int i = 0; i < array.count; i++)
    {
        NSString *str = array[i];
        APLeftPageButton *button = [[APLeftPageButton alloc] initWithFrame:CGRectMake(x, ( H_SCALE(74)-Page_Btn_W)/2.0, Page_Btn_W, Page_Btn_W)];
        [button setTitle:str forState:UIControlStateNormal];
        [scrollView addSubview:button];
        button.tag = i;
        [button addTarget:self action:@selector(pageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (self.pageBtnArray)
        {
            [self.pageBtnArray addObject:button];
        }
        
        if(i == 0)//默认选中第一个
        {
//            [button setTitleColor:ColorHex(0x3F6EF2) forState:UIControlStateNormal];
//            button.line.hidden = NO;
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];//代码模拟点击事件
        }
        
        x += Page_Btn_W + midGap;
    }
}

#pragma button响应

-(void)btnClick:(UIButton *)btn
{
    if(btn)
    {
        if (btn.tag == 0)//按钮“控制”
        {
        }
        else
        {
            
        }
    }
}

-(void)pageBtnClick:(APLeftPageButton *)btn
{
    if(btn)
    {
        //设置按钮切换后的颜色图片变化
        for (int i = 0; i < self.pageBtnArray.count; i++)
        {
            APLeftPageButton *temp = self.pageBtnArray[i];
            if (temp)
            {
                //标题文本颜色
                [temp setTitleColor:ColorHex(0xABBDD5) forState:UIControlStateNormal];
                //标题文本颜色
//                [temp setTitleColor:ColorHex(0x3F6EF2) forState:UIControlStateNormal];
                temp.line.hidden = YES;
            }
        }
        
        [btn setTitleColor:ColorHex(0x3F6EF2) forState:UIControlStateNormal];
        btn.line.hidden = NO;
        
        switch (btn.tag) {
            case 0://按钮“分组”
            {
                if(self.groupView == nil)
                {
                    self.groupView = [[APGroupView alloc] init];
                    [self addSubview:self.groupView];
                }
                else
                {
                    [self bringSubviewToFront:self.groupView];
                }
            }
                break;
            case 1://按钮“机型”
            {
                
            }
                break;
            case 2://按钮“图纸”
            {
                
            }
                break;
                
            default:
                break;
        }
    }
}

@end
