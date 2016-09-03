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
@synthesize language;




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"values%@",_object.title);
    
    if (_object.title.length >0) {
        
        MovieTile.text = _object.title;
        directer.text = _object.director;
        releaseDate.text = _object.relesed;
        plot.text = _object.plot;
        language.text = _object.language;
        rating.text =_object.rating;
        
        [self imageLoading];

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
-(void)imageLoading{
    
    dispatch_queue_t concurrentQueue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //this will start the image loading in bg
    
    dispatch_async(concurrentQueue, ^{
        NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:_object.poster]];
        
        //this will set the image when loading is finished
        
        dispatch_async(dispatch_get_main_queue(), ^{
           UIImage *imageView = [UIImage imageWithData:image];
            [posterImage setImage:imageView];
        });
    });
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
