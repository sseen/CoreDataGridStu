//
//  AppDelegate.h
//  CoreDataGridStu
//
//  Created by sseen on 16/5/31.
//  Copyright © 2016年 sseen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CoreDataStack;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) CoreDataStack* coreDataStack;

@end

