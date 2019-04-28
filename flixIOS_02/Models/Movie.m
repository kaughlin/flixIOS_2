//
//  Movie.m
//  flixIOS_02
//
//  Created by Kaughlin Caver on 4/5/19.
//  Copyright © 2019 Kaughlin Caver. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.title = dictionary[@"title"];
    self.synopsis = dictionary[@"overview"];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterPathString = dictionary[@"poster_path"];
    NSString *fullPosterString = [baseURLString stringByAppendingString:posterPathString];
    self.posterUrl = [NSURL URLWithString:fullPosterString];
    
    NSString *backdropPathString = dictionary[@"backdrop_path"];
    NSString *fullbackdropUrlString = [baseURLString stringByAppendingString:backdropPathString];
    
    //convert full path to NSURL because it checks to make sure it is a valid url
    self.backdropUrl = [NSURL URLWithString:fullbackdropUrlString];
    
    return self;
}

+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries; {
    // Implement this function
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in dictionaries) {
        Movie *movie = [[Movie alloc] initWithDictionary:dictionary];
        [movies addObject:movie];
    }
    return movies;
}

@end
