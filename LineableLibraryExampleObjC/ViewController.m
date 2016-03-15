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
    self.didStart = NO;
    // Do any additional setup after loading the view, typically from a nib.
    _lineableDetector = [LineableDetector sharedDetector];
    [_lineableDetector setupWithDelegate:self apiKey:@"111111"];
    
    //Optional values. Default is interval:60.0 seconds, backgroundmode enabled.
    [_lineableDetector setDetectInterval:10.0];
    [_lineableDetector setBackgroundMode:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    self.didStart = [_lineableDetector state] == LineableDetectorStateIdle ? NO : YES;
    [self toggle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggle {
    if (self.didStart) {
        //Start
        [self.startButton setTitle:@"Stop" forState:UIControlStateNormal];
        [_lineableDetector start];
    }
    else {
        //Stop
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
        [_lineableDetector stop];
    }
}

- (IBAction)startButtonTapped:(id)sender {
    self.didStart = !self.didStart;
    [self toggle];
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

- (void)willDetectLineables {
    [self.statusLabel setText:@"Listening to nearby Lineables."];
}

- (void)didFailDetectingLineables:(enum LineableDetectorError)error {
    switch (error) {
        case LineableDetectorErrorBluetoothOff:
            [self.statusLabel setText:@"Bluetooth is Off"];
            break;
        case LineableDetectorErrorGatewayDidNotMove:
            [self.statusLabel setText:@"Gateway didn't move specific amount of distance."];
            break;
        case LineableDetectorErrorConnectionFailed:
            [self.statusLabel setText:@"Cannot send detect info to server"];
            break;
        case LineableDetectorErrorNoLineableDetected:
            [self.statusLabel setText:@"No Lineable Detected."];
            break;
        case LineableDetectorErrorConnectionTimeout:
            [self.statusLabel setText:@"Connection Timeout."];
            break;
    }
}

@end
