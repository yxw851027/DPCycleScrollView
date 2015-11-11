# DPCycleScrollView
一个可以循环滚动的ScrollView.

使用示例：

	DPCycleScrollView *scrollView = [[DPCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    scrollView.delegate = self;
    scrollView.datasource = self;
    [self.view addSubview:scrollView];
    
    #pragma mark - DPCycleScrollViewDatasource
	- (NSInteger)numberOfPagesInCycleScrollView:(DPCycleScrollView *)csView
	{
    	return 3;
	}

	- (UIView *)cycleScrollView:(DPCycleScrollView *)csView pageAtIndex:(NSInteger)index
	{
    	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    	imageView.contentMode = UIViewContentModeScaleAspectFill;
    	imageView.clipsToBounds = YES;
    	imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", 	@(index + 1)]];
    
    	return imageView;
	}

	#pragma mark - DPCycleScrollViewDelegate
	- (void)cycleScrollView:(DPCycleScrollView *)csView didScrollToPageAtIndex:(NSInteger)index
	{
		NSLog(@"didScrollToPageAtIndex:%@", @(index));
	}
	
	- (void)cycleScrollView:(DPCycleScrollView *)csView clickPageAtIndex:(NSInteger)index
	{
    	NSLog(@"clickPageAtIndex:%@", @(index));
	}