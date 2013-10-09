#import "SPTXCTestInvocation.h"

@implementation SPTXCTestInvocation

@synthesize
  SPT_invocationBlock=_SPT_invocationBlock
;

- (void)dealloc {
  self.SPT_invocationBlock = nil;
  [super dealloc];
}

- (void)invoke {
  if(self.SPT_invocationBlock) {
    self.SPT_invocationBlock();
  }
}

@end
