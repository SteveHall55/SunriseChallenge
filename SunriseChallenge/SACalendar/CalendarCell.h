//
//  CalendarCell.h
//  SunriseChallenge
//
//  Created by Steve Hall on 3/23/15.
//  Copyright (c) 2015 Steve Hall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCell : UICollectionViewCell

// Grey line above the label
@property UIView *topLineView;

// A circle that appears on the current date
@property UIView *circleView;

// A circle that appears on the selected date
@property UIView *selectedView;

// Label showing the cell's date
@property UILabel *dateLabel;

// Label showing the month (only on 1st day of month)
@property UILabel *monthLabel;

@end
