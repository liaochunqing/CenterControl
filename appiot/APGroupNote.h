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
@property (nonatomic , strong) APGroupNote * grandfather;//祖父节点，
@property (nonatomic , strong) APGroupNote * father;//父节点，

- (instancetype)init;
-(void)setSelectedAndCount:(BOOL)selected;
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
