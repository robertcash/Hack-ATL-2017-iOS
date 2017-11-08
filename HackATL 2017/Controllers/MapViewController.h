//
//  MapViewController.h
//  HackATL 2017
//
//  Created by Robert Cash on 10/26/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import "HackATLAPI.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *mapView;


@end
