//
//  V8SimpleBarGraphView.m
//  V8SimpleBarGraph
//
//  Created by Shawn Veader on 2/16/13.
//  Copyright (c) 2013 Shawn Veader. All rights reserved.
//

#import "V8SimpleBarGraphView.h"


@interface V8SimpleBarGraphView ()

@property (nonatomic, assign) NSInteger numberOfBars;
@property (nonatomic, strong) NSMutableArray *barValues;

@property (nonatomic, assign) NSInteger maxBarValue;
@property (nonatomic, assign) CGFloat barWidth;

@property (nonatomic, assign) BOOL barCountDetermined;
@property (nonatomic, assign) BOOL gatheringData;

@property (nonatomic, strong) UITouch *trackedTouch;

@end


#pragma mark - Implementation
@implementation V8SimpleBarGraphView

#pragma mark - Init/Dealloc
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self setDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)theCoder {
	self = [super initWithCoder:theCoder];
	if (self) {
		[self setDefaults];
	}
	return self;
}

- (void)dealloc {
	self.dataSource = nil;
	self.delegate = nil;
}


#pragma mark - LayoutSubViews
- (void)layoutSubviews {
	[super layoutSubviews];

	if (!self.barCountDetermined) {
		[self collectData];
	}
	[self determineBarWidth];

	// find or create subviews for each bar
	UIView *viewForIndex = nil;
	for (int i = 0; i < self.numberOfBars; i++) {
		viewForIndex = [self viewWithTag:[self tagForBarAtIndex:i]];
		if (!viewForIndex) {
			// bar should grow entire height, set height back to 0
			viewForIndex = [[UIView alloc] initWithFrame:[self defaultFrameForBarAtIndex:i]];
			[viewForIndex setTag:[self tagForBarAtIndex:i]];
			[self addSubview:viewForIndex];
		}
		viewForIndex.backgroundColor = [self getColorForBarAtIndex:i];
	}

	// now animate the bars to proper height
	[UIView animateWithDuration:0.2f
						  delay:0.1f
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 UIView *barView = nil;
						 for (int i = 0; i < self.numberOfBars; i++) {
							 barView = [self viewWithTag:[self tagForBarAtIndex:i]];
							 if (barView) {
								 barView.frame = [self frameForBarAtIndex:i];
							 }
						 }
					 }
					 completion:^(BOOL finished){
					 }];
}


#pragma mark - Getters and Setters
- (void)setDataSource:(id)newDataSource {
	if (_dataSource != newDataSource) {
		_dataSource = newDataSource;
		[self collectData];
	}
}
 
- (void)setFrame:(CGRect)newFrame {
	if (!CGRectEqualToRect(self.frame, newFrame)) {
		// resize as necessary and "redraw"
		[self determineBarWidth];
		[self setNeedsDisplay];
	}
	[super setFrame:newFrame];
}


#pragma mark - Data Fetching Methods
- (void)reloadData {
	[self collectData];
}

- (void)collectData {
	if (!self.gatheringData) {
		self.gatheringData = YES;
		self.barCountDetermined = NO;

		if (!self.barValues) {
			self.barValues = [NSMutableArray array];
		}

		[self getNumberOfBarsFromDataSource];
		[self getBarValuesFromDataSource];
		[self determineMaximumBarValue];

		self.barCountDetermined = YES;
		self.gatheringData = NO;
		[self setNeedsLayout];
	}
}

// return the tag for the bar at a given index
- (NSInteger)tagForBarAtIndex:(NSInteger)index {
	return ((index + 1) * 10) + 13;
}

- (void)setDefaults {
	self.numberOfBars = 0;
	self.maxBarValue = 0;
	self.barWidth = 0.0f;
	self.barValues = [NSMutableArray array];
	
	self.barCountDetermined = NO;
	self.gatheringData = NO;
	
	self.paddingBetweenBars = 2.0f;
	self.paddingTop = 5.0f;
	self.paddingBottom = 5.0f;
	self.paddingLeft = 5.0f;
	self.paddingBottom = 5.0f;
	
	self.barColor = [UIColor grayColor];
	self.selectedBarColor = nil;
	
	self.currentlySelectedIndex = -1;
}

#pragma mark - Data Source Methods
- (void)getNumberOfBarsFromDataSource {
	if (self.dataSource) {
		self.numberOfBars = [self.dataSource numberOfItemsInSimpleGraphView:self];
	} else {
		self.numberOfBars = 0;
	}
}

- (void)getBarValuesFromDataSource {
	if (self.dataSource) {
		NSMutableArray *tempValues = [NSMutableArray array];
		for (int i = 0; i < self.numberOfBars; i++) {
			NSInteger barValue = [self.dataSource valueOfItemInSimpleGraphView:self atIndex:i];
			[tempValues addObject:[NSNumber numberWithInteger:barValue]];
		}
		self.barValues = tempValues;
	}
}

#pragma mark - Delegate Methods
- (UIColor *)getColorForBarAtIndex:(NSUInteger)index {
	if (self.delegate && [self.delegate respondsToSelector:@selector(colorForBarInSimpleGraphView:atIndex:)]) {
		return [self.delegate colorForBarInSimpleGraphView:self atIndex:index];
	}

	if (index == self.currentlySelectedIndex && self.selectedBarColor) {
		return self.selectedBarColor;
	} else {
		return self.barColor;
	}
}

- (void)notifyDelegateOfTouchAtIndex:(NSUInteger)index {
	if (self.delegate && [self.delegate respondsToSelector:@selector(simpleBarGraphView:didHoverOnIndex:)]) {
		[self.delegate simpleBarGraphView:self didHoverOnIndex:index];
	}
}


#pragma mark - Calculation Methods
- (void)determineMaximumBarValue {
	if ([self.barValues count] > 0) {
		self.maxBarValue = [[self.barValues valueForKeyPath:@"@max.integerValue"] integerValue];
	} else {
		self.maxBarValue = 0;
	}
}

- (void)determineBarWidth {
	if (self.numberOfBars > 0) {
		CGFloat spaceBetweenBars = (self.numberOfBars - 1) * self.paddingBetweenBars;
		CGFloat padding = self.paddingLeft + self.paddingRight;
		self.barWidth = floor((self.bounds.size.width - padding - spaceBetweenBars) / self.numberOfBars);
		// TODO: notify if width is too small
		//		- truncate number of bars shown
	} else {
		self.barWidth = 0.0f;
	}
}

- (CGFloat)heightForBarAtIndex:(NSUInteger)index {
	if ([self.barValues count] > index && self.maxBarValue > 0) {
		NSInteger value = [[self.barValues objectAtIndex:index] integerValue];
		if (value > 0) {
			CGFloat percentage = (float)value / (float)self.maxBarValue;
			CGFloat padding = self.paddingTop + self.paddingBottom;
			CGFloat barHeight = floor((self.bounds.size.height - padding) * percentage);
			return fmaxf(barHeight, 1.0f); // values > 0 should at least show as a line
		} else {
			return 0.0f;
		}
	} else {
		return 0.0f;
	}
}

- (CGRect)frameForBarAtIndex:(NSUInteger)index {
	CGFloat height = [self heightForBarAtIndex:index];
	CGFloat y = self.bounds.size.height - self.paddingBottom - height;
	return CGRectMake([self xOriginForBarAtIndex:index], y, self.barWidth, height);
}

- (CGRect)defaultFrameForBarAtIndex:(NSUInteger)index {
	return CGRectMake([self xOriginForBarAtIndex:index], self.bounds.size.height - self.paddingBottom, self.barWidth, 0.0f);
}

- (CGFloat)xOriginForBarAtIndex:(NSUInteger)index {
	return (self.barWidth * index) + (self.paddingBetweenBars * index) + self.paddingLeft;
}

- (CGPoint)centerOfBarAtIndex:(NSUInteger)index {
	CGRect barFrame = [self frameForBarAtIndex:index];
	return CGPointMake((barFrame.origin.x + (self.barWidth / 2.0f)), self.frame.origin.y + self.frame.size.height);
}

#pragma mark - Touches Methods
- (void)handleTouchEvent {
	if (self.trackedTouch) {
		CGPoint location = [self.trackedTouch locationInView:self];
		NSInteger touchedIndex = [self determineIndexOfBarUnderPoint:location];
		if (self.currentlySelectedIndex != touchedIndex && touchedIndex != -1) {
			UIView *barView = nil;
			NSInteger oldIndex = self.currentlySelectedIndex;
			self.currentlySelectedIndex = touchedIndex;

			if (oldIndex != -1) {
				// set color back on previously touched bar
				barView = [self viewWithTag:[self tagForBarAtIndex:oldIndex]];
				barView.backgroundColor = [self getColorForBarAtIndex:oldIndex];
			}

			// set selected color on current bar
			barView = [self viewWithTag:[self tagForBarAtIndex:self.currentlySelectedIndex]];
			barView.backgroundColor = [self getColorForBarAtIndex:self.currentlySelectedIndex];

			[self notifyDelegateOfTouchAtIndex:self.currentlySelectedIndex];
		}
	}
	[self setNeedsDisplay];
}

- (NSInteger)determineIndexOfBarUnderPoint:(CGPoint)point {
	NSInteger index = -1;
	UIView *barView = nil;
	CGRect barFrame = CGRectZero;
	for (int i = 0; i < self.numberOfBars; i++) {
		barView = [self viewWithTag:[self tagForBarAtIndex:i]];
		if (barView) {
			// create slice of entire view so it's easier to scrub across graph
			barFrame = barView.frame;
			barFrame.origin.y = 0.0f;
			barFrame.size.height = self.bounds.size.height;
			if (CGRectContainsPoint(barFrame, point)) {
				index = i;
				break;
			}
		}
	}
	return index;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!self.trackedTouch && [touches count] > 0) {
		// only bother to start tracking, if we're not already tracking
		self.trackedTouch = [[touches allObjects] objectAtIndex:0];
		[self handleTouchEvent];
	}
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (self.trackedTouch && [touches containsObject:self.trackedTouch]) {
		[self handleTouchEvent];
	}
	[super touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	if (self.trackedTouch && [touches containsObject:self.trackedTouch]) {
		self.trackedTouch = nil;
		[self handleTouchEvent];
	}
	[super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (self.trackedTouch && [touches containsObject:self.trackedTouch]) {
		self.trackedTouch = nil;
		// TODO: handle tap?
		[self handleTouchEvent];
	}
	[super touchesEnded:touches withEvent:event];
}

@end
