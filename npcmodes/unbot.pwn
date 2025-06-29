#include <a_npc>


//------------------------------------------

public OnRecordingPlaybackEnd()
{
    StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,"unbot");
    return 1;
}

public OnNPCDisconnect(reason[])
{
	printf("NPC Disconnected [reason: %s]",reason);
	return 1;
}
