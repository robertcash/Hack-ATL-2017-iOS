//
//  AnswerViewController.h
//  HackATL 2017
//
//  Created by Robert Cash on 10/25/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import "NSDate+TimeFormatting.h"
#import "Question.h"
#import <UIKit/UIKit.h>

@interface AnswerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;

@property Question *question;

@end
