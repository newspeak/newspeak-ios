//
//  NPInitialViewController.m
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

#import "NPInitialViewController.h"
#import "NPAPIClient.h"
#import "NPSettingsViewController.h"

@implementation NPInitialViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self) {
        UIStoryboard *storyboard;

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
        } else {
            storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        }

        UIViewController *centerViewController = [storyboard instantiateViewControllerWithIdentifier:@"NPMessageViewController"];
        UINavigationController *sideBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"NPSidebarViewController"];

        self = [super initWithCenterViewController:centerViewController leftViewController:sideBarViewController];

        NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"NPSettingsBundleUsername"];

        if (username == nil || [username isEqualToString:@""]) {
            // ask for username on startup if no username is set
            NPSettingsViewController *viewController = [[NPSettingsViewController alloc] init];
            self.centerController = [[UINavigationController alloc] initWithRootViewController:viewController];

#ifndef DEBUG
#ifndef TARGET_IPHONE_SIMULATOR
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Welcome", @"in welcome message") message:NSLocalizedString(@"Set your username to get started. You can then find the sidebar in the top left corner.", @"in welcome message") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
#endif
#endif
        }

        // this view controller is never deallocated, therefore register notificaitions here
        [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"NPSettingsBundleUsername" options:NSKeyValueObservingOptionNew context:NULL];
    }

    return self;
}

- (void)dealloc
{
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"NPSettingsBundleUsername"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    DLog(@"kvo: %@ changed property %@ to value %@", object, keyPath, change);

    if ([keyPath isEqualToString:@"NPSettingsBundleUsername"]) {
        // delete access token, force reconnection
        [NPAPIClient sharedClient].accessToken = nil;
    }
}

@end
