//
//  Course+CoreDataProperties.h
//  CoreDataGridStu
//
//  Created by sseen on 16/5/31.
//  Copyright © 2016年 sseen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Course.h"

NS_ASSUME_NONNULL_BEGIN

@interface Course (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *rooms;
@property (nullable, nonatomic, retain) NSString *teachers;
@property (nullable, nonatomic, retain) NSNumber *time;
@property (nullable, nonatomic, retain) NSNumber *weekday;
@property (nullable, nonatomic, retain) NSNumber *year;
@property (nullable, nonatomic, retain) NSOrderedSet<WeekOfYear *> *week_of_year;

@end

@interface Course (CoreDataGeneratedAccessors)

- (void)insertObject:(WeekOfYear *)value inWeek_of_yearAtIndex:(NSUInteger)idx;
- (void)removeObjectFromWeek_of_yearAtIndex:(NSUInteger)idx;
- (void)insertWeek_of_year:(NSArray<WeekOfYear *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeWeek_of_yearAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInWeek_of_yearAtIndex:(NSUInteger)idx withObject:(WeekOfYear *)value;
- (void)replaceWeek_of_yearAtIndexes:(NSIndexSet *)indexes withWeek_of_year:(NSArray<WeekOfYear *> *)values;
- (void)addWeek_of_yearObject:(WeekOfYear *)value;
- (void)removeWeek_of_yearObject:(WeekOfYear *)value;
- (void)addWeek_of_year:(NSOrderedSet<WeekOfYear *> *)values;
- (void)removeWeek_of_year:(NSOrderedSet<WeekOfYear *> *)values;

@end

NS_ASSUME_NONNULL_END
