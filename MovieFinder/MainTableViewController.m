//
//  MainTableViewController.m
//  MovieFinder
//
//  Created by sarath on 02/09/16.
//  Copyright © 2016 com.ForQuintype.Movieapp. All rights reserved.
//

#import "MainTableViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "DataObject.h"
#import "MainTableViewCell.h"
#import "DetailViewController.h"
#import <CoreData/CoreData.h>


@interface MainTableViewController ()

@end

@implementation MainTableViewController
NSDictionary *result;
NSArray *items;
NSMutableArray *textArray;
UIActivityIndicatorView *spinner;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSManagedObjectContext *)managedObjectContext {
    
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    
    return context;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
        
    } else {
        if (result ==0) {
            return 0;
        }else{
        return 1;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CustomTableCell";
    
    MainTableViewCell *cell = (MainTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (result !=nil) {
        
        NSString *title = [result objectForKey:@"Title"];
        //NSLog(@"%@",title);
        [self retrivingDataFromApiResponse];
        cell.titleLable.text = title;
        cell.posterImage.contentMode = UIViewContentModeScaleAspectFit;
        
        dispatch_queue_t concurrentQueue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        //this will start the image loading in bg
        
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[result objectForKey:@"Poster"]]];
            
            //this will set the image when loading is finished
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *imageView = [UIImage imageWithData:image];
                [cell.posterImage setImage:imageView];
            });
        });
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  //  [self performSegueWithIdentifier:@"ShowDetail" sender:tableView];

}
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    tableView.rowHeight = 155.0f; // or some other height
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
        return YES;
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    
        return YES;
   
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
  
    
    if (searchBar.text.length >0) {
        
        
        //spinner
        [self startSpinner];
        [self.view addSubview:spinner];
        [spinner startAnimating];
        
        //saving search key
        NSManagedObjectContext *context = [self managedObjectContext];
        // Create a new managed object
        NSManagedObject *searchObject = [NSEntityDescription insertNewObjectForEntityForName:@"RecentSearch" inManagedObjectContext:context];
        [searchObject setValue:searchBar.text forKey:@"name"];
        
        
        NSString *trimmedText = [self removeWhiteSpace:searchBar.text];
        
         // Do the search...
        NSString *string = [NSString stringWithFormat:@"http://www.omdbapi.com/?t=%@+&y=&plot=short&r=json", trimmedText];
        NSURL *url = [NSURL URLWithString:string];
        //NSLog(@"url =%@",string);
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            [spinner removeFromSuperview];
            [spinner stopAnimating];
            
            result = (NSDictionary *)responseObject;
            if ([[result objectForKey:@"Response"] isEqualToString:@"True"]) {
                
                [self retrivingDataFromApiResponse];
                [self.searchDisplayController.searchResultsTableView reloadData];
                
                
                
            }else{
                
                [self alertView:@"Movie name not found"];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [spinner removeFromSuperview];
            [spinner stopAnimating];
            
            [self alertView:[error localizedDescription]];
         
        }];
        
        
        [operation start];
    }
    
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [spinner removeFromSuperview];
    [spinner stopAnimating];
}
-(void)retrivingDataFromApiResponse{
    
    DataObject *Object = [[DataObject alloc]init];
    Object.poster = [result objectForKey:@"Poster"];
    Object.year = [result objectForKey:@"Year"];
    Object.director =  [result objectForKey:@"Director"];
    Object.relesed = [result objectForKey:@"Released"];
    Object.title = [result objectForKey:@"Title"];
    Object.plot = [result objectForKey:@"Plot"];
    Object.rating = [result objectForKey:@"imdbRating"];
    Object.language = [result objectForKey:@"Language"];
    
    items = [NSArray arrayWithObject:Object];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
    if (result!=0) {
        
        
        if ([segue.identifier isEqualToString:@"showMovieDetail"] ) {
            NSIndexPath *indexPath = nil;
            DataObject *object = nil;
            
            if (self.searchDisplayController.active) {
                indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
                object = [items objectAtIndex:indexPath.row];
                
            } else {
                
                indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
                object = [items objectAtIndex:indexPath.row];
                
            }
            
            DetailViewController *destViewController = segue.destinationViewController;
            destViewController.object = object;
            
        }
    }
}

-(void)startSpinner{
    
   spinner = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGRect frame = spinner.frame;
    frame.origin.x = (self.view.frame.size.width / 2 - frame.size.width / 2);
    frame.origin.y = (self.view.frame.size.height / 2 - frame.size.height / 2);
    spinner.frame = frame;
    spinner.color = [UIColor blackColor];
    
}
-(NSString *)removeWhiteSpace:(NSString *)string{
    
   
    NSString *trimmedText = [string stringByReplacingOccurrencesOfString:@"\\s"
                                                                withString:@""
                                                                   options:NSRegularExpressionSearch
                                                                     range:NSMakeRange(0, [string length])];
    return trimmedText;
}
-(void)alertView:(NSString *)message{
    
    UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle:@"Error Retrieving details"
                                                           message:message
                                                          delegate:nil
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil];
    [failureAlert show];

}
@end
