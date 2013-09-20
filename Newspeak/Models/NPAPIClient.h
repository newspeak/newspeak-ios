//
//  NPAPIClient.h
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

#import "AFRESTClient.h"
#import "AFIncrementalStore.h"

/**
   REST client to synchronize local CoreData store with the server.

   For more information, see
   [AFIncrementalStore](https://github.com/afnetworking/afincrementalstore) on
   github.
 */

#ifdef DEBUG
static NSString *const NPAPIBaseURLString = @"http://192.168.1.77/";
#else
static NSString *const NPAPIBaseURLString = @"http://api.newspeak.io/";
#endif

@interface NPAPIClient : AFRESTClient <AFIncrementalStoreHTTPClient>

/** Authenticate each API request using this token. */
@property (nonatomic, retain) NSString *accessToken;

/** API client singleton. */
+ (NPAPIClient *)sharedClient;

@end
