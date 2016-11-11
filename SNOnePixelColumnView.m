//
//  SNOnePixelColumnView.m
//  CoreDataGridStu
//
//  Created by sseen on 2016/11/11.
//  Copyright © 2016年 sseen. All rights reserved.
//

#import "SNOnePixelColumnView.h"

@implementation SNOnePixelColumnView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  (1 / [UIScreen mainScreen].scale), 40)];
        [self addSubview:line1];
    }
    return self;
}


@end
