//
//  EMGoodsCommentModel.m
//  EMall
//
//  Created by Luigi on 16/7/27.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsCommentModel.h"

@implementation EMCommentStarModel
+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"star":@"star",
             @"startNum":@"star_num"};
}
@end


@interface EMGoodsCommentModel ()
@property (nonatomic,copy,readwrite)NSString *levelString;
@end

@implementation EMGoodsCommentModel
+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"commentID":@"id",
             @"goodsID":@"gid",
             @"userID":@"mid",
             @"nickName":@"member_name",
             @"userAvatar":@"avatar",
             @"content":@"content",
             @"commentTime":@"comment_time",};
}


-(NSString *)levelString{
    switch (_level) {
        case 0:
            _levelString=@"差评";
            break;
        case 1:
            _levelString=@"中评";
            break;
        case 2:
            _levelString=@"好评";
            break;
        default:
            _levelString=@"好评";
            break;
    }
    return _levelString;
}
@end


@implementation EMGoodsCommentHomeModel

+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"startArray":@"star",
             @"commentArray":@"comment",};
}

@end