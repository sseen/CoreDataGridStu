//
//  WeekOfYear+CoreDataProperties.h
//  CoreDataGridStu
//
//  Created by sseen on 16/5/31.
//  Copyright © 2016年 sseen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "WeekOfYear.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeekOfYear (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *weekOfYear;
@property (nullable, nonatomic, retain) NSOrderedSet<Course *> *course;

@end

@interface WeekOfYear (CoreDataGeneratedAccessors)

- (void)insertObject:(Course *)value inCourseAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCourseAtIndex:(NSUInteger)idx;
- (void)insertCourse:(NSArray<Course *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCourseAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCourseAtIndex:(NSUInteger)idx withObject:(Course *)value;
- (void)replaceCourseAtIndexes:(NSIndexSet *)indexes withCourse:(NSArray<Course *> *)values;
- (void)addCourseObject:(Course *)value;
- (void)removeCourseObject:(Course *)value;
- (void)addCourse:(NSOrderedSet<Course *> *)values;
- (void)removeCourse:(NSOrderedSet<Course *> *)values;

@end

NS_ASSUME_NONNULL_END
