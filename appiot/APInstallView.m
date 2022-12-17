//
//  APInstallView.m
//  appiot
//
//  Created by App-Iot02 on 2022/12/7.
//

#import "APInstallView.h"
#import "AppDelegate.h"

#define title_width W_SCALE(120)
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
    [self createMenuView];

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

-(void)createMenuView
{
    _menuView = [UIView new];
    [self addSubview:_menuView];
    [_menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(btn_height + top_Gap);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(H_SCALE(65));
    }];
    
    
    UIImageView *line = [[UIImageView alloc] init];
    line.backgroundColor = ColorHex(0x8E8E92);
    [_menuView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_menuView.mas_left).offset(0);
        make.right.mas_equalTo(_menuView.mas_right).offset(0);
        make.bottom.mas_equalTo(_menuView.mas_bottom).offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    NSArray *array = [NSArray arrayWithObjects:@"镜头调节", @"图像调节", @"色彩调节", @"画面剪裁", @"畸变校正", @"安装配置",@"信号",@"设置",@"连接控制",nil];
    
    self.menuBtnArray = [NSMutableArray array];

    CGFloat midGap = W_SCALE(23);
    CGFloat w = W_SCALE(68);
    int x = Left_Gap;
    for (int i = 0; i < array.count; i++)
    {
        NSString *str = array[i];
        APMenuButton *button = [[APMenuButton alloc] init];
        button.lab.text = str;
        button.tag = i;
        [button addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_menuView.mas_top).offset(0);
            make.bottom.mas_equalTo(_menuView.mas_bottom).offset(0);
            make.left.mas_equalTo(_menuView.mas_left).offset(x);
            make.width.mas_equalTo(w);
        }];
        
        if (i == 3 || i==4 || i== 8)
        {
            [button setEnabled:NO];
        }
//
        
        x += w + midGap;
        
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


//
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
    
    
    self.btnArray = [NSMutableArray array];
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
        [button addTarget:self action:@selector(btnDevClick:) forControlEvents:UIControlEventTouchUpInside];
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
        if (self.btnArray)
        {
            [self.btnArray addObject:button];
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

-(void)createConfigureView
{
    if (_configureView)
    {
        [_configureView removeFromSuperview];
        _configureView = nil;
    }
    
    _configureView = [[APConfigureView alloc] init];
    [self addSubview:_configureView];
    [_configureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_menuView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    
    NSArray *array = _sortData.count > 0?_sortData[_selectedModelTag] : [NSArray array];
    [_configureView setDefaultValue:array];
    [self bringSubviewToFront:_configureView];

}

-(void)createImageView
{
    if (_imageView)
    {
        [_imageView removeFromSuperview];
        _imageView = nil;
    }
    
    _imageView = [[APImageView alloc] init];
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_menuView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    
    NSArray *array = _sortData.count > 0?_sortData[_selectedModelTag] : [NSArray array];
    [_imageView setDefaultValue:array];
    [self bringSubviewToFront:_imageView];

}

-(void)createSceneView
{
    if (_sceneView)
    {
        [_sceneView removeFromSuperview];
        _sceneView = nil;
    }
    
    _sceneView = [[APSceneView alloc] init];
    [self addSubview:_sceneView];
    [_sceneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_menuView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    
    if(_sceneView && _sortData && _sortData.count)
    {
        [_sceneView createTestView:_sortData[_selectedModelTag]];
    }
    
    [self bringSubviewToFront:_sceneView];
}

#pragma mark 通知响应函数
-(void)notifySelectedDevChanged:(NSNotification *)notification
{
//    NSArray *arr = notification.userInfo[@"array"];
//    if (!arr) return;
    
    [self getDataFromLeftView];
}

#pragma button响应函数
-(void)btnDevClick:(UIButton *)btn
{
    if(btn)
    {
        //设置按钮切换后的颜色图片变化
        for (int i = 0; i < self.btnArray.count; i++)
        {
            UIButton *temp = self.btnArray[i];
            if (temp)
            {
                [temp setBackgroundImage:[self imageWithColor:ColorHex(0x29315F)] forState:UIControlStateNormal];
            }
        }
        [btn setBackgroundImage:[self imageWithColor:ColorHex(0x3F6EF2)] forState:UIControlStateNormal];
        
        _selectedModelTag = (int)btn.tag;
//        if(_sceneView && _sortData && _sortData.count)
//        {
//            [_sceneView createTestView:_sortData[_selectedModelTag]];
//        }
//        
//        if(_imageView && _sortData && _sortData.count)
//        {
//            [_imageView setDefaultValue:_sortData[_selectedModelTag]];
//        }
//        
//        if(_configureView != nil)
//        {
//            [_configureView removeFromSuperview];
//            _configureView = nil;
//            
//            _configureView = [[APConfigureView alloc] init];
//            [self addSubview:_configureView];
//            [_configureView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.mas_equalTo(_menuView.mas_bottom).offset(0);
//                make.left.mas_equalTo(self.mas_left).offset(0);
//                make.right.mas_equalTo(self.mas_right).offset(0);
//                make.bottom.mas_equalTo(self.mas_bottom).offset(0);
//            }];
//            
//            if(_configureView && _sortData && _sortData.count)
//            {
//                [_configureView setDefaultValue:_sortData[_selectedModelTag]];
//            }
//        }

        [self menuBtnClick:_menuBtnArray[_selectedMenuIndex]];
    }
}


-(void)menuBtnClick:(APMenuButton *)btn
{
    if(btn && btn.lab)
    {
        //设置按钮切换后的颜色图片变化
        for (int i = 0; i < self.menuBtnArray.count; i++)
        {
            APMenuButton *temp = self.menuBtnArray[i];
            if (temp)
            {
                temp.lab.textColor = ColorHex(0x9DA2B5);
                temp.iv.hidden = YES;
            }
        }
        btn.lab.textColor = ColorHex(0x3F6EF2);
        btn.iv.hidden = NO;
        
        _selectedMenuIndex = (int)btn.tag;
        
        switch (btn.tag) {
            case 0://
            {
                [self createSceneView];

            }
                break;
            case 1://
            {
                [self createImageView];
            }
                break;
            case 2://
            {
            }
                break;
                
            case 5://“
            {
                [self createConfigureView];
            }
                break;
                
            default:
                break;
        }
    }
}

@end
