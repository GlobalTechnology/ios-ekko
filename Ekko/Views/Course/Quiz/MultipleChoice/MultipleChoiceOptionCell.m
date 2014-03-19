//
//  MultipleChoiceOptionCell.m
//  Ekko
//
//  Created by Brian Zoetewey on 9/9/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "MultipleChoiceOptionCell.h"
#import "UIColor+Ekko.h"

@implementation MultipleChoiceOptionCell

-(void)setCheckbox:(M13Checkbox *)checkbox {
    if (_checkbox) {
        @try {
            [_checkbox removeObserver:self forKeyPath:NSStringFromSelector(@selector(checkState))];
        }
        @catch (NSException *exception) {}
    }
    _checkbox = checkbox;
    [checkbox setCheckAlignment:M13CheckboxAlignmentLeft];
    [checkbox setTintColor:[UIColor ekkoLightBlue]];
    [checkbox addObserver:self forKeyPath:NSStringFromSelector(@selector(checkState)) options:0 context:NULL];
}

-(void)dealloc {
    if (_checkbox) {
        @try {
            [_checkbox removeObserver:self forKeyPath:NSStringFromSelector(@selector(checkState))];
        }
        @catch (NSException *exception) {}
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(checkState))]) {
        BOOL selected = self.checkbox.checkState == M13CheckboxStateChecked ? YES : NO;
        [self.delegate multipleChoiceOptionCell:self didChangeSelected:selected];
    }
}

@end
