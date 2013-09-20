//
//  NPMessageTableViewController.h
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

#import <UIKit/UIKit.h>

/**
   Message overview.

   Currently also allows for setting the recipient, which is only a temporary
   solution and will be changed in a future release.

   Does not currently show the list of conversation partners, which will be
   added in a future release.
 */
@interface NPMessageTableViewController : UITableViewController

/** Sidebar button */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

/** Add contact button */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end
