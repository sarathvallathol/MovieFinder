//
//  ViewController.h
//  MovieFinder
//
//  Created by sarath on 01/09/16.
//  Copyright © 2016 com.ForQuintype.Movieapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate, UISearchBarDelegate>

@property (strong) NSMutableArray *searchText;
@property (nonatomic) IBOutlet UITableView *ListTable;
@end

