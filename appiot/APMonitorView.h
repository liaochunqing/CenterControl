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
#import "APUdpSocket.h"
#import "GCDAsyncSocket.h"

NS_ASSUME_NONNULL_BEGIN

@interface APMonitorView : APBaseView <UITableViewDelegate,UITableViewDataSource,GCDAsyncSocketDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UILabel *titleLab;
@property (nonatomic , strong) NSMutableArray *data;//传递过来已经组织好的数据（全量数据）
@property (nonatomic ,strong)NSTimer *__nullable timer;
@property (nonatomic,strong)APTcpSocket *tcpManager;//tcp管理器
@property (nonatomic,strong)APUdpSocket *udpManager;//udp管理器

//-(void)refreshTable:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_END
