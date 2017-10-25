#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Open selected text in Chrome or new Chrome window if no text selected
; hotkey: windows + g, need disabling game bar in windows settings
; TODO: add context(ex: C#) - tricky because unity vs c#
; -----------------------------------------------------------------------------
#g::
	BlockInput, on
	prevClipboard = %clipboard%
	clipboard = 
	SendInput ^c
	BlockInput, off
	ClipWait, 0.1
	if ErrorLevel = 0
	{
		clipboard := UrlEncode(clipboard)
		Run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --incognito "http://www.google.com/search?q=%clipboard%"
	}
	else 
	{
		Run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --incognito
	}
	
	clipboard = %prevClipboard% 
	VarSetCapacity(prevClipboard, 0)
	Return

; Toggle hidden files in Windows Explorer, http://www.autohotkey.com/community/viewtopic.php?t=73186
; -----------------------------------------------------------------------------
<^h::
IfWinActive, ahk_class CabinetWClass
{
	RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden
	If HiddenFiles_Status = 2 
		RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1
	Else 
		RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 2
		
;	WinGetClass, eh_Class,A
;	If (eh_Class = "#32770" OR A_OSVersion = "WIN_VISTA" OR A_OSVersion = "WIN_7")
;		send, {F5}
;	Else PostMessage, 0x111, 28931,,, A
	
	send, {F5}
}
Else SendInput ^h
Return

UrlEncode( String )
{
	OldFormat := A_FormatInteger
	SetFormat, Integer, H

	Loop, Parse, String
	{
		if A_LoopField is alnum
		{
			Out .= A_LoopField
			continue
		}
		Hex := SubStr( Asc( A_LoopField ), 3 )
		Out .= "%" . ( StrLen( Hex ) = 1 ? "0" . Hex : Hex )
	}

	SetFormat, Integer, %OldFormat%

	return Out
}