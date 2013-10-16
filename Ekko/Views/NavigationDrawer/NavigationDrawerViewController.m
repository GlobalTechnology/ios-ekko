//
//  NavigationDrawerViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 10/15/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "NavigationDrawerViewController.h"
#import "UIImage+Ekko.h"
#import "UIColor+Ekko.h"
#import <TheKey/TheKey.h>

@implementation NavigationDrawerViewController

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case NavigationDrawerSectionCourses:
            return @"Courses";
        case NavigationDrawerSectionSettings:
            return @"Settings";
        default:
            return nil;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case NavigationDrawerSectionCourses:
            return 2;
        case NavigationDrawerSectionSettings:
            return 2;
        default:
            return 0;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
//    [[(UITableViewHeaderFooterView *)view textLabel] setTextColor:[UIColor ekkoDarkBlue]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"navigationDrawerCell"];
    
    switch (indexPath.section) {
        case NavigationDrawerSectionCourses:
            switch (indexPath.row) {
                case 0:
                    [cell.textLabel setText:@"All Courses"];
                    [cell.imageView setImage:[UIImage imageNamed:@"glyphicons_071_book.png" withTint:[[UIColor darkTextColor] colorWithAlphaComponent:0.5f]]];
                    break;
                case 1:
                    [cell.textLabel setText:@"My Courses"];
                    [cell.imageView setImage:[UIImage imageNamed:@"glyphicons_012_heart.png" withTint:[[UIColor darkTextColor] colorWithAlphaComponent:0.5f]]];
                    break;
                default:
                    break;
            }
            break;
            
        case NavigationDrawerSectionSettings:
            switch (indexPath.row) {
                case 0:
                    if ([[TheKey theKey] canAuthenticate]) {
                        [cell.textLabel setText:@"Logout"];
                        [cell.imageView setImage:[UIImage imageNamed:@"glyphicons_387_log_out.png" withTint:[[UIColor darkTextColor] colorWithAlphaComponent:0.5f]]];
                    }
                    else {
                        [cell.textLabel setText:@"Login"];
                        [cell.imageView setImage:[UIImage imageNamed:@"glyphicons_386_log_in.png" withTint:[[UIColor darkTextColor] colorWithAlphaComponent:0.5f]]];
                    }
                    break;
                case 1:
                    [cell.textLabel setText:@"About Ekko"];
                    [cell.imageView setImage:[UIImage imageNamed:@"cogwheel.png" withTint:[[UIColor darkTextColor] colorWithAlphaComponent:0.5f]]];
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
    return cell;
}

@end
