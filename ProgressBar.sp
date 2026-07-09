#pragma newdecls required
#pragma semicolon 1

#include <sdktools>

public Plugin myinfo =
{
	name = "Progress Bar",
	author = "koen",
	description = "Exposes natives for displaying progress bars to players",
	version = ""
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary("ProgressBar");
	CreateNative("ShowProgressBar", Native_ShowProgressBar);
	CreateNative("ResetProgressBar", Native_ResetProgressBar);
	return APLRes_Success;
}

public any Native_ShowProgressBar(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	float duration = GetNativeCell(2);
	SetProgressBar(client, duration);
	return 0;
}

public any Native_ResetProgressBar(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	ResetProgressBar(client);
	return 0;
}

stock void SetProgressBar(int client, float duration)
{
	if (IsValidClient(client))
	{
		int adjustedDuration = RoundToCeil(duration);

		// The maximum duration of the progress bar is 15 seconds
		// So we need to cap that duration
		if (adjustedDuration > 15)
			adjustedDuration = 15;

		SetEntPropFloat(client, Prop_Send, "m_flProgressBarStartTime", GetGameTime());
		SetEntProp(client, Prop_Send, "m_iProgressBarDuration", adjustedDuration);

		// The progress bar does not clear itself after the duration
		// So we need to create a timer to reset the progress bar
		CreateTimer(float(adjustedDuration), Timer_ResetProgressBar, GetClientSerial(client), TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Action Timer_ResetProgressBar(Handle timer, int iSerial)
{
	int client;
	if ((client = GetClientFromSerial(iSerial)) == 0)
		return Plugin_Stop;

	ResetProgressBar(client);
	return Plugin_Stop;
}

stock void ResetProgressBar(int client)
{
	if (IsValidClient(client))
	{
		SetEntPropFloat(client, Prop_Send, "m_flProgressBarStartTime", GetGameTime());
		SetEntProp(client, Prop_Send, "m_iProgressBarDuration", 0);
	}
}

stock bool IsValidClient(int client)
{
	return ((1 <= client <= MaxClients) && IsClientConnected(client) && IsClientInGame(client) && !IsFakeClient(client));
}