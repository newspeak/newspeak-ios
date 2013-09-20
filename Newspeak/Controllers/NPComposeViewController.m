//
//  NPComposeViewController.m
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

#import <QuartzCore/QuartzCore.h>
#import "TestFlight.h"
#import "NPComposeViewController.h"
#import "NPCoreDataSingleton.h"

@interface NPComposeViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *composeBarView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (assign) BOOL animating;
@end

@implementation NPComposeViewController

#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.animating = NO;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    [self.scrollView addGestureRecognizer:tapGestureRecognizer];

    // fix appearance on ios 6
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending) {
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.layer.borderColor = [[UIColor colorWithWhite:0.834f alpha:1.000f] CGColor];
        self.textField.layer.borderWidth = 1.0f;
        self.textField.layer.cornerRadius = 3.0f;
        self.textField.layer.sublayerTransform = CATransform3DMakeTranslation(3, 0, 0);
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillToggle:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillToggle:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    CGRect composeBarRect = self.composeBarView.frame;

    composeBarRect.origin.y = composeBarRect.origin.y - 20.0f;
    self.composeBarView.frame = composeBarRect;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self hideKeyboard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self hideKeyboard];
}

- (void)tapGestureRecognized:(UIGestureRecognizer *)gestureRecognizer
{
    [self hideKeyboard];
}

#pragma mark - keyboard

- (void)hideKeyboard
{
    if (self.textField.isFirstResponder) {
        [self.textField resignFirstResponder];
    }
}

- (void)keyboardWillToggle:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval duration;
    UIViewAnimationCurve animationCurve;
    CGRect startFrame;
    CGRect endFrame;

    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&startFrame];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];

    CGRect newScrollFrame = [self.scrollView frame];
    CGRect newComposeBarFrame = [self.composeBarView frame];
    CGFloat sizeChange = 0.0;

    if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait) {
        sizeChange = (endFrame.origin.y - startFrame.origin.y);
        newScrollFrame.size.height += sizeChange;
        newComposeBarFrame.origin.y += sizeChange;
    } else if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft) {
        sizeChange = (endFrame.origin.x - startFrame.origin.x);
        newScrollFrame.size.height -= sizeChange;
        newComposeBarFrame.origin.y -= sizeChange;
    } else if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight) {
        sizeChange = (endFrame.origin.x - startFrame.origin.x);
        newScrollFrame.size.height -= sizeChange;
        newComposeBarFrame.origin.y += sizeChange;
    }

    CGFloat offsetY = MAX(0.0f, self.scrollView.frame.size.height - self.containerView.frame.size.height - sizeChange);
    CGPoint newTextViewContentOffset = CGPointMake(0.0f, offsetY);

    void (^ animation)(void) = ^{
        [self.scrollView setFrame:newScrollFrame];
        [self.composeBarView setFrame:newComposeBarFrame];
    };

    [UIView animateWithDuration:duration delay:0 options:(animationCurve | UIViewAnimationOptionBeginFromCurrentState) animations:animation completion:^(BOOL finished) {
        if (finished) {
            self.animating = NO;
        }
    }];
    [self.scrollView setContentOffset:newTextViewContentOffset animated:YES];
}

- (IBAction)sendButtonPressed:(id)sender
{
    NSString *recipient = [[NSUserDefaults standardUserDefaults] stringForKey:@"NPSettingsLastRecipient"];

    if (recipient != nil && ![recipient isEqualToString:@""]) {
        [self sendMessage:self.textField.text to:recipient];
        self.textField.text = @"";
        [self.textField resignFirstResponder];
    } else {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Recipient Missing", @"in compose view") message:NSLocalizedString(@"You have to go back and press the [+] button", @"in compose view") delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }
}

#pragma mark - message sending

- (void)sendMessage:(NSString *)message to:(NSString *)recipient
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];

    NSManagedObjectContext *managedObjectContext = [NPCoreDataSingleton sharedInstance].managedObjectContext;
    [managedObjectContext performBlock:^{
        DLog(@"posting message '%@' for user '%@' to server", message, recipient);
        [TestFlight passCheckpoint:@"send message"];

        NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"NPSettingsBundleUsername"];
        NSString *formattedMessage = [NSString stringWithFormat:@"%@: %@", username, message];

        NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:managedObjectContext];
        [managedObject setValue:formattedMessage forKey:@"message"];
        [managedObject setValue:recipient forKey:@"recipient"];
        NSError *error;

        if (![managedObjectContext save:&error]) {
            DLog(@"sending message '%@' to user '%@' failed. error=%@", message, recipient, error);
            [TestFlight passCheckpoint:@"send message failed (save)"];
        }
    }];
}

@end