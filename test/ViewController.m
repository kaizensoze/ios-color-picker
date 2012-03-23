//
//  ViewController.m
//  test
//
//  Created by Joseph Gallo on 3/21/12.
//  Copyright (c) 2012 Me. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize scrollView;
@synthesize selectedButton;
@synthesize selectedColor;
@synthesize colorPickerButtons;
@synthesize buttonLabelsDict;
@synthesize popover;
@synthesize popoverTimer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Some constants to help reduce amount of "magic numbers".
    int BUTTON_WIDTH = 75;
    int BUTTON_HEIGHT = 75;
    int BUTTON_Y = 3;
    int BUTTON_PADDING_LEFT = 3;
    int BUTTON_PADDING_RIGHT = 3;
    
    // Scroll view.
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, BUTTON_Y*2 + BUTTON_HEIGHT)];
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    // Buttons.
    colorPickerButtons = [[NSMutableArray alloc] init];
    buttonLabelsDict = [[NSMutableDictionary alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"colors" ofType:@"plist"];
    NSArray *colors = [[NSArray alloc] initWithContentsOfFile:path];
    
    // Set content size of scrollbar to sum width of all the buttons.
    int numButtons = [colors count];
    scrollView.contentSize = CGSizeMake(BUTTON_PADDING_LEFT+(BUTTON_WIDTH+BUTTON_PADDING_RIGHT)*numButtons, scrollView.bounds.size.height);
    
    int i=0;
    for (NSDictionary *colorDict in colors) {
        NSString *colorDictKey = [[colorDict allKeys] objectAtIndex: 0];
        NSString *colorDictVal = [colorDict valueForKey: colorDictKey];
        
        // Get values out of the dict for given color.
        NSString *colorLabel = colorDictKey;
        NSString *colorFilepath = colorDictVal;
        
        // Set background image filepath for button.
        NSString *backgroundImageFilepath = colorFilepath;
        
        // Set button image filepath for button.
        NSString *imageFilepath;
        UIColor *borderColor;
        if ([colorLabel isEqualToString:@"White"]) {
            imageFilepath = @"gray_border.png";
            borderColor = [UIColor grayColor];
        } else {
            imageFilepath = @"white_border.png";
            borderColor = [UIColor whiteColor];
        }
        
        int buttonX = BUTTON_PADDING_LEFT + (BUTTON_WIDTH + BUTTON_PADDING_RIGHT) * i;
        
        // Create button.
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, BUTTON_Y, BUTTON_WIDTH, BUTTON_HEIGHT);
        button.layer.borderWidth = 1.0;
        button.layer.borderColor = [borderColor CGColor];
        button.tag = i;
        [button setBackgroundImage: [UIImage imageNamed:backgroundImageFilepath] forState:UIControlStateNormal];
        [button setImage: [UIImage imageNamed:imageFilepath] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [colorPickerButtons addObject: button];
        [buttonLabelsDict setValue:colorLabel forKey:[NSString stringWithFormat:@"%d", button.tag]];
        
        // Add button to scroll view.
        [scrollView addSubview: button];
        
        i++;
    }
    
    [self.view addSubview: scrollView];
}

- (void)selectButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    NSString *buttonLabel = [buttonLabelsDict valueForKey:[NSString stringWithFormat:@"%d", button.tag]];
    
    // Select tapped button.
    [button setSelected: YES];
    
    // Set new color to paint with.
    selectedColor = [self getColor: buttonLabel];
    [self testColor];
    
    // Dismiss currently visible popover if any.
    [popoverTimer invalidate];
    popoverTimer = nil;
    [popover dismissPopoverAnimated: NO];
    
    // Deselect currently selected button, if any.
    if (selectedButton != nil && selectedButton != button) {
        [selectedButton setSelected: NO];
    }
    
    // Show popover.
    NSString *title = buttonLabel;
    
    UITableViewController *tvc = [[UITableViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tvc];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:35.0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    titleLabel.textAlignment = UITextAlignmentLeft;
    [titleLabel sizeToFit];
    tvc.navigationItem.titleView = titleLabel;
    
    popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    popover.popoverLayoutMargins = UIEdgeInsetsMake(0.0, 1.0, 0.0, 1.0);
    popover.popoverContentSize = CGSizeMake(self.view.bounds.size.width, 35);
    popover.passthroughViews = [[NSArray alloc] initWithObjects:self.view, nil];
    [popover presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionDown animated:NO];
    
    // Dismiss popover after a delay.
    popoverTimer = [NSTimer scheduledTimerWithTimeInterval:1.5
                                     target:self
                                   selector:@selector(dismissPopover)
                                   userInfo:nil
                                    repeats:NO];
    
    // Set this as selected button.
    selectedButton = button;
}

- (void)dismissPopover {
    [popover dismissPopoverAnimated: YES];
}

- (UIColor *)getColor: (NSString *)colorLabel {
    // TODO: create mapping table that has color labels as keys and custom UIColor objects as values
    return [UIColor redColor];
}

- (void)testColor {
    self.view.backgroundColor = selectedColor;
}

- (void)viewDidUnload
{
    scrollView = nil;
    selectedButton = nil;
    selectedColor = nil;
    colorPickerButtons = nil;
    buttonLabelsDict = nil;
    popover = nil;
    popoverTimer = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
