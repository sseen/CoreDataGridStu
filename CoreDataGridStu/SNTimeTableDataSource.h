//
//  SNTimeTableDataSource.h
//  CoreDataGridStu
//
//  Created by sseen on 2016/11/8.
//  Copyright © 2016年 sseen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void (^ConfigureCellBlock)(CalendarEventCell *cell, NSIndexPath *indexPath, id<CalendarEvent> event);
typedef void (^ConfigureHeaderViewBlock)(HeaderView *headerView, NSString *kind, NSIndexPath *indexPath);


@interface SNTimeTableDataSource : NSObject <UICollectionViewDataSource>


@property (copy, nonatomic) ConfigureCellBlock configureCellBlock;
@property (copy, nonatomic) ConfigureHeaderViewBlock configureHeaderViewBlock;

@end
