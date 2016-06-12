//
//  XBLoginViewController.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/6.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBLoginViewController.h"
#import "User.h"
#import "XBLoginView.h"
#import "UserDefaultsUtil.h"
#import "NSIntegerFormatter.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialAccountManager.h"
@interface XBLoginViewController () <XBLoginViewDelegate>
@property (strong, nonatomic) XBLoginView  *loginView;
@end

@implementation XBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.loginView = [[XBLoginView alloc] initWithFrame:self.view.bounds];
    self.loginView.delegate = self;
    [self.view addSubview:self.loginView];
}

#pragma mark --  XBLoginViewDelegate
- (void)loginViewdDidSelectedLogin
{
    [self showLoadinng];
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){

        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            
            NSDictionary *params = @{@"access_token":snsAccount.accessToken,
                                     @"expires_in":[NSIntegerFormatter formatToNSString:[snsAccount.expirationDate timeIntervalSince1970]],
                                     @"expires_in_date":snsAccount.expirationDate,
                                     @"weibo_uid":snsAccount.usid
                                    };
            [[XBHttpClient shareInstance] userLoginWithParamter:params success:^(User *user) {
                [self hideLoading];
                
                [UserDefaultsUtil updateUserInfo:user];
                
                [self dismissViewControllerAnimated:YES completion:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginOutSuccessNotification object:nil];
                }];
                
            } failure:^(NSError *error) {
                [self hideLoading];
                [self showFail:@"登录失败!"];
            }];
        }});
}

- (void)loginViewDidSelectedProtocol
{
    DDLogDebug(@"用户协议.......");
}

- (void)loginViewDidDismiss
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self hideLoading];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
