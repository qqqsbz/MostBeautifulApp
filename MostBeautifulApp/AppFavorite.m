//
//  AppFavorite.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/3.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "AppFavorite.h"

@implementation AppFavorite

+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass(self);
}

+ (instancetype)favoriteAppFromApp:(App *)app
{
    NSManagedObjectContext *moc = [Application sharedManagedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"modelId", app.modelId];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:[self managedObjectEntityName] inManagedObjectContext:moc];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    fetchRequest.fetchLimit = 1;
    fetchRequest.predicate = predicate;
    
    NSError *error = nil;
    NSManagedObject *managedObject = [[moc executeFetchRequest:fetchRequest error:&error] firstObject];
    AppFavorite *local = [MTLManagedObjectAdapter modelOfClass:[self class] fromManagedObject:managedObject error:&error];
    AppFavorite *model = [app deriveModelWithTemplateModelClass:[self class]];
    model.isFavorite = local.isFavorite;
    return model;
}

- (BOOL)toggleFavoriteWithOutError:(NSError **)error
{
    self.isFavorite = !self.isFavorite;
    NSManagedObject *managedObject = [MTLManagedObjectAdapter managedObjectFromModel:self insertingIntoContext:[Application sharedManagedObjectContext] error:error];
    if (managedObject) {
        [Application saveSharedManagedObjectContext];
        return true;
    }
    
    self.isFavorite = !self.isFavorite;
    return NO;
}

@end
