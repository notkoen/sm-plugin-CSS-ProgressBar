#pragma newdecls required
#pragma semicolon 1

#include <ProgressBar>

public Plugin myinfo =
{
	name = "Test Progress Bar",
	author = "",
	description = "Test ProgressBar natives",
	version = "",
	url = ""
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_progressbar", Command_ProgressBar, "Displays progress bar. Usage: sm_progressbar [duration]");
	RegConsoleCmd("sm_resetprogressbar", Command_ResetBar, "Resets progress bar");
}

public Action Command_ProgressBar(int client, int args)
{
	if (!client)
		return Plugin_Handled;

	if (args < 1)
	{
		ShowProgressBar(client, 5.0);
		PrintToChat(client, "[ProgressBar] Displaying progress bar for 5.0 seconds");
		return Plugin_Handled;
	}
	else
	{
		char buffer[4];
		GetCmdArg(1, buffer, sizeof(buffer));
		float duration = StringToFloat(buffer);
		if (duration > 0.0)
		{
			ShowProgressBar(client, duration);
			PrintToChat(client, "[ProgressBar] Displaying progress bar for %.2f seconds", duration);
			return Plugin_Handled;
		}
		else
		{
			PrintToChat(client, "[ProgressBar] Error - Invalid time specified.");
			return Plugin_Handled;
		}
	}
}

public Action Command_ResetBar(int client, int args)
{
	if (!client)
		return Plugin_Handled;
	
	ResetProgressBar(client);
	PrintToChat(client, "[ProgressBar] Resetted your progress bar.");
	return Plugin_Handled;
}