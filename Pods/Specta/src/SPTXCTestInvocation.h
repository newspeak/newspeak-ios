#import <Foundation/Foundation.h>
#import "SpectaTypes.h"

@interface SPTXCTestInvocation : NSInvocation {
  SPTVoidBlock _SPT_invocationBlock;
}

@property (nonatomic, copy) SPTVoidBlock SPT_invocationBlock;

@end
