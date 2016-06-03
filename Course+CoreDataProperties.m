//
//  Course+CoreDataProperties.m
//  CoreDataGridStu
//
//  Created by sseen on 16/6/2.
//  Copyright © 2016年 sseen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Course+CoreDataProperties.h"
#import <objc/runtime.h>

@implementation Course (CoreDataProperties)

@dynamic name;
@dynamic rooms;
@dynamic teachers;
@dynamic time;
@dynamic weekday;
@dynamic year;
@dynamic timeStr;
@dynamic week_of_year;


- (NSString *)description {
    return [NSString stringWithFormat:@"{name=%@, rooms=%@, teachers=%@, timeStr=%@, time=%@, weekday=%@, year=%@}",
            self.name,
            self.rooms,
            self.teachers,
            self.timeStr,
            self.time,
            self.weekday,
            self.year
            ];
}
-(id)copyWithZone:(NSZone *)zone { // shallow copy
    NSManagedObjectContext *context = [self managedObjectContext];
    // 会插入这些数据，需要再 context 里删除掉
    id copied = [[[self class] allocWithZone: zone] initWithEntity: [self entity] insertIntoManagedObjectContext: context];
    
    for(NSString *key in [[[self entity] attributesByName] allKeys]) {
        [copied setValue: [self valueForKey: key] forKey: key];
    }
    
    for(NSString *key in [[[self entity] relationshipsByName] allKeys]) {
        [copied setValue: [self valueForKey: key] forKey: key];
    }
    return copied;
}

@end
