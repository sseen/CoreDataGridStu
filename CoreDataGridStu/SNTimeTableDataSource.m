//
//  SNTimeTableDataSource.m
//  CoreDataGridStu
//
//  Created by sseen on 2016/11/8.
//  Copyright © 2016年 sseen. All rights reserved.
//

#import "SNTimeTableDataSource.h"

#import "TopWeekdayView.h"


@interface SNTimeTableDataSource()



@end

@implementation SNTimeTableDataSource

#pragma mark - datasouce

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell0" forIndexPath:indexPath];
    
    cell.backgroundColor= [UIColor colorWithRed:0.23 green:0.60 blue:0.85 alpha:1.00];
    Course *tmp =  _dataSource[indexPath.item];
    
    if (_configureCellBlock) {
        self.configureCellBlock(cell, indexPath, tmp);
    }

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"datasource %@", indexPath);
    TopWeekdayView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"supplementCell" forIndexPath:indexPath];
    
    if (self.configureHeaderViewBlock) {
        self.configureHeaderViewBlock(reusableview, kind, indexPath);
    }
    
    return reusableview;
}

- (Course *)eventAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count <= 0) {
        return nil;
    }
    return self.dataSource[indexPath.item];
}

- (NSInteger)dataCounts {
    return self.dataSource.count;
}

@end
