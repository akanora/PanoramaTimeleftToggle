#include <sourcemod>
#include <colors>
#include <clientprefs>
/////////
// ConVars
bool g_bShow[MAXPLAYERS+1] = { true, ... }
Cookie g_PanoramaCookie = null;

public Plugin myinfo = 
{
	name = "Panorama - Timeleft", 
	author = "Noora, quantum, fastmancz", 
	description = "Shows timeleft at the bottom of the screen", 
	version = "1.3.1"
};

public void OnPluginStart()
{
	CreateTimer(1.0, Timeleft, _, TIMER_REPEAT);
	AutoExecConfig(true, "plugin.panorama_timeleft_v2");
	RegConsoleCmd("sm_kalansure", Command_ptoff, "toggle off the hud");
	RegConsoleCmd("sm_timeleft", Command_ptoff, "toggle off the hud");
	RegConsoleCmd("sm_haritasuresi", Command_ptoff, "toggle off the hud");
	RegConsoleCmd("sm_timelefthud", Command_ptoff, "toggle off the hud");
	g_PanoramaCookie = new Cookie("Panorama_Cookie", "Panorama Cookie", CookieAccess_Protected);
}

public void OnClientConnected(client)
{
	if (AreClientCookiesCached(client)) {
		char buffer[2];
		g_PanoramaCookie.Get(client, buffer, sizeof(buffer));
		if (StrEqual(buffer, "")) {
			g_PanoramaCookie.Set(client, "1");
			g_bShow[client] = true;
		} else if (StrEqual(buffer, "1")) {
			g_bShow[client] = true;
		} else if (StrEqual(buffer, "0")) {
			g_bShow[client] = false;
		}
	}
	
}

public Action Timeleft(Handle timer)
{
	char sTime[60];
	int iTimeleft;
	GetMapTimeLeft(iTimeleft);
	
	if (iTimeleft > 0)
	{
		FormatTime(sTime, sizeof(sTime), "%M:%S", iTimeleft);
		
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsClientInGame(i) && !IsFakeClient(i) && g_bShow[i])
			{
				char message[60];
				Format(message, sizeof(message), "Timeleft: %s", sTime);
				SetHudTextParams(0.0, -0.07, 1.0, 228, 174, 57, 255, 0, 0.00, 0.00, 0.00);
				ShowHudText(i, -1, message);
			}
		}
	}
	return Plugin_Continue;
}
public Action Command_ptoff(int client, int args)
{
	if (g_bShow[client]) {
		g_bShow[client] = false;
		g_PanoramaCookie.Set(client, "0");
	} else {
		g_bShow[client] = true;
		g_PanoramaCookie.Set(client, "1");
	}
} 
