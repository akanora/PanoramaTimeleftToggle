#include <sourcemod>
#include <colors>
#include <clientprefs>
/////////
// ConVars
bool g_nbShoww[MAXPLAYERS + 1] =  { true, ... }
Cookie g_PanoramaaCookieee = null;

public Plugin myinfo = 
{
	name = "Panorama - Timeleft", 
	author = "Nora, quantum, fastmancz", 
	description = "Shows timeleft at the bottom of the screen", 
	version = "1.3.2"
};

public void OnPluginStart()
{
	CreateTimer(1.0, Timeleft, _, TIMER_REPEAT);
	RegConsoleCmd("sm_kalansure", Command_ptoff, "toggle off the hud");
	RegConsoleCmd("sm_timeleft", Command_ptoff, "toggle off the hud");
	RegConsoleCmd("sm_haritasuresi", Command_ptoff, "toggle off the hud");
	RegConsoleCmd("sm_timelefthud", Command_ptoff, "toggle off the hud");
	g_PanoramaaCookieee = new Cookie("Panorama_Cookieee", "Panorama Cookieee", CookieAccess_Protected);
}

public void OnClientPostAdminCheck(int client)
{
	if (AreClientCookiesCached(client)) {
		char buffer[2];
		g_PanoramaaCookieee.Get(client, buffer, sizeof(buffer));
		if (StrEqual(buffer, "")) {
			g_PanoramaaCookieee.Set(client, "1");
			g_nbShoww[client] = true;
		} else if (StrEqual(buffer, "1")) {
			g_nbShoww[client] = true;
		} else if (StrEqual(buffer, "0")) {
			g_nbShoww[client] = false;
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
			if (IsClientInGame(i) && !IsFakeClient(i) && g_nbShoww[i])
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
	if (g_nbShoww[client]) {
		g_nbShoww[client] = false;
		g_PanoramaaCookieee.Set(client, "0");
		PrintToChat(client, "[\x10Panorama Timeleft\x01] başarıyla \x02deaktif \x01edildi!")
	} else {
		g_nbShoww[client] = true;
		g_PanoramaaCookieee.Set(client, "1");
		PrintToChat(client, "[\x10Panorama Timeleft\x01] başarıyla \x04aktif \x01edildi!")
	}
} 