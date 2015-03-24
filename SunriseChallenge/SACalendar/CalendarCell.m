//
//  CalendarCell.m
//  SunriseChallenge
//
//  Created by Steve Hall on 3/23/15.
//  Copyright (c) 2015 Steve Hall. All rights reserved.
//

#import "CalendarCell.h"

@implementation CalendarCell

// Draw the basic components of the cell, including the top grey line, the red current date circle,
// the black selected circle and the date label. Customized the cell apperance by editing this function.
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        // Display the top line view
        self.topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 3)];
        self.topLineView.backgroundColor = [UIColor darkGrayColor];
        
        // Display the date label
        self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.dateLabel.textColor = [UIColor darkGrayColor];
        
        // Display the month label
        self.monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, frame.size.width, 10)];
        self.monthLabel.textAlignment = NSTextAlignmentCenter;
        self.monthLabel.backgroundColor = [UIColor clearColor];
        self.monthLabel.font = [UIFont systemFontOfSize:10];

        
        // Get the labelSize
        CGRect labelFrame = self.dateLabel.frame;
        CGSize labelSize = labelFrame.size;
        CGPoint origin;
        int length;
        CGFloat circleToCellRatio = 0.8;
        
        // Calculate the origin and length
        origin.x = (labelSize.width * (1 - circleToCellRatio)) / 2;
        origin.y = (labelSize.height - labelSize.width * circleToCellRatio) / 2;
        length = labelSize.width * circleToCellRatio;
        
        // Display the circleView
        self.circleView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, length, length)];
        self.circleView.layer.cornerRadius = length / 2;
        self.circleView.backgroundColor = [UIColor darkGrayColor];
        self.circleView.hidden = YES;
        
        // Display the selectedView
        self.selectedView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, length, length)];
        self.selectedView.layer.cornerRadius = length / 2;
        self.selectedView.backgroundColor = [UIColor blueColor];
        self.selectedView.hidden = YES;
        
        // Add the views
        [self.viewForBaselineLayout addSubview:self.topLineView];
        [self.viewForBaselineLayout addSubview:self.circleView];
        [self.viewForBaselineLayout addSubview:self.selectedView];
        [self.viewForBaselineLayout addSubview:self.dateLabel];
        [self.viewForBaselineLayout addSubview:self.monthLabel];
    }
    
    return self;
}

@end
