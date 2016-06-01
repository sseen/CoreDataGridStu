//
//  Course+CoreDataProperties.m
//  CoreDataGridStu
//
//  Created by sseen on 16/5/31.
//  Copyright © 2016年 sseen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Course+CoreDataProperties.h"

@implementation Course (CoreDataProperties)

@dynamic name;
@dynamic rooms;
@dynamic teachers;
@dynamic time;
@dynamic weekday;
@dynamic year;
@dynamic week_of_year;


- (NSString *)description {
    return [NSString stringWithFormat:@"{name=%@, rooms=%@, teachers=%@, time=%@, weekday=%@, year=%@}",
            self.name,
            self.rooms,
            self.teachers,
            self.time,
            self.weekday,
            self.year
            ];
}

@end
