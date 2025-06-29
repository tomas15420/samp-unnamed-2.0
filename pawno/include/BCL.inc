#if defined _BCL_included
   #endinput
#endif

#define _BCL_included
#pragma library BCL
#pragma tabsize 0

#include <a_samp>

new Text:TextDraw[5];
new text_chat5[255];
new text_chat4[255];
new text_chat3[255];
new text_chat2[255];
new text_chat1[255];

stock AddStringToTextDraw(textchat[255])
{
    	convert_encoding(textchat);
    	TextDrawDiakritika(textchat);
	text_chat5 = text_chat4;
	TextDrawSetString(TextDraw[4], text_chat5);
	text_chat4 = text_chat3;
	TextDrawSetString(TextDraw[3], text_chat4);
	text_chat3 = text_chat2;
	TextDrawSetString(TextDraw[2], text_chat3);
	text_chat2 = text_chat1;
	TextDrawSetString(TextDraw[1], text_chat2);
	text_chat1 = textchat;
	TextDrawSetString(TextDraw[0], text_chat1);
}

stock convert_encoding(string[])
{
	for(new i; i < strlen(string); i ++)
	{
	    if(string[i] == '[') string[i] = '(';
	    if(string[i] == ']') string[i] = ')';
	}
	return 1;
}
