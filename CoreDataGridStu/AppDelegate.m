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
#import "Course.h"

#import "WeekOfYear.h"
#import "WeekOfYear+CoreDataProperties.h"

@interface AppDelegate ()
@property (nonatomic, strong) CoreDataStack* coreDataStack;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *courseFetchResultsController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self importJSONSeedDataIfNeeded];
    
    [self fetchManyInfoUseTag];
    
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
                //
                if (index == NSNotFound) {
                    
                    WeekOfYear *weekoy = [[WeekOfYear alloc] initWithEntity:weekOfYearEntity insertIntoManagedObjectContext:_coreDataStack.context];
                    
                    weekoy.weekOfYear = [NSNumber numberWithInteger:[item integerValue]];
//                    
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
            [_coreDataStack saveContext];
        }
        
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

- (void)fetchManyInfoUseTag {
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY week_of_year.weekOfYear == %@", @"27"];
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
    NSSortDescriptor *sortDesc2 = [[NSSortDescriptor alloc] initWithKey:@"weekday" ascending:YES];
    
    
    [fetch setSortDescriptors:@[sortDesc, sortDesc2]];
    [fetch setPredicate:predicate];
    
    NSError *error ;
    NSArray *obj = [_coreDataStack.context executeFetchRequest:fetch error:&error];
    
    for (Course *course in obj) {
        NSLog(@"%@\n", course.description);
    }
    
    Course *tmpCourse = (Course *)obj[0];
    int objIndex = 0;
    NSInteger index = tmpCourse.weekday.integerValue * tmpCourse.time.integerValue;
    NSMutableArray *dataArr = [NSMutableArray array];
    
    for (int i=0; i< 5 * 6; i++) {
        Course *emptyCourse = [tmpCourse copy];
        emptyCourse.weekday = @-1;
        
        if (i+1 == index) {
            [dataArr addObject:obj[objIndex++]];
            // 不能越界
            if (objIndex < obj.count) {
                Course *tmp = (Course *)obj[objIndex];
                int line = (int)(tmp.time.integerValue/2)+1;
                index = tmp.weekday.integerValue +  5 * (line -1);
            }
        } else {
            [dataArr addObject:emptyCourse];
        }
        
    }
    
    for (Course *course in dataArr) {
        NSLog(@"ssn%@\n", course.description);
    }
}

@end
