//
//  Movie.h
//  flixIOS_02
//
//  Created by Kaughlin Caver on 4/5/19.
//  Copyright © 2019 Kaughlin Caver. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSURL *posterUrl;
@property (nonatomic, strong) NSURL *backdropUrl;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
