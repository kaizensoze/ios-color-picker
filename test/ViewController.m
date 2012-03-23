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
@synthesize colorPickerButtons;
@synthesize buttonLabelsDict;
@synthesize popover;

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

- (void)viewDidAppear:(BOOL)animated {
    for (UIButton *button in colorPickerButtons) {
        UITableViewController *tvc = [[UITableViewController alloc] init];
        tvc.title = [buttonLabelsDict valueForKey:[NSString stringWithFormat:@"%d", button.tag]];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tvc];
        
        popover = [[UIPopoverController alloc] initWithContentViewController:nav];
        popover.popoverLayoutMargins = UIEdgeInsetsMake(0.0, 1.0, 0.0, 1.0);
        popover.popoverContentSize = CGSizeMake(self.view.bounds.size.width, 35);
        [popover presentPopoverFromRect:button.frame inView:button permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        break;
    }
}

- (void)selectButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    // Select tapped button.
    [button setSelected: YES];
    
    // Deselect currently selected button, if any.
    if (selectedButton != nil && selectedButton != button) {
        [selectedButton setSelected: NO];
    }
    
    // Set this as selected button.
    selectedButton = button;
}

- (void)viewDidUnload
{
    scrollView = nil;
    selectedButton = nil;
    colorPickerButtons = nil;
    buttonLabelsDict = nil;
    popover = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
