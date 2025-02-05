//
//  DownLoadTableViewCell.h
//  BackgroundDownload
//
//  Created by wwt on 15/9/15.
//  Copyright (c) 2015年 Touchware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownLoadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@end
