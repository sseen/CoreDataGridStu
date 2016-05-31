//
//  CoreDataStack.m
//  CoreDataGridStu
//
//  Created by sseen on 16/5/31.
//  Copyright © 2016年 sseen. All rights reserved.
//

#import "CoreDataStack.h"

static  NSString *modelName = @"Curriculum_Finder";

@implementation CoreDataStack

- (NSManagedObjectContext *)context {
    if (!_context) {
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _context.persistentStoreCoordinator = self.psc;
    }
    return _context;
}

- (NSPersistentStoreCoordinator *)psc {
    if (!_psc) {
        _psc = [[NSPersistentStoreCoordinator alloc ] initWithManagedObjectModel:self.managedObjectModel];
        NSURL *url = [self.applicationDocumentsDirectory URLByAppendingPathComponent:modelName];
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption : @true};
        
        NSError *error;
        [_psc addPersistentStoreWithType:NSSQLiteStoreType
                           configuration:nil
                                     URL:url
                                 options:options
                                   error:&error];
        if (error) {
            NSLog(@"psc init error %@", error);
        }
    }
    return _psc;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    }
    return _managedObjectModel;
}

- (NSURL *)applicationDocumentsDirectory {
    if (!_applicationDocumentsDirectory) {
        NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        _applicationDocumentsDirectory = urls[urls.count - 1];
    }
    return _applicationDocumentsDirectory;
}

- (void)saveContext {
    if ([_context hasChanges]) {
        NSError *error;
        [_context save:&error];
        
        if (error) {
            NSLog(@"context save error: %@", error);
        }
    }
}

@end
