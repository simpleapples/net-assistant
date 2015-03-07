//
//  SACoreDataManager.m
//  NetAsistant
//
//  Created by Zzy on 12/24/14.
//  Copyright (c) 2014 Zzy. All rights reserved.
//

#import "SACoreDataManager.h"
#import "SADateUtils.h"
#import <CoreData/CoreData.h>

@interface SACoreDataManager ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation SACoreDataManager

+ (SACoreDataManager *)manager
{
    static SACoreDataManager *manager;
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        if (!manager) {
            manager = [[SACoreDataManager alloc] init];
        }
    });
    return manager;
}

#pragma mark - SADetail

- (void)insertOrUpdateDetailWithFlowValue:(int64_t)flowValue date:(NSDate *)date
{
    NSInteger year = [SADateUtils yearWithDate:date];
    NSInteger month = [SADateUtils monthWithDate:date];
    NSInteger day = [SADateUtils dayWithDate:date];
    NSDate *dayDate = [SADateUtils dayDateWithStirng:[NSString stringWithFormat:@"%ld-%ld-%ld 00:00:00", (long)year, (long)month, (long)day]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortArray = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SADetail"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"date = %@", dayDate];
    fetchRequest.sortDescriptors = sortArray;
    fetchRequest.fetchLimit = 1;
    
    NSError *error;
    NSArray *fetchResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (!error && fetchResult && fetchResult.count) {
        SADetail *existDetail = [fetchResult firstObject];
        existDetail.flowValue = @(flowValue);
    } else {
        SADetail *detail = [NSEntityDescription insertNewObjectForEntityForName:@"SADetail" inManagedObjectContext:self.managedObjectContext];
        detail.flowValue = @(flowValue);
        detail.date = dayDate;
    }
}

- (void)detailsOfThisMonth:(void(^)(NSArray *details))completionBlock
{
    NSParameterAssert(completionBlock);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SADetail"];
    NSAsynchronousFetchRequest *asyncFetchRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:fetchRequest completionBlock:^(NSAsynchronousFetchResult *result) {
        if (result && result.finalResult && result.finalResult.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(result.finalResult);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil);
            });
        }
    }];
    NSError *error;
    [self.managedObjectContext executeRequest:asyncFetchRequest error:&error];
    if (error) {
        completionBlock(nil);
    }
}

#pragma mark - Core Data stack

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"netasistant" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"netasistant.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"com.zangzhiya.netasistant" code:1000 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
