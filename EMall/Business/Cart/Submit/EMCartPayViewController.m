//
//  EMCartPayViewController.m
//  EMall
//
//  Created by Luigi on 16/7/24.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMCartPayViewController.h"
#import "NSAttributedString+Price.h"
#import "EMCartPayCell.h"
static NSString *const kPayInfollIdenfier = @"kPayInfollIdenfier";
static NSString *const kPayPriceCellIdenfier = @"kPayPriceCellIdenfier";
@interface EMCartPayViewController ()
@property (nonatomic,assign)CGFloat totalPrice;
@end

@implementation EMCartPayViewController
- (instancetype)initWithTotalPrice:(CGFloat)totalPrice{
    self=[super init];
    if (self) {
        self.totalPrice=totalPrice;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.navigationItem.title=@"订单支付";
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     [self.tableView registerClass:[EMCartPayCell class] forCellReuseIdentifier:kPayInfollIdenfier];
    NSInteger count=2;
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *aCell;
    if (indexPath.row==0) {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kPayPriceCellIdenfier];
        if (nil==cell) {
            cell=[[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kPayPriceCellIdenfier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        UIColor *color=[UIColor colorWithHexString:@"#272727"];
        NSMutableAttributedString *priceAttrStr=[[NSMutableAttributedString alloc] initWithString:@"您的订单金额为:" attributes:@{NSFontAttributeName:[UIFont oc_systemFontOfSize:OCUISCALE(13)],NSForegroundColorAttributeName:color}];
        NSAttributedString *aStrr=[NSAttributedString goodsPriceAttrbuteStringWithPrice:self.totalPrice markFontSize:13 priceInterFontSize:19 pointInterSize:19 color:nil];
        [priceAttrStr appendAttributedString:aStrr];
        
        cell.textLabel.attributedText=priceAttrStr;
        aCell=cell;
    }else if (indexPath.row==1){
        EMCartPayCell *cell=[tableView dequeueReusableCellWithIdentifier:kPayInfollIdenfier forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryNone;
        [(EMCartPayCell *)cell setPayCartName:@"231wasdfaskfjls;akfja;sfjk2" cartID:@"112312312312312312312312" bankName:@"asdfasdfasdfasdfasdghqerawefasdfasdf"];
        aCell=cell;
    }
    return aCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (indexPath.row==0) {
        height=OCUISCALE(60);
    }else if(indexPath.row==1){

        height=[tableView fd_heightForCellWithIdentifier:kPayInfollIdenfier configuration:^(id cell) {
//            [(EMCartPayCell *)cell setShopCartModel:cartModel];
        }];
    }
    return height;
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