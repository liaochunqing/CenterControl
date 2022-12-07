//
//  APTcpSocket.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/29.
//

#import "APTcpSocket.h"
#define ConnectTime -1
static APTcpSocket *shareManager = nil;


@implementation APTcpSocket
#pragma mark 伪单例模式
+ (APTcpSocket *)shareManager
{
    static dispatch_once_t onecToken;
    dispatch_once(&onecToken, ^{
        shareManager = [[APTcpSocket alloc] init];
    });
    return shareManager;
}

#pragma mark连接服务器
- (void)connectToHost:(NSString *)host Port:(NSUInteger)port
{
    if (_socketDict == nil)
    {
        _socketDict = [NSMutableDictionary dictionary];
    }
    //从缓存获取已经连接的socket
    [self getSocketFromCashWith:host port:port];

    if (self.socket == nil || [self.socket isDisconnected])
    {
        dispatch_queue_t queue = dispatch_queue_create("tcpqueue", NULL);
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:shareManager delegateQueue:queue socketQueue:nil];
//        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:shareManager delegateQueue:dispatch_get_main_queue()];
    }
    NSError *error = nil;
    [self.socket connectToHost:host onPort:(uint16_t)port withTimeout:ConnectTime error:&error];

}

//从缓存获取已经连接的socket
-(void)getSocketFromCashWith:(NSString *)host port:(NSUInteger)port
{
    if(_socketDict)
    {
        self.socket = nil;
        
        NSString *localKey = [NSString stringWithFormat:@"%@+%d",host,(int)port];
        
        for (NSString * key in _socketDict)
        {
            if([key isEqualToString:localKey])
            {
                self.socket = _socketDict[key];
                break;
            }
        }
    }
}

#pragma mark 发送数据
-(void)sendData:(NSData *)contents
{
    [self.socket writeData:contents withTimeout:-1 tag:0];
    NSLog(@"%p发送：%@",self.socket, contents);
    [self.socket readDataWithTimeout:-1 tag:0];
}

#pragma mark 已连接到服务器
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSString *message = [NSString stringWithFormat:@"sock:%p,Host:%@,Port:%d",sock,host,port];
    NSLog(@"连接成功%@",message);
    //保存socket
    if(_socketDict)
    {
        NSString *key = [NSString stringWithFormat:@"%@+%d",host,port];
        [_socketDict setObject:sock forKey:SafeStr(key)];
    }
    
    // 读取数据
    [sock readDataWithTimeout:-1 tag:0];
}

#pragma mark 已经向服务器发送数据
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSString *message = [NSString stringWithFormat:@"发送数据成功:%p,%ld",sock,tag];
    NSLog(@"%@",message);
}


#pragma mark 服务器返回数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *receiverStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSDictionary *dic = [APTool dictionaryWithJsonString:receiverStr];
    NSLog(@"收到数据: %@",receiverStr);
    
    dispatch_async(dispatch_get_main_queue(), ^{
       // UI更新代码
        if (self.socketMessageBlock)
        {
            self.socketMessageBlock(receiverStr);
        }
    });
    
    
    [sock readDataWithTimeout:-1 tag:0];
}

#pragma mark 连接失败,可以在这里设置重连
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSString *message = [NSString stringWithFormat:@"连接失败.ERROR:%@\n",err.description];
    NSLog(@"%@",message);
//    self.disconnectWithHost();
    //TODO:设置重连
}

@end
