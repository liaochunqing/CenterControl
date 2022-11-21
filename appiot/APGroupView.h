//
//  APGroupView.h
//  appiot
//
//  Created by App-Iot02 on 2022/11/16.
//

#import "APBaseView.h"
#import "APBottomButton.h"
#import "APGroupTableView.h"
//#import "config.h"

NS_ASSUME_NONNULL_BEGIN

@interface APGroupView : APBaseView 
@property(nonatomic,strong)UIButton *btnLeft;//全选按钮
@property(nonatomic,strong)UIButton *btnRight;//编辑按钮
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)APGroupTableView *tableview;
@end

NS_ASSUME_NONNULL_END
