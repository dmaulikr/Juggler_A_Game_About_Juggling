//
//  JugglerViewController.h
//  Juggler
//
//  Created by Evan Lewis on 5/29/14.
//  Copyright (c) 2014 Evan Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "GADBannerView.h"

@interface JugglerViewController : UIViewController <ADBannerViewDelegate> {
    GADBannerView *bannerView;
}

-(void)showGameCenterLeaderboard;

@end
