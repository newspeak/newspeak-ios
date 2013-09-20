//
//  NPMessageTableViewController.m
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

#import <QuartzCore/QuartzCore.h>
#import "AFIncrementalStore.h"
#import "IIViewDeckController.h"
#import "SVProgressHUD.h"
#import "TestFlight.h"
#import "NPMessageTableViewController.h"
#import "NPMessageCell.h"
#import "NPAPIClient.h"
#import "NPCoreDataSingleton.h"
#import "NPToken.h"
#import "UIColor+NPColor.h"

@interface NPMessageTableViewController ()

@end

@implementation NPMessageTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];

    if (self) {
        // init
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.accessibilityLabel = @"Message Table View";
    self.addButton.accessibilityLabel = @"Add Button";
    self.sidebarButton.accessibilityLabel = @"Sidebar Button";
    [self requestAccessToken];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestAccessToken
{
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"NPSettingsBundleUsername"];
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"NPSettingsBundlePassword"];

    if (username != nil &&
        password != nil &&
        ![username isEqualToString:@""] &&
        ![password isEqualToString:@""] &&
        [NPAPIClient sharedClient].accessToken == nil) {
        NSManagedObjectContext *managedObjectContext = [NPCoreDataSingleton sharedInstance].managedObjectContext;
        [managedObjectContext performBlock:^{
            [SVProgressHUD showWithStatus:NSLocalizedString(@"Connecting...", @"in status message")];
            DLog(@"requesting access token for username '%@'", username);
            [TestFlight passCheckpoint:@"requesting access token"];

            NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Token" inManagedObjectContext:managedObjectContext];
            [managedObject setValue:username forKey:@"username"];
            [managedObject setValue:password forKey:@"password"];
            NSError *error;

            if (![managedObjectContext save:&error]) {
                DLog(@"saving token failed. error=%@", error);
            }
        }];
    }
}

#pragma mark - ib actions

- (IBAction)revealSidebar:(UIBarButtonItem *)sender
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

- (IBAction)addContact:(UIBarButtonItem *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Recipient", @"in add contact alert view") message:NSLocalizedString(@"Please enter the name of the person you want to send messsages to", @"in add contact alert view") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];

    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"NPSettingsLastRecipient"];
    [alertView show];
}

#pragma mark - alert view delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *recipient = [alertView textFieldAtIndex:0].text;
        recipient = [[recipient lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [[NSUserDefaults standardUserDefaults] setObject:recipient forKey:@"NPSettingsLastRecipient"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    UITextField *textField = [alertView textFieldAtIndex:0];

    if ([textField.text length] == 0) {
        return NO;
    }

    return YES;
}

#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    return cell;
}

/*
   // Override to support conditional editing of the table view.
   - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
   {
   // Return NO if you do not want the specified item to be editable.
   return YES;
   }
 */

/*
   // Override to support editing the table view.
   - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
   {
   if (editingStyle == UITableViewCellEditingStyleDelete) {
      // Delete the row from the data source
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
   }
   else if (editingStyle == UITableViewCellEditingStyleInsert) {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
 */

/*
   // Override to support rearranging the table view.
   - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
   {
   }
 */

/*
   // Override to support conditional rearranging of the table view.
   - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
   {
   // Return NO if you do not want the item to be re-orderable.
   return YES;
   }
 */

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