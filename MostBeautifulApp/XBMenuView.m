//
//  XBMenuView.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/31.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kImageViewWH CGRectGetHeight(self.frame) * 0.7
#define kTextSpace 5.f
#define kImageSpace 15.f
#define kNaviBarSpace 30.f
#define kAnimationSpace 10
#import "XBMenuView.h"
@interface XBMenuView()
@property (strong, nonatomic) NSArray  *images;
@property (strong, nonatomic) NSArray  *titles;
@property (assign, nonatomic) XBMenuViewType  type;
@property (strong, nonatomic) NSMutableArray<UILabel *>     *titleLabels;
@property (strong, nonatomic) NSMutableArray<UIImageView *> *imageViews;
@end
@implementation XBMenuView

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray<UIImage *> *)images type:(XBMenuViewType)type
{
    if (self == [super initWithFrame:frame]) {
        _images = images;
        _type = type;
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray<UIImage *> *)images titles:(NSArray<NSString *> *)titles type:(XBMenuViewType)type
{
    if (self = [super initWithFrame:frame]) {
        _images = images;
        _titles = titles;
        _type = type;
        if (_images.count != _titles.count) {
            NSParameterAssert(@"image count no equal title count");
        }
        [self initialization];
    }
    return self;
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    
    self.images = [data objectForKey:@"images"];
    self.titles = [data objectForKey:@"titles"];
    
    if (_images.count != _titles.count) {
        NSParameterAssert(@"image count no equal title count");
    }
    
    [self initialization];
}

- (void)initialization
{
    UIFont *textFont   = [UIFont fontWithName:@"Helvetica-Bold" size:13.f];
    UIColor *textColor = [UIColor grayColor];
    
    NSInteger count = self.images.count;
    
    self.titleLabels = [NSMutableArray arrayWithCapacity:count];
    self.imageViews  = [NSMutableArray arrayWithCapacity:count];
    
    for (NSInteger i = 0; i < count; i ++) {
        UIImageView *imageView = [UIImageView new];
        imageView.userInteractionEnabled = YES;
        imageView.image = self.images[i];
        imageView.tag = i;
        
        [self addSubview:imageView];
        [self.imageViews addObject:imageView];
        
        if (self.type == XBMenuViewTypeView) {
            UILabel *label = [UILabel new];
            label.text = self.titles[i];
            label.textColor = textColor;
            label.font = textFont;
            label.tag = i;
            
            [self addSubview:label];
            [self.titleLabels addObject:label];
            
            [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
        }
    }
    
    [self layoutIfNeeded];
    
    if (self.type == XBMenuViewTypeView) {
        [self addViewConstraint];
    } else if (self.type == XBMenuViewTypeNavBar) {
        [self addNaviBarConstraint];
    }

}

//添加到页面的布局
- (void)addViewConstraint
{
    
    NSInteger count = self.images.count;
    if (count == 3) {
        
        NSInteger mid = floor(self.images.count / 2.f);
        
        UIImageView *midImageView = self.imageViews[mid];
        UILabel *midLabel = self.titleLabels[mid];
        
        UIImageView *firstImageView = [self.imageViews firstObject];
        UILabel *firstLabel = [self.titleLabels firstObject];
        
        UIImageView *lastImageView = [self.imageViews lastObject];
        UILabel *lastLabel = [self.titleLabels lastObject];
        
        [midImageView makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kImageViewWH);
            make.height.mas_equalTo(kImageViewWH);
            make.centerY.equalTo(self);
            make.right.equalTo(self.centerX);
        }];
        
        [midLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(midImageView.right).offset(kTextSpace);
        }];
        
        [firstLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(midImageView.left).offset(-kImageSpace);
            make.centerY.equalTo(self);
        }];
        
        [firstImageView makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kImageViewWH);
            make.height.mas_equalTo(kImageViewWH);
            make.centerY.equalTo(self);
            make.right.equalTo(firstLabel.left).offset(-kTextSpace);
        }];
        
        [lastImageView makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kImageViewWH);
            make.height.mas_equalTo(kImageViewWH);
            make.centerY.equalTo(self);
            make.left.equalTo(midLabel.right).offset(kImageSpace);
        }];
        
        [lastLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastImageView.right).offset(kTextSpace);
            make.centerY.equalTo(self);
        }];
        
    } else if (count == 2) {
        
        UIImageView *lastImageView = [self.imageViews lastObject];
        UILabel *lastLabel = [self.titleLabels lastObject];
        
        UIImageView *firstImageView = [self.imageViews firstObject];
        UILabel *firstLabel = [self.titleLabels firstObject];
        
        [lastImageView makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kImageViewWH);
            make.height.mas_equalTo(kImageViewWH);
            make.centerY.equalTo(self);
            make.left.equalTo(self.centerX).offset(kImageSpace);
        }];
        
        [lastLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastImageView.right).offset(kTextSpace);
            make.centerY.equalTo(self);
        }];
        
        
        [firstLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.centerX).offset(-kImageSpace);
            make.centerY.equalTo(self);
        }];
        
        [firstImageView makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kImageViewWH);
            make.height.mas_equalTo(kImageViewWH);
            make.centerY.equalTo(self);
            make.right.equalTo(firstLabel.left).offset(-kTextSpace);
        }];
        
    } else if (count == 1) {
        
        UILabel *label = [self.titleLabels firstObject];
        UIImageView *imageView = [self.imageViews firstObject];
        imageView.tag = XBMenuViewDidSelectedTypeShare;
        
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.centerX).offset(-kTextSpace);
        }];
        
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kImageViewWH);
            make.height.mas_equalTo(kImageViewWH);
            make.centerY.equalTo(self);
            make.right.equalTo(label.left).offset(-kTextSpace);
        }];
        
    }
    
}


- (void)addNaviBarConstraint
{
    NSInteger count = self.imageViews.count;
    if (count == 3) {
        UIImageView *firstImageView = [self.imageViews firstObject];
        [firstImageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self);
            make.width.mas_equalTo(kImageViewWH);
            make.height.mas_equalTo(kImageViewWH);
        }];
        
        for (NSInteger i = 1; i < count; i ++ ) {
            UIImageView *lastImageView = self.imageViews[i - 1];
            UIImageView *currentImageView = self.imageViews[i];
            [currentImageView makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(lastImageView.centerY);
                make.left.equalTo(lastImageView.right).offset(kNaviBarSpace);
                make.width.equalTo(lastImageView.width);
                make.height.equalTo(lastImageView.height);
            }];
        }
    } else if (count == 2) {
        UIImageView *firstImageView = [self.imageViews firstObject];
        UIImageView *lastImageView  = [self.imageViews lastObject];
        
        [lastImageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(kImageViewWH);
            make.height.mas_equalTo(kImageViewWH);
        }];
        
        [firstImageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(lastImageView.left).offset(-kNaviBarSpace);
            make.width.equalTo(lastImageView);
            make.height.equalTo(lastImageView);
        }];
    } else if (count == 1) {
        
        UIImageView *imageView = [self.imageViews firstObject];
        imageView.tag = XBMenuViewDidSelectedTypeShare;
        
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kImageViewWH);
            make.height.mas_equalTo(kImageViewWH);
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(kNaviBarSpace);
        }];
    }
}

- (void)showWithComplete:(complete)complete
{
    NSInteger count = self.imageViews.count;
    
    UIImageView *firstImaegView = [self.imageViews firstObject];
    UIImageView *lastImageView = [self.imageViews lastObject];
    
    if (count == 3) {
        [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            CGRect firstFrame = firstImaegView.frame;
            firstFrame.origin.x += kAnimationSpace;
            firstImaegView.frame = firstFrame;
            
            CGRect lastFrame = lastImageView.frame;
            lastFrame.origin.x -= kAnimationSpace;
            lastImageView.frame = lastFrame;
            
        } completion:^(BOOL finished) {
            complete(finished);
        }];
        
    } else if (count == 2) {
        [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            CGRect firstFrame = firstImaegView.frame;
            firstFrame.origin.x -= kAnimationSpace * 3;
            firstImaegView.frame = firstFrame;
            
            CGRect lastFrame = lastImageView.frame;
            lastFrame.origin.x -= kAnimationSpace * 3;
            lastImageView.frame = lastFrame;
            
        } completion:^(BOOL finished) {
            complete(finished);
        }];
    } else if (count == 1) {
        
        [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            CGRect firstFrame = firstImaegView.frame;
            firstFrame.origin.x -= kAnimationSpace * 2;
            firstImaegView.frame = firstFrame;
            
        } completion:^(BOOL finished) {
            complete(finished);
        }];
    }
}

- (void)hideWithComplete:(complete)complete
{
    NSInteger count = self.imageViews.count;
    
    UIImageView *firstImaegView = [self.imageViews firstObject];
    UIImageView *lastImageView = [self.imageViews lastObject];
    
    if (count == 3) {
        
        [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            CGRect firstFrame = firstImaegView.frame;
            firstFrame.origin.x -= kAnimationSpace;
            firstImaegView.frame = firstFrame;
            
            CGRect lastFrame = lastImageView.frame;
            lastFrame.origin.x += kAnimationSpace;
            lastImageView.frame = lastFrame;
            
        } completion:^(BOOL finished) {
            complete(finished);
        }];
        
    } else if (count == 2) {
        
        [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            CGRect firstFrame = firstImaegView.frame;
            firstFrame.origin.x += kAnimationSpace * 3;
            firstImaegView.frame = firstFrame;
            
            CGRect lastFrame = lastImageView.frame;
            lastFrame.origin.x += kAnimationSpace * 3;
            lastImageView.frame = lastFrame;
            
        } completion:^(BOOL finished) {
            complete(finished);
        }];
        
    } else if (count == 1) {
        
        [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            CGRect firstFrame = firstImaegView.frame;
            firstFrame.origin.x += kAnimationSpace * 2;
            firstImaegView.frame = firstFrame;
            
        } completion:^(BOOL finished) {
            complete(finished);
        }];
        
    }

}

- (void)tapAction:(UITapGestureRecognizer *)tapGesture
{
    UIView *view = [tapGesture view];
    XBMenuViewDidSelectedType type = view.tag;
    if ([self.delegate respondsToSelector:@selector(menuView:didSelectedWithType:atIndex:)]) {
        [self.delegate menuView:self didSelectedWithType:type atIndex:view.tag];
    }
}

- (void)replaceImage:(UIImage *)image atIndex:(NSInteger)index
{
    if (index < 0 || index > self.images.count) return;
    UIImageView *imageView = self.imageViews[index];
    imageView.image = image;
}

- (void)replaceTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (index < 0 || index > self.titles.count) return;
    UILabel *label = self.titleLabels[index];
    label.text = title;
}
@end
