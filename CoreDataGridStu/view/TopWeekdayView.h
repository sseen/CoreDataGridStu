//
//  TopWeekdayView.h
//  CoreDataGridStu
//
//  Created by sseen on 2016/11/11.
//  Copyright © 2016年 sseen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopWeekdayView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *lblWeek;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@property (nonatomic, assign) NSInteger weekNow;

- (void)setWeekNow:(int)weekNow year:(int)year index:(int)weekDay;
@end
