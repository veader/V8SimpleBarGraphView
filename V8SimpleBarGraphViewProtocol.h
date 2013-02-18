//
//  V8SimpleGraphViewProtocol.h
//
//  Created by Shawn Veader on 2/16/13.
//  Copyright (c) 2013 Shawn Veader. All rights reserved.
//

@class V8SimpleBarGraphView;


@protocol V8SimpleBarGraphViewDataSource <NSObject>
@required
- (NSUInteger)numberOfItemsInSimpleGraphView:(V8SimpleBarGraphView *)graphView;
- (NSInteger)valueOfItemInSimpleGraphView:(V8SimpleBarGraphView *)graphView atIndex:(NSUInteger)index;
@end


@protocol V8SimpleBarGraphViewDelegate <NSObject>
@optional
- (void)simpleBarGraphView:(V8SimpleBarGraphView *)graphView didHoverOnIndex:(NSUInteger)index;
- (void)simpleBarGraphView:(V8SimpleBarGraphView *)graphView didTapOnIndex:(NSUInteger)index;
- (UIColor *)colorForBarInSimpleGraphView:(V8SimpleBarGraphView *)graphView atIndex:(NSUInteger)index;

// @required
@end
