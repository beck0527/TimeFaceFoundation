//
//  TFWebViewController.h
//  TimeFace
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TSubViewController.h"
#import "NotificationMacro.h"

typedef NS_ENUM(NSInteger, LocalViewType) {
    LocalViewTypeNone        = 0,
    LocalViewTypeTimeDetail  = 1,
    LocalViewTypeTopicDetail = 2,
    LocalViewTypeUserDetail  = 3,
    LocalViewTypeEventDetail  = 4,
};

@interface TFWebViewController : TSubViewController<UIWebViewDelegate>

@property (nonatomic ,strong) UIWebView     *webView;
@property (nonatomic ,copy)   NSString      *url;


- (id)initWithUrl:(NSString *)url;
- (id)initWithUrl:(NSString *)url share:(LocalViewType)shareType;

- (void)openURL:(NSURL*)URL;


@end
