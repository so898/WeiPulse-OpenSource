//
//  MessageCellBackgView.m
//  WeiFaTest2
//
//  Created by Bill Cheng on 12-7-8.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "MessageCellBackgView.h"

@implementation MessageCellBackgView

- (id)initWithFrame:(CGRect)frame {
	if((self = [super initWithFrame:frame])) {
		self.contentMode = UIViewContentModeRedraw;
		backgroundImage = [UIImage imageNamed:@"cell_backg"] ;
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect {
	[backgroundImage drawInRect:CGRectMake(0, rect.size.height - 20, rect.size.width, 20)];
	
}

@end
