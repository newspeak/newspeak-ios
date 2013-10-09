#import <XCTest/XCTest.h>

@interface XCTestRun (Specta)

- (void)SPT_visitTestCaseRunsWithBlock:(void (^)(XCTestCaseRun *testRun))block;

// ===== PENDING TEST CASES ============================================================================================
#pragma mark - Pending Test Cases

- (NSUInteger)pendingTestCaseCount;

// ===== SKIPPED TEST CASES ============================================================================================
#pragma mark - Skipped Test Cases

- (NSUInteger)skippedTestCaseCount;

@end
