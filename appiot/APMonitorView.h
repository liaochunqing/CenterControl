//
//  APMonitorView.h
//  appiot
//
//  Created by App-Iot02 on 2022/11/23.
//

#import "APBaseView.h"
#import "APMonitorModel.h"
#include "APMonitorCell.h"
#import "APGroupView.h"
#import "APGroupNote.h"
#import "GCDAsyncSocket.h"

NS_ASSUME_NONNULL_BEGIN

@interface APMonitorView : APBaseView <UITableViewDelegate,UITableViewDataSource,GCDAsyncSocketDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UILabel *titleLab;
@property (nonatomic , strong) NSMutableArray *data;//传递过来已经组织好的数据（全量数据）

-(void)refreshTable:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_END
