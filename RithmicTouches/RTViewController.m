//
//  RTViewController.m
//  RithmicTouches
//
//  Created by Darío Antequera on 29/11/12.
//  Copyright (c) 2012 Darío Antequera. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "MTXParser.h"
#import "RTViewController.h"

@interface RTViewController ()
- (void)checkNotesTime:(NSTimer*)theTimer;
@end

@implementation RTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    MTXParser *mtxParser = [[MTXParser alloc] init];
    
    NSString *song = [NSString stringWithFormat:@"easy_song1_level1.mtx"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:song ofType:@"mtx"];
    
    _arrayNotes = [[mtxParser parseFile:path] retain];
    
    [mtxParser release];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)checkNotesTime:(NSTimer*)theTimer {
    NSTimeInterval interval = (-1)*[_firstTimeFired timeIntervalSinceNow];
        
    if ([(MtxNote*)[_arrayNotes objectAtIndex:_currentNoteIndex] initTime] < interval) {

        _currentNoteIndex++;
        if (_currentNoteIndex == [_arrayNotes count]) {
            [_notesTimer invalidate];
            [_startButton setHidden:NO];
        }
    }
}


#pragma mark - Actions

- (IBAction)startGame:(id)sender {
    [sender setHidden:YES];
    _firstTimeFired = [[NSDate date] retain];
    
    _notesTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(checkNotesTime:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_notesTimer forMode:NSDefaultRunLoopMode];
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"funnybunny_game" ofType:@"aac"];
    AVAudioPlayer *player= [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:soundFilePath] error:nil];
    [player play];
}

- (IBAction)tapGestureRecognized:(id)sender {
    NSLog(@"TAP");
}

- (IBAction)pinchGestureRecognized:(id)sender {
    NSLog(@"PINCH");
}

- (IBAction)rotationGestureRecognized:(id)sender {
    NSLog(@"ROTATION");
}

- (IBAction)swipeLeftGestureRecognized:(id)sender {
    NSLog(@"SWIPE LEFT");
}

- (IBAction)swipeRightGestureRecognized:(id)sender {
    NSLog(@"SWIPE RIGHT");
}

- (IBAction)swipeUpGestureRecognized:(id)sender {
    NSLog(@"SWIPE UP");
}

- (IBAction)swipeDownGestureRecognized:(id)sender {
    NSLog(@"SWIPE DOWN");
}

- (IBAction)longPressGestureRecognized:(id)sender {
    NSLog(@"LONG PRESS");
}

@end
