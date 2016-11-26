//
//  WeekOfYear+CoreDataProperties.m
//  CoreDataGridStu
//
//  Created by sseen on 2016/11/15.
//  Copyright © 2016年 sseen. All rights reserved.
//

#import "WeekOfYear+CoreDataProperties.h"

@implementation WeekOfYear (CoreDataProperties)

+ (NSFetchRequest<WeekOfYear *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WeekOfYear"];
}

@dynamic weekOfYear;
@dynamic course;

@end
