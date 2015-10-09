//
//  FirstViewController.m
//  ChatTest
//
//  Created by Laxman on 08/10/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import "FirstViewController.h"
#import "LoginView.h"
#import "RegisterView.h"


#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <ParseTwitterUtils/ParseTwitterUtils.h>
#import "ProgressHUD.h"
#import "UIImageView+WebCache.h"

#import "utilities.h"

#import "WelcomeView.h"
#import "LoginView.h"
#import "RegisterView.h"



@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//
//#pragma mark - Twitter Action
//
//- (IBAction)twitterAction:(id)sender {
//
//    [ProgressHUD show:@"Signing in..." Interaction:NO];
//    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error)
//     {
//         if (user != nil)
//         {
//             if (user[PF_USER_TWITTERID] == nil)
//             {
//                 [self processTwitter:user];
//             }
//             else [self userLoggedIn:user];
//         }
//         else [ProgressHUD showError:@"Twitter login error."];
//     }];
//
//}
//
//- (void)processTwitter:(PFUser *)user
////-------------------------------------------------------------------------------------------------------------------------------------------------
//{
//    PF_Twitter *twitter = [PFTwitterUtils twitter];
//    //---------------------------------------------------------------------------------------------------------------------------------------------
//    user[PF_USER_FULLNAME] = twitter.screenName;
//    user[PF_USER_FULLNAME_LOWER] = [twitter.screenName lowercaseString];
//    user[PF_USER_TWITTERID] = twitter.userId;
//    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
//     {
//         if (error != nil)
//         {
//             [PFUser logOut];
//             [ProgressHUD showError:error.userInfo[@"error"]];
//         }
//         else [self userLoggedIn:user];
//     }];
//}
//
//
//
//#pragma mark - Facebook Action
//
//- (IBAction)facebookAction:(id)sender {
//}
//
//
//#pragma mark - Register Action
//
//
//- (IBAction)registerAction:(id)sender {
//    RegisterView *registerView = [[RegisterView alloc] init];
//    [self.navigationController pushViewController:registerView animated:YES];
//}
//
//
//
//#pragma mark - Login Action
//
//- (IBAction)loginAction:(id)sender {
//    
//    LoginView *loginView = [[LoginView alloc] init];
//    [self.navigationController pushViewController:loginView animated:YES];
//    
//}


//testing


#pragma mark - User actions

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)actionRegister:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    RegisterView *registerView = [[RegisterView alloc] init];
    [self.navigationController pushViewController:registerView animated:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)actionLogin:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    LoginView *loginView = [[LoginView alloc] init];
    [self.navigationController pushViewController:loginView animated:YES];
}

#pragma mark - Twitter login methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)actionTwitter:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [ProgressHUD show:@"Signing in..." Interaction:NO];
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error)
     {
         if (user != nil)
         {
             if (user[PF_USER_TWITTERID] == nil)
             {
                 [self processTwitter:user];
             }
             else [self userLoggedIn:user];
         }
         else [ProgressHUD showError:@"Twitter login error."];
     }];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)processTwitter:(PFUser *)user
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    PF_Twitter *twitter = [PFTwitterUtils twitter];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    user[PF_USER_FULLNAME] = twitter.screenName;
    user[PF_USER_FULLNAME_LOWER] = [twitter.screenName lowercaseString];
    user[PF_USER_TWITTERID] = twitter.userId;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error != nil)
         {
             [PFUser logOut];
             [ProgressHUD showError:error.userInfo[@"error"]];
         }
         else [self userLoggedIn:user];
     }];
}

#pragma mark - Facebook login methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)actionFacebook:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [ProgressHUD show:@"Signing in..." Interaction:NO];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    NSArray *permissionsArray = @[@"public_profile", @"email", @"user_friends"];
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error)
     {
         if (user != nil)
         {
             if (user[PF_USER_FACEBOOKID] == nil)
             {
                 [self requestFacebook:user];
             }
             else [self userLoggedIn:user];
         }
         else [ProgressHUD showError:@"Facebook login error."];
     }];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)requestFacebook:(PFUser *)user
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email"}];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
     {
         if (error == nil)
         {
             NSDictionary *userData = (NSDictionary *)result;
             [self requestFacebookPicture:user UserData:userData];
         }
         else
         {
             [PFUser logOut];
             [ProgressHUD showError:@"Failed to fetch Facebook user data."];
         }
     }];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)requestFacebookPicture:(PFUser *)user UserData:(NSDictionary *)userData
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    NSString *link = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", userData[@"id"]];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:link] options:0 progress:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
     {
         if (image != nil)
         {
             [self processFacebook:user UserData:userData Image:image];
         }
         else
         {
             [PFUser logOut];
             [ProgressHUD showError:@"Failed to fetch Facebook profile picture."];
         }
     }];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)processFacebook:(PFUser *)user UserData:(NSDictionary *)userData Image:(UIImage *)image
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    UIImage *picture = ResizeImage(image, 140, 140, 1);
    UIImage *thumbnail = ResizeImage(image, 60, 60, 1);
    //---------------------------------------------------------------------------------------------------------------------------------------------
    PFFile *filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(picture, 0.6)];
    [filePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error != nil) NSLog(@"WelcomeView processFacebook picture save error.");
     }];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    PFFile *fileThumbnail = [PFFile fileWithName:@"thumbnail.jpg" data:UIImageJPEGRepresentation(thumbnail, 0.6)];
    [fileThumbnail saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error != nil) NSLog(@"WelcomeView processFacebook thumbnail save error.");
     }];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    NSString *name = userData[@"name"];
    NSString *email = userData[@"email"];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if (name == nil) name = @"";
    if (email == nil) email = @"";
    //---------------------------------------------------------------------------------------------------------------------------------------------
    user[PF_USER_EMAILCOPY] = email;
    user[PF_USER_FULLNAME] = name;
    user[PF_USER_FULLNAME_LOWER] = [name lowercaseString];
    user[PF_USER_FACEBOOKID] = userData[@"id"];
    user[PF_USER_PICTURE] = filePicture;
    user[PF_USER_THUMBNAIL] = fileThumbnail;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error != nil)
         {
             [PFUser logOut];
             [ProgressHUD showError:error.userInfo[@"error"]];
         }
         else [self userLoggedIn:user];
     }];
}

#pragma mark - Helper methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)userLoggedIn:(PFUser *)user
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    ParsePushUserAssign();
    PostNotification(NOTIFICATION_USER_LOGGED_IN);
    [ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome back %@!", user[PF_USER_FULLNAME]]];
    [self dismissViewControllerAnimated:YES completion:nil];
}









@end
