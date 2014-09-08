//
//  MGalleyViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/1/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MGalleyViewController.h"
#import "MOk2DialogViewController.h"
#import "MGalleyTableViewCell.h"
#import "MGalleyPictureViewController.h"
#import "UIImageView+WebCache.h"
#import "MApi.h"

static const int KCountPerRow=4;

@interface MGalleyViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *galleyDataItemList;

@end

@implementation MGalleyViewController

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
    self.galleyDataItemList = [[NSMutableArray alloc] init];
    
    self.tableView.separatorColor = [UIColor clearColor];
;
    [self.tableView registerNib:[UINib nibWithNibName:MGalleyTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:MGalleyTableViewCellIdentifier];
    
    for (int i=0; i<10; i++)
    {
        id iconUrl=@"/media/page/540842e3bf483c53727f45e0/1410006951.jpg";
        [self.galleyDataItemList addObject:iconUrl];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickPicture:(UITapGestureRecognizer*)tapGestureRecognizer
{
    int index=tapGestureRecognizer.view.tag;
    NSString* iconUrl=[self.galleyDataItemList objectAtIndex:index];
    
    MGalleyPictureViewController *viewController = [MGalleyPictureViewController new];
    viewController.iconUrl=iconUrl;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows=self.galleyDataItemList.count/KCountPerRow;
    if(self.galleyDataItemList.count%KCountPerRow>0)
    {
        rows++;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGalleyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MGalleyTableViewCellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    int index=indexPath.row*KCountPerRow;
    
    cell.imageView0.hidden=YES;
    cell.imageView1.hidden=YES;
    cell.imageView2.hidden=YES;
    cell.imageView3.hidden=YES;
    
    for (int i=0; i<KCountPerRow; i++)
    {
        [self setImageViewWithIndex:index+i cell:cell];
    }
    
    return cell;
}

-(void)setImageViewWithIndex:(int)index cell:(MGalleyTableViewCell*)cell
{
    if(index>=self.galleyDataItemList.count)
    {
        return;
    }
    
    UIImageView* imageView=nil;
    switch (index%KCountPerRow) {
        case 0:
            imageView=cell.imageView0;
            break;
        case 1:
            imageView=cell.imageView1;
            break;
        case 2:
            imageView=cell.imageView2;
            break;
        case 3:
            imageView=cell.imageView3;
            break;
    }
    
    imageView.hidden=NO;
    
    NSString* iconUrl=[self.galleyDataItemList objectAtIndex:index];
    imageView.tag=index;
    [imageView sd_setImageWithURL:[NSURL URLWithString:iconUrl relativeToURL:[NSURL URLWithString:[MApi getBaseUrl]]]];
    
    if([imageView gestureRecognizers].count==0)
    {
        UITapGestureRecognizer* tapGestureRecognizer= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPicture:)];
        
        [imageView addGestureRecognizer:tapGestureRecognizer];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    float height=cell.frame.size.height;
    
    return height;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
