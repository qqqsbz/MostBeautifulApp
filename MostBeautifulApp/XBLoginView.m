//
//  LoginView.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/6.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kCloseWH  30.f
#define kCheckWH  25.f
#define kLoginH   45.f
#define kSinaW    35.f
#define kSinaH    28.f

#import "XBLoginView.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>
@interface XBLoginView() <TTTAttributedLabelDelegate>
@property (strong, nonatomic) UIButton      *closeButton;
@property (strong, nonatomic) UILabel       *tipLabel;
@property (strong, nonatomic) UIView        *loginView;
@property (strong, nonatomic) UIImageView   *loginImageView;
@property (strong, nonatomic) UILabel       *loginLabel;
@property (strong, nonatomic) UIButton      *checkButton;
@property (strong, nonatomic) TTTAttributedLabel  *protocolLabel;
@end
@implementation XBLoginView

- (instancetype)init
{
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}


- (void)initialization
{
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setImage:[UIImage imageNamed:@"seach_icon_clear_normal"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.tipLabel = [UILabel new];
    self.tipLabel.text = @"登录后才可以玩的更多哦!";
    self.tipLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    self.tipLabel.textColor = [UIColor colorWithHexString:@"#636363"];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    
    self.loginView = [UIView new];
    self.loginView.backgroundColor = [UIColor colorWithHexString:@"#E25B3E"];
    [self.loginView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)]];
    
    self.loginView.layer.masksToBounds = YES;
    self.loginView.layer.cornerRadius  = 5.f;
    
    self.loginImageView = [UIImageView new];
    self.loginImageView.image = [UIImage imageNamed:@"sina"];
    
    self.loginLabel = [UILabel new];
    self.loginLabel.text = @"新浪微博登录";
    self.loginLabel.textColor = [UIColor whiteColor];
    self.loginLabel.font = [UIFont systemFontOfSize:19.f];
    
    self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkButton setImage:[UIImage imageNamed:@"publish-checkbox-selected"] forState:UIControlStateNormal];
    
    NSString *protocolText = @"《用户协议》";
    NSString *text = [NSString stringWithFormat:@"我已阅读并同意%@",protocolText];
    self.protocolLabel = [TTTAttributedLabel new];
    self.protocolLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.protocolLabel.delegate = self;
    self.protocolLabel.font = [UIFont systemFontOfSize:15.f];
    self.protocolLabel.textColor = [UIColor colorWithHexString:@"#ABABAB"];
    self.protocolLabel.text = text;

    NSMutableDictionary *protocolAttributes = [NSMutableDictionary dictionary];
    [protocolAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [protocolAttributes setValue:(__bridge id)[UIColor colorWithHexString:@"#2C00EC"].CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
    self.protocolLabel.linkAttributes = protocolAttributes;
    NSRange range = NSMakeRange(text.length - protocolText.length, protocolText.length);
    [self.protocolLabel addLinkToURL:[NSURL URLWithString:@"open://protocol"] withRange:range];

    
    [self addSubview:self.closeButton];
    [self addSubview:self.tipLabel];
    [self addSubview:self.loginView];
    [self addSubview:self.checkButton];
    [self addSubview:self.protocolLabel];
    
    [self.loginView addSubview:self.loginImageView];
    [self.loginView addSubview:self.loginLabel];
    
    [self addConstraint];
}

- (void)addConstraint
{
    [self.closeButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.f);
        make.top.equalTo(self).offset(30.);
        make.width.mas_equalTo(kCloseWH);
        make.height.mas_equalTo(kCloseWH);
    }];
    
    [self.tipLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    
    [self.checkButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30);
        make.bottom.equalTo(self).offset(-20.f);
        make.width.mas_equalTo(kCheckWH);
        make.height.mas_equalTo(kCheckWH);
    }];
    
    [self.protocolLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkButton.right).offset(5);
        make.centerY.equalTo(self.checkButton);
    }];
    
    [self.loginView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(40.f);
        make.right.equalTo(self).offset(-40.f);
        make.height.mas_equalTo(kLoginH);
        make.bottom.equalTo(self.protocolLabel.top).offset(-50.f);
    }];
    
    [self.loginLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.loginView);
        make.left.equalTo(self.loginView.centerX).offset(-30.f);
    }];
    
    [self.loginImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.loginLabel.left).offset(-5);
        make.centerY.equalTo(self.loginLabel.centerY);
        make.width.mas_equalTo(kSinaW);
        make.height.mas_equalTo(kSinaH);
    }];
}

- (void)tapGesture:(UITapGestureRecognizer *)tapGesture
{
    if ([self.delegate respondsToSelector:@selector(loginViewdDidSelectedLogin)]) {
        [self.delegate loginViewdDidSelectedLogin];
    }
}

- (void)dismissAction
{
    if ([self.delegate respondsToSelector:@selector(loginViewDidDismiss)]) {
        [self.delegate loginViewDidDismiss];
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url{
    if ([self.delegate respondsToSelector:@selector(loginViewDidSelectedProtocol)]) {
        [self.delegate loginViewDidSelectedProtocol];
    }
}

@end
