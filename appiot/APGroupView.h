//
//  APGroupView.h
//  appiot
//
//  Created by App-Iot02 on 2022/11/16.
//

#import "APBaseView.h"
#import "APBottomButton.h"
#import "APGroupTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface APGroupView : APBaseView <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UIButton *btnLeft;//全选按钮
@property(nonatomic,strong)UIButton *btnRight;//编辑按钮
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)APGroupTableView *tableview;

@property (nonatomic , strong) NSMutableArray *data;//传递过来已经组织好的数据（全量数据）
//@property (nonatomic,strong)UISearchController *searchController;//搜索
@property (nonatomic,strong)NSMutableArray *filteredData;//存储搜索过滤后的数据
@property (nonatomic)BOOL isFieldActive;//是否正在使用

@end

NS_ASSUME_NONNULL_END
