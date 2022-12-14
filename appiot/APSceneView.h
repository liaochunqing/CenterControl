//
//  APSceneView.h
//  appiot
//
//  Created by App-Iot02 on 2022/12/14.
//

#import "APBaseView.h"
#import "APAdjustButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface APSceneView : APBaseView
@property (nonatomic , strong) NSMutableArray *selectedArray;

@property (nonatomic , strong) NSMutableArray *btnArray;
@property (nonatomic , strong) NSMutableArray *imageArray;

@property (nonatomic, strong)UIView *testBaseView;
@property (nonatomic, strong)APAdjustButton *wyAdjustButton;
@property (nonatomic, strong)APAdjustButton *jjAdjustButton;
@property (nonatomic, strong)APAdjustButton *sfAdjustButton;

-(void)createTestView:(NSArray *)selectedArray;
@end

NS_ASSUME_NONNULL_END
