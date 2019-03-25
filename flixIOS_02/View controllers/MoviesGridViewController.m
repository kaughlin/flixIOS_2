//
//  MoviesGridViewController.m
//  flixIOS_02
//
//  Created by Kaughlin Caver on 3/21/19.
//  Copyright © 2019 Kaughlin Caver. All rights reserved.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self fetchMovies];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = self.collectionView.frame.size.width / postersPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    layout.itemSize = CGSizeMake( itemWidth , itemHeight );
    
}

- (void)fetchMovies {
    
    //Network setup
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/287947/similar?api_key=0ae44ecf86247a29c7680a2be343cf5e&language=en-US&page=1"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //called when network called is finished
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            NSString *errorMessage = [error localizedDescription];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:(@"%@", errorMessage) preferredStyle:(UIAlertControllerStyleAlert)];
            //create cancel action
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                // handle cancel response here. Doing nothing will dismiss the view.
            }];
            
            // add the cancel action to the alertController
            [alert addAction:cancelAction];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // handle cancel response here. Doing nothing will dismiss the view.
            }];
            
            // add the OK action to the alert controller
            [alert addAction:okAction];
            
            //show alert
            [self presentViewController:alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
        }
        else {
            // Get the array of movies
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            // Store the movies in a property to use elsewhere
            self.movies = dataDictionary[@"results"];
            
            //Reload your table view data
            [self.collectionView reloadData];

        }
        //end refresh control

    }];
    [task resume];
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"MovieCollectionCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.movies[indexPath.item]; // right movie associated with the right row
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterPathString = movie[@"poster_path"];
    NSString *fullPosterUrlString = [baseURLString stringByAppendingString:posterPathString];
    //convert full path to NSURL because it checks to make sure it is a valid url
    NSURL *posterUrl = [NSURL URLWithString:fullPosterUrlString];
    
    cell.posterView.image = nil;
    //set current poster image
    [cell.posterView setImageWithURL: posterUrl];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    //get index path for the cell that was tapped.
    NSIndexPath *indexPath = [self.collectionView indexPathForCell: tappedCell];
    NSDictionary *movie = self.movies[indexPath.item];
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
    NSLog(@"Tapping on a movie in gridView.");
}


@end
