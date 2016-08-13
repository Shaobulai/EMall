//
//  EMShopCartModel.h
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseModel.h"
@class EMSpecListModel;
@interface EMShopCartModel : OCBaseModel
@property(nonatomic,assign)NSInteger cartID;
@property(nonatomic,assign)NSInteger goodsID,gdid,userID;//分别是商品id和规格id
@property(nonatomic,copy)NSString *goodsName;
@property(nonatomic,copy)NSString *goodsImageUrl;
@property(nonatomic,assign)CGFloat goodsPrice;
@property (nonatomic,assign)NSInteger goodsAmount;//库存数量

@property(nonatomic,assign)NSInteger buyCount;
@property (nonatomic,assign)CGFloat totalPrice;
@property (nonatomic,copy)NSString *spec;//尺寸
@property (nonatomic,strong)EMSpecListModel *specListModel;
@property (nonatomic,assign)BOOL unSelected;//default is no
@end
