//
//  CourseDrawerViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 10/14/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "CourseDrawerViewController.h"
#import <UIViewController+MMDrawerController.h>
#import "CourseDrawerMediaCell.h"
#import "Lesson+View.h"

@implementation CourseDrawerViewController

-(void)setItem:(ContentItem *)item {
    if (item != _item) {
        _item = item;
        [self.mediaCollectionView reloadData];
        [self.lessonTableView reloadData];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.item && [self.item isKindOfClass:[Lesson class]]) {
        return [[(Lesson *)self.item media] count];
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CourseDrawerMediaCell *cell = (CourseDrawerMediaCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"courseDrawerMediaCell" forIndexPath:indexPath];
    
    Lesson *lesson = (Lesson *)self.item;
    Media *media = (Media *)[lesson.media objectAtIndex:indexPath.row];
    cell.media = media;
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"LESSONS", nil);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.item) {
        Manifest *course = (Manifest *)[self.item manifest];
        return [course.content count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseDrawerLessonCell"];

    Manifest *course = (Manifest *)[self.item manifest];
    ContentItem *item = [course.content objectAtIndex:indexPath.row];
    [cell.textLabel setText:item.title];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.courseViewController setViewController:[self.item.manifest viewControllerAtIndex:indexPath.row storyboard:self.storyboard] direction:SwipeViewControllerDirectionNone];
    [[self mm_drawerController] toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {}];
}

@end
