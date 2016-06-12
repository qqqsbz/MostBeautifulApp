//
//  ShareView.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/3.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareModel : NSObject
@property (strong, nonatomic) UIImage   *icon;
@property (strong, nonatomic) NSString  *title;
@property (strong, nonatomic) NSString  *plantform;

+ (instancetype)shareWithImage:(UIImage *)image title:(NSString *)title plantform:(NSString *)plantform;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title plantform:(NSString *)plantform;;

@end

@interface ShareData : NSObject
@property (strong, nonatomic) UIImage   *image;
@property (strong, nonatomic) NSString  *content;
@property (strong, nonatomic) NSString  *url;

+ (instancetype)shareWithImage:(UIImage *)image content:(NSString *)content url:(NSString *)url;

- (instancetype)initWithImage:(UIImage *)image content:(NSString *)content url:(NSString *)url;

@end

typedef ShareData*(^SharePlantformData)();
@interface XBShareView : UIView

- (void)showWidthTargetViewController:(UIViewController *)targetViewController shareDataBlock:(SharePlantformData)shareDataBlock;

@end
