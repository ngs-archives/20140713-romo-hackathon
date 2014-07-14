//
//  ViewController.h
//  HelloRomo
//

#import <UIKit/UIKit.h>
#import <RMCore/RMCore.h>
#import <RMCharacter/RMCharacter.h>

@interface ViewController : UIViewController <RMCoreDelegate>

@property (nonatomic, strong) RMCoreRobotRomo3 *Romo3;
@property (nonatomic, strong) RMCharacter *Romo;
@property (nonatomic, assign) BOOL laughing;
@property (nonatomic, assign) BOOL tilting;
@property (nonatomic, assign) BOOL tiltFront;
@property (nonatomic, strong) NSTimer *laughTimer;

- (void)addGestureRecognizers;
- (void)startLaughing;

@end
