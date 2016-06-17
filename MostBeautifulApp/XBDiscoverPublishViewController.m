//
//  XBDiscoverPublishViewController.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/14.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBDiscoverPublishViewController.h"
#import "XBDiscoverPublishSearchViewController.h"
@interface XBDiscoverPublishViewController () <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *linkTextField;
@property (strong, nonatomic) IBOutlet UITextField *contentPlaceHolder;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation XBDiscoverPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildNavigationBarItem];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E4E8E9"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBarHidden = YES;
}


#pragma mark -- UITable view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self.linkTextField becomeFirstResponder];
    } else if (indexPath.row == 1) {
        
        [self presentViewController:[[XBDiscoverPublishSearchViewController alloc] init] animated:YES completion:nil];
        
    }
}

#pragma mark -- UITextview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.contentPlaceHolder.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)buildNavigationBarItem
{
    self.title = @"分享应用";
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -64, CGRectGetWidth(self.view.frame), 64.f)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 35, 35);
    [backBtn setImage:[UIImage imageNamed:@"detail_icon_back_normal"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 35);
    rightBtn.layer.masksToBounds = YES;
    rightBtn.layer.cornerRadius  = 4.f;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [rightBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:[UIColor colorWithHexString:@"#49A9F5"]];
    [rightBtn addTarget:self action:@selector(publishAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addPhotosAction:(UIButton *)sender {
    
}

- (void)publishAction
{
    
}

@end
