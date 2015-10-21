//
//  MainTableViewController.h
//  Smile
//
//  Created by Apple on 10/15/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalResource.h"
@interface MainTableViewController : UITableViewController<NSURLConnectionDelegate>

//获取数据
@property (nonatomic,strong) NSMutableData * receiveData;

//每页内容数组
@property (nonatomic,strong) NSMutableArray * contentArray;

//二维页数数组
@property (nonatomic,strong) NSMutableArray * titleArray;


@end
