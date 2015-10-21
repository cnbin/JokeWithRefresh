//
//  MainTableViewController.m
//  Smile
//
//  Created by Apple on 10/15/15.
//  Copyright © 2015 cnbin. All rights reserved.
//
//易源笑话大全 http://apistore.baidu.com/apiworks/servicedetail/864.html

#import "MainTableViewController.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"

@interface MainTableViewController ()

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title =@"每天笑一笑";
    self.titleArray = [NSMutableArray array];

    [GlobalResource sharedInstance].page =@"1";
    NSString *httpUrl = @"http://apis.baidu.com/showapi_open_bus/showapi_joke/joke_text";
    NSString * httpArg = [[NSString alloc]initWithFormat: @"page=%@", [GlobalResource sharedInstance].page];
    [self request: httpUrl withHttpArg: httpArg];
    
    //初始化UIRefreshControl
    UIRefreshControl *rc = [[UIRefreshControl alloc] init];
    rc.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [rc addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = rc;
}

-(void) refreshTableView
{
    if (self.refreshControl.refreshing) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"加载中..."];
        
        [GlobalResource sharedInstance].page =@"2";
        NSString *httpUrl = @"http://apis.baidu.com/showapi_open_bus/showapi_joke/joke_text";
        NSString * httpArg = [[NSString alloc]initWithFormat: @"page=%@", [GlobalResource sharedInstance].page];
        [self request: httpUrl withHttpArg: httpArg];

    }
}

- (void)request:(NSString*)httpUrl withHttpArg:(NSString*)HttpArg {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 1];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"c33bdd6ad06c082a12a171edc323cc9a" forHTTPHeaderField: @"apikey"];
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request delegate:self];
    
    if (connection) {
        self.receiveData = [NSMutableData data];
    }
}

- (void)connection: (NSURLConnection *)connection didReceiveData: (NSData *)data {
    
    [self.receiveData appendData:data];
}

- (void)connectionDidFinishLoading: (NSURLConnection*) connection {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:self.receiveData options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary * dicBody = [dic objectForKey:@"showapi_res_body"];
    [self reloadView:dicBody];
}

//重新加载表视图
-(void)reloadView:(NSDictionary*)res
{
    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    }
    
    self.contentArray = [res objectForKey:@"contentlist"];
    for (int i = 0; i< self.contentArray.count; i++) {
        
        //在头部插入数据
       // [self.contentAddArray insertObject:[[self.contentArray objectAtIndex:i]objectForKey:@"title"] atIndex:0];
        //在尾部添加数据
        [self.titleArray addObject:[[self.contentArray objectAtIndex:i]objectForKey:@"title"]];
        
    }
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return  self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MainCellIdentifier";
    NSUInteger row = [indexPath row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = [self.titleArray objectAtIndex:row];
    
    
    return cell;
}
@end
