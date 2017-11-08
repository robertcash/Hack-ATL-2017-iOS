//
//  InfoWithImageTableViewCell.h
//  HackATL 2017
//
//  Created by Robert Cash on 10/26/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <UIKit/UIKit.h>

@interface InfoWithImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photo;

@end
