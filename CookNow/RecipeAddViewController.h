//
//  RecipeAddViewController.h
//  CookNow
//
//  Created by Tobias on 25.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecipeAddViewControllerDelegate <NSObject>
    
- (void) didSelectIndex: (NSInteger) index;
    
@end

@interface RecipeAddViewController : UIAlertController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *alertTableView;
    NSArray* array;
}

@property id<RecipeAddViewControllerDelegate> delegate;
    
- (void) setData: (NSArray* ) data;

@end
