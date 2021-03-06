//
//  D2ViewController.m
//  day2
//
//  Created by John Bender on 9/11/13.
//  Copyright (c) 2013 General UI, LLC. All rights reserved.
//

#import "D2PostsViewController.h"
#import "D2NewPostViewController.h"
#import "D2Post.h"
#import "D2PostViewCell.h"
#import "D2PostFetcher.h"

enum {
    CreateNewPostSection,
    PostsSection,
    NumberOfSections
} SectionEnumerator;

@interface D2PostsViewController () <NewPostDelegate>
{
    NSArray *posts;
}
@end

@implementation D2PostsViewController

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[D2PostFetcher postFetcher] fetchPostsAsync:^(NSArray *p) {
        posts = [p copy];
        [self.tableView reloadData];
        NSLog( @"got posts" );
    }];
    NSLog( @"finished appearing" );
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [segue.destinationViewController isKindOfClass:[D2NewPostViewController class]] ) {
        ((D2NewPostViewController*)segue.destinationViewController).delegate = self;
    }
}


#pragma mark - UITableView data source

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return NumberOfSections;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch( section ) {
        case CreateNewPostSection:
            return 1;
        case PostsSection:
            return [posts count];
        default:
            return 0;
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch( indexPath.section ) {
        case CreateNewPostSection:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreatePostCell" forIndexPath:indexPath];
            return cell;
        }
        case PostsSection:
        {
            D2PostViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostViewCell" forIndexPath:indexPath];
            [cell populateWithPost:posts[indexPath.row]];

            return cell;
        }
    }

    return nil;
}

#pragma mark - UITableView delegate

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch( indexPath.section ) {
        case CreateNewPostSection:
            return 44.;
        default:
            return tableView.rowHeight;
    }
}


#pragma mark - NewPost delegate

-(void) newPostViewController:(D2NewPostViewController *)newPostViewController didCreateNewPost:(D2Post *)post
{
    posts = [[D2PostFetcher postFetcher] addPost:post];
    [self.tableView reloadData];

    [self.navigationController popToViewController:self animated:YES];
}

@end
