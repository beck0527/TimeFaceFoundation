Pod::Spec.new do |s|
  s.name         = "TimeFaceFoundation"
  s.version      = "0.3.4"
  s.summary      = "时光流影iOS开发框架"
  s.homepage     = "https://github.com/beck0527/TimeFaceFoundation"
  s.license      = "Copyright (C) 2015 TimeFace, Inc.  All rights reserved."
  s.author             = { "zguanyu" => "zhuguanyu@timeface.cn" }
  s.social_media_url   = "http://www.timeface.cn"
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/beck0527/TimeFaceFoundation.git"}
  s.source_files  = "TimeFaceFoundation/**/*.{h,m,c}"
  s.requires_arc = true
  s.dependency 'SDWebImage'
  s.dependency 'DateTools'
  s.dependency 'JTCalendar'

  s.dependency 'GKFadeNavigationController'
  s.dependency 'JSONModel'
  s.dependency 'SSKeychain'
  s.dependency 'pop'
  s.dependency 'AFNetworking'
  s.dependency 'RETableViewManager'
  s.dependency 'HHRouter'
  s.dependency 'JDStatusBarNotification'
  s.dependency 'NJKWebViewProgress'
  s.dependency 'GPUImage'
  s.dependency 'EGOCache'
  s.dependency 'ActionSheetPicker-3.0'
  s.dependency 'Masonry'
  s.dependency 'SVProgressHUD'
  s.dependency 'FMDB'
  s.dependency 'MJRefresh'
  s.dependency 'Reachability'
end
