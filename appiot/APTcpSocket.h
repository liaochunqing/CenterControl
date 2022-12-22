//
//  APTcpSocket.h
//  appiot
//
//  Created by App-Iot02 on 2022/11/29.
//

#import <Foundation/Foundation.h>
#import "config.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^SocketReturnMessage)(NSString *message);
typedef void(^SocketDidConnected)(NSString *message);

@interface APTcpSocket : NSObject<GCDAsyncSocketDelegate>
/*
 *创建GCDAsyncSocket tcp的socket对象
 */
@property (nonatomic,strong) GCDAsyncSocket *__nullable socket;
@property (nonatomic, strong) NSMutableDictionary *socketDict;
@property (nonatomic,strong)NSData *senddata;
@property (nonatomic,strong)NSString *ip;
@property (nonatomic,assign) NSUInteger port;

/*
 *创建SocketReturnMessage类型的block对象
 */
@property (nonatomic,copy) SocketReturnMessage socketMessageBlock;
@property (nonatomic,copy) SocketDidConnected didConnectedBlock;


/*
 *初始化方法
 */
+ (APTcpSocket *)shareManager;

/*
 *连接服务/主机的方法
 */
- (void)connectToHost:(NSString *)host Port:(NSUInteger)port;
- (void)connectToHost;

//发送数据
-(void)sendData:(NSData *)contents;
@end

NS_ASSUME_NONNULL_END
