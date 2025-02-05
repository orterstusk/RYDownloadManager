//
//  RYDownloadObject.h
//  DownloadManager
//
//  Created by Michelangelo Chasseur on 26/07/14.
//  Copyright (c) 2014 Touchware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^RYDownloadRemainingTimeBlock)(NSUInteger seconds);
typedef void(^RYDownloadProgressBlock)(CGFloat progress);
typedef void(^RYDownloadCompletionBlock)(BOOL completed);

@interface RYDownloadObject : NSObject

@property (copy, nonatomic) RYDownloadProgressBlock progressBlock;
@property (copy, nonatomic) RYDownloadCompletionBlock completionBlock;
@property (copy, nonatomic) RYDownloadRemainingTimeBlock remainingTimeBlock;

@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
//文件名
@property (copy, nonatomic) NSString *fileName;
//目录名
@property (copy, nonatomic) NSString *directoryName;
//开始日期
@property (copy, nonatomic) NSDate *startDate;
//标记正在请求的下载session
@property (assign, nonatomic) NSInteger requestTag;

- (instancetype)initWithDownloadTask:(NSURLSessionDownloadTask *)downloadTask
                       progressBlock:(RYDownloadProgressBlock)progressBlock
                       remainingTime:(RYDownloadRemainingTimeBlock)remainingTimeBlock
                     completionBlock:(RYDownloadCompletionBlock)completionBlock requestTag:(NSInteger)requestTag;

@end
