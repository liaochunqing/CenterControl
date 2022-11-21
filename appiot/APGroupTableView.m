//
//  APGroupTableView.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/17.
//

#import "APGroupTableView.h"
#import "AppDelegate.h"
@implementation APGroupTableView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/**
 * 初始化数据源
 */
-(NSMutableArray *)createTempData : (NSArray *)data{
    _tempData = [NSMutableArray array];
    _data = [NSMutableArray array];

    
    for (int i=0; i<data.count; i++)
    {
        APGroupNote *node = [data objectAtIndex:i];
        [_data addObject:node];

        if (node.expand) {
            [_tempData addObject:node];
        }
    }
    return _tempData;
}

-(void)selectedAllWithSelected:(BOOL)selected
{
    for (int k = 0; k < self.data.count; k++)
    {
        APGroupNote *node = self.data[k];
        node.selected = selected;
    }
    [self reloadData];
}

-(void)deleteSelectedNode
{
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];//临时容器，存储将要删除的节点
    
    //收集删除节点
    for (int i = 0; i < _data.count; i++)
    {
        APGroupNote *first = _data[i];
        if (first.selected)//第一层
        {
            if(first.expand == YES)
            {
                for (int k = 0; k < _data.count; k++)
                {
                    APGroupNote *second = _data[k];
                    if (second.parentId == first.nodeId)//第二层
                    {
                        for (int j = 0; j < _data.count; j++)
                        {
                            APGroupNote *third = _data[j];
                            if (third.parentId == second.nodeId)//第三层
                            {
                                [set addIndex:j];

                            }
                        }
                        [set addIndex:k];

                    }
                }
            }
            
            [set addIndex:i];
        }
    }

    
    //删除节点刷新列表
    if (set.count > 0)
    {
        WS(weakSelf);
        UIAlertController  *alert = [UIAlertController alertControllerWithTitle:@"确认删除" message:@"删除后无法恢复" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
        {
            
            [weakSelf.data removeObjectsAtIndexes:set];
            [weakSelf reloadData];
        }];
                
        UIAlertAction *action2= [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                }];

        [alert addAction:action1];
        [alert addAction:action2];
        AppDelegate *appDelegate = kAppDelegate;
    //    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UIViewController *vc = appDelegate.mainVC;
        [vc presentViewController:alert animated:YES completion:nil];  //显示对话框
    }
}

#pragma mark *** UITableViewDelegate/UITableViewDataSource ***
 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//首先展示的数据是tempData的数据
    return _data.count;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *NODE_CELL_ID = @"node_cell_id";

    APGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:NODE_CELL_ID];
    if (!cell) {
        cell = [[APGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NODE_CELL_ID];
    }

    APGroupNote *node = [_data objectAtIndex:indexPath.row];

    [cell updateCellWithData:node];
    
//    WS(weakSelf);
    __block APGroupNote *temp = [_data objectAtIndex:indexPath.row];
    [cell setBtnClickBlock:^(BOOL index) {
        
//        node.selected = index;
        temp.selected = index;
        
//        NSArray *dd = weakSelf.data;
//        int i =0;
    }];
    return cell;
}

 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row ;
    APGroupNote *node = _data[row];
    if (node && node.height == 0)
    {
        return node.height;
    }
    
    return 40;
}
 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row ;
    APGroupNote *node = _data[row];
    if (node == nil) return;
    
    if (node.expand == YES)
    {
        node.expand = !node.expand;
        for (int i = 0; i < _data.count; i++)
        {
            APGroupNote *second = _data[i];
            if (second.parentId == node.nodeId)
            {
                second.height = 0;
                
                for (int k = 0; k < _data.count; k++)
                {
                    APGroupNote *third = _data[k];
                    if (third.parentId == second.nodeId)
                    {
                        third.height = 0;
                    }
                }
            }
        }
    }
    else
    {
        node.expand = !node.expand;
        for (int i = 0; i < _data.count; i++)
        {
            APGroupNote *second = _data[i];
            if (second.parentId == node.nodeId)
            {
                second.height = Group_Cell_Height;
                if(second.expand == YES)
                {
                    for (int k = 0; k < _data.count; k++)
                    {
                        APGroupNote *third = _data[k];
                        if (third.parentId == second.nodeId)
                        {
                            third.height = Group_Cell_Height;
                        }
                    }
                }
            }
        }
    }
    
    [tableView reloadData];
}
@end
