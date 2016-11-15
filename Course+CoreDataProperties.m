//
//  Course+CoreDataProperties.m
//  CoreDataGridStu
//
//  Created by sseen on 2016/11/15.
//  Copyright © 2016年 sseen. All rights reserved.
//

#import "Course+CoreDataProperties.h"

@implementation Course (CoreDataProperties)

+ (NSFetchRequest<Course *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Course"];
}

@dynamic color;
@dynamic name;
@dynamic rooms;
@dynamic teachers;
@dynamic time;
@dynamic timeStr;
@dynamic weekday;
@dynamic year;
@dynamic week_of_year;

@end
