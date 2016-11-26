//
//  WeekOfYear+CoreDataProperties.h
//  CoreDataGridStu
//
//  Created by sseen on 2016/11/15.
//  Copyright © 2016年 sseen. All rights reserved.
//

#import "WeekOfYear+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WeekOfYear (CoreDataProperties)

+ (NSFetchRequest<WeekOfYear *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *weekOfYear;
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
