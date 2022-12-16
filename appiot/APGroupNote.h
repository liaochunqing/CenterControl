//
//  APGroupNote.h
//  appiot
//
//  Created by App-Iot02 on 2022/11/17.
//

#import <Foundation/Foundation.h>
#include "config.h"
NS_ASSUME_NONNULL_BEGIN

@interface APGroupNote : NSObject
//@property (nonatomic , strong) NSString * grandfatherId;//祖父节点的id，
@property (nonatomic , strong) NSString * parentId;//父节点的id，如果为-1表示该节点为根节点
@property (nonatomic , strong) NSString * nodeId;//本节点的id
@property (nonatomic , strong) NSString *imageName;//该节点图片名
@property (nonatomic , strong) NSString *name;//本节点的名称
@property (nonatomic , assign) int depth;//该节点的深度
@property (nonatomic , assign) int childNumber;//该节点的孩子数量
@property (nonatomic , assign) int childSelected;//该节点的被选中的孩子数量
@property (nonatomic , assign) BOOL expand;//该节点是否处于展开状态
@property (nonatomic , assign) CGFloat height;//该节点展现的高度
@property (nonatomic , assign) BOOL selected;//是否被选中
@property (nonatomic) BOOL isDevice;
@property (nonatomic) BOOL haveChild;
//@property (nonatomic) BOOL needMove;
@property (nonatomic , strong) APGroupNote * grandfather;//祖父节点，
@property (nonatomic , strong) APGroupNote * father;//父节点，

//连接属性
@property (nonatomic , strong) NSString *ip;//
@property (nonatomic , strong) NSString *port;//端口
@property (nonatomic , strong) NSString *access_protocol;//连接协议  udp tcp mqtt
@property (nonatomic , strong) NSString *model_id;//设备型号ID
@property (nonatomic , strong) NSString *model_name;//型号名

//控制
@property (nonatomic,strong)NSMutableDictionary *commandDict;
@property (nonatomic,strong)NSMutableDictionary *monitorDict;
@property (nonatomic,strong)NSMutableDictionary *sceneDict;
@property (nonatomic,strong)NSMutableDictionary *installConfigDict;
@property (nonatomic,strong)NSMutableDictionary *imageDict;

//监测的属性
@property (nonatomic , strong) NSString *signals;//信源
@property (nonatomic , strong) NSString *temperature;//环境温度
@property (nonatomic , strong) NSString *machine_running_time;//整机时间
@property (nonatomic , strong) NSString *light_running_time;//光源时间
@property (nonatomic , strong) NSString *connect;//连接
@property (nonatomic , strong) NSString *supply_status;//电源状态
@property (nonatomic , strong) NSString *shutter_status;//快门状态
@property (nonatomic , strong) NSString *error_code;//报错码
@property (nonatomic , strong) NSString *device_id;//新建投影仪的冗余字段

- (instancetype)init;
//-(void)setSelectedAndCount:(BOOL)selected;
/**
*快速实例化该对象模型
*/
//- (instancetype)initWithParentId : (int)parentId
//                          nodeId : (int)nodeId
//                       imageName : (NSString *)imageName
//                            name : (NSString *)name
//                           depth : (int)depth
//                            height:(CGFloat)height
//                          expand : (BOOL)expand
//                         selected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
