//
//  AgendaEventView.m
//  SunriseChallenge
//
//  Created by Steve Hall on 3/27/15.
//  Copyright (c) 2015 Steve Hall. All rights reserved.
//

#import "AgendaEventView.h"

@interface AgendaEventView()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *longDescriptionLabel;
@property (strong, nonatomic) UILabel *durationLabell;

@end

@implementation AgendaEventView

- (void)updateView:(Event *)event
{
    // These labels are just for testing that I'm pulling the data
    // Not the real implementation
    
    self.titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(16, 0, 320, 16)];
    self.titleLabel.text = event.title;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    
    self.longDescriptionLabel =[[UILabel alloc] initWithFrame:CGRectMake(16, 20, 320, 16)];
    self.longDescriptionLabel.text = event.longDescription;
    self.longDescriptionLabel.font = [UIFont systemFontOfSize:14];
    
    self.durationLabell =[[UILabel alloc] initWithFrame:CGRectMake(16, 40, 320, 16)];
    self.durationLabell.text = event.duration;
    self.durationLabell.font = [UIFont systemFontOfSize:14];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.longDescriptionLabel];
    [self addSubview:self.durationLabell];
}

@end
