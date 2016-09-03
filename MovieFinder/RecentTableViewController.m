//
//  RecentTableViewController.m
//  MovieFinder
//
//  Created by sarath on 02/09/16.
//  Copyright © 2016 com.ForQuintype.Movieapp. All rights reserved.
//

#import "RecentTableViewController.h"
#import <CoreData/CoreData.h>


@interface RecentTableViewController ()

@end

@implementation RecentTableViewController
@synthesize searchText;
- (void)viewDidLoad {
    [super viewDidLoad];
   // [self.tableView reloadData];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RecentSearch" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    searchText = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]mutableCopy];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
    } else {
        NSLog(@"%@", searchText);
    }
}
- (NSManagedObjectContext *)managedObjectContext {
    
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    
    return context;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //NSLog(@"count%lu",(unsigned long)searchText.count);
    return searchText.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSManagedObject *object = [self.searchText objectAtIndex:indexPath.row];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.textLabel setText:[NSString stringWithFormat:@"%@",[object valueForKey:@"name"]]];
        
    }
    
    
    
    return cell;
}



@end
