//
//  QuestionTableViewCell.h
//  HackATL 2017
//
//  Created by Robert Cash on 10/25/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
