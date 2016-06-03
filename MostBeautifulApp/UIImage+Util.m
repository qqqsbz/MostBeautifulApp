//
//  UIImage+Util.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/2.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "UIImage+Util.h"

@implementation UIImage (Util)

+ (UIImage *)resizeImageWithImage:(UIImage *)image
{
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 27, 4, 4) resizingMode:UIImageResizingModeTile];
}

+ (UIImage *)resizeImageWithImageName:(NSString *)imageName
{
    return [UIImage resizeImageWithImage:[UIImage imageNamed:imageName]];
}

@end
