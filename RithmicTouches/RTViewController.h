//
//  RTViewController.h
//  RithmicTouches
//
//  Created by Darío Antequera on 29/11/12.
//  Copyright (c) 2012 Darío Antequera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTViewController : UIViewController {
    IBOutlet UIButton   *_startButton;
    
    NSArray     *_arrayNotes;
    NSDate      *_firstTimeFired;
    NSInteger   _currentNoteIndex;
    NSTimer     *_notesTimer;
}

- (IBAction)startGame:(id)sender;
- (IBAction)tapGestureRecognized:(id)sender;
- (IBAction)pinchGestureRecognized:(id)sender;
- (IBAction)rotationGestureRecognized:(id)sender;
- (IBAction)swipeLeftGestureRecognized:(id)sender;
- (IBAction)swipeRightGestureRecognized:(id)sender;
- (IBAction)swipeUpGestureRecognized:(id)sender;
- (IBAction)swipeDownGestureRecognized:(id)sender;
- (IBAction)longPressGestureRecognized:(id)sender;

@end
