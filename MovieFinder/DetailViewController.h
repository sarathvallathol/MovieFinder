//
//  DetailViewController.h
//  MovieFinder
//
//  Created by sarath on 02/09/16.
//  Copyright © 2016 com.ForQuintype.Movieapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataObject.h"

@interface DetailViewController : UIViewController
@property(nonatomic,weak) IBOutlet UIImageView *posterImage;
@property (nonatomic,weak) IBOutlet UILabel *rating;
@property (nonatomic,weak) IBOutlet UILabel *plot;
@property (nonatomic,weak) IBOutlet UILabel *releaseDate;
@property (nonatomic,weak) IBOutlet UILabel *MovieTile;
@property (nonatomic,weak) IBOutlet UILabel *directer;
@property (nonatomic,strong) DataObject *object;
 @end
