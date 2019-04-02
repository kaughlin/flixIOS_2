//
//  DetailsViewController.m
//  flixIOS_02
//
//  Created by Kaughlin Caver on 3/19/19.
//  Copyright © 2019 Kaughlin Caver. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterPathString = self.movie[@"poster_path"];
    NSString *fullPosterUrlString = [baseURLString stringByAppendingString:posterPathString];
    
    //convert full path to NSURL because it checks to make sure it is a valid url
    NSURL *posterUrl = [NSURL URLWithString:fullPosterUrlString];
    [self.posterView setImageWithURL:posterUrl];
    
    NSString *backdropPathString = self.movie[@"backdrop_path"];
    NSString *fullbackdropUrlString = [baseURLString stringByAppendingString:backdropPathString];
    
    //convert full path to NSURL because it checks to make sure it is a valid url
    NSURL *backdropUrl = [NSURL URLWithString:fullbackdropUrlString];
    [self.backdropView setImageWithURL:backdropUrl];
    self.backdropView.alpha = .80;
    
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
