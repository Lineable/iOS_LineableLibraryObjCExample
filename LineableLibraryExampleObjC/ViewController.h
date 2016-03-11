//
//  ViewController.h
//  LineableLibraryExampleObjC
//
//  Created by Berrymelon on 3/11/16.
//  Copyright © 2016 Lineable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineableLibrary-Swift.h"

@interface ViewController : UIViewController <LineableDetectorDelegate>

@property (nonatomic,retain) LineableDetector *lineableDetector;

@end

