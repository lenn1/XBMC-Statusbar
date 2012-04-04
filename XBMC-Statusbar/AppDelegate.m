//
//  AppDelegate.m
//  XBMC-Statusbar
//
//  Created by Lennart Hansen on 16.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import <arpa/inet.h>
#import <netinet/in.h>
#import <unistd.h>
#import <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>
@implementation NSString (HexIntValue)

- (unsigned int)hexIntValue
{
    NSScanner *scanner;
    unsigned int result;
    scanner = [NSScanner scannerWithString: self];
    [scanner scanHexInt: &result];
    return result;
}

@end
@implementation AppDelegate
@synthesize ipAddress;
- (void)dealloc
{
    
    [statusMenu release];
    [statusItem release];
        
    
    [super dealloc];
}
-(void)awakeFromNib
{
 
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"ipAddress"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"192.168.0.1" forKey:@"ipAddress"];
        [[NSUserDefaults standardUserDefaults]setObject:@"00:00:00:00:00:00" forKey:@"MAC"];
        [[NSUserDefaults standardUserDefaults]setObject:@"big" forKey:@"IconSize"];
        
    }

    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    [statusItem setMenu:statusMenu];
    [self updateIcon];
    
    
    [statusItem setHighlightMode:YES];
    statusMenu.delegate = self;
    
    

    self.ipAddress = (NSString*)[[NSUserDefaults standardUserDefaults]objectForKey:@"ipAddress"];
}
-(void)updateIcon
{
    
    NSString* iconsize = [[NSUserDefaults standardUserDefaults]objectForKey:@"IconSize"];

    if([iconsize isEqualToString:@"big"])
    {
        [statusItem setImage:[NSImage imageNamed:@"xbmc.png"]];
        [statusItem setAlternateImage:[NSImage imageNamed:@"xbmc-inv.png"]];
    }
    else
    {
        [statusItem setImage:[NSImage imageNamed:@"xbmc-small.png"]];
        [statusItem setAlternateImage:[NSImage imageNamed:@"xbmc-inv-small.png"]];
    }

}



-(void)RPCThread:(id)object
{
    @try 
    {
        NSString* rpc_call = (NSString*)object;
        
        struct sockaddr_in remote_addr;
        remote_addr.sin_family = AF_INET;
        remote_addr.sin_port = htons(9090);
        remote_addr.sin_addr.s_addr = inet_addr([self.ipAddress UTF8String]);
        
        int sfd = socket(AF_INET, SOCK_STREAM, 0);
        if(sfd < 0)
            @throw @"Socket Error";
        int con = connect(sfd, (struct sockaddr*)&remote_addr, sizeof(remote_addr));
        if(con < 0)
            @throw @"Connection Error";
        ssize_t sending = send(sfd, [rpc_call UTF8String], rpc_call.length, 0);
        if(sending < 0)
            @throw @"Sending Error";
        close(sfd);
    }
    @catch (NSString* error) 
    {
        NSLog(@"%@",error);
    }
    

}
-(void)RPCCall:(NSString*)rpc_call
{
    NSThread* rpcThread = [[NSThread alloc]initWithTarget:self selector:@selector(RPCThread:) object:rpc_call];
    [rpcThread start];
    
}
- (IBAction)button_UpdateLibrary:(id)sender 
{
    NSString* rpc_call = @"{\"jsonrpc\": \"2.0\", \"method\": \"VideoLibrary.Scan\",\"id\": null}";
    [self RPCCall:rpc_call];
}

- (IBAction)button_CleanLibrary:(id)sender 
{
    NSString* rpc_call = @"{\"jsonrpc\": \"2.0\", \"method\": \"VideoLibrary.Clean\",\"id\": null}";
    [self RPCCall:rpc_call];    
}

- (IBAction)button_WakeOnLan:(id)sender 
{
    NSString* macadd = [[NSUserDefaults standardUserDefaults]objectForKey:@"MAC"];
    
    unsigned char ethaddr[6];
    ethaddr[0] = [[macadd substringWithRange:NSMakeRange(0, 2)]hexIntValue];
    ethaddr[1] = [[macadd substringWithRange:NSMakeRange(3, 2)]hexIntValue];
    ethaddr[2] = [[macadd substringWithRange:NSMakeRange(6, 2)]hexIntValue];
    ethaddr[3] = [[macadd substringWithRange:NSMakeRange(9, 2)]hexIntValue];
    ethaddr[4] = [[macadd substringWithRange:NSMakeRange(12, 2)]hexIntValue];
    ethaddr[5] = [[macadd substringWithRange:NSMakeRange(15, 2)]hexIntValue];
    
    unsigned char *magicPacket;
    unsigned char buf [128];
    
    /* Build the message to send - 6 x 0xff then 16 x MAC address */
    magicPacket = buf;
    for (int i = 0; i < 6; i++)
        *magicPacket++ = 0xff;
    for (int j = 0; j < 16; j++)
        for (int i = 0; i < 6; i++)
            *magicPacket++ = ethaddr[i];
    
    /* Send the message */
    
    struct sockaddr_in remote_addr;
    remote_addr.sin_family = AF_INET;
    remote_addr.sin_port = htons(9);
    remote_addr.sin_addr.s_addr = inet_addr([self.ipAddress UTF8String]);
    
	int sfd = socket(AF_INET,SOCK_DGRAM,0);
	if(sfd < 0)
		NSLog(@"Socket Error");

	ssize_t SEND_MAGIC_PACKET = sendto(sfd, (char*)buf, 102, 0,(struct sockaddr*)&remote_addr, sizeof(remote_addr));
    if(SEND_MAGIC_PACKET < 0)
        NSLog(@"Sending Error!");
}

- (IBAction)button_Suspend:(id)sender 
{
    NSString* rpc_call = @"{\"jsonrpc\": \"2.0\", \"method\": \"System.Suspend\",\"id\": null}";
    [self RPCCall:rpc_call]; 

}

- (IBAction)button_Reboot:(id)sender 
{
    NSString* rpc_call = @"{\"jsonrpc\": \"2.0\", \"method\": \"System.Reboot\",\"id\": null}";
    [self RPCCall:rpc_call]; 
}

- (IBAction)button_ShutDown:(id)sender 
{
    NSString* rpc_call = @"{\"jsonrpc\": \"2.0\", \"method\": \"System.Shutdown\",\"id\": null}";
    [self RPCCall:rpc_call]; 
}

- (IBAction)button_Preferences:(id)sender 
{
    [preferencesWindow makeKeyAndOrderFront:nil];
    textfield_ipAddress.stringValue = self.ipAddress;
    textfield_macAddress.stringValue = (NSString*)[[NSUserDefaults standardUserDefaults]objectForKey:@"MAC"];
    NSString* iconsize = [[NSUserDefaults standardUserDefaults]objectForKey:@"IconSize"];
    
    if([iconsize isEqualToString:@"big"])
    {
        [checkBox_smallIcon setState:NSOffState];
    }
    else
    {
        [checkBox_smallIcon setState:NSOnState];
    }

    
    
    
}
- (IBAction)button_prefOk:(id)sender 
{
   if(checkBox_smallIcon.state == NSOnState)
       [[NSUserDefaults standardUserDefaults]setObject:@"small" forKey:@"IconSize"];
   else
       [[NSUserDefaults standardUserDefaults]setObject:@"big" forKey:@"IconSize"];

    
    [self updateIcon];
    
    
    [[NSUserDefaults standardUserDefaults]setObject:[textfield_ipAddress stringValue] forKey:@"ipAddress"];
    [[NSUserDefaults standardUserDefaults]setObject:[textfield_macAddress stringValue] forKey:@"MAC"];

    [[NSUserDefaults standardUserDefaults]synchronize];
    
    self.ipAddress = (NSString*)[[NSUserDefaults standardUserDefaults]objectForKey:@"ipAddress"];
    [preferencesWindow orderOut:self];
    
    
} 
- (IBAction)button_Quit:(id)sender 
{    
    [NSApp terminate: nil]; 
}

- (IBAction)button_prefCancel:(id)sender 
{
    [preferencesWindow orderOut:self];
}

 
@end
