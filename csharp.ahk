#IfWinActive ahk_exe devenv.exe
F2::
	oCB := ClipboardAll  ; save clipboard contents
	Send, ^c
	ClipWait,1

	text := ClipBoard
	Send, ^a
	Send, public class %text% {{}
	Send, {Enter}

	ClipBoard := oCB         ; return original Clipboard contents
return

#IfWinActive
$^s::
	IfWinActive, %A_ScriptFullPath% - Notepad++
	{
	   Send, ^s
	   SplashTextOn,,,Updated script,
	   Sleep,200
	   SplashTextOff
	   Reload
	}
	else
	   Send, ^s
return