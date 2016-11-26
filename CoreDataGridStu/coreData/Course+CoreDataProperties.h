//
//  Course+CoreDataProperties.h
//  CoreDataGridStu
//
//  Created by sseen on 2016/11/15.
//  Copyright © 2016年 sseen. All rights reserved.
//

#import "Course+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Course (CoreDataProperties)

+ (NSFetchRequest<Course *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *color;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *rooms;
@property (nullable, nonatomic, copy) NSString *teachers;
@property (nullable, nonatomic, copy) NSNumber *time;
@property (nullable, nonatomic, copy) NSString *timeStr;
@property (nullable, nonatomic, copy) NSNumber *weekday;
@property (nullable, nonatomic, copy) NSNumber *year;
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
