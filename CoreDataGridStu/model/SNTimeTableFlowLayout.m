//
//  SNTimeTable.m
//  CoreDataGridStu
//
//  Created by sseen on 2016/11/9.
//  Copyright © 2016年 sseen. All rights reserved.
//



#import "SNTimeTableFlowLayout.h"
#import "SNTimeTableDataSource.h"
#import "Course+CoreDataClass.h"


static const NSUInteger DaysPerWeek = 7;
static const NSUInteger HoursPerDay = 13;//24;
static const CGFloat HeightPerHour = 50;
static const CGFloat DayHeaderHeight = 50;
static const CGFloat HourHeaderWidth = 20;


@implementation SNTimeTableFlowLayout


#pragma mark - UICollectionViewLayout Implementation

- (CGSize)collectionViewContentSize
{
    // Don't scroll horizontally
    CGFloat contentWidth = self.collectionView.bounds.size.width;
    
    // Scroll vertically to display a full day
    CGFloat contentHeight = DayHeaderHeight + (HeightPerHour * HoursPerDay);
    
    CGSize contentSize = CGSizeMake(contentWidth, contentHeight);
    return contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    // Cells
    NSArray *visibleIndexPaths = [self indexPathsOfItemsInRect:rect];
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    
    // Supplementary views
    NSArray *dayHeaderViewIndexPaths = [self indexPathsOfDayHeaderViewsInRect:rect];
    for (NSIndexPath *indexPath in dayHeaderViewIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:@"DayHeaderView" atIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    NSArray *hourHeaderViewIndexPaths = [self indexPathsOfHourHeaderViewsInRect:rect];
    for (NSIndexPath *indexPath in hourHeaderViewIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:@"HourHeaderView" atIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SNTimeTableDataSource *dataSource = self.collectionView.dataSource;
    Course* event = [dataSource eventAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = [self frameForEvent:event];
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    
    CGFloat totalWidth = [self collectionViewContentSize].width;
    if ([kind isEqualToString:@"DayHeaderView"]) {
        CGFloat availableWidth = totalWidth - HourHeaderWidth;
        CGFloat widthPerDay = availableWidth / DaysPerWeek;
        attributes.frame = CGRectMake(HourHeaderWidth + (widthPerDay * indexPath.item), 0, widthPerDay, DayHeaderHeight);
        attributes.zIndex = -10;
    } else if ([kind isEqualToString:@"HourHeaderView"]) {
        attributes.frame = CGRectMake(0, DayHeaderHeight + HeightPerHour * (indexPath.item -1), totalWidth, HeightPerHour);
        attributes.zIndex = -10;
    }
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

#pragma mark - Helpers

- (NSArray *)indexPathsOfItemsInRect:(CGRect)rect
{
    
    SNTimeTableDataSource *dataSource = self.collectionView.dataSource;
    NSMutableArray *indexPaths = [NSMutableArray array];
    if ([dataSource dataCounts] > 0) {
        
        for (NSInteger idx = 0; idx < [dataSource dataCounts]; idx++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
            [indexPaths addObject:indexPath];
        }
    }
    
    return indexPaths;
}



- (NSArray *)indexPathsOfDayHeaderViewsInRect:(CGRect)rect
{
    if (CGRectGetMinY(rect) > DayHeaderHeight) {
        return [NSArray array];
    }
    
    NSInteger minDayIndex = [self dayIndexFromXCoordinate:CGRectGetMinX(rect)];
    NSInteger maxDayIndex = [self dayIndexFromXCoordinate:CGRectGetMaxX(rect)];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger idx = minDayIndex; idx <= maxDayIndex; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

- (NSArray *)indexPathsOfHourHeaderViewsInRect:(CGRect)rect
{
    if (CGRectGetMinX(rect) > HourHeaderWidth) {
        return [NSArray array];
    }
    
    NSInteger minHourIndex = [self hourIndexFromYCoordinate:CGRectGetMinY(rect)];
    NSInteger maxHourIndex = [self hourIndexFromYCoordinate:CGRectGetMaxY(rect)];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger idx = minHourIndex; idx <= maxHourIndex; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

- (CGRect)frameForEvent:(Course *)event
{
    CGFloat totalWidth = [self collectionViewContentSize].width - HourHeaderWidth;
    CGFloat widthPerDay = totalWidth / DaysPerWeek;
    
    CGRect frame = CGRectZero;
    frame.origin.x = HourHeaderWidth + widthPerDay * event.weekday.integerValue;
    frame.origin.y = DayHeaderHeight + HeightPerHour * (event.time.integerValue -1);
    frame.size.width = widthPerDay;
    frame.size.height = 2 * HeightPerHour; //event.durationInHours * HeightPerHour;
    
    // frame = CGRectInset(frame, 1.0/2, 1.0/2);
    return frame;
}


- (NSInteger)dayIndexFromXCoordinate:(CGFloat)xPosition
{
    CGFloat contentWidth = [self collectionViewContentSize].width - HourHeaderWidth;
    CGFloat widthPerDay = contentWidth / DaysPerWeek;
    NSInteger dayIndex = MAX((NSInteger)0, (NSInteger)((xPosition - HourHeaderWidth) / widthPerDay));
    return dayIndex;
}

- (NSInteger)hourIndexFromYCoordinate:(CGFloat)yPosition
{
    NSInteger hourIndex = MAX((NSInteger)0, (NSInteger)((yPosition - DayHeaderHeight) / HeightPerHour));
    return hourIndex;
}

@end
