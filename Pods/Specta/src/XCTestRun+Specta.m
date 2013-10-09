#import "XCTestRun+Specta.h"
#import "SPTXCTestCase.h"
#import "SPTExample.h"

@implementation XCTestRun (Specta)

- (void)SPT_visitTestCaseRunsWithBlock:(void (^)(XCTestCaseRun *testRun))block
{
  if (block == nil) return;
  
  if ([self isKindOfClass:[XCTestSuiteRun class]])
  {
    NSArray * testRuns = ((XCTestSuiteRun *)self).testRuns;
    if (testRuns != nil)
    {
      for (XCTestRun * testRun in testRuns)
      {
        [testRun SPT_visitTestCaseRunsWithBlock:block];
      }
    }
  }
  else if ([self isKindOfClass:[XCTestCaseRun class]])
  {
    block((XCTestCaseRun *)self);
  }
}

// ===== PENDING TEST CASES ============================================================================================
#pragma mark - Pending Test Cases

- (NSUInteger)pendingTestCaseCount
{
  NSUInteger pendingTestCaseCount = 0;
  
  if ([self isKindOfClass:[XCTestSuiteRun class]])
  {
    for (XCTestRun * testRun in [(XCTestSuiteRun *)self testRuns])
    {
      pendingTestCaseCount += [testRun pendingTestCaseCount];
    }
  }
  else if ([[self test] isKindOfClass:[SPTXCTestCase class]])
  {
    SPTXCTestCase * testCase = (SPTXCTestCase *)[self test];
    if (testCase != nil && [testCase SPT_isPending])
    {
      pendingTestCaseCount++;
    }
  }

  return pendingTestCaseCount;
}

// ===== SKIPPED TEST CASES ============================================================================================
#pragma mark - Skipped Test Cases

- (NSUInteger)skippedTestCaseCount
{
  NSUInteger skippedTestCaseCount = 0;
  
  if ([self isKindOfClass:[XCTestSuiteRun class]])
  {
    for (XCTestRun * testRun in [(XCTestSuiteRun *)self testRuns])
    {
      skippedTestCaseCount += [testRun skippedTestCaseCount];
    }
  }
  else if ([[self test] isKindOfClass:[SPTXCTestCase class]])
  {
    SPTXCTestCase * testCase = (SPTXCTestCase *)[self test];
    if (testCase.SPT_skipped)
    {
      skippedTestCaseCount++;
    }
  }
  
  return skippedTestCaseCount;
}

@end
