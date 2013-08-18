//
//  ImageDetailViewController.m
//  WeiFaTest2
//
//  Created by Bill Cheng on 12-7-12.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "ImageDetailViewController.h"
#import "StatusViewController.h"

@interface ImageDetailViewController ()

@end

@implementation ImageDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.alpha = 0;
	// Do any additional setup after loading the view.
    //[[UIApplication sharedApplication].keyWindow setFrame:CGRectMake(0, -20, 320, 480)];
    self.view.frame = CGRectMake(0, 0, 320, 480);
    UIView *backg = [UIView new];
    backg.frame = CGRectMake(0, 0, 320, 480);
    backg.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"image_detail_view_background"]];
    [self.view addSubview:backg];
    
    UITapGestureRecognizer *singleTapGestureRecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Exit)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    [UIView animateWithDuration:0.3 animations:^{self.view.alpha = 1;[[UIApplication sharedApplication].keyWindow setFrame:CGRectMake(0, -20, 320, 480)];} ];
}

- (void)setImage:(UIImage *)aimage
{
    type = ImageFromTopCoverView;
    image = aimage;
    imageView = [[UIImageView alloc] initWithImage:image];
    imageView.image = image;
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    scrollView.contentMode = UIViewContentModeCenter;
    scrollView.maximumZoomScale = 3.0;
    scrollView.minimumZoomScale = 0.5;
    scrollView.delegate = self;
    scrollView.clipsToBounds = YES;
    scrollView.contentSize = CGSizeMake(image.size.width, image.size.height);
    scrollView.decelerationRate = 1.0f;
    scrollView.scrollsToTop = NO;
    [scrollView addSubview:imageView];
    [self.view addSubview:scrollView];
    saveImage = [UIButton new];
    saveImage.frame = CGRectMake(290, 450, 16, 16);
    saveImage.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"save"]];
    [saveImage addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveImage];
    float minimumScale = [scrollView frame].size.width  / ([imageView frame].size.width );
    [scrollView setMinimumZoomScale:minimumScale];
    [scrollView setZoomScale:minimumScale];
    [scrollView setContentOffset:CGPointZero];
}

- (void)setImageUrl:(NSString *)imageurl type:(ImageDetailViewType)t
{
    type = t;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *tmp_array = [imageurl componentsSeparatedByString:@"/"];
    NSString *temp_name = [NSString stringWithFormat:@"big_%@", [tmp_array objectAtIndex:([tmp_array count]-1)]];
    path = [path stringByAppendingPathComponent:temp_name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]){
        [self createScrollView:path];
    }
    else {
        NSURL *url = [NSURL URLWithString:imageurl];
        request = [[ASIHTTPRequest alloc] initWithURL:url];
        [request setDownloadDestinationPath:path];
        [request setCompletionBlock:^(void){
            [self createScrollView:path];
        }];
        [request setShowAccurateProgress:YES];
        [request startAsynchronous];
        request.downloadProgressDelegate = self;
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.mode = MBProgressHUDModeAnnularDeterminate;
        HUD.delegate = self;
        HUD.labelText = @"正在下载图片";
    }
}

- (void) createScrollView:(NSString *)path
{
    NSArray *tmp_array = [path componentsSeparatedByString:@"."];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    scrollView.contentMode = UIViewContentModeCenter;
    scrollView.maximumZoomScale = 3.0;
    scrollView.minimumZoomScale = 0.5;
    scrollView.delegate = self;
    scrollView.clipsToBounds = YES;
    scrollView.contentSize = CGSizeMake(image.size.width, image.size.height);
    scrollView.decelerationRate = 1.0f;
    scrollView.scrollsToTop = NO;
    image = [[UIImage alloc] initWithContentsOfFile: path];
    if ([[tmp_array objectAtIndex:(tmp_array.count - 1)] isEqualToString:@"gif"]){
        gifImageView = [[SCGIFImageView alloc] initWithGIFFile:path];
        gifImageView.frame = CGRectMake(0, 0, gifImageView.image.size.width, gifImageView.image.size.height);
        [scrollView addSubview:gifImageView];
        float minimumScale = [scrollView frame].size.width  / ([gifImageView frame].size.width );
        [scrollView setMinimumZoomScale:minimumScale];
        [scrollView setZoomScale:minimumScale];
        [scrollView setContentOffset:CGPointZero];
    } else {
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.image = image;
        imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [scrollView addSubview:imageView];
        float minimumScale = [scrollView frame].size.width  / ([imageView frame].size.width );
        [scrollView setMinimumZoomScale:minimumScale];
        [scrollView setZoomScale:minimumScale];
        [scrollView setContentOffset:CGPointZero];
    }
    [self.view addSubview:scrollView];
    saveImage = [UIButton new];
    saveImage.frame = CGRectMake(282, 442, 32, 32);
    [saveImage setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    [saveImage addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveImage];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)saveImage
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"正在保存图片";
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != nil){
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MTInfoPanel.bundle/Warning"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"保存失败";
        [HUD hide:YES afterDelay:1];
    }else{
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MTInfoPanel.bundle/Tick"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"已保存";
        [HUD hide:YES afterDelay:1];
    }
}

- (void)setProgress:(float)newProgress
{
    HUD.progress = newProgress;
}

- (void)Exit
{
    //[[UIApplication sharedApplication].keyWindow setFrame:CGRectMake(0, 0, 320, 480)];
    if (request != nil)
        [request cancel];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [UIView animateWithDuration:0.5 animations:^{
        if (type == ImageFromTopView)
            self.view.alpha = 0;
        [[UIApplication sharedApplication].keyWindow setFrame:CGRectMake(0, 0, 320, 480)];} 
                     completion:^(BOOL Complete){
                         //[self.view removeFromSuperview];
                         if (type == ImageFromTopView){
                             UIViewController *x = [UIViewController new];
                             self.slidingViewController.topCoverViewController = x;
                             x.view.userInteractionEnabled = NO;
                         } else if (type == ImageFromTopCoverView){
                             [self dismissModalViewControllerAnimated:YES];
                         }
                     }];
    
}

- (void)scrollViewDidZoom:(UIScrollView *)ascrollview
{
    /*if (scrollView.zoomScale <1.0){
     real_image = [scrollView.subviews lastObject];
     [real_image setCenter:CGPointMake(scrollView.frame.size.width /2, scrollView.frame.size.height / 2)];
     }*/
    CGFloat offsetX = (ascrollview.bounds.size.width > ascrollview.contentSize.width)?(ascrollview.bounds.size.width - ascrollview.contentSize.width) *0.5 :0.0;
    CGFloat offsetY = (ascrollview.bounds.size.height > ascrollview.contentSize.height)?(ascrollview.bounds.size.height - ascrollview.contentSize.height) *0.5 :0.0;
    if (imageView != nil)
        imageView.center = CGPointMake(ascrollview.contentSize.width * 0.5 + offsetX, ascrollview.contentSize.height * 0.5 + offsetY);
    else
        gifImageView.center = CGPointMake(ascrollview.contentSize.width * 0.5 + offsetX, ascrollview.contentSize.height * 0.5 + offsetY);
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollview withView:(UIView *)view atScale:(float)scale {
    [scrollview setZoomScale:scale+0.01 animated:NO];
    [scrollview setZoomScale:scale animated:NO];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (imageView != nil)
        return imageView;
    else
        return gifImageView;
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [scrollView frame].size.height / scale;
    zoomRect.size.width  = [scrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
