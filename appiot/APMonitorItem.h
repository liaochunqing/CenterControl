//
//  APMonitorItem.h
//  appiot
//
//  Created by App-Iot02 on 2022/11/15.
//

#import "APBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface APMonitorItem : APBaseView
@property(nonatomic,strong)UIImageView* iv;
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UILabel *detail;
@end

NS_ASSUME_NONNULL_END
