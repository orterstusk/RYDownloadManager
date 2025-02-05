//
//  RYDownloadObject.m
//  DownloadManager
//
//  Created by Michelangelo Chasseur on 26/07/14.
//  Copyright (c) 2014 Touchware. All rights reserved.
//

#import "RYDownloadObject.h"

@implementation RYDownloadObject

- (instancetype)initWithDownloadTask:(NSURLSessionDownloadTask *)downloadTask
                       progressBlock:(RYDownloadProgressBlock)progressBlock
                       remainingTime:(RYDownloadRemainingTimeBlock)remainingTimeBlock
                     completionBlock:(RYDownloadCompletionBlock)completionBlock requestTag:(NSInteger)requestTag{
    self = [super init];
    if (self) {
        self.downloadTask = downloadTask;
        self.progressBlock = progressBlock;
        self.remainingTimeBlock = remainingTimeBlock;
        self.completionBlock = completionBlock;
        self.requestTag = requestTag;
    }
    return self;
}

@end
