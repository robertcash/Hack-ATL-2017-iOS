//
//  InfoTableViewController.h
//  HackATL 2017
//
//  Created by Robert Cash on 10/26/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "HackATLAPI.h"
#import "Info.h"
#import "InfoTableViewCell.h"
#import "InfoWithImageTableViewCell.h"
#import <UIKit/UIKit.h>

@interface InfoTableViewController : UITableViewController

@property NSString *infoType;

@end
