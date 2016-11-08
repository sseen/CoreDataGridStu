//
//  SNTimeTableDataSource.m
//  CoreDataGridStu
//
//  Created by sseen on 2016/11/8.
//  Copyright © 2016年 sseen. All rights reserved.
//

#import "SNTimeTableDataSource.h"

#import "Course.h"
#import "WeekCollectionReusableView.h"


@interface SNTimeTableDataSource()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SNTimeTableDataSource

#pragma mark - datasouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell0" forIndexPath:indexPath];
    
    if (_dataSource.count > 0) {
        cell.backgroundColor= [UIColor colorWithRed:0.23 green:0.60 blue:0.85 alpha:1.00];
        UILabel *lblTitle = [cell viewWithTag:1001];
        Course *tmp =  _dataSource[indexPath.item];
        // NSLog(@"%@", tmp.name);
        if ([tmp isKindOfClass:[Course class]]) {
            lblTitle.text = [NSString stringWithFormat:@"%@ %@",tmp.name, tmp.rooms];
        }else {
            lblTitle.text = @"";
            cell.backgroundColor = [UIColor colorWithRed:0.23 green:0.60 blue:0.85 alpha:0.4];
        }
    }
    
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    WeekCollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"supplementCell" forIndexPath:indexPath];
    
    if (kind == UICollectionElementKindSectionHeader) {
        [reusableview setWeekNow:(int)_nowSelected + 9 year:(int)_weekOfNow.year];
    }
    
    
    return reusableview;
}

@end
