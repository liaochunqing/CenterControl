//
//  APGroupCell.h
//  appiot
//
//  Created by App-Iot02 on 2022/11/17.
//

#import <UIKit/UIKit.h>
#import "APGroupNote.h"
#import "config.h"

//声明一个无返回值，两个参数的 block
typedef void(^ClickBlock)(BOOL index);

NS_ASSUME_NONNULL_BEGIN

@interface APGroupCell : UITableViewCell
//@property (strong, nonatomic) UIImageView *expendImageView;
@property (strong, nonatomic) UIImageView *im;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UIButton *selectBtn;
@property (strong, nonatomic) UIButton *expendBtn;

//@property (nonatomic) BOOL haveChild;

@property (nonatomic, copy) ClickBlock btnClickBlock;


-(void)updateCellWithData:(APGroupNote*)node index:(int)row;
- (UIImage *)imageWithColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
