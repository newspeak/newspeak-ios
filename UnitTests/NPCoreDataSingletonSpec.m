//
// MIT license
//
// Copyright (c) 2013 Jahn Bertsch
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "Specta.h"
#import "Expecta.h"
#import "NPCoreDataSingleton.h"

SpecBegin(CoreDataSingletonTest)

describe(@"CoreDataSingleton", ^{
    __block NPCoreDataSingleton *coreDataSingleton;
    beforeAll(^{
        coreDataSingleton = [NPCoreDataSingleton sharedInstance];
        [coreDataSingleton reset];
    });

    context(@"when accessed", ^{
        it(@"should have default values set", ^{
            expect(coreDataSingleton.useCustomStore).to.beFalsy();
            expect(coreDataSingleton.useInMemoryStore).to.beFalsy();
        });
        it(@"should have a managed object model set", ^{
            expect(coreDataSingleton.managedObjectModel).toNot.beNil();
        });
        it(@"should have a persistent store coordinator set", ^{
            expect(coreDataSingleton.persistentStoreCoordinator).toNot.beNil();
        });
        it(@"should have a managed object context set", ^{
            expect(coreDataSingleton.managedObjectContext).toNot.beNil();
        });
        it(@"should have one persistent store", ^{
            expect(coreDataSingleton.persistentStoreCoordinator.persistentStores.count).to.equal(1);
        });
        it(@"should have a sql store", ^{
            NSPersistentStore *persistentStore = [coreDataSingleton.persistentStoreCoordinator.persistentStores objectAtIndex:0];
            expect(persistentStore).to.equal(@"SQLite");
        });
    });

    context(@"saving context", ^{
        it(@"should be successful", ^{
            expect([coreDataSingleton saveContext]).to.beTruthy();
        });
    });

    context(@"after reset", ^{
        it(@"should still have defaults set", ^{
            [coreDataSingleton reset];
            expect(coreDataSingleton.useCustomStore).to.beFalsy();
            expect(coreDataSingleton.useInMemoryStore).to.beFalsy();
        });
    });

    context(@"after reset and setting to in-memory store", ^{
        beforeAll(^{
            [coreDataSingleton reset];
            coreDataSingleton.useInMemoryStore = YES;
        });
        it(@"should have one persistent store", ^{
            expect(coreDataSingleton.persistentStoreCoordinator.persistentStores.count).to.equal(1);
        });
        it(@"should have an in-memory store", ^{
            NSPersistentStore *persistentStore = [coreDataSingleton.persistentStoreCoordinator.persistentStores objectAtIndex:0];
            expect(persistentStore.type).to.equal(@"InMemory");
        });
    });
});

SpecEnd