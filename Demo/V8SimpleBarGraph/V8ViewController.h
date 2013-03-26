//
//  V8ViewController.h
//  V8SimpleBarGraph
//
//  Created by Shawn Veader on 2/16/13.
//  Copyright (c) 2013 Shawn Veader. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "V8SimpleBarGraphView.h"
#import "V8SimpleBarGraphViewProtocol.h"

@interface V8ViewController : UIViewController <V8SimpleBarGraphViewDelegate, V8SimpleBarGraphViewDataSource>

@property (nonatomic, strong) NSArray *barValues;
@property (nonatomic, strong) IBOutlet V8SimpleBarGraphView *graphView;
@property (nonatomic, strong) IBOutlet UIButton *animateButton;
@property (nonatomic, strong) IBOutlet UILabel *indexLabel;
@property (nonatomic, strong) IBOutlet UILabel *arrowLabel;
@property (nonatomic, strong) IBOutlet UILabel *valueLabel;

- (IBAction)animateButtonTapped:(id)sender;

@end
