//
//  SNTimeTableDataSource.h
//  CoreDataGridStu
//
//  Created by sseen on 2016/11/8.
//  Copyright © 2016年 sseen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class Course;


typedef void (^ConfigureCellBlock)(UICollectionViewCell *cell, NSIndexPath *indexPath, Course* model);
typedef void (^ConfigureHeaderViewBlock)(UICollectionReusableView *headerView, NSString *kind, NSIndexPath *indexPath);


@interface SNTimeTableDataSource : NSObject <UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;


- (Course *)eventAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)dataCounts;
@property (copy, nonatomic) ConfigureCellBlock configureCellBlock;
@property (copy, nonatomic) ConfigureHeaderViewBlock configureHeaderViewBlock;

@end
