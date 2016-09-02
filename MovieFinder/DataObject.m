//
//  DataObject.m
//  MovieFinder
//
//  Created by sarath on 02/09/16.
//  Copyright © 2016 com.ForQuintype.Movieapp. All rights reserved.
//

#import "DataObject.h"

@implementation DataObject
@synthesize poster;
@synthesize year;
@synthesize director;
@synthesize title;
@synthesize relesed;

-(void)recieveValues:(NSDictionary *)values{
    
                poster = [values objectForKey:@"Poster"];
                year = [values objectForKey:@"Year"];
                director =  [values objectForKey:@"Director"];
                relesed = [values objectForKey:@"Released"];
                title = [values objectForKey:@"Title"];

    
}
@end
//@implementation MovieDetail





//-(id)copyWithZone:(NSZone *)zone {
//    
////    MovieDetail *item = [MovieDetail allocWithZone:zone];
////    
////    item.poster = poster;
////    item.year = year;
////    item.director = director;
////    item.title = title;
////    item.relesed = relesed;
////    
////    return item;
//    
//}

//@end
