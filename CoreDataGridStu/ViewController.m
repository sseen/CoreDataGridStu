//
//  ViewController.m
//  CoreDataGridStu
//
//  Created by sseen on 16/5/31.
//  Copyright © 2016年 sseen. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

#import "Course.h"

int cellsInLine = 5;

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIPickerView *pvWeek;
@property (assign, nonatomic) Boolean statusPickerVisible;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.dataSource = appDelegate.dataSource;
    
    UIView *buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [button setTitle:@"第10周" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ckTitle:) forControlEvents:UIControlEventTouchUpInside ];
    [buttonsView addSubview: button];
    self.navigationItem.titleView = buttonsView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - target
- (void)ckTitle:(UIButton *)sender {
    [self showStatusPickerCell];
}
- (void)showStatusPickerCell {
    self.statusPickerVisible = YES;
    self.pvWeek.hidden = NO;
    self.pvWeek.alpha = 0.0f;
    [self.view bringSubviewToFront:_pvWeek];
    [UIView animateWithDuration:0.25 animations:^{
        self.pvWeek.alpha = 1.0f;
    }];
}

- (void)hideStatusPickerCell {
    self.statusPickerVisible = NO;
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.pvWeek.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.pvWeek.hidden = YES;
                     }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"ABC";
}

#pragma mark - datasouce

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell0" forIndexPath:indexPath];
    
    cell.backgroundColor= [UIColor colorWithRed:0.23 green:0.60 blue:0.85 alpha:1.00];
    UILabel *lblTitle = [cell viewWithTag:1001];
    Course *tmp =  _dataSource[indexPath.item];
    if (tmp.weekday.integerValue != -1) {
        lblTitle.text = [NSString stringWithFormat:@"%@ %@",tmp.name, tmp.rooms];
    }else {
        lblTitle.text = @"";
        cell.backgroundColor = [UIColor colorWithRed:0.23 green:0.60 blue:0.85 alpha:0.4];
    }
    
    return cell;
}

#pragma mark - flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = [self itemWidth];
    return CGSizeMake(width, width);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return [self itemSpacing];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return [self itemSpacing];
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //     return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}

- (float)itemSpacing {
    float width = [self itemWidth];
    float spacing = ((CGRectGetWidth(self.view.frame) - cellsInLine * width) / (cellsInLine -1));
    return spacing;
}

- (float)itemWidth {
    float width = roundf(( CGRectGetWidth(self.view.frame) - cellsInLine + 1) / cellsInLine);
    return width;
}

@end
