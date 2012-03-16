//
//  AppDelegate.h
//  XBMC-Statusbar
//
//  Created by Lennart Hansen on 16.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate,NSMenuDelegate>
{
    IBOutlet NSMenu *statusMenu;
    NSStatusItem * statusItem;
    NSString* username;
    NSString* password;
    NSString* ipAddress;
    int port;
    IBOutlet NSWindow* preferencesWindow;
}
- (IBAction)button_UpdateLibrary:(id)sender;
- (IBAction)button_CleanLibrary:(id)sender;
- (IBAction)button_WakeOnLan:(id)sender;
- (IBAction)button_Suspend:(id)sender;
- (IBAction)button_ShutDown:(id)sender;
- (IBAction)button_Preferences:(id)sender;
- (IBAction)button_Quit:(id)sender;

@property(assign,nonatomic)NSString* ipAddress;
@property(assign,nonatomic)NSString* username;
@property(assign,nonatomic)NSString* password;
@property int port;


@end
