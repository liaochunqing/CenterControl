//
//  APMonitorModel.h
//  appiot
//
//  Created by App-Iot02 on 2022/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APMonitorModel : NSObject
@property (nonatomic , strong)  NSString * errorCode;//错误码
//
@property (nonatomic , strong)  NSString * IP;//IP
@property (nonatomic , strong) NSString *name;//展厅名

@property (nonatomic , strong) NSString *signalSource;//信源

@property (nonatomic , strong) NSString * ID;//该节点ID
@property (nonatomic , strong) NSString * temperature;
@property (nonatomic , strong) NSString * timeRatio;

@property (nonatomic , assign) BOOL isOpen;//是否开机
@property (nonatomic , assign) BOOL isShutter;//是否开快门
@property (nonatomic , assign) BOOL isConnect;//RS232是否连接
@end

NS_ASSUME_NONNULL_END
