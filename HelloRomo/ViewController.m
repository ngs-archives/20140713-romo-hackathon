//
//  ViewController.m
//  HelloRomo
//

#import "ViewController.h"

@implementation ViewController

#pragma mark - View Management
- (void)viewDidLoad
{
  [super viewDidLoad];

  // To receive messages when Robots connect & disconnect, set RMCore's delegate to self
  [RMCore setDelegate:self];

  // Grab a shared instance of the Romo character
  self.Romo = [RMCharacter Romo];
  [RMCore setDelegate:self];

  [self addGestureRecognizers];
}

- (void)viewWillAppear:(BOOL)animated
{
  // Add Romo's face to self.view whenever the view will appear
  [self.Romo addToSuperview:self.view];
}

#pragma mark - RMCoreDelegate Methods
- (void)robotDidConnect:(RMCoreRobot *)robot
{
  // Currently the only kind of robot is Romo3, so this is just future-proofing
  if ([robot isKindOfClass:[RMCoreRobotRomo3 class]]) {
    self.Romo3 = (RMCoreRobotRomo3 *)robot;

    // Change Romo's LED to be solid at 80% power
    [self.Romo3.LEDs setSolidWithBrightness:0.8];

    // When we plug Romo in, he get's excited!
    self.Romo.expression = RMCharacterExpressionExcited;
    self.laughing = NO;
    self.tiltFront = YES;
  }
}

- (void)robotDidDisconnect:(RMCoreRobot *)robot
{
  if (robot == self.Romo3) {
    self.Romo3 = nil;

    // When we plug Romo in, he get's excited!
    self.Romo.expression = RMCharacterExpressionChuckle;
  }
}

- (void)startLaughing {
  self.laughing = YES;
  self.Romo.expression = RMCharacterExpressionChuckle;
  [self laugh];
  self.laughTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(laugh) userInfo:nil repeats:YES];
  [self.Romo3 driveWithLeftMotorPower:-1.0 rightMotorPower:1.0];
}

- (void)stopLaughing {
  self.laughing = NO;
  [self.laughTimer invalidate];
  self.laughTimer = nil;
}

- (void)laugh {
  [self.Romo setExpression:RMCharacterExpressionChuckle];
  if(!self.tilting) {
    self.tiltFront = !self.tiltFront;
    self.tilting = YES;
    [self.Romo3 tiltToAngle:self.tiltFront ? self.Romo3.maximumHeadTiltAngle : -self.Romo3.maximumHeadTiltAngle completion:^(BOOL success) {
      self.tilting = NO;
    }];
  }
}

#pragma mark - Gesture recognizers

- (void)addGestureRecognizers
{
  // Let's start by adding some gesture recognizers with which to interact with Romo
  UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedLeft:)];
  swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
  [self.view addGestureRecognizer:swipeLeft];

  UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight:)];
  swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
  [self.view addGestureRecognizer:swipeRight];

  UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedUp:)];
  swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
  [self.view addGestureRecognizer:swipeUp];

  UITapGestureRecognizer *tapReceived = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedScreen:)];
  [self.view addGestureRecognizer:tapReceived];
}


- (void)swipedLeft:(UIGestureRecognizer *)sender
{
  // When the user swipes left, Romo will turn in a circle to his left
  [self.Romo3 driveWithRadius:-1.0 speed:1.0];
}

- (void)swipedRight:(UIGestureRecognizer *)sender
{
  // When the user swipes right, Romo will turn in a circle to his right
  [self.Romo3 driveWithRadius:1.0 speed:1.0];
}

// Swipe up to change Romo's emotion to some random emotion
- (void)swipedUp:(UIGestureRecognizer *)sender
{
  // int numberOfEmotions = 7;

  // Choose a random emotion from 1 to numberOfEmotions
  // That's different from the current emotion
  //    RMCharacterEmotion randomEmotion = 1 + (arc4random() % numberOfEmotions);
  //
  //    self.Romo.emotion = randomEmotion;
}

// Simply tap the screen to stop Romo
- (void)tappedScreen:(UIGestureRecognizer *)sender
{
  [self.Romo3 stopDriving];
}

@end
