//
//  NPSidebarViewController.m
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

#import "NPSidebarViewController.h"
#import "NPMessageTableViewController.h"
#import "NPSettingsViewController.h"

static NSInteger const NPSidebarMessages = 0;
static NSInteger const NPSidebarSettings = 1;

@interface NPSidebarViewController ()
@property (assign, nonatomic) BOOL firstTimeShown;
@end

@implementation NPSidebarViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];

    if (self) {
        // Custom initialization
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.firstTimeShown = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    // when sidebar is first shown, add hint what is currently selected
    if (self.firstTimeShown) {
        NSIndexPath *indexPath;
        NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"NPSettingsBundleUsername"];

        if (username == nil || [username isEqualToString:@""]) {
            // username is not set
            indexPath = [NSIndexPath indexPathForRow:NPSidebarSettings inSection:0];
        } else {
            indexPath = [NSIndexPath indexPathForRow:NPSidebarMessages inSection:0];
        }

        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];

        self.firstTimeShown = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view data source

// Return the number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Return the number of rows in the section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SidebarCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if (indexPath.row == NPSidebarMessages) {
        cell.textLabel.text = NSLocalizedString(@"Messages", @"in sidebar");
    } else if (indexPath.row == NPSidebarSettings) {
        cell.textLabel.text = NSLocalizedString(@"Settings", @"in sidebar");
    } else {
        cell.textLabel.text = @"default";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        if (indexPath.section == 0) {
            if (indexPath.row == NPSidebarMessages) {
                UIStoryboard *storyboard;

                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
                } else {
                    storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
                }

                NPMessageTableViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NPMessageViewController"];
                controller.centerController = viewController;
            } else if (indexPath.row == NPSidebarSettings) {
                NPSettingsViewController *viewController = [[NPSettingsViewController alloc] init];
                controller.centerController = [[UINavigationController alloc] initWithRootViewController:viewController];
            }
        }
    }];
}

/*
   #pragma mark - Navigation

   // In a story board-based application, you will often want to do a little preparation before navigation
   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
   {
   // Get the new view controller using [segue destinationViewController].
   // Pass the selected object to the new view controller.
   }

 */

@end