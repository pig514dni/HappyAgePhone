//
//  AddViewController.m
//  HappyAgePhone
//
//  Created by 張峻綸 on 2016/8/27.
//  Copyright © 2016年 張峻綸. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()<UITextFieldDelegate>
{
    BOOL textFieldIndex;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;


@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _phoneTextField.keyboardType =  UIKeyboardTypeNumberPad;
    //去调用上面的代码，给这个UITextField的对象添加UIToolbar
    _phoneTextField.inputAccessoryView = [self addToolbar];
    self.navigationItem.title = @"新增聯絡人";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.view.backgroundColor = [UIColor colorWithRed:254.0/255.0 green:147.0/255.0 blue:140.0/255.0 alpha:1];
    
    _nameTextField.layer.cornerRadius = 15.0;
    _phoneTextField.layer.cornerRadius = 15.0;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_nameTextField resignFirstResponder ];
    [_phoneTextField resignFirstResponder ];
    return true;
}


- (IBAction)saveBtnPressd:(UIButton *)sender {
    NSString *name = _nameTextField.text;
    NSString *phone = _phoneTextField.text;
    if ([name  isEqual: @""] || [phone  isEqual: @""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"資料無法儲存" message:@"請填入完整資料" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"了解" style:(UIAlertActionStyleDefault) handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:true completion:nil];
    }else {
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSMutableArray *nameArray = [[NSMutableArray alloc]initWithArray:[userdefault objectForKey:@"name"]];
        NSMutableArray *phoneArray = [[NSMutableArray alloc]initWithArray:[userdefault objectForKey:@"phone"]];
        
        [nameArray addObject:name];
        [phoneArray addObject:phone];
        
        [userdefault setObject:nameArray forKey:@"name"];
        [userdefault setObject:phoneArray forKey:@"phone"];
        [userdefault synchronize];
        
        NSArray *addArray = @[name,phone];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"add" object:addArray];
        
        [self.navigationController popViewControllerAnimated:true];
    }
    
}

- (UIToolbar *)addToolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 35)];
    toolbar.tintColor = [UIColor blueColor];
    toolbar.backgroundColor = [UIColor grayColor];

    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"輸入完成" style:UIBarButtonItemStylePlain target:self action:@selector(keyboardHide)];
    
    toolbar.items = @[space,bar];
    return toolbar;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _nameTextField) {
        textFieldIndex = false;
    }else {
        textFieldIndex = true;
    }
}
#pragma mark 鍵盤出現
-(void)keyboardWillShow:(NSNotification *)notifa{
//    NSLog(@"notifa:%@",notifa);
    if (textFieldIndex) {
        [self dealKeyboardFrame:notifa];
    }
    
}
#pragma mark 鍵盤消失
-(void)keyboardWillHide:(NSNotification *)notifa{
    if (textFieldIndex) {
        [self dealKeyboardFrame:notifa];
    }
}
#pragma mark 處理鍵盤位置
-(void)dealKeyboardFrame:(NSNotification *)changeMess{
    NSDictionary *dicMess=changeMess.userInfo;//键盘改变的所有信息
    CGFloat changeTime=[dicMess[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];//透過userInfo 0.25秒後消失鍵盤
    CGFloat keyboardMoveY=[dicMess[UIKeyboardFrameEndUserInfoKey]CGRectValue].origin.y-[UIScreen mainScreen].bounds.size.height;//鍵盤的高度UIKeyboardFrameEndUserInfoKey-螢幕自己的高度)
    [UIView animateWithDuration:changeTime animations:^{ //0.25秒之後改變messageTableView和messageView的高
       

            
            _nameTextField.transform = CGAffineTransformMakeTranslation(0, keyboardMoveY);
            _phoneTextField.transform = CGAffineTransformMakeTranslation(0, keyboardMoveY);
           
    }];
    
}

-(void)keyboardHide {
    [_phoneTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
