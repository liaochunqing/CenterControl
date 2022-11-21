//
//  APViewController.h
//  appiot
//
//  Created by App-Iot02 on 2022/11/14.
//

#import "APBaseViewController.h"
#import "APLeftView.h"
#import "APCenterView.h"

NS_ASSUME_NONNULL_BEGIN

@interface APViewController : APBaseViewController
@property(nonatomic,strong)APLeftView *leftView;
@property(nonatomic,strong)APCenterView *centerView;


@end

NS_ASSUME_NONNULL_END
