/*
 *  BOXHashHelper.h
 *
 *  Based on FileHash by Joel Lopes Da Silva:
 *  Copyright © 2010-2014 Joel Lopes Da Silva. All rights reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 * 
 *        http://www.apache.org/licenses/LICENSE-2.0
 * 
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

#import <Foundation/Foundation.h>

@interface BOXHashHelper : NSObject

+ (NSString *)md5HashOfFileAtPath:(NSString *)filePath __attribute__((deprecated("All MD5 based methods will be removed")));
+ (NSString *)sha1HashOfFileAtPath:(NSString *)filePath;
+ (NSString *)sha512HashOfFileAtPath:(NSString *)filePath;

+ (NSData *)sha1HashDataOfData:(NSData *)data;
+ (NSString *)sha1HashOfData:(NSData *)data;

+ (NSString *)sha512HashFromString:(NSString *)string;

@end
