//
//  ViewController.m
//  LineableLibraryExampleObjC
//
//  Created by Berrymelon on 3/11/16.
//  Copyright © 2016 Lineable. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property BOOL didStart;

@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _lineableDetector = [LineableDetector sharedDetector];
    [_lineableDetector setDelegate:self];
    
    self.didStart = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startButtonTapped:(id)sender {
    
    if (self.didStart) {
        //Stop
        self.didStart = NO;
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
        [_lineableDetector stopTracking];
    }
    else {
        //Start
        self.didStart = YES;
        [self.startButton setTitle:@"Stop" forState:UIControlStateNormal];
        [_lineableDetector startTracking];
    }
}

- (void)didStartRangingLineables {
    [self.statusLabel setText:@"Lineable Detector Started"];
}

- (void)didStopRangingLineables {
    [self.statusLabel setText:@"Lineable Detector Stopped"];
}

- (void)didDetectLineables:(NSInteger)numberOfLineablesDetected missingLineable:(MissingLineable *)missingLineable {
    NSString *msg = [NSString stringWithFormat:@"%ld Lineable Detected.",(long)numberOfLineablesDetected];
    NSString *missingText = missingLineable == nil ? @"" : [NSString stringWithFormat:@"\nMissing Lineable:%@",missingLineable.name];
    [self.statusLabel setText:[NSString stringWithFormat:@"%@%@",msg,missingText]];
}

- (void)statuschanged:(enum LineableDetectorState)status {
    switch (status) {
        case LineableDetectorStateErrorSendingLineable:
            [self.statusLabel setText:@"Cannot send detect info to server"];
            break;
        case LineableDetectorStateGatewayNoMovement:
            [self.statusLabel setText:@"Gateway didn't move specific amount of distance."];
            break;
        case LineableDetectorStateNoDetectedLineables:
            [self.statusLabel setText:@"No Lineable Detected."];
            break;
        case LineableDetectorStateIdle:
            [self.statusLabel setText:@"Waiting.."];
            break;
        case LineableDetectorStatePreparingToSendToServer:
            [self.statusLabel setText:@"Listening to nearby Lineables."];
            break;
        default:
            break;
    }
}

@end
