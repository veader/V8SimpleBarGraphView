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

@end
