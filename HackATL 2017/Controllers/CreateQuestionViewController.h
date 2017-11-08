//
//  CreateQuestionViewController.h
//  HackATL 2017
//
//  Created by Robert Cash on 10/25/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

#import "HackATLAPI.h"
#import "Question.h"
#import <UIKit/UIKit.h>

@interface CreateQuestionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end
