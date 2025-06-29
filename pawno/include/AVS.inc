/*=================================================*/
/*======== Addressed Variable System v1.0.5 =======*/
/*=============== by  BatisCorleone ===============*/
/*============= Released  : 29.5.2015 =============*/
/*=================================================*/
#define INT 0
#define FLOAT 1
#define STRING 2

new ISaver[MAX_PLAYERS_EX][MAX_USED_INT];
new Float:FSaver[MAX_PLAYERS_EX][MAX_USED_FLOAT];
new SSaver[MAX_PLAYERS_EX][MAX_USED_STRING][(MAX_USED_STRING_LENGTH/2)+2];
new IAddress[MAX_PLAYERS_EX][MAX_USED_INT];
new FAddress[MAX_PLAYERS_EX][MAX_USED_FLOAT];
new SAddress[MAX_PLAYERS_EX][MAX_USED_STRING];
new PLAYER_MAX_USED_VARIABLE_ID[MAX_PLAYERS_EX][3];

stock HashString(s[])
{
    new n1=1,n2=0;
    for (new i=0;i<strlen(s);i++)
    {
       n1 = (n1 + s[i]) % 999;
       n2 = (n2 + n1) % 999;
    }
    return (n2 << 16) + n1;
}

stock GetDigits(n)
{
	new s[12];
	valstr(s,n);
	return strlen(s);
}

stock SetInt(playerid,VName[],i)
{
	new VariableNameAddress = CheckVariableNameAddress(playerid,VName,INT);
	if(VariableNameAddress == -1)
	{
		ISaver[playerid][PLAYER_MAX_USED_VARIABLE_ID[playerid][INT]] = i;
		IAddress[playerid][PLAYER_MAX_USED_VARIABLE_ID[playerid][INT]] = HashString(VName);
		PLAYER_MAX_USED_VARIABLE_ID[playerid][INT]++;
	}
	else
	{
	    ISaver[playerid][VariableNameAddress] = i;
	}
	return 1;
}

stock GetInt(playerid,VName[])
{
	new n = HashString(VName);
	for(new i;i<PLAYER_MAX_USED_VARIABLE_ID[playerid][INT];i++)
	{
	    if(IAddress[playerid][i] == n)
	    {
			return ISaver[playerid][i];
		}
	}
	return 0;
}

stock SetFloat(playerid,VName[],Float:f)
{
	new VariableNameAddress = CheckVariableNameAddress(playerid,VName,FLOAT);
	if(VariableNameAddress == -1)
	{

		FSaver[playerid][PLAYER_MAX_USED_VARIABLE_ID[playerid][FLOAT]] = f;
		FAddress[playerid][PLAYER_MAX_USED_VARIABLE_ID[playerid][FLOAT]] = HashString(VName);
		PLAYER_MAX_USED_VARIABLE_ID[playerid][FLOAT]++;
	}
	else
	{
	    FSaver[playerid][VariableNameAddress] = f;
	}
	return 1;
}

stock Float:GetFloat(playerid,VName[])
{
	new n = HashString(VName);
	for(new i;i<PLAYER_MAX_USED_VARIABLE_ID[playerid][FLOAT];i++)
	{
	    if(FAddress[playerid][i] == n)
	    {
			return FSaver[playerid][i];
		}
	}
	return 0.0;
}
	
stock SetString(playerid,VName[],s[])
{
	new VariableNameAddress = CheckVariableNameAddress(playerid,VName,STRING);
	new Repeatings = strlen(s);
	if(Repeatings % 2 != 0)
	{
 		Repeatings++;
	}
	Repeatings/=2;
	if(VariableNameAddress == -1)
	{
		SAddress[playerid][PLAYER_MAX_USED_VARIABLE_ID[playerid][STRING]] = HashString(VName);
		SSaver[playerid][PLAYER_MAX_USED_VARIABLE_ID[playerid][STRING]][0] = Repeatings;
		for(new s2[12],i=1,j;i<Repeatings+1;i++,j+=2)
		{
 			format(s2,sizeof(s2),"%d%d%d%d",GetDigits(s[j]),GetDigits(s[j+1]),s[j],s[j+1]);
			SSaver[playerid][PLAYER_MAX_USED_VARIABLE_ID[playerid][STRING]][i] = strval(s2);
		}
		PLAYER_MAX_USED_VARIABLE_ID[playerid][STRING]++;
	}
	else
	{
		for(new s2[12],i=1,j;i<Repeatings+1;i++,j+=2)
		{
 			format(s2,sizeof(s2),"%d%d%d%d",GetDigits(s[j]),GetDigits(s[j+1]),s[j],s[j+1]);
			SSaver[playerid][VariableNameAddress][i] = strval(s2);
		}
	}
	return 1;
}

stock GetString(playerid,VName[])
{
	new n = HashString(VName);
	new s[MAX_USED_STRING_LENGTH];
	for(new i;i<PLAYER_MAX_USED_VARIABLE_ID[playerid][STRING];i++)
	{
	    if(SAddress[playerid][i] == n)
	    {
			for(new n1,n2,s2[12],s3[4],j=1;j<SSaver[playerid][i][0]+1;j++)
			{
				valstr(s2,SSaver[playerid][i][j]);
		 		format(s3,sizeof(s3),"%c",s2[0]);
				n1 = strval(s3);
 				format(s3,sizeof(s3),"%c",s2[1]);
		 		n2 = strval(s3);
		 		s3 = "";
		 		for(new k;k<n2;k++)
		 		{
		 		    format(s3,sizeof(s3),"%s%c",s3,s2[2+k+n1]);
				}
				n2 = strval(s3);
                		s3 = "";
		 		for(new k;k<n1;k++)
		 		{
		 		    format(s3,sizeof(s3),"%s%c",s3,s2[2+k]);
				}
				n1 = strval(s3);
				format(s,sizeof(s),"%s%c%c",s,n1,n2);
			}
		}
	}
	return s;
}

stock DeleteVariable(playerid,VName[],VType)
{
	new n = HashString(VName);
	if(VType == INT)
	{
		for(new i;i<PLAYER_MAX_USED_VARIABLE_ID[playerid][INT];i++)
		{
	    	if(IAddress[playerid][i] == n)
	    	{
	        	IAddress[playerid][i] = 0;
	        	ISaver[playerid][i] = 0;
	        	if(i+1 == PLAYER_MAX_USED_VARIABLE_ID[playerid][INT])
	        	{
	        	    PLAYER_MAX_USED_VARIABLE_ID[playerid][INT]--;
				}
				else
				{
				    ShiftVariableAddresses(playerid,i,INT);
				}
			}
		}
	}
	else if(VType == FLOAT)
	{
    	for(new i;i<PLAYER_MAX_USED_VARIABLE_ID[playerid][FLOAT];i++)
		{
	    	if(FAddress[playerid][i] == n)
	    	{
    			FAddress[playerid][i] = 0;
	        	FSaver[playerid][i] = 0;
        		if(i+1 == PLAYER_MAX_USED_VARIABLE_ID[playerid][FLOAT])
	        	{
	        	    PLAYER_MAX_USED_VARIABLE_ID[playerid][FLOAT]--;
				}
				else
				{
				    ShiftVariableAddresses(playerid,i,FLOAT);
				}
			}
		}
	}
	else if(VType == STRING)
	{
    	for(new i;i<PLAYER_MAX_USED_VARIABLE_ID[playerid][STRING];i++)
		{
	    	if(SAddress[playerid][i] == n)
	    	{
     			SAddress[playerid][i] = 0;
	        	for(new j;j<(MAX_USED_STRING_LENGTH/2)+2;j++)
	        	{
	        	    SSaver[playerid][i][j] = 0;
				}
				if(i+1 == PLAYER_MAX_USED_VARIABLE_ID[playerid][STRING])
	        	{
	        	    PLAYER_MAX_USED_VARIABLE_ID[playerid][STRING]--;
				}
				else
				{
				    ShiftVariableAddresses(playerid,i,STRING);
				}
			}
		}
	}
	return 1;
}

stock DeleteAllVariables(playerid)
{
	for(new i;i<PLAYER_MAX_USED_VARIABLE_ID[playerid][INT];i++)
	{
		IAddress[playerid][i] = 0;
		ISaver[playerid][i] = 0;

	}
	for(new i;i<PLAYER_MAX_USED_VARIABLE_ID[playerid][FLOAT];i++)
	{
		FAddress[playerid][i] = 0;
		FSaver[playerid][i] = 0;
	}
	for(new i;i<PLAYER_MAX_USED_VARIABLE_ID[playerid][STRING];i++)
	{
		SAddress[playerid][i] = 0;
		for(new j;j<(MAX_USED_STRING_LENGTH/2)+2;j++)
		{
			SSaver[playerid][i][j] = 0;
	 	}
	}
	PLAYER_MAX_USED_VARIABLE_ID[playerid][INT] = 0;
	PLAYER_MAX_USED_VARIABLE_ID[playerid][FLOAT] = 0;
	PLAYER_MAX_USED_VARIABLE_ID[playerid][STRING] = 0;
	return 1;
}

stock CheckVariableNameAddress(playerid,VName[],VType)
{
	new n = HashString(VName);
	if(VType == INT)
	{
		for(new i;i<PLAYER_MAX_USED_VARIABLE_ID[playerid][VType];i++)
		{
	    	if(IAddress[playerid][i] == n)
	    	{
	        	return i;
			}
		}
	}
	else if(VType == FLOAT)
	{
    	for(new i;i<PLAYER_MAX_USED_VARIABLE_ID[playerid][VType];i++)
		{
	    	if(FAddress[playerid][i] == n)
	    	{
	        	return i;
			}
		}
	}
	else if(VType == STRING)
	{
    	for(new i;i<PLAYER_MAX_USED_VARIABLE_ID[playerid][VType];i++)
		{
	    	if(SAddress[playerid][i] == n)
	    	{
	        	return i;
			}
		}
	}
	return -1;
}

stock ShiftVariableAddresses(playerid,AddressPos,VType)
{
	if(VType == INT)
	{
	    for(new i=AddressPos;i<PLAYER_MAX_USED_VARIABLE_ID[playerid][INT];i++)
	    {
			ISaver[playerid][i] = ISaver[playerid][i+1];
			IAddress[playerid][i] = IAddress[playerid][i+1];
		}
		PLAYER_MAX_USED_VARIABLE_ID[playerid][INT]--;
	}
	else if(VType == FLOAT)
	{
		for(new i=AddressPos;i<PLAYER_MAX_USED_VARIABLE_ID[playerid][FLOAT];i++)
	    {
			FSaver[playerid][i] = FSaver[playerid][i+1];
			FAddress[playerid][i] = FAddress[playerid][i+1];
		}
		PLAYER_MAX_USED_VARIABLE_ID[playerid][FLOAT]--;
	}
	else if(VType == STRING)
	{
		for(new i=AddressPos;i<PLAYER_MAX_USED_VARIABLE_ID[playerid][STRING];i++)
	    {
			SAddress[playerid][i] = SAddress[playerid][i+1];
 			for(new j;j<(MAX_USED_STRING_LENGTH/2)+2;j++)
			{
  				SSaver[playerid][i][j] = SSaver[playerid][i+1][j];
			}
			PLAYER_MAX_USED_VARIABLE_ID[playerid][STRING]--;
		}
	}
	return 1;
}