//
//  UIImage+Util.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/2.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util)

+ (UIImage *)resizeImageWithImage:(UIImage *)image;

+ (UIImage *)resizeImageWithImageName:(NSString *)imageName;

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

@end
