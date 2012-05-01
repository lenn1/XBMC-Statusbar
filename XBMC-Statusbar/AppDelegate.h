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
    IBOutlet NSTextField *textfield_ipAddress;
    IBOutlet NSTextField *textfield_port;
    IBOutlet NSTextField *textfield_username;
    IBOutlet NSSecureTextField *textfield_password;
    IBOutlet NSTextField *textfield_macAddress;
    IBOutlet NSButton *checkBox_smallIcon;
}

- (IBAction)button_UpdateLibrary:(id)sender;
- (IBAction)button_CleanLibrary:(id)sender;
- (IBAction)button_WakeOnLan:(id)sender;
- (IBAction)button_Suspend:(id)sender;
- (IBAction)button_Reboot:(id)sender;
- (IBAction)button_ShutDown:(id)sender;
- (IBAction)button_Preferences:(id)sender;
- (IBAction)button_Quit:(id)sender;
- (IBAction)button_prefCancel:(id)sender;
- (IBAction)button_prefOk:(id)sender;
- (IBAction)button_playPause:(id)sender;
- (IBAction)button_Next:(id)sender;
- (IBAction)button_Previous:(id)sender;
- (IBAction)button_Stop:(id)sender;
-(void)RPCCall:(NSString*)rpc_call;
-(void)updateIcon;
@property(assign,nonatomic)NSString* ipAddress;


@end
