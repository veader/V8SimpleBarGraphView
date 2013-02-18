//
//  V8SimpleBarGraphView.h
//  V8SimpleBarGraph
//
//  Created by Shawn Veader on 2/16/13.
//  Copyright (c) 2013 Shawn Veader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V8SimpleBarGraphViewProtocol.h"

@interface V8SimpleBarGraphView : UIView

// delegate and datasources to feed graph. this view only maintains a weak reference to these
@property (nonatomic, weak) IBOutlet id <V8SimpleBarGraphViewDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id <V8SimpleBarGraphViewDelegate> delegate;

// padding values. these default to 5pt
@property (nonatomic, assign) CGFloat paddingTop;
@property (nonatomic, assign) CGFloat paddingBottom;
@property (nonatomic, assign) CGFloat paddingLeft;
@property (nonatomic, assign) CGFloat paddingRight;
@property (nonatomic, assign) CGFloat paddingBetweenBars;

// statically set bar colors. alternatively use delegate callback methods
@property (nonatomic, strong) UIColor *barColor;
@property (nonatomic, strong) UIColor *selectedBarColor;

// TODO: track selection/hover point/index

- (void)reloadData;

@end
