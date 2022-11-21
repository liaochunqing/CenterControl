//
//  APGroupView.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/16.
//

#import "APGroupView.h"
#import "APGroupNote.h"


//CGFloat Group_Btn_W = (30);
//CGFloat Bottom_View_Height = (88);

@implementation APGroupView 

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(void)createUI
{

    CGFloat x = 0;
    CGFloat y = H_SCALE(141);
    CGFloat w = Left_View_Width;
    CGFloat h = SCREEN_HEIGHT - y;
    
    [self setFrame:CGRectMake(x, y, w, h)];
//    self.backgroundColor = ColorHex(0x161635);
    
//    [self cteateSearchView];
    [self createButton];
        [self createTableview];

    [self createBottomView];
}

-(void)createTableview
{
    //----------------------------------中国的省地市关系图3,2,1--------------------------------------------
    APGroupNote *country1 = [[APGroupNote alloc] initWithParentId:-1 nodeId:0 imageName:@"Group 11674" name:@"展厅1" depth:0 height:Group_Cell_Height expand:YES selected:NO];
    APGroupNote *province1 = [[APGroupNote alloc] initWithParentId:0 nodeId:1 imageName:@"Group 11674" name:@"展厅1-1" depth:1 height:Group_Cell_Height expand:YES selected:NO];
    APGroupNote *city1 = [[APGroupNote alloc] initWithParentId:1 nodeId:2 imageName:@"Group 11661" name:@"投影机1001" depth:2 height:Group_Cell_Height expand:NO selected:NO];
    APGroupNote *city2 = [[APGroupNote alloc] initWithParentId:-1 nodeId:3 imageName:@"Group 11674" name:@"展厅2" depth:0 height:Group_Cell_Height expand:NO selected:NO];
    APGroupNote *city3 = [[APGroupNote alloc] initWithParentId:-1 nodeId:4 imageName:@"Group 11674" name:@"展厅3" depth:0 height:Group_Cell_Height expand:NO selected:NO];
    APGroupNote *province2 = [[APGroupNote alloc] initWithParentId:-1 nodeId:5 imageName:@"Group 11674" name:@"展厅4" depth:0 height:Group_Cell_Height expand:NO selected:NO];
    APGroupNote *city4 = [[APGroupNote alloc] initWithParentId:-1 nodeId:6 imageName:@"Group 11674" name:@"展厅5" depth:0 height:Group_Cell_Height expand:NO selected:NO];
//    APGroupNote *city5 = [[APGroupNote alloc] initWithParentId:5 nodeId:7 name:@"广州" depth:2 expand:NO];
//    APGroupNote *province3 = [[APGroupNote alloc] initWithParentId:0 nodeId:8 name:@"浙江" depth:1 expand:NO];
//    APGroupNote *city6 = [[APGroupNote alloc] initWithParentId:8 nodeId:9 name:@"杭州" depth:2 expand:NO];
//    //----------------------------------美国的省地市关系图0,1,2--------------------------------------------
//    APGroupNote *country2 = [[APGroupNote alloc] initWithParentId:-1 nodeId:10 name:@"美国" depth:0 expand:YES];
//    APGroupNote *province4 = [[APGroupNote alloc] initWithParentId:10 nodeId:11 name:@"纽约州" depth:1 expand:NO];
//    APGroupNote *province5 = [[APGroupNote alloc] initWithParentId:10 nodeId:12 name:@"德州" depth:1 expand:NO];
//    APGroupNote *city7 = [[APGroupNote alloc] initWithParentId:12 nodeId:13 name:@"休斯顿" depth:2 expand:NO];
//    APGroupNote *province6 = [[APGroupNote alloc] initWithParentId:10 nodeId:14 name:@"加州" depth:1 expand:NO];
//    APGroupNote *city8 = [[APGroupNote alloc] initWithParentId:14 nodeId:15 name:@"洛杉矶" depth:2 expand:NO];
//    APGroupNote *city9 = [[APGroupNote alloc] initWithParentId:14 nodeId:16 name:@"旧金山" depth:2 expand:NO];
//
//    //----------------------------------日本的省地市关系图0,1,2--------------------------------------------
//    APGroupNote *country3 = [[APGroupNote alloc] initWithParentId:-1 nodeId:17 name:@"日本" depth:0 expand:YES];
    NSArray *data = [NSArray arrayWithObjects:country1,province1,city1,city2,city3,province2,city4,nil];
    
    
    _tableview  = [[APGroupTableView alloc] init];
    _tableview.userInteractionEnabled = YES;
    [self addSubview:_tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Left_View_Width);
        make.top.mas_equalTo(self.mas_top).offset(80);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    
    [_tableview createTempData:data];
    
}

-(void)createBottomView
{
    self.bottomView = [[UIView alloc] init];
    [self addSubview:self.bottomView];
    self.bottomView.userInteractionEnabled = YES;
    self.bottomView.backgroundColor = ColorHex(0x1D2242 );
//    self.bottomView.hidden = YES;
    [self.bottomView setFrame:CGRectMake(0, self.frame.size.height, Left_View_Width, Bottom_View_Height)];
    
    NSDictionary *dict1 = @{@"string":@"重命名",
                           @"imageName":@"Group 11531",
    };
    NSDictionary *dict2 = @{@"string":@"删除",
                           @"imageName":@"Group 11533",
    };
    NSDictionary *dict3 = @{@"string":@"移动",
                           @"imageName":@"Group 11532",
    };
    NSDictionary *dict4 = @{@"string":@"。。。",
                           @"imageName":@"Group 11531",
    };
    
    
    NSArray *array = [NSArray arrayWithObjects:dict1, dict2, dict3, dict4,nil];
    
    CGFloat btnW = W_SCALE(50);
    CGFloat btnH = H_SCALE(60);
    CGFloat edgeGap = 2*Left_Gap;
    CGFloat x = edgeGap;
    CGFloat midGap = (Left_View_Width - 2*edgeGap - array.count*btnW)/(array.count - 1);

    for (int i = 0; i < array.count; i++)
    {
        NSDictionary *dic = array[i];
        if (dic == nil)
        {
            continue;
        }
        NSString *str = dic[@"string"];
        NSString *strImage = dic[@"imageName"];
        APBottomButton *button = [[APBottomButton alloc] initWithFrame:CGRectMake(x, (Bottom_View_Height-btnH)/2, btnW, btnH)];
//        [button setBackgroundImage:[self imageWithColor:ColorHex(0x7877A9)] forState:UIControlStateHighlighted];
//        button.backgroundColor = [UIColor redColor];
        [self.bottomView addSubview:button];

        if (str && str.length)
        {
            button.lab.text = str;
        }
        if (strImage && strImage.length)
        {
            [button.iv setImage:[UIImage imageNamed:strImage]];
        }
        if(i == 0)//默认选中第一个
        {
//            [button sendActionsForControlEvents:UIControlEventTouchUpInside];//代码点击
        }
        
        button.tag = i;
        [button addTarget:self action:@selector(btnBottomClick:) forControlEvents:UIControlEventTouchUpInside];

        x += btnW + midGap;
    }
    

}

-(void)createButton
{
    
    self.btnLeft = [UIButton new];
    [self addSubview:self.btnLeft];
//    [self.btnLeft setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateSelected];
    [self.btnLeft setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
    [self.btnLeft setTitle:@"全选" forState:UIControlStateNormal];
    ViewBorderRadius(self.btnLeft, 8, 1, ColorHex(0x4870EA));
    self.btnLeft.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [self.btnLeft setTitleColor:ColorHex(0xFFFFFF ) forState:UIControlStateNormal];
    [self.btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(57, Group_Btn_W));
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(45));
        make.left.equalTo(self.mas_left).offset(Left_Gap);
    }];
    [self.btnLeft addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    self.btnRight = [UIButton new];
    [self addSubview:self.btnRight];
    [self.btnRight setTitle:@"编辑" forState:UIControlStateNormal];
    self.btnRight.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [self.btnRight setTitleColor:ColorHex(0x3F6EF2) forState:UIControlStateNormal];
    [self.btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(W_SCALE(45), Group_Btn_W));
        make.top.mas_equalTo(self.mas_top).offset(H_SCALE(45));
        make.right.equalTo(self.mas_right).offset(-Left_Gap);
    }];
    [self.btnRight addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];


}

#pragma button响应
-(void)btnBottomClick:(UIButton *)btn
{
    if(btn)
    {
        
        switch (btn.tag) {
            case 0://按钮重命名
            {
//                [self createCommandView];
            }
                break;
            case 1://删除
            {
                [_tableview deleteSelectedNode];
            }
                break;
            case 2://移动
            {
//                [self creatCenterChuangeView];
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)btnClick:(UIButton *)btn
{
    if (btn == self.btnLeft)
    {
        
        self.btnLeft.selected = !self.btnLeft.selected;
        if(self.btnLeft.selected == YES)
        {
            [self.btnLeft setTitle:@"取消全选" forState:UIControlStateNormal];
            [self.btnLeft mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake(90, Group_Btn_W));
            }];
        }
        else
        {
            [self.btnLeft setTitle:@"全选" forState:UIControlStateNormal];
            [self.btnLeft mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake(57, Group_Btn_W));
            }];
        }
        
        [_tableview selectedAllWithSelected:self.btnLeft.selected];
    }
    
    if (btn == self.btnRight)
    {
        
        self.btnRight.selected = !self.btnRight.selected;
        if(self.btnRight.selected == YES)
        {
            [self.btnRight setTitle:@"完成编辑" forState:UIControlStateNormal];
            [self.btnRight mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake(70, Group_Btn_W));
            }];
            
            if (self.bottomView)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    [self.bottomView setFrame:CGRectMake(0, self.frame.size.height - Bottom_View_Height, Left_View_Width, Bottom_View_Height)];
//                    self.bottomView.hidden = NO;
                    [self.bottomView.superview layoutIfNeeded];//强制绘制
                }];
                
            }
        }
        else
        {
            [self.btnRight setTitle:@"编辑" forState:UIControlStateNormal];
            [self.btnRight mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake(45, Group_Btn_W));
            }];
            
            if (self.bottomView)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    [self.bottomView setFrame:CGRectMake(0, self.frame.size.height, Left_View_Width, Bottom_View_Height)];
                    [self.bottomView.superview layoutIfNeeded]; // 强制绘制 (重点是这句)
                }];
            }
        }
    }
 
}

-(void)cteateSearchView
{
//    UISearchBar *searchBar = [[UISearchBar alloc]init];
//        searchBar.placeholder = @"请输入搜索内容";
//        searchBar.barStyle = UISearchBarStyleMinimal;
//        searchBar.delegate = self;
//        UITextField *searchField1 = [searchBar valueForKey:@"_searchField"];
//        searchField1.backgroundColor = [UIColor whiteColor];
//        searchBar.tintColor = [UIColor blackColor];
//        [self.navigationController.navigationBar addSubview:searchBar];
}
@end
