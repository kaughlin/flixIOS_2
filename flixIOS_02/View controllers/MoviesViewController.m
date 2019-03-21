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

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    
    [self.refreshControl addTarget:self action: @selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview: self.refreshControl];
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
        }
        else {
            // Get the array of movies
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"Data Dictionary: \n %@", dataDictionary);
            
            // Store the movies in a property to use elsewhere
            self.movies = dataDictionary[@"results"];
            
            for(NSDictionary *movie in self.movies) {
                NSLog(@"Movie in array: %@ \n", movie);
            }
            
            //Reload your table view data
            [self.tableView reloadData];
        }
        //end refresh control
        [self.refreshControl endRefreshing];
    }];
    [task resume];
}

// returns number for rows in the tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

//creates and configures cell based on index path
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //create a cell
    //UITableViewCell *cell = [[UITableViewCell alloc] init];
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.movies[indexPath.row]; // right movie associated with the right row
    //cell.textLabel.text = movie[@"title"];
    
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    //get index path for the cell that was tapped.
    NSIndexPath *indexPath = [self.tableView indexPathForCell: tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
    NSLog(@"Tapping on a movie.");
}


@end
