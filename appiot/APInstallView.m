//
//  APInstallView.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/7.
//

#import "APInstallView.h"
#import "AppDelegate.h"

#define title_width W_SCALE(118)
#define btn_height (H_SCALE(33))
#define btn_width W_SCALE(100)

@implementation APInstallView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    CGFloat x = Left_Gap;
    CGFloat y = Center_Top_Gap + Center_Btn_Heigth + top_Gap;
    CGFloat w = Center_View_Width- 2*Left_Gap;
    CGFloat h = SCREEN_HEIGHT - y - top_Gap;
    
    [self setFrame:CGRectMake(x, y, w, h)];
    self.backgroundColor = ColorHex(0x1D2242);
    ViewRadius(self, 10);
    
    //监听设备选中的通知
    [kNotificationCenter addObserver:self selector:@selector(notifySelectedDevChanged:) name:Notification_Get_SelectedDev object:nil];


    [self createSelectedView];
    [self getDataFromLeftView];

}


-(void)createSelectedView
{
    UILabel *fenzuLab = [[UILabel alloc] init];
    [self addSubview:fenzuLab];
    fenzuLab.text = @"当前已选设备";
    fenzuLab.font = [UIFont systemFontOfSize:17];
    fenzuLab.textColor = [UIColor whiteColor];
    [fenzuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(top_Gap);
        make.left.mas_equalTo(self.mas_left).offset(Left_Gap);
        make.size.mas_equalTo(CGSizeMake(title_width, btn_height));
    }];
}


//右侧顶部菜单
- (void)createModelDevice
{
    if (_baseView)
    {
        [_baseView removeFromSuperview];
    }
    _baseView = [UIView new];
    [self addSubview:_baseView];
    [_baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(top_Gap);
        make.left.mas_equalTo(self.mas_left).offset( Left_Gap + title_width + Left_Gap);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(btn_height);
    }];
    
    
    self.menuBtnArray = [NSMutableArray array];
//    CGFloat w = W_SCALE(102);
    CGFloat midGap = Left_Gap;
    int x = 0;
    for (int i = 0; i < _sortData.count; i++)
    {
        NSArray *array = _sortData[i];
        APGroupNote *node = array[0];
        UIButton *button = [[UIButton alloc] init];
        ViewRadius(button, 12);
        NSString *str = [NSString stringWithFormat:@"%@(%d台)",node.model_name,(int)array.count];
        [button setTitle:str forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize: 15.0];
        [button setTitleColor:ColorHex(0xFFFFFF ) forState:UIControlStateNormal];
        button.tag = i;
        [button setBackgroundImage:[self imageWithColor:ColorHex(0x29315F)] forState:UIControlStateNormal];
//      [button setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_baseView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_baseView.mas_top).offset(0);
            make.left.mas_equalTo(_baseView.mas_left).offset(x);
            make.size.mas_equalTo(CGSizeMake(btn_width, btn_height));
        }];
        x += btn_width + midGap;
        
        if(i == 0)//默认选中第一个
        {
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];//代码点击
        }
        if (self.menuBtnArray)
        {
            [self.menuBtnArray addObject:button];
        }
    }
}

#pragma mark 私有方法


-(void)getDataFromLeftView
{
    AppDelegate *appDelegate = kAppDelegate;
    APGroupView *vc = appDelegate.mainVC.leftView.groupView;
    if (vc && [vc isKindOfClass:[APGroupView class]])
    {
        NSArray *temp = [vc getSelectedDevice];
        if (!temp) return;
        
        if (_data && _data.count)
        {
            [_data removeAllObjects];
        }
        else
        {
            _data = [NSMutableArray array];
        }
        _data = [NSMutableArray arrayWithArray:temp];

        if (_data)
        {
            [self sort:_data];
            [self createModelDevice];
        }
    }
}

//按照model id分组）
-(void)sort:(NSArray *)array
{
    if (_sortData && _sortData.count)
    {
        [_sortData removeAllObjects];
    }
    else
    {
        _sortData = [NSMutableArray array];
    }
    
    NSMutableArray* copyArray = [NSMutableArray arrayWithArray:array];

            while (copyArray.count) {
                APGroupNote *node = copyArray[0];

                NSArray * tmpArray = [copyArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"model_id = %@",node.model_id]];
                [_sortData addObject:tmpArray];
                [copyArray removeObjectsInArray:tmpArray];
            }
}

#pragma mark 通知响应函数
-(void)notifySelectedDevChanged:(NSNotification *)notification
{
//    NSArray *arr = notification.userInfo[@"array"];
//    if (!arr) return;
    
    [self getDataFromLeftView];
}

#pragma button响应函数
-(void)btnClick:(UIButton *)btn
{
    if(btn)
    {
        //设置按钮切换后的颜色图片变化
        for (int i = 0; i < self.menuBtnArray.count; i++)
        {
            UIButton *temp = self.menuBtnArray[i];
            if (temp)
            {
                [temp setBackgroundImage:[self imageWithColor:ColorHex(0x29315F)] forState:UIControlStateNormal];
            }
        }
        [btn setBackgroundImage:[self imageWithColor:ColorHex(0x3F6EF2)] forState:UIControlStateNormal];
        
        switch (btn.tag) {
            case 0://
            {
//                [self createCommandView];
            }
                break;
            case 1://
            {
            }
                break;
            case 2://
            {
            }
                break;
                
            case 3://“
            {
            }
                break;
                
            default:
                break;
        }
    }
}

@end
