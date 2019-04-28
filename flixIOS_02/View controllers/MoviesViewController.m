//
//  MoviesViewController.m
//  flixIOS_02
//
//  Created by Kaughlin Caver on 3/10/19.
//  Copyright © 2019 Kaughlin Caver. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Movie.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSArray *filteredMovies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    
    [self.refreshControl addTarget:self action: @selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview: self.refreshControl];
    [self.activityIndicator startAnimating];
    //same as above
    //[self.tableView insertSubview:self.refreshControl atIndex:0];
    
}

- (void)fetchMovies {
    
    //Network setup
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=0ae44ecf86247a29c7680a2be343cf5e"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //called when network called is finished
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            NSString *errorMessage = [error localizedDescription];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:((void)(@"%@"), errorMessage) preferredStyle:(UIAlertControllerStyleAlert)];
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
            self.movies  = [Movie moviesWithDictionaries:dataDictionary[@"results"]];
                 
            // store movies in a filtered property for search
            self.filteredMovies = self.movies;
            
            //Reload your table view data
            [self.tableView reloadData];
            
        }
        //end refresh control
        [self.refreshControl endRefreshing];
        //end loading animation
        [self.activityIndicator stopAnimating];
    }];
    [task resume];
}

// returns number for rows in the tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredMovies.count;
}

//creates and configures cell based on index path
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //create a cell
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    Movie *movie = self.filteredMovies[indexPath.row]; // right movie associated with the right row
    
    cell.titleLabel.text = movie.title;
    cell.synopsisLabel.text = movie.synopsis;
    
    cell.posterView.image = nil;
    //set current poster image
    [cell.posterView setImageWithURL: movie.posterUrl];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    //get index path for the cell that was tapped.
    NSIndexPath *indexPath = [self.tableView indexPathForCell: tappedCell];
    Movie *movie = self.filteredMovies[indexPath.row];
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Movie *evaluatedObject, NSDictionary *bindings) {

            NSString* evaluatedMovie = evaluatedObject.title;
            return [evaluatedMovie containsString:searchText];
        }];
        
        self.filteredMovies = [self.filteredMovies filteredArrayUsingPredicate:predicate];
    }
    else {
        self.filteredMovies = self.movies;
    }
    [self.tableView reloadData];
}

@end
