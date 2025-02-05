//
//  ViewController.m
//  BackgroundDownload
//
//  Created by Michelangelo Chasseur on 13/09/14.
//  Copyright (c) 2014 Touchware. All rights reserved.
//

#define FILE_URL @"http://ovh.net/files/10Mio.dat"

#import "ViewController.h"
#import "RYDownloadManager.h"
#import "DownLoadTableViewCell.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *contentTableView;
//记录进度的字典
@property (strong, nonatomic) NSMutableDictionary *progressDict;

@property (copy, nonatomic) NSArray *filePaths;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.filePaths = @[@"http://ovh.net/files/1Mio.dat",
                       @"http://ovh.net/files/10Mio.dat",
                       @"http://ovh.net/files/100Mio.dat",
                       @"http://ovh.net/files/1Gio.dat",
                       @"http://ovh.net/files/10Gio.dat",
                       @"http://ovh.net/files/1Mbit.dat",
                       @"http://ovh.net/files/10Mbit.dat",
                       @"http://ovh.net/files/100Mbit.dat",
                       @"http://ovh.net/files/1Gbit.dat",
                       @"http://ovh.net/files/10Gbit.dat"];
    self.progressDict = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    [self.view addSubview:self.contentTableView];
}

- (void)startDownload:(UIButton *)sender {
    // Just a demo example file...
    
    __strong ViewController *weakSelf = self;
    
    [[RYDownloadManager sharedManager] downloadFileForURL:self.filePaths[(sender.tag - 1)%10] fileType:@"dat" progressBlock:^(CGFloat progress) {
        //进度
        
        [weakSelf.progressDict setValue:[NSString stringWithFormat:@"%f",progress] forKey:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:20];
            
            for (NSString *keyStr in weakSelf.progressDict.allKeys) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:[keyStr intValue] - 1 inSection:0]];
            }
            
            [weakSelf.contentTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        });
        
    } remainingTime:^(NSUInteger seconds) {
        //上传需要的时间
        NSLog(@"ETA: %lu sec.", (unsigned long)seconds);
    } completionBlock:^(BOOL completed) {
        //上传完成
        NSLog(@"Download completed!");
    } enableBackgroundMode:YES requestTag:sender.tag];
}

- (void)cancelDownload:(id)sender {
    [[RYDownloadManager sharedManager] cancelAllDownloads];
    [self nilProgress];
}

- (void)deleteFiles:(id)sender {
    [[RYDownloadManager sharedManager] deleteFileForUrl:FILE_URL];
    [self nilProgress];
}

- (void)nilProgress {
    //初始化进度
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    DownLoadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DownLoadTableViewCell" owner:self options:nil] lastObject];
    }
    cell.downloadBtn.tag = indexPath.row + 1;
    [cell.downloadBtn addTarget:self action:@selector(startDownload:) forControlEvents:UIControlEventTouchUpInside];
    
    //状态为完成或者正在下载时，其实可以不用设置不可点击，因为如果可以点击，下载方法中有拦截
    if ([[RYDownloadManager sharedManager] fileExistsForUrl:FILE_URL]) {
        //存在文件
        //完成状态
        
    }else if(self.progressDict[[NSString stringWithFormat:@"%ld",(long)cell.downloadBtn.tag]]){
        //存在进度（表示正在下载）
        cell.progressView.progress = [self.progressDict[[NSString stringWithFormat:@"%ld",(long)cell.downloadBtn.tag]] floatValue];
    }else {
        //没有点击下载且文件从来没有被下载过
        //没有下载状态
    }
    
    return cell;
}

- (UITableView *)contentTableView {
    
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
    }
    return _contentTableView;
}

@end
