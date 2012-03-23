//
//  ViewController.h
//  test
//
//  Created by Joseph Gallo on 3/21/12.
//  Copyright (c) 2012 Me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) UIButton *selectedButton;
@property (nonatomic, retain) UIColor *selectedColor;
@property (nonatomic, retain) NSMutableArray *colorPickerButtons;
@property (nonatomic, retain) NSMutableDictionary *buttonLabelsDict;
@property (nonatomic, retain) UIPopoverController *popover;
@property (nonatomic, retain) NSTimer *popoverTimer;

@end
