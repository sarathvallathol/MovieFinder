//
//  DetailViewController.m
//  MovieFinder
//
//  Created by sarath on 02/09/16.
//  Copyright © 2016 com.ForQuintype.Movieapp. All rights reserved.
//

#import "DetailViewController.h"
#import "DataObject.h"
@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize MovieTile;
@synthesize rating;
@synthesize plot;
@synthesize posterImage;
@synthesize directer;
@synthesize releaseDate;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"values%@",_object.title);
    
    if (_object.title.length >0) {
        
        MovieTile.text = _object.title;
        directer.text = _object.director;
        releaseDate.text = _object.relesed;
        
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_object.poster]]];
        [posterImage setImage:image];
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"oops!"
                                                            message:@"no data avilable"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];

        


    }
    


    
    
    
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
