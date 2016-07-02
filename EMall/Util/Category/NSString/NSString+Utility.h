//
//  NSString+Utility.h
//  Edu901iPhone
//
//  Created by user on 14-2-17.
//  Copyright (c) 2014年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utility)

- (UIColor *)colorWithHexString;
- (NSUInteger)numberOfMatchesNonChineseCharacterSet;

/**
 * Returns a URL Encoded String
 */

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;
- (NSString *)removeSpaceOfTyping;


- (CGSize)sizeWithFont:(UIFont *)font inSize:(CGSize)size;
- (CGSize)sizeWithFont:(UIFont *)font inSize:(CGSize)size lineSpacing:(CGFloat)lineSpace;
- (CGSize)sizeWithFont:(UIFont *)font inSize:(CGSize)size lineSpacing:(CGFloat)lineSpace characterSpacing:(long)characterSpace;
- (CGSize)sizeWithFont:(UIFont *)font inSize:(CGSize)size lineSpacing:(CGFloat)lineSpace characterSpacing:(long)characterSpace lineBreakMode:(NSLineBreakMode)lineBreakMode;

+ (BOOL)isNilOrEmptyForString:(NSString *)aString;
+ (NSUInteger)numberOfMatchesNonChineseCharacterSetInString:(NSString *)aString;


- (NSString *)encode64String;

- (NSString *)decodedWith64String;
@end
