
#import "Helper.h"
#import "Reachability.h"
@implementation Helper 

#pragma mark -
#pragma mark Check Whether Internet is active or not 

+(bool)isConnectedToInternet
{
    Reachability *hostReach = [[Reachability reachabilityForInternetConnection] retain];
	NetworkStatus netStatus = [hostReach currentReachabilityStatus];
	BOOL isInternetActive = TRUE;
    
	if(netStatus == NotReachable)
    {
		isInternetActive = FALSE;
	}
    
	return isInternetActive;
}

@end
