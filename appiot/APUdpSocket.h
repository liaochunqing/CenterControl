//
//  APUdpSocket.h
//  appiot
//
//  Created by App-Iot02 on 2022/11/21.
//

#import <Foundation/Foundation.h>
#import "config.h"
NS_ASSUME_NONNULL_BEGIN

@interface APUdpSocket : NSObject<GCDAsyncUdpSocketDelegate>
@property(nonatomic,strong)GCDAsyncUdpSocket *udpSocket;
@property (nonatomic, copy) NSString *host;       // socket的Host
@property (nonatomic, assign) UInt16 port;        // socket的prot
@property (nonatomic, strong) NSTimer *connectTimer;    // 计时器
@property (nonatomic, strong) NSDictionary *socketResult;
//@property (nonatomic, strong) dataBlock receiveData;

//- (void)receiveData:(dataBlock)block;

+ (APUdpSocket *)sharedInstance;   // 单例
-(void)createClientUdpSocket;  // socket连接
-(void)cutOffSocket; // 断开socket连接
- (void)sendMessage:(NSString *)message;
-(void)broadcast:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
