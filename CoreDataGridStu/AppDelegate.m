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
    
    for (NSDictionary *dic in jsonArray) {
        NSArray *innerArray = dic[@"activities"];
        NSString *name = dic[@"course_name"];
        for (NSDictionary *innerDic in innerArray) {
            
            
            NSArray *weekOfYearArray = innerDic[@"week_of_year"];
            WeekOfYear *weekoy = [[WeekOfYear alloc] initWithEntity:weekOfYearEntity insertIntoManagedObjectContext:_coreDataStack.context];
            NSMutableOrderedSet *mutableOrderSet = [NSMutableOrderedSet orderedSet];
            for (NSString *item in weekOfYearArray) {
                weekoy.weekOfYear = [NSNumber numberWithInteger:[item integerValue]];
                [_coreDataStack saveContext];
                [mutableOrderSet addObject:weekoy];
            }
            
            Course *course = [[Course alloc] initWithEntity:courseEntity insertIntoManagedObjectContext:_coreDataStack.context];
            course.name = name;
            NSString *time = innerDic[@"time"];
            NSInteger intTime = [[time substringToIndex:[time rangeOfString:@"-"].location] integerValue];
            course.time = [NSNumber numberWithInteger:intTime];
            course.year = innerDic[@"year"];
            course.rooms = innerDic[@"rooms"][0];
            course.teachers = innerDic[@"teachers"][0];
            course.weekday = [NSNumber numberWithInteger:[innerDic[@"weekday"] integerValue]];
            
            course.week_of_year = mutableOrderSet;
            [_coreDataStack saveContext];
        }
        
    }
}

@end
