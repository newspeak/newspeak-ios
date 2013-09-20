//
//  NPAppDelegateSpec.m
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

#import <Kiwi/Kiwi.h>
#import "NPAppDelegate.h"
#import "NPCoreDataSingleton.h"

SPEC_BEGIN(AppDelegateSpec)

describe(@"AppDelegate", ^{
    __block NPAppDelegate *appDelegate = nil;
    beforeEach(^{
        appDelegate = [NPAppDelegate new];
    });

    context(@"when finished launching", ^{
        it(@"should set up CoreData.", ^{
            [appDelegate application:nil didFinishLaunchingWithOptions:nil];
            [[[NPCoreDataSingleton sharedInstance].managedObjectContext shouldNot] beNil];
        });
    });
});

SPEC_END

