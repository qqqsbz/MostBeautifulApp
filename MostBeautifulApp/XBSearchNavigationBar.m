//
//  XBSearchNavigationBar.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/7.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kLeftImageViewWH 15.f
#import "XBSearchNavigationBar.h"
@interface XBSearchNavigationBar() <UITextFieldDelegate>
@property (strong, nonatomic) UIView        *textView;
@property (strong, nonatomic) UIImageView   *leftImageView;
@property (strong, nonatomic) UIImageView   *rightImageView;
@property (strong, nonatomic) UITextField   *textField;
@property (strong, nonatomic) UIButton      *cancleButton;
@property (copy  , nonatomic) SearchBlock   searchBlock;
@property (strong, nonatomic) NSArray       *images;
@property (copy  , nonatomic) dispatch_block_t  cancleBlock;
@end
@implementation XBSearchNavigationBar

- (instancetype)initWidthSearchBlock:(SearchBlock)searchBlock cancleBlock:(dispatch_block_t)block
{
    if (self = [super init]) {
        _searchBlock = searchBlock;
        _cancleBlock = block;
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame searchBlock:(SearchBlock)searchBlock cancleBlock:(dispatch_block_t)block
{
    if (self = [super initWithFrame:frame]) {
        _searchBlock = searchBlock;
        _cancleBlock = block;
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    
    self.textView = [UIView new];
    self.textView.backgroundColor = [UIColor colorWithHexString:@"#E6E7E9"];
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius  = 3.f;
    
    self.leftImageView = [UIImageView new];
    self.leftImageView.image = [UIImage imageNamed:@"seach_icon_seach"];
    
    self.rightImageView = [UIImageView new];
    self.rightImageView.userInteractionEnabled = YES;
    self.rightImageView.image = [UIImage imageNamed:@"seach_icon_clear_normal"];
    self.rightImageView.hidden = YES;
    [self.rightImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cleanAction)]];
    
    UIFont *textFieldFont = [UIFont systemFontOfSize:15.f];
    self.textField = [[UITextField alloc] init];
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入名称、关键字" attributes:@{NSFontAttributeName:textFieldFont}];
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentCenter;
    self.textField.returnKeyType = UIReturnKeySearch;
    self.textField.font = textFieldFont;
    self.textField.textColor = [UIColor grayColor];
    self.textField.delegate  = self;
    [self.textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancleButton.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
    [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleButton setBackgroundColor:[UIColor colorWithHexString:@"#3D95CB"]];
    [self.cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancleButton addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.cancleButton.layer.masksToBounds = YES;
    self.cancleButton.layer.cornerRadius  = 3.f;
    
    [self addSubview:self.textView];
    [self addSubview:self.cancleButton];
    
    [self.textView addSubview:self.leftImageView];
    [self.textView addSubview:self.textField];
    [self.textView addSubview:self.rightImageView];
    
    [self addConstraint];
}

- (void)addConstraint
{
    [self.textView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(29);
        make.bottom.equalTo(self).offset(-5);
    }];
    
    [self.leftImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textView);
        make.left.equalTo(self.textView).offset(10);
        make.width.mas_equalTo(kLeftImageViewWH);
        make.height.mas_equalTo(kLeftImageViewWH);
    }];
    
    [self.rightImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textView);
        make.right.equalTo(self.textView).offset(-10);
        make.width.equalTo(self.leftImageView);
        make.height.equalTo(self.leftImageView);
    }];
    
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textView);
        make.left.equalTo(self.leftImageView.right).offset(10.f);
        make.right.equalTo(self.rightImageView.left).offset(-10.f);
    }];
    
    [self.cancleButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.top);
        make.right.equalTo(self).offset(-10);
        make.left.equalTo(self.textView.right).offset(10.f);
        make.width.mas_equalTo(45.f);
        make.bottom.equalTo(self.textView);
    }];

}

- (void)setIsBecomeFirstResponder:(BOOL)isBecomeFirstResponder
{
    _isBecomeFirstResponder = isBecomeFirstResponder;
    self.rightImageView.hidden = !isBecomeFirstResponder;
    if (isBecomeFirstResponder) {
        [self.textField becomeFirstResponder];
    } else {
        [self.textField resignFirstResponder];
    }
}

- (void)setPlaceHolderString:(NSString *)placeHolderString
{
    _placeHolderString = placeHolderString;
    self.textField.placeholder = placeHolderString;
}

- (void)startAnimation
{
    self.leftImageView.animationImages = self.images;
    self.leftImageView.animationDuration = 0.5f;
    self.leftImageView.animationRepeatCount = NSIntegerMax;
    [self.leftImageView startAnimating];
}

- (void)stopAnimation
{
    self.leftImageView.image = [UIImage imageNamed:@"seach_icon_seach"];
}

- (void)cleanAction
{
    self.textField.text = @"";
}

- (void)cancleAction
{
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.searchBlock) {
        self.searchBlock(textField.text);
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.rightImageView.hidden = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.rightImageView.hidden = YES;
}

- (void)textFieldChange:(UITextField *)textField
{
    if (self.searchBlock) {
        self.searchBlock(textField.text);
    }
}

#pragma mark -- lazy loading
- (NSArray *)images
{
    if (!_images) {
        _images = @[[UIImage imageNamed:@"loading_1"],
                    [UIImage imageNamed:@"loading_2"],
                    [UIImage imageNamed:@"loading_3"],
                    [UIImage imageNamed:@"loading_4"],
                    [UIImage imageNamed:@"loading_5"],
                    [UIImage imageNamed:@"loading_6"],
                    [UIImage imageNamed:@"loading_7"],
                    [UIImage imageNamed:@"loading_8"]
                    ];;
    }
    return _images;
}
@end
