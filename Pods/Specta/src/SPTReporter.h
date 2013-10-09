#import <XCTest/XCTest.h>

@interface SPTReporter : XCTestObserver {
  NSArray *_runStack;
}

// ===== SHARED REPORTER ===============================================================================================
#pragma mark - Shared Reporter

+ (SPTReporter *)sharedReporter;

// ===== RUN STACK =====================================================================================================
#pragma mark - Run Stack

@property (nonatomic, retain) NSArray *runStack;

// ===== TEST SUITE ====================================================================================================
#pragma mark - Test Suite

- (void)testSuiteDidBegin:(XCTestSuiteRun *)suiteRun;
- (void)testSuiteDidEnd:(XCTestSuiteRun *)suiteRun;

// ===== TEST CASES ====================================================================================================
#pragma mark - Test Cases

- (void)testCaseDidBegin:(XCTestCaseRun *)testCaseRun;
- (void)testCaseDidEnd:(XCTestCaseRun *)testCaseRun;
- (void)testCaseDidFail:(XCTestCaseRun *)testCaseRun;

// ===== PRINTING ======================================================================================================
#pragma mark - Printing

- (void)printString:(NSString *)string;
- (void)printStringWithFormat:(NSString *)formatString, ... NS_FORMAT_FUNCTION(1,2);

- (void)printLine;
- (void)printLine:(NSString *)line;
- (void)printLineWithFormat:(NSString *)formatString, ... NS_FORMAT_FUNCTION(1,2);


@end
