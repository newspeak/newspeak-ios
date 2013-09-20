//
//  NPSettingsViewController.m
//  Newspeak
//
//  Copyright (C) 2013 Jahn Bertsch.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3 of the License.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "IIViewDeckController.h"
#import "IASKPSTextFieldSpecifierViewCell.h"
#import "NPSettingsViewController.h"
#import "NPMessageTableViewController.h"


// category to fix appearance on ios 6
#pragma mark - settings text field category

@interface IASKPSTextFieldSpecifierViewCell (NPTextFieldSpecifierViewCell)
@property (nonatomic, weak) UIColor *backgroundCellColor UI_APPEARANCE_SELECTOR;
@end

@implementation IASKPSTextFieldSpecifierViewCell (NPTextFieldSpecifierViewCell)

@dynamic backgroundCellColor;

- (void)setBackgroundCellColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
}

@end


#pragma mark - settings view controller class

@implementation NPSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];

    if (self) {
        self.delegate = self;

        self.showCreditsFooter = NO;
        self.showDoneButton = NO;

        UIImage *sidebarButtonImage = [UIImage imageNamed:@"SidebarImage.png"];
        UIBarButtonItem *sidebarItem = [[UIBarButtonItem alloc] initWithImage:sidebarButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
        sidebarItem.accessibilityLabel = @"Sidebar";
        [self.navigationItem setLeftBarButtonItem:sidebarItem];

        self.title = NSLocalizedString(@"Settings", nil);

        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            // fix appearance on ios 6 or older

            self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

            // change settings table view cell background
            [[IASKPSTextFieldSpecifierViewCell appearance] setBackgroundCellColor:[UIColor whiteColor]];

            // removed striped background
            self.tableView.backgroundView = nil;

            self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        }
        self.tableView.backgroundColor = [UIColor whiteColor];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)close:(UIBarButtonItem *)sender
{
    [[self.tableView superview] endEditing:YES];
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

#pragma mark - text field delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.viewDeckController.isAnySideOpen) {
        return NO;
    } else {
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.text = [[textField.text lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"NPSettingsBundleUsername"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end