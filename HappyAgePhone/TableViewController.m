//
//  TableViewController.m
//  HappyAgePhone
//
//  Created by 張峻綸 on 2016/8/27.
//  Copyright © 2016年 張峻綸. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
#import "AddViewController.h"
@interface TableViewController ()
{
    NSMutableArray *nameArray;
    NSMutableArray *phoneArray;
    float viewHight ;
    BOOL arrayCount;
    NSUserDefaults *userdefault ;
    
//    TableViewCell *cell;
    
}
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;


@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _navigationBar.title = @"樂齡電話";

   
    nameArray = [NSMutableArray new];
    phoneArray = [NSMutableArray new];

    userdefault = [NSUserDefaults standardUserDefaults];
    NSArray *nameBook = [userdefault objectForKey:@"name"];
    NSArray *phoneBook = [userdefault objectForKey:@"phone"];
    nameArray = [[NSMutableArray alloc]initWithArray:nameBook];
    phoneArray = [[NSMutableArray alloc]initWithArray:phoneBook];
    
    
    viewHight = self.view.bounds.size.height - 44;
    NSLog(@"viewHight:%f",viewHight);
    self.tableView.rowHeight = 0.33333 * viewHight;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAddArray:) name:@"add" object:nil];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(editNamePhone:)];
    longPress.minimumPressDuration = 1.0;
    [self.tableView addGestureRecognizer:longPress];
    

    if (nameArray.count == 0 && phoneArray.count == 0) {
        NSArray *info1 = @[@"請按右上角"];
        NSArray *info2 = @[@"新增資訊"];
        [nameArray addObjectsFromArray:info1];
        [phoneArray addObjectsFromArray:info2];
        arrayCount = true;
    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
-(void)editNamePhone:( UILongPressGestureRecognizer  *)gestureRecognizer{
    CGPoint pointTouch = [gestureRecognizer  locationInView : self.tableView ];
    
    
    
    if  (gestureRecognizer .state  == UIGestureRecognizerStateBegan) {
        NSLog( @"UIGestureRecognizerStateBegan" );
        
        NSIndexPath  *indexPath = [self.tableView indexPathForRowAtPoint:pointTouch];
        if  (arrayCount) {
            UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"請按右上角新增資訊" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDefault handler:nil];
            [errorAlert addAction:ok];
            [self presentViewController:errorAlert animated:true completion:nil];
        } else {
            
            NSLog( @"Section = %ld,Row = %ld" ,( long )indexPath .section ,( long )indexPath .row );
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改聯絡人資訊" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
           [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
               textField.text = nameArray[indexPath.row];
           }];
           [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
               textField.keyboardType = UIKeyboardTypeNumberPad;
               textField.text = phoneArray[indexPath.row];
           }];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"修改完成" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
                nameArray[indexPath.row] = alert.textFields.firstObject.text;
                phoneArray[indexPath.row] = alert.textFields.lastObject.text;
                [userdefault setObject:nameArray forKey:@"name"];
                [userdefault setObject:phoneArray forKey:@"phone"];
                [userdefault synchronize];
                
                [self.tableView reloadData];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消修改" style:(UIAlertActionStyleCancel) handler:nil];
            
            [alert addAction:ok];
            [alert addAction:cancel];
            [self presentViewController:alert animated:true completion:nil];

        }
    
    }
    if  (gestureRecognizer .state  == UIGestureRecognizerStateChanged) {
        NSLog( @"UIGestureRecognizerStateChanged" );
    }
    
    if  (gestureRecognizer .state  == UIGestureRecognizerStateEnded) {
        NSLog( @"UIGestureRecognizerStateEnded" );
        [self.tableView reloadData];
    }
}

- ( void ) getAddArray: (NSNotification* ) aNotification
{
    NSArray *addArray = [aNotification object ];
    
    if (arrayCount) {
        [nameArray replaceObjectAtIndex:0 withObject:addArray[0]];
        [phoneArray replaceObjectAtIndex:0 withObject:addArray[1]];
        arrayCount = false;
    }else{
        
        
        NSArray *nameBook = [userdefault objectForKey:@"name"];
        NSArray *phoneBook = [userdefault objectForKey:@"phone"];
        nameArray = [[NSMutableArray alloc]initWithArray:nameBook];
        phoneArray = [[NSMutableArray alloc]initWithArray:phoneBook];
//        [nameArray addObject:addArray[0]];
//        [phoneArray addObject:addArray[1]];
        
    }
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
   
    
        return nameArray.count;
    

    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
   TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(editNamePhone:)];
//    longPress.minimumPressDuration = 2.0;
//    [cell addGestureRecognizer:longPress];
    // Configure the cell...
    
   
        cell.nameLabel.text = nameArray[indexPath.row];
        cell.phoneLabel.text = phoneArray[indexPath.row];
    UIView * bkView = [UIView new];
    bkView.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:142.0/255.0 blue:255.0/255.0 alpha:1.0];
    cell.selectedBackgroundView = bkView;
    
    if (indexPath.row % 2 == 0) {
        
        cell.backgroundColor = [UIColor colorWithRed:178.0/255.0 green:255.0/255.0 blue:168.0/255.0 alpha:1.0];
    }else {
        cell.backgroundColor = [UIColor colorWithRed:208.0/255.0 green:255.0/255.0 blue:183.0/255.0 alpha:1];
    }
    
    
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor redColor];
    
    if ([phoneArray[indexPath.row] isEqualToString:@"" ]) {
        UIAlertController *phoneErrorAlert = [UIAlertController alertControllerWithTitle:@"電話格式錯誤" message:@"請修改電話欄位" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDefault handler:nil];
        [phoneErrorAlert addAction:ok];
        [self presentViewController:phoneErrorAlert animated:true completion:nil];
        
    }else if ([nameArray[indexPath.row] isEqualToString:@"" ]) {
        UIAlertController *nameErrorAlert = [UIAlertController alertControllerWithTitle:@"姓名格式錯誤" message:@"請修改姓名欄位" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDefault handler:nil];
        [nameErrorAlert addAction:ok];
        [self presentViewController:nameErrorAlert animated:true completion:nil];
        
        
    }else if (arrayCount){
       
        UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"請按右上角新增資訊" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDefault handler:nil];
        [errorAlert addAction:ok];
        [self presentViewController:errorAlert animated:true completion:nil];
        
        
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否撥打電話" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確認" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *telephoneString=[phoneArray[indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSMutableString *str1=[[NSMutableString alloc] initWithString:telephoneString];
            [str1 setString:[str1 stringByReplacingOccurrencesOfString:@"(" withString:@""]];
            [str1 setString:[str1 stringByReplacingOccurrencesOfString:@")" withString:@""]];
            [str1 setString:[str1 stringByReplacingOccurrencesOfString:@"-" withString:@""]];
            [str1 setString:[str1 stringByReplacingOccurrencesOfString:@" " withString:@""]];
            telephoneString = [@"tel://" stringByAppendingString:str1];
            
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telephoneString]];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:true completion:nil];

    }
    
    
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

{
    return TRUE;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return UITableViewCellEditingStyleDelete;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        
        [phoneArray removeObjectAtIndex:indexPath.row];//移除数据源的数据
        [nameArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
        
        [userdefault setObject:nameArray forKey:@"name"];
        [userdefault setObject:phoneArray forKey:@"phone"];
        [userdefault synchronize];
        [self.tableView reloadData];
        
    }
        
}



- (IBAction)addBtnPressed:(UIBarButtonItem *)sender {
    AddViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddViewController"];
    [self.navigationController showViewController:vc sender:nil];
}

//-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
