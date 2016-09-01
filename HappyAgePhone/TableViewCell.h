//
//  TableViewCell.h
//  HappyAgePhone
//
//  Created by 張峻綸 on 2016/8/27.
//  Copyright © 2016年 張峻綸. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end
