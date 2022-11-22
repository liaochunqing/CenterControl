//
//  APGroupTableView.h
//  appiot
//
//  Created by App-Iot02 on 2022/11/17.
//

#import <UIKit/UIKit.h>
#import "APGroupNote.h"
#import "APGroupCell.h"
#import "config.h"

NS_ASSUME_NONNULL_BEGIN

@interface APGroupTableView : UITableView<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate>
@property (nonatomic , strong) NSMutableArray *data;//传递过来已经组织好的数据（全量数据）

@property (nonatomic , strong) NSMutableArray *tempData;//用于存储数据源（部分数据）
@property (nonatomic,strong)UISearchController *searchController;//搜索
@property (nonatomic,strong)NSMutableArray *filteredData;//存储搜索过滤后的数据



//-(NSMutableArray *)createTempData : (NSArray *)data;
-(void)selectedAllWithSelected:(BOOL)selected;
-(void)deleteSelectedNode;
@end

NS_ASSUME_NONNULL_END
