;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
;
; Script Function:
;       This Script is a a small tool for working with Regular Expression within Autohotkey
;	    It helps you to evaluate Regular Expression strings before casting them in code
;
;	Version 1.0
;
;**********************************************************
; START 
;**********************************************************

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Menu, Tray, Tip, AHK-RegEx GUI Run with Win+Alt+R ; Tooltip for TrayIcon

SampleInput = 
(
This is RegEx GUI
You can use this tool to evaluate 'Regular Expressions' before You implement them in your Code.

1. Put the text you want to scan (‘Haystack string’) in this field (where this help is shown).
2. If you want to evaluate a match string:
	- Put the search pattern (‘Needle string’) in the Match-string field
	- Then hit Find
	- The length of found string is given above the Found string fild 
	- By hitting 'CutOut' you can delete the found string from haystack
	- By hitting “SetAsNewInput” you can set the matched string as new haystack
3: If you want to evaluate a replace string:
	- Put the search pattern ‘Needle string’ in the Replace-string field
	- Then hit Replace

The Help button shows Autohotkey Regular Expression reference

You can close the window and open it by pressing Win+Alt+R
)

gosub TestRegExReplace
return


#!r::
gosub TestRegExReplace
return 

;**********************************************************
; Generate GUI
;**********************************************************
TestRegExReplace:
	;Gui, [Name:] New [, Options, Title] 
	Gui, Replace: New, 
	Gui Margin, 10,10
	;Gui, font, s10, Consolas
	
	Gui, Font, s11, calibri
	Gui, Add, Text, x0 y0 w100 h20 +Right -TabStop , Match string
	Gui, Font, s9, consolas
	Gui, Add, Edit, x125 yp w500 h20 gUpdateReplaceFilter vRegExMatchDef, .*
	Gui, Font, s11, calibri
	Gui, Add, Text, x0 y25 w100 h20 +Right -TabStop , Replace string
	Gui, Font, s9, consolas
	Gui, Add, Edit, x125 yp w500 h20 gUpdateReplaceFilter vRegExReplaceDef, .*
	
	Gui, Font, s11, calibri
	Gui, Add, Text, x25 yp25 w150 h20 +Left -TabStop , Input string
	Gui, Font, s9, consolas
	Gui, Add, Edit, xp yp25 w750 h400 gUpdateReplaceFilter vRegExInputString, %SampleInput%
	
	Gui, Font, s11, calibri
	Gui, Add, Text, x25 yp425 w150 h20 +Left -TabStop , Found/Replaced string
	Gui, Add, Text, xp175 yp w125 h20 +Left -TabStop vPreviewContentLen, xx characters
	Gui, Font, s9, consolas
	; Erstelle Vorschaufeld
	Gui, Add, Edit, x25 yp25 w750 h400 +ReadOnly +VScroll vPreviewContent, 
	
	; Erstelle Bedienelemente
	Gui, Font, s10, calibri
	Gui, Add, Button, x650 y0 w100 h20 -TabStop, &Find
	Gui, Add, Button, x650 yp25 wp hp -TabStop, &Replace
	Gui, Add, Button, x650 yp25 wp hp -TabStop, &Help
		
	Gui, Add, Button, x400 y500 wp hp -TabStop, &CutOut
	Gui, Add, Button, x600 yp wp hp -TabStop, &SetAsNewInput
	
	; Zeige Menü
	Gui, Show, yCenter, RegEx Test
	return

	;~Enter::
	ReplaceButtonFind:
	UpdateReplaceFilter:
	Gui, Submit, NoHide
	RegExMatch(RegExInputString, RegExMatchDef, RegExOutput)
	GuiControl, , PreviewContent, %RegExOutput%
	tempLen := StrLen(RegExOutput)
	GuiControl, , PreviewContentLen, %tempLen% characters
	return
	
	ReplaceButtonCutOut:
	Gui, Submit, NoHide
	posOfString := RegExMatch(RegExInputString, RegExMatchDef, RegExOutput)
	lenghtOfString := StrLen(RegExOutput)
	tempOut := SubStr(RegExInputString, 1, posOfString-1) . SubStr(RegExInputString, posOfString+lenghtOfString)
	; Funktioniert leider nur in Ausnahmefällen RegExReplace(RegExInputString, RegExOutput, "")
	GuiControl, , RegExInputString, %tempOut%
	return
	
	ReplaceButtonReplace:
	Gui, Submit, NoHide
	tempOut := RegExReplace(RegExInputString, RegExMatchDef, RegExReplaceDef)
	GuiControl, , PreviewContent, %tempOut%
	return
	
	ReplaceButtonHelp:
	ahkHelpFile := "C:\Program Files (x86)\AutoHotkey\AutoHotkey.chm"
	ahkRegExReference := "mk:@MSITStore:C:\Program%20Files%20(x86)\AutoHotkey\AutoHotkey.chm::/docs/misc/RegEx-QuickRef.htm"
	helpFileExe := "C:\Windows\hh.exe"
	IfExist, %ahkHelpFile%
	  Run, %helpFileExe% %ahkRegExReference%
	IfNotExist, %ahkHelpFile%
	  MsgBox, It seems you didn't install Autohotkey on default location. Please fix it in Script
	return
	
	ReplaceButtonSetAsNewInput:
	Gui, Submit, NoHide
	GuiControl, , RegExInputString, %PreviewContent%
	return

	
	ReplaceGuiClose:
	Gui, Destroy
	return
return
