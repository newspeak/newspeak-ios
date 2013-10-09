#import "SPTXCTestCase.h"
#import "SPTSpec.h"
#import "SPTExample.h"
#import "SPTXCTestInvocation.h"
#import "SPTSharedExampleGroups.h"
#import "SpectaUtility.h"
#import <objc/runtime.h>

@interface NSObject (SPTXCTestCase)

+ (NSArray *)xctAllSuperclasses;

@end

@implementation SPTXCTestCase

@synthesize
  SPT_invocation=_SPT_invocation
, SPT_run=_SPT_run
, SPT_skipped=_SPT_skipped
;

- (void)dealloc {
  self.SPT_invocation = nil;
  self.SPT_run = nil;
  [super dealloc];
}

+ (void)initialize {
  [SPTSharedExampleGroups initialize];
  SPTSpec *spec = [[SPTSpec alloc] init];
  SPTXCTestCase *testCase = [[[self class] alloc] init];
  objc_setAssociatedObject(self, "SPT_spec", spec, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  [testCase SPT_defineSpec];
  [testCase release];
  [spec compile];
  [spec release];
  [super initialize];
}

+ (SPTSpec *)SPT_spec {
  return objc_getAssociatedObject(self, "SPT_spec");
}

+ (BOOL)SPT_isDisabled
{
  return [self SPT_spec].disabled;
}

+ (void)SPT_setDisabled:(BOOL)disabled
{
  [self SPT_spec].disabled = disabled;
}

- (BOOL)SPT_isPending
{
  SPTExample * example = [self SPT_getCurrentExample];
  return example == nil || example.pending;
}

+ (NSArray *)SPT_allSpecClasses
{
  static NSArray * allSpecClasses = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    
    NSMutableArray * specClasses = [[NSMutableArray alloc] init];
    
    int numberOfClasses = objc_getClassList(NULL, 0);
    if(numberOfClasses > 0) {
      Class * classes = malloc(sizeof(Class) * numberOfClasses);
      numberOfClasses = objc_getClassList(classes, numberOfClasses);
      
      for (int classIndex = 0; classIndex < numberOfClasses; classIndex++) {
        Class aClass = classes[classIndex];
        if (SPT_IsSpecClass(aClass)) {
          [specClasses addObject:aClass];
        }
      }
      
      free(classes);
    }
    
    allSpecClasses = [specClasses copy];
    [specClasses release];
  });
  
  return allSpecClasses;
}

+ (BOOL)SPT_focusedExamplesExist
{
  for (Class specClass in [self SPT_allSpecClasses])
  {
    SPTSpec * spec = [specClass SPT_spec];
    if (spec.disabled == NO && [spec hasFocusedExamples])
    {
      return YES;
    }
  }
  
  return NO;
}

- (void)SPT_setCurrentSpecWithFileName:(const char *)fileName lineNumber:(NSUInteger)lineNumber {
  SPTSpec *spec = [[self class] SPT_spec];
  spec.fileName = [NSString stringWithUTF8String:fileName];
  spec.lineNumber = lineNumber;
  [[[NSThread currentThread] threadDictionary] setObject:spec forKey:@"SPT_currentSpec"];
}

- (void)SPT_defineSpec {}

- (void)SPT_unsetCurrentSpec {
  [[[NSThread currentThread] threadDictionary] removeObjectForKey:@"SPT_currentSpec"];
}

- (void)SPT_runExampleAtIndex:(NSUInteger)index {
  [[[NSThread currentThread] threadDictionary] setObject:self forKey:@"SPT_currentTestCase"];
  SPTExample *compiledExample = [[[self class] SPT_spec].compiledExamples objectAtIndex:index];
  if(!compiledExample.pending)
  {
    if ([[self class] SPT_isDisabled] == NO &&
        (compiledExample.focused || [[self class] SPT_focusedExamplesExist] == NO)) {
      ((SPTVoidBlock)compiledExample.block)();
    } else {
      self.SPT_skipped = YES;
    }
  }
  
  [[[NSThread currentThread] threadDictionary] removeObjectForKey:@"SPT_currentTestCase"];
}

- (SPTExample *)SPT_getCurrentExample {
  if(!self.SPT_invocation) {
    return nil;
  }
  NSUInteger i;
  [self.SPT_invocation getArgument:&i atIndex:2];
  return [[[self class] SPT_spec].compiledExamples objectAtIndex:i];
}

#pragma mark - XCTestCase overrides

+ (NSArray *)testInvocations {
  NSMutableArray *invocations = [NSMutableArray array];
  for(NSUInteger i = 0; i < [[self SPT_spec].compiledExamples count]; i ++) {
    SPTXCTestInvocation *invocation = (SPTXCTestInvocation *)[SPTXCTestInvocation invocationWithMethodSignature:[self instanceMethodSignatureForSelector:@selector(SPT_runExampleAtIndex:)]];
    invocation.SPT_invocationBlock = ^{
      [(SPTXCTestCase *)[invocation target] SPT_runExampleAtIndex:i];
    };
    [invocation setSelector:@selector(SPT_runExampleAtIndex:)];
    [invocation setArgument:&i atIndex:2];
    [invocations addObject:invocation];
  }
  return invocations;
}

- (void)setInvocation:(NSInvocation *)invocation {
  self.SPT_invocation = invocation;
  [super setInvocation:invocation];
}

- (NSString *)name {
  NSString *specName = NSStringFromClass([self class]);
  SPTExample *compiledExample = [self SPT_getCurrentExample];
  NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"];
  NSString *exampleName = [[compiledExample.name componentsSeparatedByCharactersInSet:[charSet invertedSet]] componentsJoinedByString:@"_"];
  return [NSString stringWithFormat:@"-[%@ %@]", specName, exampleName];
}

- (void)performTest:(XCTestRun *)run {
  self.SPT_run = (XCTestCaseRun *)run;
  [super performTest:run];
  self.SPT_run = nil;
}

+ (NSArray *)xctAllSuperclasses {
  NSArray *arr = [super xctAllSuperclasses];
  if([arr objectAtIndex:0] == [SPTXCTestCase class]) {
    return [NSArray arrayWithObject:[NSObject class]];
  }
  return arr;
}

@end
