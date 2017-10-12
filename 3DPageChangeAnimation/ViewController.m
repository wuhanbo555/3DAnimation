//
//  ViewController.m
//  3DPageChangeAnimation
//
//  Created by 吴瀚波 on 17/3/2.
//  Copyright © 2017年 bobo. All rights reserved.
//

#import "ViewController.h"

#define NAVIGATIONBAR_HIGHT 44
#define STATEBAR_HIGHT 20

@interface ViewController ()

//截图
@property (nonatomic,strong)UIImageView *screenshots;
//搭配视图
@property (nonatomic,strong)UIImageView *showPicView;
//描述文字
@property (nonatomic,strong)UILabel *descLabel;
//遮罩图
@property (nonatomic,strong)UIView *maskView;
//附属内容区域
@property (nonatomic,strong)UIView *showListView;
//最大滑动距离
@property (nonatomic,assign)CGFloat showListMaxDt;
//是否展示
@property (nonatomic,assign)BOOL isShow;
//是否完成缩小动画
@property (nonatomic,assign)BOOL narrow;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.title = @"推拉动画Demo";
	[self createShowPicView];
	[self createShowListView];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)createShowPicView
{
	//主图
	_showPicView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 110 - NAVIGATIONBAR_HIGHT - STATEBAR_HIGHT)];
	_showPicView.userInteractionEnabled = YES;
	_showPicView.backgroundColor = [UIColor whiteColor];
	_showPicView.clipsToBounds = YES;
	_showPicView.contentMode = UIViewContentModeScaleAspectFill;
	_showPicView.image = [UIImage imageNamed:@"putao.jpeg"];
	[self.view addSubview:_showPicView];

	//描述文字
	_descLabel = [[UILabel alloc] init];
	_descLabel.font = [UIFont systemFontOfSize:13.0f];
	_descLabel.numberOfLines = 2;
	_descLabel.backgroundColor = [UIColor clearColor];
	_descLabel.textColor = [UIColor whiteColor];
	_descLabel.shadowColor = [UIColor whiteColor];
	_descLabel.shadowOffset = CGSizeMake(0,1);
	_descLabel.text = @"吃葡萄，不吐葡萄皮";
	[_descLabel sizeToFit];
	CGRect frame = _descLabel.frame;
	frame.origin = CGPointMake(12, self.showPicView.frame.size.height - 20);
	_descLabel.frame = frame;
	[_showPicView addSubview:_descLabel];
	
	//在上面添加遮罩
	_maskView = [[UIView alloc] initWithFrame:self.view.bounds];
	_maskView.backgroundColor = [UIColor blackColor];
	_maskView.userInteractionEnabled = NO;
	_maskView.alpha = 0;
	[self.view addSubview:_maskView];
	
}

- (void)createShowListView
{
	_showListView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 110, self.view.bounds.size.width, self.view.bounds.size.height - 116)];
	_showListView.backgroundColor = [UIColor blackColor];
	_showListView.alpha = 0.8;
	[self.view addSubview:_showListView];

	//限定最高滑动区域
	self.showListMaxDt = self.showListView.frame.origin.y - 116;
	
	UIImageView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.showListView.frame.size.width, 26)];
	headerView.tag = 101;
	headerView.contentMode = UIViewContentModeCenter;
	headerView.image = [UIImage imageNamed:@"TMWuse_Beacon"];
	headerView.userInteractionEnabled = YES;
	UITapGestureRecognizer *showClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showListViewClick:)];
	[headerView addGestureRecognizer:showClick];
	UIPanGestureRecognizer *beaconPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(showListViewPan:)];
	[headerView addGestureRecognizer:beaconPan];
	
	[self.showListView addSubview:headerView];
}

- (void)setIsShow:(BOOL)isShow
{
	_isShow = isShow;
	UIImageView *imageView = (UIImageView *)[self.showListView viewWithTag:101];
	if (isShow)
	{
		imageView.image = [UIImage imageNamed:@"TMWuse_BeaconDonw"];
	}
	else
	{
		imageView.image = [UIImage imageNamed:@"TMWuse_Beacon"];
	}
}

- (void)showListViewClick:(UITapGestureRecognizer *)recognizer
{
	if (self.isShow)
	{
		self.isShow = NO;
		[self.navigationController setNavigationBarHidden:NO animated:YES];
		
		[UIView animateWithDuration:0.5 animations:^{
			self.showListView.frame = CGRectMake(0, self.view.bounds.size.height - 110, self.view.bounds.size.width, self.view.bounds.size.height - 116);
			self.maskView.alpha = 0;
		}];
		
		//回复原状
		self.showPicView.transform = CGAffineTransformMakeScale(1,1);
		self.showPicView.frame = CGRectMake(0, NAVIGATIONBAR_HIGHT + STATEBAR_HIGHT, self.showPicView.frame.size.width, self.showPicView.frame.size.height);
		self.narrow = NO;
		CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
		rotationAndPerspectiveTransform.m34 = 1.0 / 300;
		rotationAndPerspectiveTransform = CATransform3DTranslate(rotationAndPerspectiveTransform, 0, - NAVIGATIONBAR_HIGHT * 1.8 , 0);
		rotationAndPerspectiveTransform = CATransform3DScale(rotationAndPerspectiveTransform, 0.8, 0.8, 1);
		rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 0.0f, 1.0f, 0.0f, 0.0f);
		self.showPicView.layer.transform = rotationAndPerspectiveTransform;
		
		
		[UIView animateWithDuration:0.25 animations:^{
			CALayer *layer = self.showPicView.layer;
			layer.zPosition = -200;
			CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
			rotationAndPerspectiveTransform.m34 = 1.0 / 300;
			rotationAndPerspectiveTransform = CATransform3DTranslate(rotationAndPerspectiveTransform, 0,  - NAVIGATIONBAR_HIGHT * 0.9 , 0);
			rotationAndPerspectiveTransform = CATransform3DScale(rotationAndPerspectiveTransform, 0.9 , 0.9, 1);
			rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -12 * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
			self.showPicView.layer.transform = rotationAndPerspectiveTransform;
			
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:0.25 animations:^{
				CALayer *layer = self.showPicView.layer;
				layer.zPosition = -200;
				CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
				rotationAndPerspectiveTransform.m34 = 1.0 / 300;
				rotationAndPerspectiveTransform = CATransform3DTranslate(rotationAndPerspectiveTransform, 0,  0 , 0);
				rotationAndPerspectiveTransform = CATransform3DScale(rotationAndPerspectiveTransform, 1.0, 1.0, 1);
				rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 0.0f, 1.0f, 0.0f, 0.0f);
				self.showPicView.layer.transform = rotationAndPerspectiveTransform;
			}];
		}];
	}
	else
	{
		self.isShow = YES;
		[self.navigationController setNavigationBarHidden:YES animated:YES];
		[UIView animateWithDuration:0.5 animations:^{
			self.showListView.frame = CGRectMake(0, 116, self.showListView.frame.size.width, self.showListView.frame.size.height);
			self.maskView.alpha = 0.6;
		}];
		
		[UIView animateWithDuration:0.25 animations:^{
			CALayer *layer = self.showPicView.layer;
			layer.zPosition = -200;
			CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
			rotationAndPerspectiveTransform.m34 = 1.0 / 300;
			rotationAndPerspectiveTransform = CATransform3DTranslate(rotationAndPerspectiveTransform, 0, - NAVIGATIONBAR_HIGHT * 0.9 , 0);
			rotationAndPerspectiveTransform = CATransform3DScale(rotationAndPerspectiveTransform, 0.9 , 0.9, 1);
			rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -12 * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
			self.showPicView.layer.transform = rotationAndPerspectiveTransform;
			
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:0.25 animations:^{
				CALayer *layer = self.showPicView.layer;
				layer.zPosition = -200;
				CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
				rotationAndPerspectiveTransform.m34 = 1.0 / 300;
				rotationAndPerspectiveTransform = CATransform3DTranslate(rotationAndPerspectiveTransform, 0,  - NAVIGATIONBAR_HIGHT * 1.8 , 0);
				rotationAndPerspectiveTransform = CATransform3DScale(rotationAndPerspectiveTransform, 0.8, 0.8, 1);
				rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 0.0f, 1.0f, 0.0f, 0.0f);
				self.showPicView.layer.transform = rotationAndPerspectiveTransform;
			} completion:^(BOOL finished) {
				//改变原状
				float top = self.showPicView.frame.origin.y;
				float left = self.showPicView.frame.origin.x;
				CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
				rotationAndPerspectiveTransform = CATransform3DScale(rotationAndPerspectiveTransform, 1, 1, 1);
				self.showPicView.layer.transform = rotationAndPerspectiveTransform;
				self.showPicView.transform = CGAffineTransformMakeScale(0.8,0.8);
				self.showPicView.frame = CGRectMake(left, top, self.showPicView.frame.size.width, self.showPicView.frame.size.height);
				self.narrow = YES;
			}];
		}];
	}
}

- (void)showListViewPan:(UIPanGestureRecognizer *)recognizer
{
	static float startPoint_Y;
	float changePoint_Y;
	static float viewPoint_Y;
	switch (recognizer.state)
	{
		case UIGestureRecognizerStateBegan:
		{
			startPoint_Y = [recognizer locationInView:self.view.window].y;
			viewPoint_Y = self.showListView.frame.origin.y;
			break;
		}
		case UIGestureRecognizerStateChanged:
		{
			changePoint_Y = [recognizer locationInView:self.view.window].y;
			float move_Y = viewPoint_Y + (changePoint_Y - startPoint_Y);
			if (move_Y > self.view.bounds.size.height - 110)
			{
				move_Y = self.view.bounds.size.height - 110;
			}
			else if(move_Y < 116)
			{
				move_Y = 116;
			}
			self.showListView.frame = CGRectMake(self.showListView.frame.origin.x, move_Y, self.showListView.frame.size.width, self.showListView.frame.size.height);
			[self showPicViewChangeProgress:((self.view.bounds.size.height - 116) - self.showListView.frame.origin.y)/self.showListMaxDt];
			[recognizer setTranslation:CGPointZero inView:self.view.window];
			break;
		}
		case UIGestureRecognizerStateEnded:
		{
			[self showPicViewAnimationProgress:((self.view.bounds.size.height - 116) - self.showListView.frame.origin.y)/self.showListMaxDt];
			break;
		}
			
		default:
			break;
	}
}

- (void)showPicViewChangeProgress:(float)progress
{
	if (progress > 1 || progress < 0)
	{
		return;
	}
	if (self.narrow)
	{
		//回复原状
		self.showPicView.transform = CGAffineTransformMakeScale(1,1);
		self.showPicView.frame = CGRectMake(0, NAVIGATIONBAR_HIGHT + STATEBAR_HIGHT, self.showPicView.frame.size.width, self.showPicView.frame.size.height);
		self.narrow = NO;
	}
	
	self.maskView.alpha = 0.6 * progress;
	if (progress <= 0.5)
	{
		if (self.navigationController.navigationBarHidden)
		{
			[self.navigationController setNavigationBarHidden:NO animated:YES];
		}
		CALayer *layer = self.showPicView.layer;
		layer.zPosition = -200;
		CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
		rotationAndPerspectiveTransform.m34 = 1.0 / 300;
		rotationAndPerspectiveTransform = CATransform3DTranslate(rotationAndPerspectiveTransform, 0,  - NAVIGATIONBAR_HIGHT * progress * 1.8 , 0);
		rotationAndPerspectiveTransform = CATransform3DScale(rotationAndPerspectiveTransform, 1.0 - (0.2 * progress) , 1.0 - (0.2 * progress), 1);
		rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -(24 * progress)*M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
		self.showPicView.layer.transform = rotationAndPerspectiveTransform;
	}
	else
	{
		if (!self.navigationController.navigationBarHidden)
		{
			[self.navigationController setNavigationBarHidden:YES animated:YES];
		}
		CALayer *layer = self.showPicView.layer;
		layer.zPosition = -200;
		CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
		rotationAndPerspectiveTransform.m34 = 1.0 / 300;
		rotationAndPerspectiveTransform = CATransform3DTranslate(rotationAndPerspectiveTransform, 0,  - NAVIGATIONBAR_HIGHT * progress * 1.8 , 0);
		rotationAndPerspectiveTransform = CATransform3DScale(rotationAndPerspectiveTransform, 1.0 - (0.2 * progress), 1.0 - (0.2 * progress), 1);
		rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -(12 - 24*(progress - 0.5))*M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
		self.showPicView.layer.transform = rotationAndPerspectiveTransform;
	}
}

- (void)showPicViewAnimationProgress:(float)progress
{
	if(progress <= 0.5)
	{
		[UIView animateWithDuration:0.25 animations:^{
			CALayer *layer = self.showPicView.layer;
			layer.zPosition = -200;
			CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
			rotationAndPerspectiveTransform.m34 = 1.0 / 300;
			rotationAndPerspectiveTransform = CATransform3DTranslate(rotationAndPerspectiveTransform, 0, 0, 0);
			rotationAndPerspectiveTransform = CATransform3DScale(rotationAndPerspectiveTransform, 1.0, 1.0, 1);
			rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 0.0f, 1.0f, 0.0f, 0.0f);
			self.showPicView.layer.transform = rotationAndPerspectiveTransform;
			self.showListView.frame = CGRectMake(0, self.view.bounds.size.height - 110, self.view.bounds.size.width, self.view.bounds.size.height - 116);
			self.maskView.alpha = 0;
		}completion:^(BOOL finished) {
			self.narrow = NO;
			self.isShow = NO;
		}];
	}
	else
	{
		//已经缩小，说明已经达到固定位置了，不需要再做动画
		if (self.narrow)
		{
			return;
		}
		[UIView animateWithDuration:0.25 animations:^{
			CALayer *layer = self.showPicView.layer;
			layer.zPosition = -200;
			CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
			rotationAndPerspectiveTransform.m34 = 1.0 / 300;
			rotationAndPerspectiveTransform = CATransform3DTranslate(rotationAndPerspectiveTransform, 0,  - NAVIGATIONBAR_HIGHT * 1.8 , 0);
			rotationAndPerspectiveTransform = CATransform3DScale(rotationAndPerspectiveTransform, 0.8 , 0.8, 1);
			rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 0.0f, 1.0f, 0.0f, 0.0f);
			self.showPicView.layer.transform = rotationAndPerspectiveTransform;
			self.showListView.frame = CGRectMake(0, 116, self.showListView.frame.size.width, self.showListView.frame.size.height);
			self.maskView.alpha = 0.6;
		} completion:^(BOOL finished) {
			//改变原状
			float top = self.showPicView.frame.origin.y;
			float left = self.showPicView.frame.origin.x;
			CALayer *layer = self.showPicView.layer;
			layer.zPosition = -200;
			CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
			rotationAndPerspectiveTransform = CATransform3DScale(rotationAndPerspectiveTransform, 1, 1, 1);
			self.showPicView.layer.transform = rotationAndPerspectiveTransform;
			self.showPicView.transform = CGAffineTransformMakeScale(0.8,0.8);
			self.showPicView.frame = CGRectMake(left, top, self.showPicView.frame.size.width, self.showPicView.frame.size.height);
			self.narrow = YES;
			self.isShow = YES;
		}];
	}
}


@end
