//
//  WeekCollectionReusableView.h
//  CoreDataGridStu
//
//  Created by sseen on 16/6/3.
//  Copyright © 2016年 sseen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekCollectionReusableView : UICollectionReusableView

@property (nonatomic, assign) NSInteger weekNow;

- (void)setWeekNow:(int)weekNow year:(int)year;

@end
