//
//  AppDelegate.m
//  CoreDataGridStu
//
//  Created by sseen on 16/5/31.
//  Copyright © 2016年 sseen. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataStack.h"
#import <CoreData/CoreData.h>

#import "Course+CoreDataProperties.h"

#import "WeekOfYear+CoreDataProperties.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *courseFetchResultsController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self importJSONSeedDataIfNeeded];
    
    return YES;
}

- (void)importJSONSeedDataIfNeeded {
    self.coreDataStack = [[CoreDataStack alloc] init];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    NSError *error;
    NSInteger results = [_coreDataStack.context countForFetchRequest:fetchRequest error:&error];
    
    if (results == 0) {
        [self importJSONSeedData];
    }
}

- (void)importJSONSeedData {
    NSURL *jsonURL = [[NSBundle mainBundle] URLForResource:@"seed" withExtension:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    NSEntityDescription *courseEntity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.coreDataStack.context];
    NSEntityDescription *weekOfYearEntity = [NSEntityDescription entityForName:@"WeekOfYear" inManagedObjectContext:self.coreDataStack.context];
    
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
    NSArray *jsonArray = jsonDict[@"activitys"];
    NSMutableArray *m_array = [NSMutableArray array];
    for (NSDictionary *dic in jsonArray) {
        NSArray *innerArray = dic[@"activities"];
        NSString *name = dic[@"course_name"];
        // 有几条就插几条 相同课程的纪录
        for (NSDictionary *innerDic in innerArray) {
            
            
            Course *course = [[Course alloc] initWithEntity:courseEntity insertIntoManagedObjectContext:_coreDataStack.context];
            course.name = name;
            NSString *time = innerDic[@"time"];
            course.timeStr = time;
            NSInteger intTime = [[time substringToIndex:[time rangeOfString:@"-"].location] integerValue];
            course.time = [NSNumber numberWithInteger:intTime];
            
            course.year = innerDic[@"year"];
            course.rooms = innerDic[@"rooms"][0];
            course.teachers = innerDic[@"teachers"][0];
            course.weekday = [NSNumber numberWithInteger:[innerDic[@"weekday"] integerValue]];
            
            NSArray *weekOfYearArray = innerDic[@"week_of_year"];
            
            NSMutableOrderedSet *mutableOrderSet = [NSMutableOrderedSet orderedSet];
            for (NSString *item in weekOfYearArray) {
                // 查找是不是已经有 weekofyear
                NSUInteger index = [self.fetchedResultsController.fetchedObjects indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    return ([[(WeekOfYear *)obj weekOfYear] integerValue] == item.integerValue);
                }];
                // 没有插入
                if (index == NSNotFound) {
                    
                    WeekOfYear *weekoy = [[WeekOfYear alloc] initWithEntity:weekOfYearEntity insertIntoManagedObjectContext:_coreDataStack.context];
                    
                    weekoy.weekOfYear = [NSNumber numberWithInteger:[item integerValue]];
                    
                    NSError *error;
                    [_coreDataStack saveContext];
                    NSLog(@"week of year: %@", error);
                    [_fetchedResultsController performFetch:&error];
                    NSLog(@"week of year fetch : %@", error);
                }
                
                [mutableOrderSet addObject:[self fetchWeekOfYear:item]];
            }
            
            //
            course.week_of_year = mutableOrderSet;
           
            [m_array addObject:course];
        }
        
        // add color belong the top class
        [m_array sortUsingComparator:^NSComparisonResult(Course *obj1, Course *obj2) {
            return [[NSNumber numberWithInt: (int)obj1.week_of_year.count ] compare:[NSNumber numberWithInt: (int)obj2.week_of_year.count]];
        }];
        
        [_coreDataStack saveContext];
    }
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"WeekOfYear"
                                   inManagedObjectContext:_coreDataStack.context];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"weekOfYear" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]  initWithFetchRequest:fetchRequest
                                                                                                 managedObjectContext:_coreDataStack.context
                                                                                                   sectionNameKeyPath:nil
                                                                                                            cacheName:nil];
    
    _fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Core data error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (NSFetchedResultsController *)courseFetchResultsController
{
    if (_courseFetchResultsController != nil) {
        return _courseFetchResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Course"
                                   inManagedObjectContext:_coreDataStack.context];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"name" ascending:NO];
//    NSPredicate    *predicate    = [NSPredicate predicateWithFormat:@"name == [cd] %@", @"高等数学A（二）"];

    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
//    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]  initWithFetchRequest:fetchRequest
                                                                                                 managedObjectContext:_coreDataStack.context
                                                                                                   sectionNameKeyPath:nil
                                                                                                            cacheName:nil];
    
    _courseFetchResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![_courseFetchResultsController performFetch:&error]) {
        NSLog(@"Core data error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _courseFetchResultsController;
}

- (WeekOfYear *)fetchWeekOfYear:(NSString *)number {
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"WeekOfYear"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"weekOfYear == %@", number];
    [fetch setPredicate:predicate];
    
    NSError *error ;
    NSArray *obj = [_coreDataStack.context executeFetchRequest:fetch error:&error];
    
    if (obj.count > 0) {
        return obj[0];
    } else {
        return  nil;
    }
}

@end
