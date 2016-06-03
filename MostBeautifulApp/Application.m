//
//  Application.m
//  iPenYou
//
//  Created by trgoofi on 14-5-30.
//  Copyright (c) 2014年 vbuy. All rights reserved.
//

#import "Application.h"

static NSManagedObjectContext *_context = nil;

@implementation Application

+ (NSString *)shortVersion
{
    return [self infoPlistObjectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)bundleVersion
{
    return [self infoPlistObjectForKey:@"CFBundleVersion"];
}

+ (id)infoPlistObjectForKey:(id)key
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
}

+ (NSString *)deviceId
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString *)resolution
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    int width = size.width * scale;
    int height = size.height * scale;
    NSString *result = [NSString stringWithFormat:@"%dx%d", width, height];
    return result;
}

+ (BOOL)isPlus
{
    return [[Application resolution] isEqualToString:@"1242x2208"];
}

+ (NSURL *)directoryOfDocument
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSManagedObjectContext *)sharedManagedObjectContext
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSError *error = nil;
        
        NSDictionary *options = nil;
        options = @{NSMigratePersistentStoresAutomaticallyOption: [NSNumber numberWithBool:YES],
                    NSInferMappingModelAutomaticallyOption: [NSNumber numberWithBool:YES]};
        
        //NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Article" withExtension:@"momd"];
        //NSURL *storeURL = [[self directoryOfDocument] URLByAppendingPathComponent:@"Article.sqlite"];
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"App" withExtension:@"momd"];
        NSURL *storeURL = [[self directoryOfDocument] URLByAppendingPathComponent:@"App.sqlite"];
        
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
            DDLogError(@"Fail to create NSManagedObjectContext: %@, %@", error, [error userInfo]);
            abort();
        }
        
        _context = [[NSManagedObjectContext alloc] init];
        [_context setPersistentStoreCoordinator:coordinator];
    });
    return _context;
}

+ (void)saveSharedManagedObjectContext
{
    NSError *error = nil;
    if (_context != nil) {
        if ([_context hasChanges] && ![_context save:&error]) {
            NSLog(@"Fail to save NSManagedObjectContext: %@, %@", error, [error userInfo]);
        }
    }
}

+ (void)deleteShareManagedObjectContext:(NSManagedObject *)object
{
    if (_context != nil) {
        [_context deleteObject:object];
    }
    
}

@end
