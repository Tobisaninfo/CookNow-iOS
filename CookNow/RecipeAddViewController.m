//
//  RecipeAddViewController.m
//  CookNow
//
//  Created by Tobias on 25.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

#import "RecipeAddViewController.h"
#import "AddRecipeTableViewCell.h"

@interface RecipeAddViewController ()

@end

@implementation RecipeAddViewController
    
@synthesize delegate;
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController *controller = [[UIViewController alloc]init];
    CGRect rect;
    if (array.count < 4) {
        rect = CGRectMake(0, 0, 272, 150);
        [controller setPreferredContentSize:rect.size];
        
    } else if (array.count < 6){
        rect = CGRectMake(0, 0, 272, 200);
        [controller setPreferredContentSize:rect.size];
    } else if (array.count < 8){
        rect = CGRectMake(0, 0, 272, 250);
        [controller setPreferredContentSize:rect.size];
        
    } else {
        rect = CGRectMake(0, 0, 272, 300);
        [controller setPreferredContentSize:rect.size];
    }
    
    alertTableView  = [[UITableView alloc]initWithFrame:rect];
    alertTableView.delegate = self;
    alertTableView.dataSource = self;
    alertTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [alertTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [alertTableView registerNib:[UINib nibWithNibName:@"AddRecipeTableViewCell" bundle: NSBundle.mainBundle] forCellReuseIdentifier:@"Cell"];
    
    [controller.view addSubview:alertTableView];
    [controller.view bringSubviewToFront:alertTableView];
    [controller.view setUserInteractionEnabled:YES];
    
    [alertTableView setUserInteractionEnabled:YES];
    [alertTableView setAllowsSelection:YES];
    [self setValue:controller forKey:@"contentViewController"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {}];
    [self addAction:cancelAction];
}

- (void)setData: (NSArray*) data {
    array = data;
    [alertTableView reloadData];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return array.count;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if ([cell isKindOfClass:[AddRecipeTableViewCell class]]) {
        ((AddRecipeTableViewCell*) cell).nameLabel.text = array[indexPath.row];
    }
    
    return cell;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (delegate != nil) {
        [delegate didSelectIndex:indexPath.row];
    }
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
