//
//  AppDelegate.h
//  WeiFaTest2
//
//  Created by Bill Cheng on 12-6-26.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#define VERSION                ((float)1.0)

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSManagedObjectContext         *_managedObjContext;
    NSManagedObjectModel           *_managedObjModel;
    NSPersistentStoreCoordinator   *_persistentStoreCoordinator;
    ECSlidingViewController *slidingViewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain,readonly) NSManagedObjectContext         *managedObjContext;
@property (nonatomic,retain,readonly) NSManagedObjectModel           *managedObjModel;
@property (nonatomic,retain,readonly) NSPersistentStoreCoordinator   *persistentStoreCoordinator;

@end
