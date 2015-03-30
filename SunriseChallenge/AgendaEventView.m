//
//  AgendaEventView.m
//  SunriseChallenge
//
//  Created by Steve Hall on 3/27/15.
//  Copyright (c) 2015 Steve Hall. All rights reserved.
//

#import "AgendaEventView.h"
#import "DateUtil.h"

@interface AgendaEventView()

@property (strong, nonatomic) UILabel *startTimeLabel;
@property (strong, nonatomic) UILabel *durationLabel;
@property (strong, nonatomic) UIImageView *eventTypeImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *longDescriptionLabel;

@end

@implementation AgendaEventView

- (void)updateView:(Event *)event
{
    // Start time
    self.startTimeLabel =[[UILabel alloc] initWithFrame:CGRectMake(16, 8, self.frame.size.width - 16, 16)];
    if (event.isAllDayEvent)
    {
        self.startTimeLabel.text = @"ALL DAY";
    }
    else
    {
        self.startTimeLabel.text = [DateUtil getTimeFromDate:event.eventStartDate];
    }
    self.startTimeLabel.font = [UIFont systemFontOfSize:12];
    self.longDescriptionLabel.textColor = [UIColor blackColor];
    [self addSubview:self.startTimeLabel];
    
    // Duration
    self.durationLabel =[[UILabel alloc] initWithFrame:CGRectMake(16, 26, self.frame.size.width - 16, 16)];
    if (!event.isAllDayEvent)
    {
        self.durationLabel.text = event.duration;
    }
    self.durationLabel.font = [UIFont systemFontOfSize:12];
    self.durationLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.durationLabel];
    
    // Event type image
    self.eventTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(72, 4, 30, 30)];
    NSString *eventTypeImageName = [NSString stringWithFormat:@"%@Icon", event.eventType];
    self.eventTypeImageView.image = [UIImage imageNamed:eventTypeImageName];
    [self addSubview:self.eventTypeImageView];
    
    // Title
    self.titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(110, 8, self.frame.size.width - 100, 16)];
    self.titleLabel.text = event.title;
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    self.titleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.titleLabel];
    
    // Long description
    self.longDescriptionLabel =[[UILabel alloc] initWithFrame:CGRectMake(110, 26, self.frame.size.width - 100, 16)];
    self.longDescriptionLabel.text = event.longDescription;
    self.longDescriptionLabel.font = [UIFont systemFontOfSize:14];
    self.longDescriptionLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.longDescriptionLabel];
}

@end
