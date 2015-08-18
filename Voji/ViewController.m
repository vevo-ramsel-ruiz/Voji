//
//  ViewController.m
//  Voji
//
//  Created by Ramsel J Ruiz on 8/17/15.
//  Copyright (c) 2015 Vevo. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import <CoreMotion/CoreMotion.h>
#import <VevoSDK_Internal/VMMoviePlayerController.h>
#import <VevoSDK_Internal/VMApiFacade.h>
#import <VevoSDK_Internal/VMMoviePlayerController_Private.h>


@interface ViewController () <VMMoviePlayerControllerDelegate>

// Data
@property (nonatomic) VMVideo           *video;
@property (nonatomic) NSArray           *vojis;
@property (nonatomic) NSDictionary      *vojisDict;

// Views
@property (nonatomic) UIView            *playerBaseView;
@property (nonatomic) UIImageView       *thumbnailView;
@property (nonatomic) CMMotionManager   *motionManager;
@property (nonatomic) VMMoviePlayerController       *player;

// Timer and observers
@property (nonatomic, strong) id                    playerTimeChangeObserver;


@end

@implementation ViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Bypass the MUTE button of the device.
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];

    
    [self setupPlayer];
    [self setupMotionManager];
    
    
    [self loadAndPlayVideo:@"USCJY1531563"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - Setup
- (void)setupPlayer {
    
    CGFloat height = CGRectGetHeight(self.view.frame);
    CGFloat width = height*16./9;
    CGFloat x = CGRectGetWidth(self.view.frame)/2 - width/2;
    NSString *imageUrl = @"http://img.cache.vevo.com/Content/VevoImages/video/851E27D7CB54BED811E0D7F52365E7D9201536115833385.jpg";
    self.thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, width, height)];
    [self.thumbnailView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    [self.view addSubview:self.thumbnailView];
    
    UIImage *buttonImg = [[UIImage imageNamed:@"icon_playall_pink"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setImage:buttonImg forState:UIControlStateNormal];
    //[playButton sizeToFit];
    playButton.bounds = CGRectMake(0, 0, buttonImg.size.width * 2, buttonImg.size.height*2);
    playButton.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
    playButton.layer.cornerRadius = buttonImg.size.width;
    playButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    playButton.tintColor = [UIColor grayColor];

}

- (void)setupMotionManager {
    
    self.motionManager = [CMMotionManager new];
    
    //__block CMAttitude *initialAttitude = self.motionManager.deviceMotion.attitude;
    //__weak ViewController *weakSelf = self;
    BOOL canUseDeviceMotion = self.motionManager.deviceMotionAvailable;
    if (canUseDeviceMotion){
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue new]
                                                withHandler:^(CMDeviceMotion *motion, NSError *error) {
                                                    //NSLog(@"New Device Motion data: %@", motion);
                                                    
                                                    //NSLog(@"x: %f, y: %f, z: %f", motion.userAcceleration.x, motion.userAcceleration.y, motion.userAcceleration.z);
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                        
                                                        
                                                        [self moveAround:motion.attitude.roll ];
                                                        
                                                        //NSLog(@"x: %f", motion.magneticField.field.x);
                                                    });
                                                    
                                                    
                                                    /*
                                                     if (!initialAttitude)
                                                     initialAttitude = weakSelf.motionManager.deviceMotion.attitude;
                                                     // translate the attitude
                                                     [motion.attitude multiplyByInverseOfAttitude:initialAttitude];
                                                     
                                                     // calculate magnitude of the change from our initial attitude
                                                     double magnitude = [ViewController magnitudeFromAttitude:motion.attitude];
                                                     
                                                     NSLog(@"magnitude: %f", magnitude);
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                     
                                                     [self moveAround:magnitude];
                                                     });
                                                     
                                                     */
                                                    
                                                    
                                                    
                                                    //                                               // show the prompt
                                                    //                                               if (!showingPrompt && (magnitude > showPromptTrigger)) {
                                                    //                                                   showingPrompt = YES;
                                                    //
                                                    //                                                   PromptViewController *promptViewController = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"PromptViewController"];
                                                    //                                                   promptViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                                                    //                                                   [weakSelf presentViewController:promptViewController animated:YES completion:nil];
                                                    //                                               }
                                                    //
                                                    //                                               // hide the prompt
                                                    //                                               if (showingPrompt && (magnitude < showAnswerTrigger)) {
                                                    //                                                   showingPrompt = NO;
                                                    //                                                   [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                                    //                                               }
                                                    
                                                }];
        //
        //        __block CGFloat accel = 0;
        //        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue new]
        //                                            withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        //                                                //NSLog(@"accelerometer data: %@", accelerometerData);
        //
        //                                                accel += accelerometerData.acceleration.x;
        //
        //                                                dispatch_async(dispatch_get_main_queue(), ^{
        //
        //                                                    [self moveAround:accel];
        //                                                });
        //
        //                                            }];
        //
        //        [self.motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue new]
        //                                                withHandler:^(CMMagnetometerData *magnetometerData, NSError *error) {
        //                                                    //NSLog(@"manetic data: %@", magnetometerData);
        //
        //                                                    dispatch_async(dispatch_get_main_queue(), ^{
        //
        //                                                        [self moveAround:accel];
        //                                                    });
        //                                                }];
        //
        //        [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMGyroData *gyroData, NSError *error){
        //            NSLog(@"gyroscope data: %@", gyroData);
        //        }];
    }
}


#pragma mark - User Actions
- (void)onDoubleTapped:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        // Play next video
        if (self.player)
            [self.player playNextVideo];
    }
}


#pragma mark - Data

- (void)loadAndPlayVideo:(NSString *)isrc
{
    
    dispatch_group_t dispatchGroup = dispatch_group_create();
    
    // -- Get video
    dispatch_group_enter(dispatchGroup);
    [[VMApiFacade sharedInstance] getVideoWithIsrc:isrc completion:^(BOOL success, VMVideo *video, VMError *error){
        if (success) {
            
            self.video = video;
            
            dispatch_group_leave(dispatchGroup);
            
        }
    }];
    
    // -- Get vojs
    dispatch_group_enter(dispatchGroup);
    [[VMApiFacade sharedInstance] getVojis:isrc completion:^(BOOL success, NSArray *vojis, VMError *error) {
        
        if (success) {
            
            self.vojis = vojis;
            self.vojisDict = [self VMVojisToDictionary:vojis];
            
            dispatch_group_leave(dispatchGroup);
        }
    }];
    
    
    // -- Display
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
        
        self.playerBaseView = [[UIView alloc] initWithFrame:self.thumbnailView.frame];
        
        // Add tap gesture
        UISwipeGestureRecognizer *doubleTapGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTapped:)];
        doubleTapGesture.direction = UISwipeGestureRecognizerDirectionUp;
        [self.playerBaseView addGestureRecognizer:doubleTapGesture];
        
        self.player = [[VMMoviePlayerController alloc] initWithBaseView:self.playerBaseView];
        self.player.delegate = self;
        self.player.disableArtistVideos = YES;
        self.player.controlStyle = VMMovieControlStyleNone;
        self.player.hideDefaultCloseButton = YES;
        self.player.hideDefaultVevoLogo = YES;
        self.player.enableContinuousPlay = YES;
        [self.player playVideo:self.video];
  

    });

    
    
  
}

//// OPTIONS

// 1 - Dict with Keys as time and objects as Array of Voji types
// 2 - Array initialized with capacity of seconds of video, objects are nested arrays of voji types


#pragma mark Data - Utilities
- (NSDictionary*)VMVojisToDictionary:(NSArray*)vojis {
    
    NSMutableDictionary* data = [NSMutableDictionary new];
    
    [vojis enumerateObjectsUsingBlock:^(VMVoji* voji, NSUInteger idx, BOOL *stop) {
        if (![voji isKindOfClass:[VMVoji class]])
            return;
    
        // Get array of types at key
        NSMutableArray* types = [data objectForKey:voji.time];
        
        // Initialize if none
        if (![data objectForKey:voji.time])
            types = [NSMutableArray new];
        
        
        // Add type to array at key
        [types addObject:voji.type];
        
        //  Reset in data
        [data setObject:types forKey:voji.time];
    }];
    
    return [data copy];
}


#pragma mark - Time

- (void)elapsedTimeChanged {
    
    NSNumber* currentTime = @(floor(self.player.currentTime));
    
    NSLog(@"*** currentTime --- %@",currentTime);
    
    if ([self.vojisDict objectForKey:currentTime]) {
        
        NSArray* vojisAtTime = [self.vojisDict objectForKey:currentTime];
        
        NSLog(@"currentTime OBJECT = %@",currentTime);
        NSLog(@"vojisAtTime = %@",vojisAtTime);
    }

}


- (void)registerPlayerTimeObserver {
    
    // Observe current time
    double interval = 1.0f;
    __weak ViewController *weakSelf = self;
    /* Update the scrubber during normal playback. */
    self.playerTimeChangeObserver = [self.player registerPlayerTimeObserverWithInterval:interval callbackBlock:^(CMTime time)
                                     {
                                         [weakSelf elapsedTimeChanged];
                                     }];

}

- (void)unregisterPlayerTimeObserver {
    if (self.playerTimeChangeObserver) {
        
        [self.player unregisterPlayerTimeObserver:self.playerTimeChangeObserver];
        
        // Nil out the time observer after unregistering.
        self.playerTimeChangeObserver = nil;
    }

}


#pragma mark - Motion
- (void)moveAround:(CGFloat)x
{
    if (self.playerBaseView == nil)
        return;
    
    
    CGFloat xCenterRef = self.view.frame.size.width/2;
    CGFloat xCenterMax = self.playerBaseView.frame.size.width/2;
    CGFloat xCenterMin = self.view.frame.size.width - self.playerBaseView.frame.size.width/2;
    
    CGFloat xCenterNew = xCenterRef + x/M_PI * xCenterMax;
    xCenterNew = fmax(xCenterMin, xCenterNew);
    xCenterNew = fmin(xCenterMax, xCenterNew);
    
    self.playerBaseView.center = CGPointMake(xCenterNew, self.view.frame.size.height/2);
    
    NSLog(@"center: %f", xCenterNew);
}



#pragma mark - Delegate - VMMoviePlayerController

/**
 Called right before the movie player is about start playing a video.
 @param player The player controller object.
 */
- (void)movieplayerWillStartPlaying:(VMMoviePlayerController *)player {
    
    if (self.playerBaseView.superview == nil)
        [self showPlayerView];
    
    
#warning Make sure unregistering properly
    // observe
    [self registerPlayerTimeObserver];

}

- (void)moviePlayerDidStartPlayingPreroll:(VMMoviePlayerController *)player {
    
    if (self.playerBaseView.superview == nil)
        [self showPlayerView];
}

- (void)showPlayerView
{
    self.playerBaseView.alpha = 0;
    [self.view addSubview:self.playerBaseView];
    [UIView animateWithDuration:2. animations:^{
        self.playerBaseView.alpha = 1;
        self.thumbnailView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 3., 3.);
        self.thumbnailView.alpha = 0;
    } completion:^(BOOL finished){
        
    }];
}



@end
