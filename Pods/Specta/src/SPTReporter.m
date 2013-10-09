#import "SPTReporter.h"
#import "SPTDefaultReporter.h"

@interface SPTReporter ()

+ (SPTReporter *)loadSharedReporter;

@end

@implementation SPTReporter

@synthesize
  runStack=_runStack
;

// ===== SHARED REPORTER ===============================================================================================
#pragma mark - Shared Reporter

+ (SPTReporter *)sharedReporter
{
  static SPTReporter * sharedReporter = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedReporter = [[self loadSharedReporter] retain];
  });
  
  return sharedReporter;
}

+ (SPTReporter *)loadSharedReporter
{
  NSString * customReporterClassName = [[[NSProcessInfo processInfo] environment] objectForKey:@"SPECTA_REPORTER_CLASS"];
  if (customReporterClassName != nil)
  {
    Class customReporterClass = NSClassFromString(customReporterClassName);
    if (customReporterClass != nil)
    {
      return [[[customReporterClass alloc] init] autorelease];
    }
  }
  
  return [[[SPTDefaultReporter alloc] init] autorelease];
}

- (id)init
{
  self = [super init];
  if (self != nil)
  {
    self.runStack = [NSMutableArray array];
  }
  return self;
}

- (void)dealloc
{
  self.runStack = nil;
  [super dealloc];
}

// ===== XCTestObserver ===============================================================================================
#pragma mark - XCTestObserver

#define SPTSharedReporter ([SPTReporter sharedReporter])

- (void)testSuiteDidStart:(XCTestRun *)testRun {
  [SPTSharedReporter testCaseDidBegin:(XCTestCaseRun *)testRun];
}

- (void)testSuiteDidStop:(XCTestRun *)testRun {
  [SPTSharedReporter testSuiteDidEnd:(XCTestSuiteRun *)testRun];
}

- (void)testCaseDidStart:(XCTestRun *)testRun {
  [SPTSharedReporter testCaseDidBegin:(XCTestCaseRun *)testRun];
}

- (void)testCaseDidStop:(XCTestRun *)testRun {
  [SPTSharedReporter testCaseDidEnd:(XCTestCaseRun *)testRun];
}

- (void)testCaseDidFail:(XCTestRun *)testRun withDescription:(NSString *)description inFile:(NSString *)filePath atLine:(NSUInteger)lineNumber {
//    [super testCaseDidFail:testRun withDescription:description inFile:filePath atLine:lineNumber];
    [SPTSharedReporter testCaseDidFail:(XCTestCaseRun *)testRun];
}

// ===== RUN STACK =====================================================================================================
#pragma mark - Run Stack

- (void)pushRunStack:(XCTestRun *)run
{
  [(NSMutableArray *)self.runStack addObject:run];
}

- (void)popRunStack:(XCTestRun *)run
{
  NSAssert(run != nil,
           @"Attempt to pop nil test run");
  
  NSAssert([self.runStack lastObject] == run,
           @"Attempt to pop test run (%@) out of order: %@",
           run,
           self.runStack);
  
  [(NSMutableArray *)self.runStack removeLastObject];
}

// ===== TEST SUITE ====================================================================================================
#pragma mark - Test Suite

- (void)testSuiteDidBegin:(XCTestSuiteRun *)suiteRun
{
  [self pushRunStack:suiteRun];
}

- (void)testSuiteDidEnd:(XCTestSuiteRun *)suiteRun
{
  [self popRunStack:suiteRun];
}

// ===== TEST CASES ====================================================================================================
#pragma mark - Test Cases

- (void)testCaseDidBegin:(XCTestCaseRun *)testCaseRun
{
  [self pushRunStack:testCaseRun];
}

- (void)testCaseDidEnd:(XCTestCaseRun *)testCaseRun
{
  [self popRunStack:testCaseRun];
}

- (void)testCaseDidFail:(XCTestCaseRun *)testCaseRun
{

}

// ===== PRINTING ======================================================================================================
#pragma mark - Printing

- (void)printString:(NSString *)string
{
  fprintf(stderr, "%s", [string UTF8String]);
}

- (void)printStringWithFormat:(NSString *)formatString, ...
{
  va_list args;
  va_start(args, formatString);
  NSString * formattedString = [[NSString alloc] initWithFormat:formatString arguments:args];
  va_end(args);
  
  [self printString:formattedString];
  [formattedString release];
}

- (void)printLine
{
  [self printString:@"\n"];
}

- (void)printLine:(NSString *)line
{
  [self printStringWithFormat:@"%@\n", line];
}

- (void)printLineWithFormat:(NSString *)formatString, ...
{
  va_list args;
  va_start(args, formatString);
  NSString * formattedString = [[NSString alloc] initWithFormat:formatString arguments:args];
  va_end(args);
  
  [self printLine:formattedString];
  
  [formattedString release];
}

@end
