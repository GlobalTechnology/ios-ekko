//
//  MultipleChoiceOptionCell.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/9/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <M13Checkbox.h>

@protocol MultipleChoiceOptionCellDelegate;
@interface MultipleChoiceOptionCell : UITableViewCell

@property (nonatomic, weak) id<MultipleChoiceOptionCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet M13Checkbox *checkbox;

@end

@protocol MultipleChoiceOptionCellDelegate <NSObject>
@required;
-(void)multipleChoiceOptionCell:(MultipleChoiceOptionCell *)cell didChangeSelected:(BOOL)selected;
@end