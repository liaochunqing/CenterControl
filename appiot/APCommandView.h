//
//  APCommandView.h
//  appiot
//
//  Created by App-Iot02 on 2022/11/14.
//

#import "APBaseView.h"
#import "APComandButton.h"
#import "APMonitorItem.h"
#import "APUdpSocket.h"



NS_ASSUME_NONNULL_BEGIN

@interface APCommandView : APBaseView
@property(nonatomic,strong)UIView *testBaseView;
@property(nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)NSMutableArray *itemArray;

@end

NS_ASSUME_NONNULL_END
