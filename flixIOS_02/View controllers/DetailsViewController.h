//
//  DetailsViewController.h
//  flixIOS_02
//
//  Created by Kaughlin Caver on 3/19/19.
//  Copyright © 2019 Kaughlin Caver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (nonatomic, strong) Movie *movie;

@end

NS_ASSUME_NONNULL_END
