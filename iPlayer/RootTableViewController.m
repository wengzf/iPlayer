//
//  RootTableViewController.m
//  iPlayer
//
//  Created by 翁志方 on 16/9/8.
//  Copyright © 2016年 wzf. All rights reserved.
//

#import "RootTableViewController.h"

#import "GuideViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>


@implementation RootCell


@end

@interface RootTableViewController ()
{
    NSArray *titleImageArr;
    NSArray *shareImageArr;
    
    NSArray *titleArr;
    NSArray *desArr;
    
    NSArray *shareDesArr1;
    NSArray *shareDesArr2;
    
    NSArray *shareLinkArr;
    
}
@end


@implementation RootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"试玩列表";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareItemClked)];
    
    titleImageArr = @[@"1", @"2", @"3", @"4",
                      @"5", @"6", @"7", @"8",
                      @"9", @"10", @"11", @"12",
                      @"13", @"14", @"15", @"16"];
    
    shareImageArr = @[@"s1", @"s2", @"s3", @"s4",
                      @"s5", @"s6", @"s7", @"s8",
                      @"s9", @"s10", @"s11", @"s12",
                      @"s13", @"s14", @"s15", @"s16"];
    
    // 对应文案
    titleArr = @[@"试玩平台1", @"试玩平台2", @"试玩平台3", @"试玩平台4",
                 @"试玩平台5", @"试玩平台6", @"试玩平台7", @"试玩平台8",
                 @"试玩平台9", @"试玩平台10", @"试玩平台11", @"试玩平台12",
                 @"试玩平台13", @"试玩平台14", @"试玩平台15", @"试玩平台16"
                 ];
    
    desArr = @[@"每单任务收入1.0元到2.0元", @"每单任务收入1.0元到3.0元",
               @"每单任务收入2.0元到4.0元", @"每单任务收入1.0元到3.0元",
               @"每单任务收入2.0元到3.5元", @"每单任务收入1.0元到3.0元",
               @"每单任务收入1.0元到3.0元", @"每单任务收入1.0元到3.5元",
               @"每单任务收入1.0元到3.0元", @"每单任务收入1.0元到3.0元",
               @"每单任务收入1.0元到3.0元", @"每单任务收入1.0元到3.0元",
               @"每单任务收入1.0元到2.0元", @"每单任务收入1.0元到3.0元",
               @"每单任务收入1.0元到3.0元", @"每单任务收入1.0元到2.0元"
               ];
 
    shareDesArr1 = @[@"方法一：点击最下方分享赚钱按钮，分享至任意微信好友或朋友圈，朋友打开你的分享链接，长按二维码图片识别，加入赚么；",
                     @"方法一：点击最下方分享赚钱按钮，分享至任意微信好友或朋友圈，朋友打开你的分享链接，按照提示操作即可；",
                     @"方法一：点击最下方分享赚钱按钮，分享至任意微信好友或朋友圈，朋友打开你的分享链接，按照提示操作即可；",
                     @"方法一：点击最下方分享赚钱按钮，分享至任意微信好友或朋友圈，朋友打开你的分享链接，按照提示操作即可；",
                     @"方法一：点击最下方分享赚钱按钮，分享至任意微信好友或朋友圈，朋友打开你的分享链接，按照提示操作即可；",
                     @"方法一：点击最下方分享赚钱按钮，分享至任意微信好友或朋友圈，朋友打开你的分享链接，按照提示操作即可；",
                     @"方法一：点击最下方分享赚钱按钮，分享至任意微信好友或朋友圈，朋友打开你的分享链接，按照提示操作即可；",
                     @"方法一：点击最下方分享赚钱按钮，分享至任意微信好友或朋友圈，朋友打开你的分享链接，按照提示操作即可；",
                     @"方法一：点击最下方分享赚钱按钮，分享至任意微信好友或朋友圈，朋友打开你的分享链接，按照提示操作即可；",
                     @"方法一：点击最下方分享赚钱按钮，分享至任意微信好友或朋友圈，朋友打开你的分享链接，按照提示操作即可；",
                     @"方法一：点击最下方分享赚钱按钮，分享至任意微信好友或朋友圈，朋友打开你的分享链接，按照提示操作即可；",
                     @"方法一：点击最下方分享赚钱按钮，分享至任意微信好友或朋友圈，朋友打开你的分享链接，按照提示操作即可；",
                     @"方法一：点击最下方分享赚钱按钮，分享至任意微信好友或朋友圈，朋友打开你的分享链接，按照提示操作即可；",
                     @"方法一：点击最下方分享赚钱按钮，分享至任意微信好友或朋友圈，朋友打开你的分享链接，按照提示操作即可；",
                     @"方法一：点击最下方分享赚钱按钮，分享至任意微信好友或朋友圈，朋友打开你的分享链接，按照提示操作即可；",
                     @"方法一：点击最下方分享赚钱按钮，分享至任意微信好友或朋友圈，朋友打开你的分享链接，按照提示操作即可；"];
    
    shareDesArr2 = @[@"方法二：点击并保存下方二维码图片，打开微信扫一扫，选择相册中二维码图片识别，加入赚么。",
                     @"方法二：点击并保存下方二维码图片，打开微信扫一扫，选择相册中二维码图片识别，按照提示操作即可。",
                     @"方法二：点击并保存下方二维码图片，打开微信扫一扫，选择相册中二维码图片识别，按照提示操作即可。",
                     @"方法二：点击并保存下方二维码图片，打开微信扫一扫，选择相册中二维码图片识别，按照提示操作即可。",
                     @"方法二：点击并保存下方二维码图片，打开微信扫一扫，选择相册中二维码图片识别，按照提示操作即可。",
                     @"方法二：点击并保存下方二维码图片，打开微信扫一扫，选择相册中二维码图片识别，按照提示操作即可。",
                     @"方法二：点击并保存下方二维码图片，打开微信扫一扫，选择相册中二维码图片识别，按照提示操作即可。",
                     @"方法二：点击并保存下方二维码图片，打开微信扫一扫，选择相册中二维码图片识别，按照提示操作即可。",
                     @"方法二：点击并保存下方二维码图片，打开微信扫一扫，选择相册中二维码图片识别，按照提示操作即可。",
                     @"方法二：点击并保存下方二维码图片，打开微信扫一扫，选择相册中二维码图片识别，按照提示操作即可。",
                     @"方法二：点击并保存下方二维码图片，打开微信扫一扫，选择相册中二维码图片识别，按照提示操作即可。",
                     @"方法二：点击并保存下方二维码图片，打开微信扫一扫，选择相册中二维码图片识别，按照提示操作即可。",
                     @"方法二：点击并保存下方二维码图片，打开微信扫一扫，选择相册中二维码图片识别，按照提示操作即可。",
                     @"方法二：点击并保存下方二维码图片，打开微信扫一扫，选择相册中二维码图片识别，按照提示操作即可。",
                     @"方法二：点击并保存下方二维码图片，打开微信扫一扫，选择相册中二维码图片识别，按照提示操作即可。",
                     @"方法二：点击并保存下方二维码图片，打开微信扫一扫，选择相册中二维码图片识别，按照提示操作即可。"
                     ];
    
    
    shareLinkArr = @[@"http://zhuanme.cc/?u=060008",
                     @"http://qianka.com/shoutu?u=38070509",
                     @"http://url.cn/2B7Xp5d",
                     @"http://wx.xy599.com/share.php?id=1668915&from=singlemessage&isappinstalled=1",
                     @"http://api2.ppyaoqing.cn/web/?inviter=1736088",
                     @"http://www.neihanhongbao.com/Friend/FenBefor?invid=772856&channid=2",
                     @"http://diaoqianyaner.com.cn/home.html?u=6098879",
                     @"http://11.pphongbao.com/?r=829141559",
                     @"http://wx.myskf.cn/p/s.html?m=2&t=5&id=47856406&c=273&s=XUBAQ",
                     @"http://amb.shouxidashi.com/wx/ui/html/share.html?msg=ISeqP3I9ibuqcbUnRWxqrJvhJJUy9ylDsZztwLXZn0w%3D&ev=3&from=singlemessage&isappinstalled=1",
                     @"http://m.rhl2.cn?u=2055296",
                     @"http://m.vfou.com/share/vfou_weixin_2.do?uid=1347066&from=singlemessage&isappinstalled=1",
                     @"http://www.mapzqq-com.com/test/jump/251899?unionid=o3C3ev7tPqUMBjwL98VCXjO-vVpw&from=singlemessage&isappinstalled=1",
                     @"http://www.kuaima.cn/?fu=565291",
                     @"http://qianxiaoka.com/Share?u=32661",
                     @"http://m.pandatry.com/invite/?inviter=rTJEEGCZ8ae7HJakqtfYTyd228aXNMmUPRZLJvkCr6HcPiMrR_*_W0GeuCx56uLr12_@_RmiaokmIZI=&openid=nOBLiIOEck.yluEu47F_ug&from=singlemessage&isappinstalled=1"
                     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)shareItemClked
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return titleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RootCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.titleImageView.image = [UIImage imageNamed:titleImageArr[indexPath.row]];
    cell.titleLabel.text = titleArr[indexPath.row];
    cell.desLabel.text = desArr[indexPath.row];

    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GuideViewController *vc = [[GuideViewController alloc] init];
    
    vc.desStr1 = shareDesArr1[indexPath.row];
    vc.desStr2 = shareDesArr2[indexPath.row];
    vc.qaStr = shareImageArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
