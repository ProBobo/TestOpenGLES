//
//  TestGLView.h
//  TestOpenglES
//
//  Created by yulibo on 2019/3/13.
//  Copyright © 2019年 余礼钵. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestGLView : UIView
/**
 创建上下文
 */
- (void)createContext;
/**
 渲染
 */
- (void)render;
@end

NS_ASSUME_NONNULL_END
