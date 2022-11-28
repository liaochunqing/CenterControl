//
//  APGroupView.h
//  appiot
//
//  Created by App-Iot02 on 2022/11/16.
//

#import "APBaseView.h"
#import "APBottomButton.h"
#import "APGroupTableView.h"
#import "APDatabaseTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface APGroupView : APBaseView <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic)int allNumber;//所有设备数
@property (nonatomic)int selectedNumber;//被选中设备数
@property(nonatomic,strong)UIButton *btnLeft;//全选按钮
@property(nonatomic,strong)UILabel *allSelectLabel;//全选标题

@property(nonatomic,strong)UIButton *btnRight;//编辑按钮
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)APGroupTableView *tableview;

@property (nonatomic , strong) NSMutableArray *data;//组织好的数据
@property (nonatomic,strong)NSMutableArray *orgData;//数据库搜索上来的原始数据（全量数据）
@property (nonatomic,strong)NSMutableArray *filteredData;//存储搜索过滤后的数据
@property (nonatomic)BOOL isFieldActive;//是否正在使用
//@property (nonatomic,strong)APDatabaseTool *dbtool;
@end

NS_ASSUME_NONNULL_END
