//
//  ViewController.m
//  datePicker
//
//  Created by 彪 马 on 15/8/25.
//  Copyright (c) 2015年 彪叔. All rights reserved.
//

#define PickerViewHeight 240
#define BorderWidth     0.3

#import "ViewController.h"
#import "DIDatepicker.h"
#import "UIButton+Border.h"
@interface ViewController ()<DIDatepickerDelegate,UIScrollViewDelegate>
{
    DIDatepicker *picker;
    UIView *contentView;
    UIScrollView *scroller;
    NSMutableArray *dataArray;
    UIButton *pickerButton;
    UIView *alphaView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadInitData];
    [self loadButton];
    [self loadPickerView];
}

- (void)loadAlphaView{
    if (!alphaView) {
        alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
        alphaView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickup:)];
        [alphaView addGestureRecognizer:tap];
        [self.view addSubview:alphaView];
        [self.view bringSubviewToFront:contentView];
    }
}

- (void)loadInitData{
    dataArray = [NSMutableArray arrayWithObjects:@"8:30",@"9:00",@"9:30",@"13:30\n(约满)",@"14:00",@"14:30",@"16:00\n(约满)",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30", nil];
}

- (void)loadButton{
    if (!pickerButton) {
        pickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [pickerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [pickerButton setTitle:@"请选择服务时间" forState:UIControlStateNormal];
        pickerButton.frame = CGRectMake(self.view.bounds.size.width/2-100, 100, 200, 44);
        [pickerButton addTarget:self action:@selector(pickup:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:pickerButton];
    }
    
}

- (void)loadPickerView{
    
    if (!contentView) {
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, PickerViewHeight)];
        contentView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:contentView];
    }
    
    if (!picker) {
        picker = [[DIDatepicker alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
        picker.delegate = self;
        picker.selectedDateBottomLineColor = [UIColor colorWithRed:241./255 green:100./255 blue:72./255 alpha:1];
        [picker fillDatesFromDate:[NSDate date] numberOfDays:7];
        [picker selectDateAtIndex:0];
        [contentView addSubview:picker];
    }
    
    if (!scroller) {
        scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, PickerViewHeight-60)];
        scroller.contentSize = CGSizeMake(self.view.bounds.size.width*8, PickerViewHeight-60);
        scroller.pagingEnabled = YES;
        scroller.delegate = self;
        scroller.showsHorizontalScrollIndicator = NO;
        for (int i = 0; i<8; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*self.view.bounds.size.width, 0, self.view.bounds.size.width, PickerViewHeight-60)];
            
            NSInteger count = dataArray.count;
            for (int j = 0; j<count; j++) {
                NSInteger margin = 20;
                NSInteger padding = 15;
                NSInteger x = j%4;
                NSInteger y = j/4;
                NSInteger width = (self.view.bounds.size.width-margin*2)/4;
                NSInteger height = 80-padding*2;
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(margin+x*width, padding+y*height, width, height);
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                btn.titleLabel.numberOfLines = 0;
                btn.titleLabel.contentMode = NSLineBreakByWordWrapping;
                btn.titleLabel.textAlignment =NSTextAlignmentCenter;
                btn.backgroundColor = [UIColor whiteColor];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithRed:201./255 green:201./255 blue:201./255 alpha:1] forState:UIControlStateDisabled];
                [btn setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:241./255 green:100./255 blue:72./255 alpha:1]] forState:UIControlStateSelected];
                [btn setBackgroundImage:[self createImageWithColor:[UIColor lightTextColor]] forState:UIControlStateDisabled];
                if ([dataArray[j] hasSuffix:@"(约满)"]) {
                    btn.enabled = NO;
                    NSString *isFilled = dataArray[j];
                    NSMutableAttributedString *date = [[NSMutableAttributedString alloc] initWithString:isFilled];
                    [date addAttributes:@{
                                          NSFontAttributeName: [UIFont systemFontOfSize:10],
                                          NSForegroundColorAttributeName: [UIColor grayColor]
                                          } range:NSMakeRange(isFilled.length-4,4)];
                    
                    [date addAttributes:@{
                                          NSFontAttributeName: [UIFont systemFontOfSize:14],
                                          NSForegroundColorAttributeName: [UIColor grayColor]
                                          } range:NSMakeRange(0,isFilled.length-4)];
                    [btn setAttributedTitle:date forState:UIControlStateNormal];
                }else{
                    [btn setTitle:dataArray[j] forState:UIControlStateNormal];
                }
                btn.tag = j;
                [btn addTarget:self action:@selector(dataSelected:) forControlEvents:UIControlEventTouchUpInside];
                
                [btn addLeftBorderWithColor:[UIColor grayColor] andWidth:BorderWidth];
                [btn addTopBorderWithColor:[UIColor grayColor] andWidth:BorderWidth];
                if (j == 3 || j == 7|| j==11) {
                    [btn addRightBorderWithColor:[UIColor grayColor] andWidth:BorderWidth];
                }
                if (j >=8 ) {
                    [btn addBottomBorderWithColor:[UIColor grayColor] andWidth:BorderWidth];
                }
                [view addSubview:btn];
            }
            
            [scroller addSubview:view];
        }
        [contentView addSubview:scroller];
    }
}

- (void)dataSelected:(UIButton *)sender
{
    UIButton *btn = (UIButton *)sender;
    for (UIView *view in scroller.subviews) {
        
        for (UIButton *bb in view.subviews) {
            if ([bb isKindOfClass:[UIButton class]]) {
                if (bb.tag == btn.tag) {
                    bb.selected = YES;
                }else{
                    bb.selected = NO;
                }
            }
        }
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"YYYY-MM-dd(EEE)" options:0 locale:nil];
    [pickerButton setTitle:[NSString stringWithFormat:@"%@ %@",[formatter stringFromDate:picker.selectedDate],dataArray[btn.tag]] forState:UIControlStateNormal];
    [self pickup:nil];
}

- (void)pickup:(id)sender
{
    if (contentView.frame.origin.y == self.view.bounds.size.height) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect tempRect = contentView.frame;
            tempRect.origin.y -= PickerViewHeight;
            contentView.frame = tempRect;
            [self loadAlphaView];
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            CGRect tempRect = contentView.frame;
            tempRect.origin.y += PickerViewHeight;
            contentView.frame = tempRect;
            alphaView.alpha = 0;
            [alphaView removeFromSuperview];
            alphaView = nil;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)DIDatepicker:(DIDatepicker *)picker didSelectToIndex:(NSInteger)index
{
    [scroller scrollRectToVisible:CGRectMake(index*self.view.bounds.size.width, 0, self.view.bounds.size.width, PickerViewHeight-60) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == scroller) {
        CGFloat xOffset = scroller.contentOffset.x;
        NSInteger index = xOffset/self.view.bounds.size.width;
        [picker selectDateAtIndex:index];
    }
}

- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
