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

@interface MainTableViewController ()

@end

@implementation MainTableViewController
NSDictionary *result;
NSArray *items;
@synthesize acitvityIndicator;


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
        [self getValuesFromResult];
        NSString *title = [result objectForKey:@"Title"];
        NSLog(@"%@",title);
        cell.titleLable.text = title;
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[result objectForKey:@"Poster"]]]];
        [cell.posterImage setImage:image];
    }
    
    //cell.posterImage.image = [UIImage imageNamed:@"image001.png"];
    
        return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  //  [self performSegueWithIdentifier:@"ShowDetail" sender:tableView];

}
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    tableView.rowHeight = 147.0f; // or some other height
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // NSLog(@"SEARCH ACTIVATED");
    
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
        
    
    NSString *string = [NSString stringWithFormat:@"http://www.omdbapi.com/?t=%@+&y=&plot=short&r=json", searchBar.text];
    NSURL *url = [NSURL URLWithString:string];
        NSLog(@"url =%@",string);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
          
        [acitvityIndicator startAnimating];
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        [acitvityIndicator stopAnimating];
        result = (NSDictionary *)responseObject;
        if ([[result objectForKey:@"Response"] isEqualToString:@"True"]) {
            
            [self getValuesFromResult];
             [self getProductData:searchBar.text];
            
            
        }
        
        
      
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [acitvityIndicator stopAnimating];

       
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving details"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
 
    [operation start];
    }
    
    
}
-(void)getValuesFromResult{
    
    DataObject *Object = [[DataObject alloc]init];
    // NSMutableArray *item = [[NSMutableArray alloc]init];
    
    
    Object.poster = [result objectForKey:@"Poster"];
    Object.year = [result objectForKey:@"Year"];
    Object.director =  [result objectForKey:@"Director"];
    Object.relesed = [result objectForKey:@"Released"];
    Object.title = [result objectForKey:@"Title"];
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
-(void)getProductData:(NSString *)title{
    
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}
-(void)reloadData{
    [self.tableView reloadData];
}

@end
