//
//  MovieCell.h
//  flixIOS_02
//
//  Created by Kaughlin Caver on 3/14/19.
//  Copyright © 2019 Kaughlin Caver. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@end

NS_ASSUME_NONNULL_END
