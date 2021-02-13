/*
 * * * Compile_AHK SETTINGS BEGIN * * *

[AHK2EXE]
Exe_File=%In_Dir%\Live Enhancement Suite.exe
Compression=0
No_UPX=1
Created_Date=1
[VERSION]
Set_Version_Info=1
Company_Name=Inverted Silence & Dylan Tallchief
File_Description=Live Enhancement Suite
File_Version=0.1.3.2
Inc_File_Version=0
Internal_Name=Live Enhancement Suite
Legal_Copyright=© 2019
Original_Filename=Live Enhancement Suite
Product_Name=Live Enhancement Suite
Product_Version=0.1.3.2
[ICONS]
Icon_1=%In_Dir%\resources\blueico.ico
Icon_2=%In_Dir%\resources\blueico.ico
Icon_3=%In_Dir%\resources\redico.ico
Icon_4=%In_Dir%\resources\redico.ico
Icon_5=%In_Dir%\resources\redico.ico

* * * Compile_AHK SETTINGS END * * *
*/

; ^^^^^^^^^^^^^^^^^^
; this stuff up here are settings I use to compile the EXE file; appointing icons.. etc.

; Ok so, just to mentally prepare you: this source code is a complete mess. 
; I only really got into programming while writing this, so there's just dumb stuff happening all over.
; Live Enhancement Suite for windows was my first programming project, and you'll especially be able to see that the sections I wrote first. 
; They are the absolute worst to read.
; My apologies in advance.

; If you want to see organized code, look at the mac rewrite... But this?? nahhhhhhhhhhhhh


;-----------------------------------;
;		   AHK Setup stuff			;
;-----------------------------------;
#MaxThreadsPerHotkey 2

CoordMode, Menu, Screen
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SetTitleMatchMode, Regex
SetWorkingDir %A_ScriptDir%
SetDefaultMouseSpeed, 0
#InstallKeybdHook
#KeyHistory 100
#SingleInstance Force
setmousedelay, -1 
setbatchlines, -1
#UseHook
#MaxHotkeysPerInterval 400

OnExit, exitfunc

;-----------------------------------;
;		  Tray menu contents		;
;-----------------------------------;

;this sets up the tray menu
Menu, Tray, NoStandard
Menu, Tray, Add, Configure Settings, settingsini
Menu, Tray, Add, Configure Menu, menuini
Menu, Tray, Add,
Menu, Tray, Add, Donate 💲, monatpls
Menu, Tray, Add,
Menu, Tray, Add, Strict Time, stricttime
Menu, Tray, Add, Check Project Time 🕒, requesttime
Menu, Tray, Add,
Menu, Tray, Add,
Menu, Tray, Add, Install InsertWhere, InsertWhere
Menu, Tray, Add, Manual 📖, Manual
Menu, Tray, Add, Exit ❌, quitnow
Menu, Tray, Default, Exit ❌
Menu, Tray, insert, 9&, Reload ⟳️, doreload
Menu, Tray, insert, 10&, Pause && Suspend, freeze

Random, randomgen, 1, 13 ;these are the random hover quotes
if (randomgen = 1){
Menu, Tray, Tip, Ableton Live 2: Electric Boogaloo
}
if (randomgen = 2){
Menu, Tray, Tip, Super Live Bros: Lost Levels
}
if (randomgen = 3){
Menu, Tray, Tip, LES is more
}
if (randomgen = 4){
Menu, Tray, Tip, Live HD Audio Manager
}
if (randomgen = 5){
Menu, Tray, Tip, Vitableton Enhancement 100mg [Now with extra vitamin C!]
}
if (randomgen = 6){
Menu, Tray, Tip, hey`, pshh!! hit both shift keys with debug on
}
if (randomgen = 7){
Menu, Tray, Tip, Do more with LES
}
if (randomgen = 8){
Menu, Tray, Tip, *Cowbell*
}
if (randomgen = 9){
Menu, Tray, Tip, OTT.exe
}
if (randomgen = 10){
Menu, Tray, Tip, Live Sweet
}
if (randomgen = 11){
Menu, Tray, Tip, 1`.2`, Yahoo!
}
if (randomgen = 12){
Menu, Tray, Tip, Ableton Gratis Saus
}
if (randomgen = 13){
Menu, Tray, Tip, The biggest thing since sliced bread
}
randomgen := ;

FileRead, stricttxt, %A_ScriptDir%\resources\strict.txt
if(ErrorLevel = 1){
	stricton := 1
}
else{
	stricton := stricttxt
}
if(stricttxt = 1){
Menu, Tray, Check, Strict Time
}

;-----------------------------------;
;		  Installation		;
;-----------------------------------;

; msgbox, % A_ScriptDir

FileReadLine, OutputVar, %A_ScriptDir%/resources/firstrun.txt, 1
;Checks if the first run file exists
;If it doesn't exist; this is the first run, so then do a bunch of initialization stuff.
if (ErrorLevel = 1 or !(OutputVar = 0)){

If !(InStr(FileExist("resources"), "D")){ ;if the resources folder doesn't exist, check if there's other stuff in the current folder, otherwise spawn the text box.
Loop, %A_ScriptDir%\*.*,1,1
If (A_Index > 3)
{
MsgBox,48,Live Enhancement Suite, % "You have placed LES in a directory that contains other files.`n LES will create new files when used for the first time.`n Please move the program to a dedicated directory."
exitapp
}
}

if InStr(splitPath A_ScriptDir, "Windows\Temp") or InStr(splitPath A_ScriptDir, "\AppData\Local\Temp"){
MsgBox,48,Live Enhancement Suite, % "You executed LES from within your file extraction software.`nThis placed it inside of a temporary cache folder, which will cause it to be deleted by Windows' cleanup routine.`nPlease extract LES into its own folder before proceeding."
exitapp
}

if (instr(A_ScriptDir, "C:\Program Files") != 0) or (instr(A_ScriptDir, "C:\Program Files (x86)") != 0){
	MsgBox,4,Live Enhancement Suite, % "You may have executed LES from within a system folder.`nThis may cause LES to not function properly, as it will not have enough permissions to self-extract in this location.`nAre you sure you want to install LES in this location?`nPlease move this foder to another location to remove this warning."
	IfMsgBox No
		{
		exitapp
		}
}

;this part of the code extracts a bunch of resources from the .exe and puts them in the right spot
FileCreateDir, resources

FileInstall, resources/readmejingle.wav, %A_ScriptDir%/resources/readmejingle.wav
FileInstall, resources/piano.png, %A_ScriptDir%/resources/piano.png
FileInstall, resources/piano2.png, %A_ScriptDir%/resources/piano2.png
FileInstall, resources/pianoblack.png, %A_ScriptDir%/resources/pianoblack.png
FileInstall, menuconfig.ini, %A_ScriptDir%/menuconfig.ini
FileInstall, settings.ini, %A_ScriptDir%/settings.ini
FileInstall, CHANGELOG.md, %A_ScriptDir%/CHANGELOG.md

	MsgBox, 4, Live Enhancement Suite, Welcome to the Live Enhancement Suite!`nWould you like to add the Live Enhancement Suite to startup?`nIt won't do anything when you're not using Ableton Live.`n(This can be changed anytime)
	IfMsgBox Yes
		{
		;MsgBox You pressed Yes.
		Loop, Read, %A_ScriptDir%/settings.ini, %A_ScriptDir%/settingstemp.ini
		{
		testforstartup := Instr(A_LoopReadLine, "addtostartup")
		If(testforstartup = 1) {
			FileAppend, addtostartup = 1`n, %A_ScriptDir%/settingstemp.ini
			FileAppend, `;`	causes the script to launch on startup`n, %A_ScriptDir%/settingstemp.ini"
			}
		Else{
			FileAppend, %A_LoopReadLine%`n, %A_ScriptDir%/settingstemp.ini
			}
		}
		goto, donewithintro
		}

	;MsgBox You pressed No.
	Loop, Read, %A_ScriptDir%/settings.ini, %A_ScriptDir%/settingstemp.ini
		{
		testforstartup := Instr(A_LoopReadLine, "addtostartup")
		If(testforstartup = 1) {
			FileAppend, addtostartup = 0`n, %A_ScriptDir%/settingstemp.ini
			FileAppend, `;`	causes the script to launch on startup`n, %A_ScriptDir%/settingstemp.ini"
			}
		Else{
			FileAppend, %A_LoopReadLine%`n, %A_ScriptDir%/settingstemp.ini
			}
		}
	donewithintro: ;this is the goto thats being used when the "intro" is done
	FileDelete,%A_ScriptDir%/resources/firstrun.txt
	FileAppend, 0,%A_ScriptDir%/resources/firstrun.txt
	FileDelete, %A_ScriptDir%/settings.ini
	FileMove, %A_ScriptDir%/settingstemp.ini, %A_ScriptDir%/settings.ini
	Sleep, 50
	settimer, tooltipboi, 1
	Sleep, 2
}
	
FileReadLine, OutputVar, %A_ScriptDir%\resources\firstrun.txt, 2
;msgbox % OutputVar
coolpath := A_ScriptFullPath
if (ErrorLevel = 1 or !(OutputVar = coolpath)){
	;msgbox, adding reg
	FileReadLine, line1, %A_ScriptDir%\resources\firstrun.txt, 1
	;msgbox % line1
	FileReadLine, line2, %A_ScriptDir%\resources\firstrun.txt, 2
	if (Errorlevel = 0)
		{
		RegDelete, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %line2%
		}
	FileDelete, %A_ScriptDir%/resources/firstrun.txt
	FileAppend, %line1%, %A_ScriptDir%/resources/firstrun.txt
	FileAppend, `n%A_ScriptFullPath%,%A_ScriptDir%/resources/firstrun.txt
	RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %A_ScriptFullPath%, ~ HIGHDPIAWARE
}

loop, 1 { ;test if configuration files are present
FileReadLine, OutputVar, settings.ini, 1
if (ErrorLevel = 1){
Msgbox, 4, Oops!, % "the settings.ini file is missing and is required for operation. Create new?"
IfMsgBox Yes
	{
	FileInstall, settings.ini, %A_ScriptDir%/settings.ini
	}
Else{
	exitapp
	}
}
FileReadLine, OutputVar, menuconfig.ini, 1
if (ErrorLevel = 1){
Msgbox, 4, Oops!, % "the menuconfig.ini file is missing and is required for operation. Create new?"
IfMsgBox Yes
	{
	FileInstall, menuconfig.ini, %A_ScriptDir%/menuconfig.ini
	}
Else{
	exitapp
	}
}
Outputvar :=  ;
}

sleep, 10

; updating the changelog.txt file with the one included in the current package
FileDelete, %A_ScriptDir%\CHANGELOG.md
FileDelete, %A_ScriptDir%\changelog.txt
FileInstall, CHANGELOG.md, %A_ScriptDir%\CHANGELOG.md

;-----------------------------------;
;		  reading Settings.ini		;
;-----------------------------------;

; This next loop is the settings.ini "spell checker". As a lot of variables come from this text file.
; It's important that all of them are present in the correct way; otherwise AHK might misbehave or do stupid stuff.
; I didn't really know how to make this work as a function back then so I just copy pasted the different checks for each of the values.
; Contrary to what it looks like, these are not all the same; not every field requires a 1 or a 0
Loop, Read, %A_ScriptDir%\settings.ini
{

	line := StrReplace(A_LoopReadLine, "`r", "")
	line := StrReplace(line, "`n", "")

	if (RegExMatch(line, "autoadd\s=\s") != 0){
	result := StrSplit(line, "=", A_Space)
	if !(result[2] = 0 or result[2] = 1){
		msgbox % "Invalid parameter for " . Chr(34) "autoadd" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
		run, %A_ScriptDir%\settings.ini
		exitapp
		}
	autoadd := result[2]
	}
	
	if (RegExMatch(line, "resetbrowsertobookmark\s=\s") != 0){
	result := StrSplit(line, "=", A_Space)
	if !(result[2] = 0 or result[2] = 1){
		msgbox % "Invalid parameter for " . Chr(34) "resetbrowsertobookmark" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
		run, %A_ScriptDir%\settings.ini
		exitapp
		}
	resetbrowsertobookmark := result[2]
	}
	
	if (RegExMatch(line, "bookmarkx\s=\s") != 0){
	result := StrSplit(line, "=", A_Space)
		if !(RegExReplace(result[2], "[0-9]") = ""){
		msgbox % "Invalid parameter for " . Chr(34) "bookmarkx" . Chr(34) . ": the specified parameter is not a number. The program will shut down now."
		run, %A_ScriptDir%\settings.ini
		exitapp
		}
	bookmarkx := result[2]
	}
	
	if (RegExMatch(line, "bookmarky\s=\s") != 0){
	result := StrSplit(line, "=", A_Space)
		if !(RegExReplace(result[2], "[0-9]") = ""){
		msgbox % "Invalid parameter for " . Chr(34) "bookmarky" . Chr(34) . ": the specified parameter is not a number. The program will shut down now."
		run, %A_ScriptDir%\settings.ini
		exitapp
		}
	bookmarky := result[2]
	}
	
	if (RegExMatch(line, "windowedcompensationpx\s=\s") != 0){
	result := StrSplit(line, "=", A_Space)
		if !(RegExReplace(result[2], "[0-9]") = ""){
		msgbox % "Invalid parameter for " . Chr(34) "windowedcompensationpx" . Chr(34) . ": the specified parameter is not a number. The program will shut down now."
		run, %A_ScriptDir%\settings.ini
		exitapp
		}
	windowedcompensationpx := result[2]
	}
	
	if (RegExMatch(line, "disableloop\s=\s") != 0){
	result := StrSplit(line, "=", A_Space)
	if !(result[2] = 0 or result[2] = 1){
		msgbox % "Invalid parameter for " . Chr(34) "disableloop" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
		run, %A_ScriptDir%\settings.ini
		exitapp
		}
	disableloop := result[2]
	}
	
	if (RegExMatch(line, "saveasnewver\s=\s") != 0){
	result := StrSplit(line, "=", A_Space)
	if !(result[2] = 0 or result[2] = 1){
		msgbox % "Invalid parameter for " . Chr(34) "saveasnewver" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
		run, %A_ScriptDir%\settings.ini
		exitapp
		}
	saveasnewver := result[2]
	}
	
	if (RegExMatch(line, "usectrlaltsinstead\s=\s") != 0){
	result := StrSplit(line, "=", A_Space)
	if !(result[2] = 0 or result[2] = 1){
		msgbox % "Invalid parameter for " . Chr(34) "usectrlaltsinstead" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
		run, %A_ScriptDir%\settings.ini
		exitapp
		}
	usectrlaltsinstead := result[2]
	}
	
	if (RegExMatch(line, "altgrmarker\s=\s") != 0){
	result := StrSplit(line, "=", A_Space)
	if !(result[2] = 0 or result[2] = 1){
		msgbox % "Invalid parameter for " . Chr(34) "altgrmarker" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
		run, %A_ScriptDir%\settings.ini
		exitapp
		}
	altgrmarker := result[2]
	}
	
	if (RegExMatch(line, "middleclicktopan\s=\s") != 0){
	result := StrSplit(line, "=", A_Space)
	if !(result[2] = 0 or result[2] = 1){
		msgbox % "Invalid parameter for " . Chr(34) "middleclicktopan" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
		run, %A_ScriptDir%\settings.ini
		exitapp
		}
	middleclicktopan := result[2]
	}
	
	if (RegExMatch(line, "scrollspeed\s=\s") != 0){
	result := StrSplit(line, "=", A_Space)
	if !(RegExReplace(result[2], "[0-9]") = ""){
		msgbox % "Invalid parameter for " . Chr(34) "scrollspeed" . Chr(34) . ". The specified parameter is not a number. The program will shut down now."
		run, %A_ScriptDir%\settings.ini
		exitapp
		}
	scrollspeed := floor(result[2])
	}
	
	if (RegExMatch(line, "addctrlshiftz\s=\s") != 0){
	result := StrSplit(line, "=", A_Space)
	if !(result[2] = 0 or result[2] = 1){
		msgbox % "Invalid parameter for " . Chr(34) "addctrlshiftz" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
		run, %A_ScriptDir%\settings.ini
		exitapp
		}
	addctrlshiftz := result[2]
	}
	
	if (RegExMatch(line, "0todelete\s=\s") != 0){
	result := StrSplit(line, "=", A_Space)
	if !(result[2] = 0 or result[2] = 1){
		msgbox % "Invalid parameter for " . Chr(34) "0todelete" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
		run, %A_ScriptDir%\settings.ini
		exitapp
		}
	0todelete := result[2]
	}
	
	if (RegExMatch(line, "absolutereplace\s=\s") != 0){
	result := StrSplit(line, "=", A_Space)
	if !(result[2] = 0 or result[2] = 1){
		msgbox % "Invalid parameter for " . Chr(34) "absolutereplace" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
		run, %A_ScriptDir%\settings.ini
		exitapp
		}
	absolutereplace := result[2]
	}
	
	if (RegExMatch(line, "enableclosewindow\s=\s") != 0){
	result := StrSplit(line, "=", A_Space)
	if !(result[2] = 0 or result[2] = 1){
		msgbox % "Invalid parameter for " . Chr(34) "enableclosewindow" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
		run, %A_ScriptDir%\settings.ini
		exitapp
		}
	enableclosewindow := result[2]
	}
	
	if (RegExMatch(line, "vstshortcuts\s=\s") != 0){
	result := StrSplit(line, "=", A_Space)
	if !(result[2] = 0 or result[2] = 1){
		msgbox % "Invalid parameter for " . Chr(34) "vstshortcuts" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
		run, %A_ScriptDir%\settings.ini
		exitapp
		}
	vstshortcuts := result[2]
	}

; depricated feature	

;	if (RegExMatch(line, "superspeedmode\s=\s") != 0){
;	result := StrSplit(line, "=", A_Space)
;	if !(result[2] = 0 or result[2] = 1){
;		msgbox % "Invalid parameter for " . Chr(34) "superspeedmode" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
;		run, %A_ScriptDir%\settings.ini
;		exitapp
;		}
;	superspeedmode := result[2]
;	}
	
	if (RegExMatch(line, "smarticon\s=\s") != 0){
	result := StrSplit(line, "=", A_Space)
	if !(result[2] = 0 or result[2] = 1){
		msgbox % "Invalid parameter for " . Chr(34) "smarticon" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
		run, %A_ScriptDir%\settings.ini
		exitapp
		}
	smarticon := result[2]
	}
	
	if (RegExMatch(line, "dynamicreload\s=\s") != 0){
	result := StrSplit(line, "=", A_Space)
	if !(result[2] = 0 or result[2] = 1){
		msgbox % "Invalid parameter for " . Chr(34) "dynamicreload" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
		run, %A_ScriptDir%\settings.ini
		exitapp
		}
	dynamicreload := result[2]
	}
	
	if (RegExMatch(line, "pianorollmacro\s=\s") != 0){
	result := StrSplit(line, "=", A_Space)
	if ((RegExMatch(line, "SC\d\d") = 0)){
		msgbox % "Invalid parameter for " . Chr(34) "pianorollmacro" . Chr(34) . ". This needs to be a keycode starting with SC. The program will shut down now."
		run, %A_ScriptDir%\settings.ini
		exitapp
		}
	pianorollmacro := result[2]
	}
	
	if (RegExMatch(line, "pianosearch\s=\s") != 0){
	result := StrSplit(line, "=", A_Space)
	if !(result[2] = 0 or result[2] = 1){
		msgbox % "Invalid parameter for " . Chr(34) "pianosearch" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
		run, %A_ScriptDir%\settings.ini
		exitapp
		}
	pianosearch := result[2]
	}
	
	if (RegExMatch(line, "enabledebug\s=\s") != 0){
	result := StrSplit(line, "=", A_Space)
	if !(result[2] = 0 or result[2] = 1){
		msgbox % "Invalid parameter for " . Chr(34) "enabledebug" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
		run, %A_ScriptDir%\settings.ini
		exitapp
		}
	enabledebug := result[2]
	}
	
	if (RegExMatch(line, "addtostartup\s=\s") != 0){
	result := StrSplit(line, "=", A_Space)
	if !(result[2] = 0 or result[2] = 1){
		msgbox % "Invalid parameter for " . Chr(34) "addtostartup" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
		run, %A_ScriptDir%\settings.ini
		exitapp
		}
	addtostartup := result[2]
	}
	
	if (RegExMatch(line, "fliptabfunction\s=\s") != 0){
		result := StrSplit(line, "=", A_Space)
		if !(result[2] = 0 or result[2] = 1){
			msgbox % "Invalid parameter for " . Chr(34) "fliptabfunction" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
			run, %A_ScriptDir%\settings.ini
			exitapp
			}
		fliptabfunction := result[2]
	}
}

; alright, so this section asks the user to update the settings.ini with the one included in the package if some values are missing.
; these are the values I deem "nescesary"
if ((autoadd = "") or (resetbrowsertobookmark = "") or (bookmarkx = "") or (bookmarky = "") or (windowedcompensationpx = "") or (disableloop = "") or (saveasnewver = "") or (usectrlaltsinstead = "")or (usectrlaltsinstead = "") or (middleclicktopan = "") or (addctrlshiftz = "") or (0todelete = "") or (absolutereplace = "") or (smarticon = "") or (pianorollmacro = "") or (pianosearch = "") or (enabledebug = "") or (addtostartup = "")){
gosub, settingsinibad
}

; this section checks for the remaining variables; ones that were added in recent updates or betas. They aren't really nescesary for the program to function.
; In case you're wondering; missing variables default to a "false" response in AHK - so none of the features with missing settings.ini entries will work until you add them to the file.

; I never bothered to make a dynamic settings.ini file updater. Or some UI thing that would make this entire process more convoluted.
; Things like LES 1.2 and 1.3 were never supposed to happen so I didn't account for them - these are the crappy workarounds.

if ((dynamicreload = "") or (altgrmarker = "") or (enableclosewindow = "") or (vstshortcuts = "") or (scrollspeed = "") or (fliptabfunction = ""))
Msgbox, 4, Oops!, % "It seems your settings.ini file is from an older version of LES.`nYou won't be able to use some of the new features added to the settings without restoring your settings.ini file to its default state. It is recommended you make a backup before you do. This won't reset your menu. Reset settings?"
IfMsgBox Yes
	{
	FileDelete, %A_ScriptDir%\settings.ini
	FileInstall, settings.ini, %A_ScriptDir%/settings.ini
	
	MsgBox, 4,Live Enhancement Suite, Would you like to add the Live Enhancement Suite to startup?`n(This can be changed anytime)
	IfMsgBox Yes
		{
		;MsgBox You pressed Yes.
		Loop, Read, %A_ScriptDir%/settings.ini, %A_ScriptDir%/settingstemp.ini
		{
		testforstartup := Instr(A_LoopReadLine, "addtostartup")
		If(testforstartup = 1) {
			FileAppend, addtostartup = 1`n, %A_ScriptDir%/settingstemp.ini
			FileAppend, `;`	causes the script to launch on startup`n, %A_ScriptDir%/settingstemp.ini"
			}
		Else{
			FileAppend, %A_LoopReadLine%`n, %A_ScriptDir%/settingstemp.ini
			}
		}
		goto, donelalalala
		}
		
	;MsgBox You pressed No.
	Loop, Read, %A_ScriptDir%/settings.ini, %A_ScriptDir%/settingstemp.ini
		{
		testforstartup := Instr(A_LoopReadLine, "addtostartup")
		If(testforstartup = 1) {
			FileAppend, addtostartup = 0`n, %A_ScriptDir%/settingstemp.ini
			FileAppend, `;`	causes the script to launch on startup`n, %A_ScriptDir%/settingstemp.ini"
			}
		Else{
			FileAppend, %A_LoopReadLine%`n, %A_ScriptDir%/settingstemp.ini
			}
		}
	donelalalala:
	FileDelete,%A_ScriptDir%/resources/firstrun.txt
	FileAppend, 0,%A_ScriptDir%/resources/firstrun.txt
	FileDelete, %A_ScriptDir%/settings.ini
	FileMove, %A_ScriptDir%/settingstemp.ini, %A_ScriptDir%/settings.ini
	Sleep, 50
	settimer, tooltipboi, 1
	Sleep, 2
	}
	
if (scrollspeed = ""){ ;prevents error from empty variable, in case the user didn't want to reset their settings.ini file during an update
	scrollspeed := 1
}

;-----------------------------------;
;		  Post-settings.ini stuff		;
;-----------------------------------;

if (enabledebug = 1){ ;modifies the tray menu if enabledebug is enabled.
Menu, Tray, Insert, 1&, Key History, listkeys
Menu, Tray, Insert, 2&,
Menu, Tray, Insert, 1&, Log, logstuff
Menu, Tray, Default, Log
}

; speeeeeeeeeeeeeeeeeeeeeeeed
; This used to have a variable setting "superspeedmode", but it was depricated.
; I'm not sure why I haven't moved this to the start of the script.
setmousedelay -1 
setbatchlines -1

loop, 1{ ;adding to startup (or not)
if (addtostartup = 1){
RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run, Live Enhancement Suite, %A_ScriptDir%\%A_ScriptName%
}
if (addtostartup = 0){
RegDelete, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run, Live Enhancement Suite
}
}

SetTimer, watchforopen, 1000
goto hotkeysmain

~$MButton Up::
Critical
	if (activenaw = 1){
		if (middleclicktopan = 1){
			Send {LControl up}{LAlt up}{LButton up}
		}
	}
	else {
		sendinput {blind}{mbutton up}
	}
Return

hotkeysmain:
#IfWinActive ahk_exe Ableton Live.+

;-----------------------------------;
;		  Hotkeys main		;
;-----------------------------------;
loop, 1{ ;creating hotkeys
If (disableloop = 1){
HotKey, ^+m, midiclip
}
HotKey, %pianorollmacro% & ~Lbutton, doubleclick
if (usectrlaltsinstead = 0){
	Hotkey, ^+s, savenewver
	}
Else{
	Hotkey, ^!s, savenewver
	}
Hotkey, !e, envelopemode
if (addctrlshiftz = 1){
Hotkey, ^+z, redo
}
if (0todelete = 1){
Hotkey, ~0, double0delet
}
if (altgrmarker = 0){
Hotkey, RShift & L, quickmarker
}
else{
Hotkey, <^>!L, quickmarker
Hotkey, Ralt & L, quickmarker
}
if (enabledebug = 1){
Hotkey, ~RShift & LShift, cheats
}

Hotkey, !c, colortracks
Hotkey, !x, cleartracks
if (absolutereplace = 1){
Hotkey, ^!v, absolutev
Hotkey, ^!d, absoluted
}
if (enableclosewindow = 1){
Hotkey, ^w, closewindow
Hotkey, ^!w, closeall
}
Hotkey, ^b, buplicate

Hotkey, ^+h, directshyper

if (fliptabfunction = 1) {
	Hotkey, Tab, PianoRoll
	Hotkey, LShift & Tab, SessionView
}

if(vstshortcuts = 1){
	scaling = 1

	; depricated phaseplant VST specific shortcuts - the alt key would stick sometimes and that's really annoying.
	; was mostly a proof of concept anyway
	FileRead, cheatread, %A_ScriptDir%\resources\activecheat.txt
	if(cheatread = "kilohearts"){ ; you can still enable it with a cheat though; for the people who wanna mess around with it.
		Hotkey, ~!a, phaseplanta
		Hotkey, ~!n, phaseplantn
		Hotkey, ~!s, phaseplants
		Hotkey, ~!w, phaseplantw
		Hotkey, ~!d, phaseplantd
		Hotkey, ~!f, phaseplantf
		Hotkey, ~!o, phaseplanto
		Hotkey, ~!l, phaseplantl
	}

	Hotkey, ^z, VSTundo
	Hotkey, ^y, VSTredo
}

}

gosub, createpluginmenu

;-----------------------------------;
;		  Piano menu contents		;
;-----------------------------------;

loop,1 { ;this is where the scale menu is created
FileRead, cheatread, %A_ScriptDir%\resources\activecheat.txt ;these cheats are hidden jokes; don't mind them.
if (cheatread = "jazz"){
Menu, Scales, Add, THE LICK™, thelick
Menu, Chords, Add, THE LICK™, thelick

Menu, Pianomenu, Add, Scales, :Scales
Menu, Pianomenu, Add, Chords, :Chords
goto, skipnormalscales
}
if (cheatread = "blackmidi"){
Menu, AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA, Add, 死, deathmidi
Menu, Pianomenu, Add, AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA, :AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
goto, skipnormalscales
}

; the actual scale menu is built here
Menu, Scales, Add, Major/Ionian, majorscale
Menu, Scales, Add, Natural Minor/Aeolean, minorscale
Menu, Scales, Add,
Menu, Scales, Add, Harmonic Minor, minorscaleh
Menu, Scales, Add, Melodic Minor, minorscalem 
Menu, Scales, Add, Dorian, dorian
Menu, Scales, Add, Phrygian, phrygian
Menu, Scales, Add, Lydian, lydian
Menu, Scales, Add, Mixolydian, mixolydian
Menu, Scales, Add, Locrian, locrian
Menu, Scales, Add,
Menu, Pentatonic Based, Add, Major Pentatonic, majorpentatonic
Menu, Pentatonic Based, Add, Minor Pentatonic, minorpentatonic
Menu, Pentatonic Based, Add, Major Blues, BluesMaj
Menu, Pentatonic Based, Add, Minor Blues, Blues
Menu, World, Add, Gypsy, Gypsy
Menu, World, Add, Minor Gypsy, GypsyM
Menu, World, Add, Arabic/Double Harmonic, Arabic
Menu, World, Add, Hungarian Minor, HungarianM
Menu, World, Add, Pelog, Pelog
Menu, World, Add, Bhairav, Bhairav
Menu, World, Add, Spanish, Spanish
Menu, World, Add,
Menu, World, Add, Hirajōshi, Hirajoshi
Menu, World, Add, In-Sen, Insen
Menu, World, Add, Iwato, Iwato
Menu, World, Add, Kumoi, Kumoi
Menu, Chromatic, Add, Chromatic/Freeform Jazz, chromatic
Menu, Chromatic, Add, Wholetone, wholetone
Menu, Chromatic, Add, Diminished, diminishedscale
Menu, Chromatic, Add, Dominant Bebop, dominantbebop
Menu, Chromatic, Add, Super Locrian, Superlocrian

Menu, Chords, Add, Octaves, octaves
Menu, Chords, Add, Power Chord, pwrchord
Menu, Chords, Add
Menu, Chords, Add, Major, maj
Menu, Chords, Add, Minor, min
Menu, Chords, Add, Maj7, maj7
Menu, Chords, Add, Min7, m7
Menu, Chords, Add, Maj9, maj9
Menu, Chords, Add, Min9, m9
Menu, Chords, Add, 7, dominant7
Menu, Chords, Add, Augmented, aug
Menu, Chords, Add, Diminished, dim
Menu, Chords, Add,
Menu, Chords, Add, Triad (Fold), fold3
Menu, Chords, Add, Seventh (Fold), fold7
Menu, Chords, Add, Ninth (Fold), fold9

Menu, Pianomenu, Add, Scales, :Scales
Menu, Pianomenu, Add, Chords, :Chords
Menu, Scales, Add, Pentatonic Based, :Pentatonic Based
Menu, Scales, Add, World, :World
Menu, Scales, Add, Chromaitc, :Chromatic

skipnormalscales:
}

;-----------------------------------;
;		  Double right click routine		;
;-----------------------------------;

; double right click routine

Loop, 1 {
*~RButton::
tildestate := GetKeyState(pianorollmacro)
if (A_PriorHotkey <> "*~RButton" or A_TimeSincePriorHotkey > 400)
{
    KeyWait, RButton
    return
}

Show()
WinKill, menu launcher
return  ;end of script's auto-execute section.

return  ;end of double right click loop

; the menu show routine; which includes the part of the code that uses imagesearch to detect the piano roll on a certain portion of the screen.
; I singled out just one area on the screen in order to improve performance. 
; Image search is actually faster than pixel search, which is why I use 2x2 pixel .pngs to achieve the same goal.
Show() {
Global pianosearch
Global dynamicreload
Global tildestate
SetTitleMatchMode, 2
WinGetPos, wx, wy, wWidth, wHeight, Ableton Live
coolvar := ((wHeight/3.5) + wy)
coolvar2 := (wHeight - 100 + wy)
coolvar3 := ((wWidth/3.4) + wx)
if (!MX && !MY)
MouseGetPos, MX, MY
if (pianosearch = 1){
	ImageSearch, x1, y1, (wx + 8), coolvar, coolvar3, coolvar2, %A_ScriptDir%\resources\piano.png
	;msgbox,0,ha, % "Top left x[" (wx + 8) "] y[" coolvar "] and then bottom right x[" coolvar3 "] y[" coolvar2 "]"
	if (Errorlevel = 0){
		Imagesearch, a1, b1, x1, (y1 + 5), x1, (y1 + 105), %A_ScriptDir%\resources\pianoblack.png
		if (Errorlevel = 0){
			;mousemove, coolvar3, 500
			Menu, pianomenu, Show, % MX, % MY
			Return
			}
		if (dynamicreload = 1){
			gosub, createpluginmenu
		}
		Menu, ALmenu, Show, % MX, % MY
		Return
	}
	ImageSearch, x1, y1, (wx + 8), coolvar, coolvar3, coolvar2, %A_ScriptDir%\resources\piano2.png
	if (Errorlevel = 0){
		Imagesearch, a1, b1, x1, (y1 + 5), x1, (y1 + 105), %A_ScriptDir%\resources\pianoblack.png
		if (Errorlevel = 0){
			;mousemove, coolvar3, 500
			Menu, pianomenu, Show, % MX, % MY
			Return
			}
		if (dynamicreload = 1){
			gosub, createpluginmenu
		}
		Menu, ALmenu, Show, % MX, % MY
		Return
	}
	Else{
	if (dynamicreload = 1){
		gosub, createpluginmenu
	}
	Menu, ALmenu, Show, % MX, % MY
	}
}

if (pianosearch = 0){
if GetKeyState("LShift") = 0{
		gosub, createpluginmenu
		Menu, ALmenu, Show, % MX, % MY
		}
if GetKeyState("LShift") = 1{
		Menu, pianomenu, show, % MX, % MY
		}
}
}

} ;ends whole loop

Return

;-----------------------------------;
;		  Hotkeys Mouse		;
;-----------------------------------;
; I'm using this syntax here; rather than "Hotkey", because for some reason this works on MX master mice and the "Hotkey" approach does not.
; I'm not sure if I'm doing something wrong but this is probably a bug; AHK pease fix?
; these are after the double right click routine because it ends the auto execute section of the script.
; If they were higher up, the nescesary "Return" would end the auto-execute section of the script early.


; I moved $Mbutton up:: hotkey to the top of the script to be set before the global #ifwinactive marker
; this way you will be able to release the mbutton hotkey even when ableton live is not in focus
; I think this is the cause of the hotkey getting stuck bug (requires some testing)
$MButton::
Critical
	if (middleclicktopan = 1){
		Send {LControl down}{LAlt down}{LButton down}
		keywait, Mbutton
		Send {LControl up}{LAlt up}{LButton up}
	}
Return

$WheelDown::
	MouseGetPos,,,guideUnderCursor
	WinGetTitle, WinTitle, ahk_id %guideUnderCursor%
	if(InStr(WinTitle, "Ableton") != 0){
		SendInput, {WheelDown %scrollspeed%}
	}
	else{
		SendInput, {WheelDown 1}
	}
Return

$WheelUp:: ;selecta
	MouseGetPos,,,guideUnderCursor
	WinGetTitle, WinTitle, ahk_id %guideUnderCursor%
	if(InStr(WinTitle, "Ableton") != 0){
		SendInput, {WheelUp %scrollspeed%}
	}
	Else{
		SendInput, {WheelUp 1}
	}
Return

pause::
^F1::
    Suspend, Permit
	if (A_IsPaused = 1){
		;traytip, "Live Enhancement Suite", "LES is unpaused", 0.1, 16
		Menu, Tray, Rename, Unpause && Unsuspend, Pause && Suspend
	}
	Else{
		;traytip, "Live Enhancement Suite", "LES is paused", 0.1, 16
		Menu, Tray, Rename, Pause && Suspend, Unpause && Unsuspend
	}
    Pause, Toggle, 1
    Suspend, Toggle
Return

;-----------------------------------;
;		  reading menuconfig.ini		;
;-----------------------------------;

; Below here is the function that interprets the stuff inside of the menuconfig.ini file and turns it into a functional autohotkey menu.

; I made up the LES menu syntax improve accessibility. In hindsight I could've done some things better, but it's too late for that now.
; If I ever decide to overhaul this (or if someone else does), I would try to make a converter that can convert people's old configurations into a new syntax, along with the update.
; Seriously, I've seen people add a thousand items. That must take for ever...

createpluginmenu:

; this thing over here clears out all variables and folders from memory before rebuilding to prevent double entries while using dynamic reload.
if (menuitemcount != ""){
	menu, ALmenu, DeleteAll

	Array := ""
	menuitemcount := ""
	querycount := ""
	categoryname := ""
	configoutput := ""
	TestForContent := ""
	slashcount := ""
	counter := ""
	outputcount := ""
	historyi := ""
	table := trimArray(table)
	loop {
		if (historyi = ""){
			historyi := 1
		}
		if (table[historyi] = ""){
			Break
		}
		menu, % table[historyi], DeleteAll
		historyi := historyi + 1
	}
	table := ""
	historyi := ""
}

loop, 1 { ; loop, 1 does nothing. I just used it so I could collapse this section of code inside of notepad++.
table := []
mathvar := ""
Array := Array()
categorydest := Array()
categoryname := Array()
categorydest[1] := "ALmenu"
depth := 1
Loop
	{
	if (mathvar = "") ;if the counter is non existent, make it 1. The counter keeps tracks of the line count. Didn't know you could use 'loop, read' for this until after I was done with it.
		{
		Mathvar := 1
		}
	FileReadLine, configoutput, menuconfig.ini, mathvar
	if (configoutput = ""){ ;checks if string is empty
		goto, skipalles
		}
	TestForcontent := SubStr(configoutput, 1, 1)
	TestForContent := RegExReplace(TestForContent, ";", "ȶ") ; the way I used to check for stuff here is really dumb. Never fixed it because it works. I used these characters because I figured nobody would ever use them.
	If (TestForContent = "ȶ"){ ;checks if line is comment
		goto, skipalles
		}
	TestForcontent := SubStr(configoutput, 1)
	TestForContent := RegExReplace(TestForContent, "Readme", "þ")
	If (TestForContent = "þ"){ ;checks if line is Readme
		Menu, ALmenu, Add, Readme, readme
		goto, skipalles
		}
	TestForContent := SubStr(configoutput, 1)
	TestForContent := RegExReplace(TestForContent, "/nocategory", "ȴ")
	If (TestForContent = "ȴ"){ ;checks if line is /nocategory
		CategoryHeader := 0
		NoCategoryHeader := 1
		goto, skipalles
		}
	TestForContent := SubStr(configoutput, 1)
	TestForContent := RegExReplace(TestForContent, "--", "ȴ")
	If (TestForContent = "ȴ"){ ;checks if line is --
		If (NoCategoryHeader = 1){ ;is the item in or out of a category?
		Menu, ALmenu, Add
		CategoryHeader := 0
		goto, skipalles
		}
		If (CategoryHeader = 1){
		Menu, % categoryname[depth], Add
		}
		Else{
		Menu, ALmenu, Add
		}
		goto, skipalles
		}
	TestForContent := RegExReplace(TestForContent, "—", "ȴ")
	If (TestForContent = "ȴ"){ ;checks if line is --
		If (NoCategoryHeader = 1){ ;is the item in or out of a category?
		Menu, ALmenu, Add
		CategoryHeader := 0
		goto, skipalles
		}
		If (CategoryHeader = 1){
		Menu, % categoryname[depth], Add
		}
		Else{
		Menu, ALmenu, Add
		}
		goto, skipalles
		}
	slashcount := RegExMatch(TestForcontent, "/[^/;]+") 
	if (slashcount > 0){ ; tests if line is category
		depth := slashcount
		categoryname[depth] := SubStr(configoutput, (slashcount + 1))
		if (depth > 1){
			categorydest[depth] := categoryname[(depth - 1)]
			}
		;Msgbox % categoryname[depth] . " and depth = " . depth
		if (historyi = ""){
			historyi := 1
		}
		historyi := (historyi + 1) ; history keeps track of all the subcategory names so they can properly be cleared later.
		table[historyi] := categoryname[depth]

		CategoryHeader := 1
		NoCategoryHeader := 0
		goto, skipalles
	}
	TestForContent := SubStr(configoutput, 1)
	TestForContent := RegExReplace(TestForContent, "\.\.", "ȴ")
	If (TestForContent = "ȴ"){ ;checks if line is ..
		depth := depth - 1
		if (depth = 0){
			depth := 1
			CategoryHeader := 0
			NoCategoryHeader := 1
			}
		goto, skipalles
	}
	If (configoutput = "End" or configoutput = "END" or configoutput = "end"){ ;checks for the end of the config file
		Break
		}
	
	;// Below this line is the stuff that happens when the config is is actually outputting entries and it's not just configuration or empty lines
		{
	if (outputcount = "") ;counting how many times the config has output menu entries
		outputcount := 1
		}
	outputcount := outputcount + 1
	counter := outputcount/2
	if (counter ~= "\.0+?$|^[^\.]$"){	; on titles only
	configoutput := StrReplace(configoutput, "&", "&&") 
	}
	
	Array[mathvar] := configoutput ;putting the output in an array
	
	If (counter ~= "\.0+?$|^[^\.]$"){	; on titles only
		actionname:= RegExReplace(configoutput, "^.*?,")
		
		if (menuitemcount = "") ;counting how many items the config has output
		{
		menuitemcount := 0
		}
		menuitemcount := menuitemcount + 1
		
		If (NoCategoryHeader = 1){
		Menu, ALmenu, Add, % Array[mathvar], % menuitemcount
		CategoryHeader := 0
		}
		If (CategoryHeader = 1){
		Menu, % categoryname[depth], Add, % Array[mathvar], % menuitemcount
		Menu, % categorydest[depth], Add, % categoryname[depth], % ":" . categoryname[depth]
		}
		Else{
		Menu, ALmenu, Add, % Array[mathvar], % menuitemcount
		}
	}
	else{
	if (querycount = "") ;counting in order to figure out if config output is a menu item name or a search query
		{
		querycount := 0
		}
		querycount := querycount + 1
		queryname%querycount% := Array[mathvar]
	}

	skipalles:
	mathvar := mathvar + 1
	}
goto klaar

; Alright, hear me out.
; This right here, is my biggest programming sin.
; I was actually hoping nobody would ever have to see this.
; I'm so sorry

; This "library" below here contains 2000 numerical variables labeled 1 through 2000.
; When you click a menu item in AHK, it will ALWAYS perform a "gosub", which is basically the same as a goto except it can go back to whatever it was doing beforehand once it's done.
; A goto can only go to a label, and AHK does not support dynamic labels.
; I have no idea what people will name their menu entries so I thought of the infamous minecraft item ID system and picked it as a "solution". 
; I printed out a 4000 line AHK script that's nothing but goto markers with two lines of repeated code each.
; None of this code is actually executed unless a menu item is clicked; so I moved it to a library to debloat my code.
; I would be greatful if you could figure out a better way to do this, but right now; I'm going to keep sinning. Sinning hard forever.
#include menuindex.ahk

}
klaar:
Return

;-----------------------------------;
;		  Opening a plugin		;
;-----------------------------------;

openplugin: ;you would think consistently typing something in the ableton search bar would be easy
loop, 1{
Send,{ctrl down}{f}{ctrl up}
Sendinput % queryname
WinWaitActive, ExcludeText - ExcludeTitle, , 0.5 ; prevents the keystrokes from desynchronizing when ableton lags during the search query.


if (pressingalt = 1){
	if (GetKeyState("Lctrl", p) = 0){
	tempautoadd := autoadd
	}
}
if (GetKeyState("Lctrl", p) = 1){
	if (autoadd = 1){
	tempautoadd := 0
	}
	Else{
	tempautoadd := 1
	}
}
Else{
tempautoadd := autoadd
}


If (tempautoadd = 1){
sleep, 112
Send,{down}{enter}
}
Else{
goto, skipautoadd
}
MouseGetPos, posX, posY
If (resetbrowsertobookmark = 1){ ;this is a feature barely anyone uses, but you can have LES click a collection or something after you hit a menu item.
	SetTitleMatchMode, 2
	WinGetPos, wx, wy, wWidth, wHeight, Ableton
	CoordMode, Pixel, Screen
	CoordMode, Mouse, Screen
	PixelGetColor, titlebarcolor, (wx + 10), (wy + 38)
			If (titlebarcolor = "0xFFFFFF") || (titlebarcolor = "0xF2F2F2") || (titlebarcolor = "0x2F2F2F") || (titlebarcolor = "0xFFFFFFFF") || (titlebarcolor = "0xF2F2F2F2") || (titlebarcolor = "0x2F2F2F2F"){
			; the colours are used to detect if live is in fullscreen or in windowed mode.

			;msgbox, titlebar found
			coolclicky := bookmarky + windowedcompensationpx + wy
			coolclickx := bookmarkx + wx
			}
			Else{
			coolclicky := bookmarky + wy
			coolclickx := bookmarkx + wx
			}
	sleep, 1
	Click, %coolclickx%, %coolclicky%, 1
	MouseMove, posX, posY, 0
}
SendInput, {Esc}
SetTitleMatchMode, RegEx

querynameclean := RegExReplace(queryname, "['""]+", "")
StringLower, querynameclean, querynameclean
;msgbox, % querynameclean
if (querynameclean = "analog" or querynameclean = "collision" or querynameclean = "drum rack" or querynameclean = "electric" or querynameclean = "external instrument" or querynameclean = "impulse" or querynameclean = "instrument rack" or querynameclean = "operator" or querynameclean = "sampler" or querynameclean = "simpler" or querynameclean = "tension" or querynameclean = "wavetable" or querynameclean = "amp" or querynameclean = "audio effect rack" or querynameclean = "auto filter" or querynameclean = "auto pan" or querynameclean = "beat repeat" or querynameclean = "cabinet" or querynameclean = "chorus" or querynameclean = "compressor" or querynameclean = "corpus" or querynameclean = "drum buss" or querynameclean = "dynamic tube" or querynameclean = "echo" or querynameclean = "eq eight" or querynameclean = "eq three" or querynameclean = "erosion" or querynameclean = "external audio effect" or querynameclean = "filter delay" or querynameclean = "flanger" or querynameclean = "frequency shifter" or querynameclean = "gate" or querynameclean = "glue compressor" or querynameclean = "grain delay" or querynameclean = "limiter" or querynameclean = "looper" or querynameclean = "multiband dynamics" or querynameclean = "overdrive" or querynameclean = "pedal" or querynameclean = "phaser" or querynameclean = "ping pong delay" or querynameclean = "redux" or querynameclean = "resonators" or querynameclean = "reverb" or querynameclean = "saturator" or querynameclean = "simple delay" or querynameclean = "delay" or querynameclean = "spectrum" or querynameclean = "tuner" or querynameclean = "utility" or querynameclean = "vinyl distortion" or querynameclean = "vocoder" or InStr(querynameclean, ".adv") or InStr(querynameclean, "hybrid reverb") or InStr(querynameclean, "spectral resonator") or InStr(querynameclean, "spectral time")  or InStr(querynameclean, "chorus ensemble") or InStr(querynameclean, "phaser-flanger") != 0){
; I could do this with an array instead but I'm too lazy and this works too so enjoy this 15km 'if' statement
WinWaitActive, ExcludeText - ExcludeTitle, , 0.5
return
}
else{
WinWaitActive, ahk_class (AbletonVstPlugClass|Vst3PlugWindow),,12
WinGetTitle, piss, ahk_class (AbletonVstPlugClass|Vst3PlugWindow)
}
if (piss != "") {
	SetTitleMatchMode, 2
	WinActivate, Ableton
	SendInput, {Esc}
	sleep, 1
	WinActivate, %piss%
	}
Else{
	SetTitleMatchMode, 2
	}
skipautoadd:
piss :=  ;
wTitle :=  ;
wWidth :=  ;
wHeight :=  ;
wx :=  ;
wy :=  ;
}
Return

;-----------------------------------;
;		  Tray menu actions	& Readme	;
;-----------------------------------;

loop, 1 { ; (again, loop, 1 does nothing)

listkeys: ;these are built in AHK GUIs, so this simple command needed to be added to the tray menu as well.
KeyHistory
Return

logstuff:
listlines
Return

settingsini:
run, %A_ScriptDir%\settings.ini
Return

menuini:
run, %A_ScriptDir%\menuconfig.ini
Return

doreload:
FileDelete,%A_ScriptDir%\resources\activecheat.txt
gosub coolfunc
Reload
Return

stricttime: ;this is what happens when you click "strict time"
if (stricton = 0){
stricton := 1
Menu, Tray, Check, Strict Time
FileDelete,%A_ScriptDir%/resources/strict.txt
FileAppend, 1,%A_ScriptDir%/resources/strict.txt


settitlematchmode, regex
if !(WinActive("ahk_exe Ableton Live")){
	SetTimer, Clock, Delete ; deleting a clock that increases the timer when ableton is unfocussed.
}
settitlematchmode, 2

}
Else if (stricton = 1){
stricton := 0
FileDelete,%A_ScriptDir%/resources/strict.txt
FileAppend, 0,%A_ScriptDir%/resources/strict.txt
Menu, Tray, Uncheck, Strict Time
if (WinExist("ahk_exe Ableton Live ") != 0) and (trackname != ""){
	SetTimer, Clock, 1000 ; creating a clock that increases the timer.
}
}
Return

freeze:
if (A_IsPaused = 1){
Menu, Tray, Rename, Unpause && Unsuspend, Pause && Suspend
}
Else{
Menu, Tray, Rename, Pause && Suspend, Unpause && Unsuspend
}

Suspend, Toggle
Pause
Return

InsertWhere:
Msgbox, 4, Live Enhancement Suite, % "InsertWhere is a Max For Live companion device developed by Mat Zo.`nInsertWhere allows you to change the position where plugins are autoinserted after using the LES plugin menu.`nOnce loaded, it will allow you to switch between these settings:`n`n - Autoadd plugins before the one you have selected`n - Autoadd plugins after the the one you have selected`n - Always autoadd plugins at the end of the chain like normal.`n`nTo activate InsertWhere, place a single instance of the device on the master channel in your project and choose your desired setting.`n`nDo you want to install the InsertWhere M4L plugin?"
IfMsgBox Yes
{
	Msgbox, 64, Live Enhancement Suite, % "Please select the location where you want LES to extract the InsertWhere companion plugin.`n`nRecommended: Ableton User Library"
	FileSelectFile, userlibrary, S, C:\Users\%A_UserName%\Documents\Ableton\User Library\InsertWhere.amxd
	if (userlibrary = ""){
		return
	}
	fileinstall, resources\InsertWhere.amxd, %userlibrary%
	Msgbox, 64, Live Enhancement Suite, % "Succes!!`nFor extra ease of use, include InsertWhere in your default template.`n`nFor more information on InsertWhere, visit the documentation website linked under the ""Manual 📖"" button in the tray.`n`nThank you Mat Zo for making this amazing device!"
}

return

manual:
run, https://docs.enhancementsuite.me/
Return

monatpls: ;please gib monat
run, https://paypal.me/enhancementsuite
Return

quitnow:
exitapp
Return
}

; the readme technically isn't a tray menu action, since it's no longer located there. It's now included in the plugin menu to attract more attention.
; the marker is still here though because idk where else to put it.

readme:
SoundPlay, %A_ScriptDir%\resources\readmejingle.wav
MsgBox, 0, Readme, % "Welcome to the Live Enhancement Suite created by @InvertedSilence & @DylanTallchief 🐦`nDouble right click to open up the custom plug-in menu.`nClick on the LES logo in the menu bar to add your own plug-ins, change settings, and read our manual if you're confused.`nHappy producing : )"
Return

;-----------------------------------;
;		  Hotkey actions		;
;-----------------------------------;

midiclip:
Sendinput, {ctrl down}{ShiftDown}{m}{ShiftUp}{ctrl up}
sleep, 1
Sendinput, {ctrl down}{j}{ctrl up}
return

doubleclick:
Click Down
KeyWait, Lbutton
Click Up
if (pressingshit = 1){
	if (GetKeyState("LShift", p) = 0){
	stampselect := ""
	}
}
if (GetKeyState("LShift", p) = 1){
pressingshit := 1
}
Else{
pressingshit := 0
}
if (stampselect != ""){
	gosub, % stampselect
	}
return

savenewver: 
; this section does the ctrl+alt+s command and also includes the section that tries to parse the filename in a way that makes sense.
; I'm not very good at these, but this spaghetti approach works 99% of the time, so it would be ok.
; Ever since LES 1.0, it's gone through many different iterations.
Errorlevel := ""
Sendinput, ^+s
SetTitleMatchMode, 2
WinWaitActive, ahk_class #32770,,2 ;this waits for the save dialog thing to show up.
if (ErrorLevel = 1){
	Return
}
If (saveasnewver = 1){
ClipSaved := ClipboardAll
clipboard =  ;
SendInput, {Ctrl down}{a}{Ctrl up}
SendInput, {Ctrl down}{c}{Ctrl up}
ClipWait  ;
stuff := Clipboard
Clipboard := ClipSaved

if (InStr(Stuff, ".als")){
	Sendinput, {right}
	sendinput, {Backspace 4}
	alsfound := 1
	StringTrimRight, Stuff, Stuff, 4
	}
else {
	alsfound := 0
	}
if (Stuff = "Untitled"){ ;safeguard for if the user is trying to do something really unnescesary
MsgBox, 4, Live Enhancement Suite, Your project name is "Untitled".`nAre you sure you want to save it as a new version?
	IfMsgBox Yes
		{
		goto enduntitledcycle
		}
	Else{
	winclose, ahk_class #32770
	Return
	}
}
enduntitledcycle:
; I don't know if this goto was nescesary or if it was a workaround to fix AHK jank - ...now I'm scared to remove it.

EndPos := InStr(Stuff, "_", 0, 0) -1
Stuff := SubStr(Stuff, (EndPos))

if (InStr(Stuff, "_"))
	{
	testforletterend := (SubStr(stuff, (0), 1))
	;Msgbox % testforletterend
	if testforletterend is alpha
			{
			;StringTrimRight, stuff, stuff, (1)
			;stuff .= "."
			alphacharatend := 1
			;numberstuff := % "_" . numberstuff
			}
	numberstuff := RegExReplace(stuff, "^.*?_")
	numberstuff := RegExReplace(numberstuff, "[^0-9, .]")
	}

else
	{
	Numberstuff =   ;
	goto nounderscore
	}
	
if (extentioncompensation = 0){
StringTrimRight, numberstuff, numberstuff, 1
}
Versionlength := StrLen(numberstuff)
if (alphacharatend = 1)
	{
	Versionlength := Versionlength + 1
	}

nounderscore:
if (numberstuff = "") ; if the string is empty make it 1 and then tell it to skip deletion
	{
	numberstuff := "1"
	skipflag := 1
	}
numberstuff := numberstuff + 1 ; add 1 to the version number
if (RegExMatch(numberstuff, "[., 0{5}]")) ; if theres a dot delete everything until after and including the dot
	{
	SplitPath, numberstuff,,,,numberstuff
	}

if !(InStr(Stuff, "_"))
	{
	;msgbox, yatta
	numberstuff := % "_" . numberstuff
	;msgbox % numberstuff
	}

;If (alsfound = 1){
;Sendinput, {Left 4}
;}
;Else{
Sendinput, {Right 1}
;}

if (skipflag = 1)
	{
	goto skipdel1
	}

sleep, 5
Sendinput, {ShiftDown}{Left %Versionlength%}{ShiftUp}
SendInput, {BackSpace}

sleep, 5
skipdel1:
Sendinput % numberstuff
Sendinput, {Enter}
skipflag := 0
alphacharatend := 0
numberstuff =   ;
stuff =   ;
Return
}
return

envelopemode:
MouseGetPos,,,guideUnderCursor
WinGetTitle, WinTitle, ahk_id %guideUnderCursor%
if(InStr(WinTitle, "Ableton") != 0){
	WinGetPos, wx, wy, wWidth, wHeight, Ableton Live
	MouseGetPos, posX, posY
	coolvar4 := wy + wHeight - 47
	coolvar5 := wx + 54
	loop, 4{
	;pixelgetcolor, coolcolor, (%coolvar5% + 50
	click, %coolvar5%, %coolvar4%
	coolvar4 := coolvar4 - 18
	coolvar5 := coolvar5 + 18
	}
	Mousemove, posX, posY
	wTitle :=  ;
	wWidth :=  ;
	wHeight :=  ;
	wx :=  ;
	wy :=  ;
}
Return

double0delet:
if (A_PriorHotkey <> "~0" or A_TimeSincePriorHotkey > 200)
{
    KeyWait, 0
    return
}
send {delete}
return

redo:
send {ctrl down}{y down}{ctrl up}{y up}
if(vstshortcuts := 1){
gosub, VSTredo
}
Return

quickmarker:
MouseGetPos,,,guideUnderCursor
WinGetTitle, WinTitle, ahk_id %guideUnderCursor%
if (InStr(WinTitle, "Live 9", CaseSensitive := false) != 0){
	WinMenuSelectItem,,, 3&, 13&
}
else if(InStr(WinTitle, "Ableton Live 11") != 0){
	WinMenuSelectItem,,, 3&, 20&
}
else if(InStr(WinTitle, "Ableton") != 0){
	WinMenuSelectItem,,, 3&, 14&
}
return

colortracks:
MouseGetPos,,,guideUnderCursor
WinGetTitle, WinTitle, ahk_id %guideUnderCursor%
if(InStr(WinTitle, "Ableton") != 0){
	Click, Right
	sleep, 20
	SendInput {up 2}
	SendInput {Enter}
}
Return

cleartracks:
MouseGetPos,,,guideUnderCursor
WinGetTitle, WinTitle, ahk_id %guideUnderCursor%
if(InStr(WinTitle, "Ableton Live 11") != 0){
	Click, Right
	sleep, 20
	SendInput {up 9}{enter}
	sleep, 5
	sendinput {delete}
}
else if(InStr(WinTitle, "Ableton")){
	Click, Right
	sleep, 20
	SendInput {down 12}{enter}{delete}
}
Return

absolutev:
MouseGetPos,,,guideUnderCursor
WinGetTitle, WinTitle, ahk_id %guideUnderCursor%
if(InStr(WinTitle, "Ableton") != 0){
	BlockInput, On
	sendinput, {ctrl down}{v}{ctrl up}
	sendinput, {backspace}
	sendinput, {ctrl down}{v}{ctrl up}
	Blockinput, Off
}
Return

absoluted:
MouseGetPos,,,guideUnderCursor
WinGetTitle, WinTitle, ahk_id %guideUnderCursor%
if(InStr(WinTitle, "Ableton") != 0){
	BlockInput, On
	ClipSaved := ClipboardAll
	clipboard =  ;
	send {ctrl down}{c}{ctrl up}
	send {ctrl down}{d}{ctrl up}
	send {backspace}
	send {ctrl down}{v}{ctrl up}
	Clipboard := ClipSaved ; restore clipboard
	Blockinput, Off
}
Return

closewindow:
Winget processnameoutput, ProcessName
WinGetClass classnameoutput
WinGetTitle, wintitleoutput
SetTitleMatchMode, 3
if (RegExMatch(processnameoutput, "Ableton")){
	if (RegExMatch(classnameoutput, "AbletonVstPlugClass") or RegExMatch(classnameoutput, "Vst3PlugWindow")){
		Winclose, %wintitleoutput%
		SetTitleMatchMode, 2
	}
}
return

closeall:
DetectHiddenWindows, Off
WinGet windows, List
SetTitleMatchMode, 3
Loop %windows%
{
	id := windows%A_Index%
	Winget processnameoutput, ProcessName, ahk_id %id%
	WinGetClass classnameoutput, ahk_id %id%
	if (RegExMatch(processnameoutput, "Ableton")){ 
		If (RegExMatch(classnameoutput, "AbletonVstPlugClass") or RegExMatch(classnameoutput, "Vst3PlugWindow")){
		Winclose, ahk_id %id%
		;windowlist .= wt . "`n"
		}
	}
}
;if (enabledebug = 1){
;MsgBox %windowlist%
;}
SetTitleMatchMode, 2
Return

PianoRoll:
MouseGetPos,,,guideUnderCursor
WinGetTitle, WinTitle, ahk_id %guideUnderCursor%
if(InStr(WinTitle, "Ableton") != 0){
	send {LShift down}{Tab}{LShift up}
}
return

SessionView:
MouseGetPos,,,guideUnderCursor
WinGetTitle, WinTitle, ahk_id %guideUnderCursor%
if(InStr(WinTitle, "Ableton") != 0){
	send {Tab}
}
return

;safeautomationopen: ;depricated feature
;if (pressingshit = 1){
;	if (GetKeyState("LShift", p) = 0){
;	}
;}
;if (GetKeyState("LShift", p) = 1){
;pressingshit := 1
;}
;Else{
;pressingshit := 0
;}
;if (pressingshit = 0){
;sendinput, {down}{enter}
;}
;Else{
;sendinput, {down}{down}{enter}
;}
;Return

buplicate: ;brought to you by dylan tallchief
if (A_PriorHotkey != "^b" or A_TimeSincePriorHotkey > 1800 or A_PriorKey = Lbutton)
{
    ; Too much time between presses, so this isn't a double-press.
send {ctrl down}{d 7}{ctrl up}
return
}
send {ctrl down}{d 8}{ctrl up}
return

absolutelynothing:
return

directshyper: ;backup shortcut in case the double right click routine fails someone
Show()
Return

;-----------------------------------;
;		  Plugin specific hotkeys		;
;-----------------------------------;

VSTundo:
if(WinActive("ahk_class AbletonVstPlugClass") or WinActive("ahk_class Vst3PlugWindow")){
	WinGetTitle, wintitleoutput, A
	RegExMatch(wintitleoutput, "FabFilter\sPro-Q\s3|(?=(\/))", piss)
	if (piss = "FabFilter Pro-Q 3") and (scaling = 1){
		MouseGetPos, posX, posY
		WinGetPos, wx, wy, wWidth, wHeight
		quotient := wWidth/wHeight
		if (quotient = "1.967914"){ ;mini
			fraction := 13/30
		}
		if (quotient = "1.569444"){ ;small
			fraction := 12/30
		}
		if (quotient = "1.582038"){ ;medium
			fraction := 12/31
		}
		if (quotient = "1.592760"){ ;large
			fraction := 12/30
		}
		if (quotient = "1.602108"){ ;extra large
			fraction := 12/29
		}
		if (fraction = ""){
			msgbox, % "If you're seeing this, it means that Midas didn't properly think about the way VST plugins deal with scaling at your current display resolution.`nPerhaps you have the plugin (or your OS) set to a custom scaling amount?`nIt is recommended to disable the VST specific shortcuts in the settings.ini if you want to continue to use custom scaling, since they probably won't work right anyway..`n`n this shortcut will temporarily be disabled."
			scaling := 0
			Return
		}
		yea1 := (wx + (wWidth * fraction))
		yea2 := (wy + (windowedcompensationpx*(31/48) + 20))
		Click, %yea1%, %yea2%
		fraction := ""
		yea1 := ""
		yea2 := ""
		mousemove, posX, posY
	}
	
	RegExMatch(wintitleoutput, "Kick\s2|(?=(\/))", piss)
	if (piss = "Kick 2") and (scaling = 1){
		MouseGetPos, posX, posY
		WinGetPos, wx, wy, wWidth, wHeight
		yea1 := (wx + (wWidth / 3.40))
		yea2 := (wy + (windowedcompensationpx*(31/48) + 85))
		Click, %yea1%, %yea2%
		yea1 := ""
		yea2 := ""
		mousemove, posX, posY
		Return
	}
}
sendinput {ctrl down}{z}{ctrl up}
; my own dimension quotients (can be added to later!)
; mini 1.967914
; small 1.569444
; medium 1.582038
; large 1.592760
; extra large 1.602108
Return

VSTredo:
if(WinActive("ahk_class AbletonVstPlugClass") or WinActive("ahk_class Vst3PlugWindow")){
	WinGetTitle, wintitleoutput, A
	RegExMatch(wintitleoutput, "FabFilter\sPro-Q\s3|(?=(\/))", piss)
	if (piss = "FabFilter Pro-Q 3") and (scaling = 1){
		MouseGetPos, posX, posY
		WinGetPos, wx, wy, wWidth, wHeight
		quotient := wWidth/wHeight
		; MsgBox, % quotient
		if (quotient = "1.967914"){ ;mini
			fraction := 14/30
		}
		if (quotient = "1.569444"){ ;small
			fraction := 13/30
		}
		if (quotient = "1.582038"){ ;medium
			fraction := 13/31
		}
		if (quotient = "1.592760"){ ;large
			fraction := 12/28
		}
		if (quotient = "1.602108"){ ;extra large
			fraction := 13/30
		}
		if (fraction = ""){
			msgbox, % "If you're seeing this, it means that Midas didn't properly think about the way Pro-Q deals with scaling at your current display resolution.`nThe command has been disabled to prevent misfired keystrokes.`nPlease contact me on twitter so I can fix the bug!"
			Hotkey, ~^y, VSTredo, Off
			Return
		}
		yea1 := (wx + (wWidth * fraction))
		yea2 := (wy + (windowedcompensationpx*(31/48) + 20))
		Click, %yea1%, %yea2%
		fraction := ""
		yea1 := ""
		yea2 := ""
		mousemove, posX, posY
	}
	
	RegExMatch(wintitleoutput, "Kick\s2|(?=(\/))", piss)
	if (piss = "Kick 2") and (scaling = 1){
		MouseGetPos, posX, posY
		WinGetPos, wx, wy, wWidth, wHeight
		yea1 := (wx + (wWidth / 3.19))
		yea2 := (wy + (windowedcompensationpx*(31/48) + 85))
		Click, %yea1%, %yea2%
		yea1 := ""
		yea2 := ""
		mousemove, posX, posY
		Return
	}
}
sendinput {ctrl down}{y}{ctrl up}
Return

;-----------------------------------;
;	   depricated vst shortcuts		;
;-----------------------------------;

Sylenth:
	MouseGetPos, posX, posY
	WinGetPos, wx, wy, wWidth, wHeight
	yea1 := (wx + (wWidth*10/19))
	yea2 := (wy + (windowedcompensationpx*(31/48) + 20))
	Click, %yea1%, %yea2%, 1
	MouseMove, posX, posY
	yea1 := ""
	yea2 := ""
Return

vst1:
if(WinActive("ahk_class AbletonVstPlugClass") or WinActive("ahk_class Vst3PlugWindow")){
	WinGetTitle, wintitleoutput, A
	RegExMatch(wintitleoutput, "^Serum|(?=(\/))", piss)
	if (piss = "Serum"){
		MouseGetPos, posX, posY
		WinGetPos, wx, wy, wWidth, wHeight
		yea1 := (wx + (wWidth*2/9))
		yea2 := (wy + (windowedcompensationpx*(31/48) + 20))
		Click, %yea1%, %yea2%, 1
		; sleep, 200
		MouseMove, posX, posY
		yea1 := ""
		yea2 := ""
		Return
	}
	RegExMatch(wintitleoutput, "^Sylenth1|(?=(\/))", piss)
	if (piss = "Sylenth1"){
		gosub, Sylenth
		Return
	}
	RegExMatch(wintitleoutput, "^Massive|(?=(\/))", piss)
	if (piss = "Massive"){
		MouseGetPos, posX, posY
		WinGetPos, wx, wy, wWidth, wHeight
		yea1 := (wx + (wWidth*20/958))
		yea2 := (wy + (windowedcompensationpx*(31/48) + (wHeight*72/680)))
		Click, %yea1%, %yea2%, 1
		MouseMove, posX, posY
		yea1 := ""
		yea2 := ""
	}
}
else{
sendinput, {Blind}{1}
}
Return

vst2:
if(WinActive("ahk_class AbletonVstPlugClass") or WinActive("ahk_class Vst3PlugWindow")){
	WinGetTitle, wintitleoutput, A
	RegExMatch(wintitleoutput, "^Serum|(?=(\/))", piss)
	if (piss = "Serum"){
		MouseGetPos, posX, posY
		WinGetPos, wx, wy, wWidth, wHeight
		yea1 := (wx + (wWidth*25/90))
		yea2 := (wy + (windowedcompensationpx*(31/48) + 20))
		Click, %yea1%, %yea2%, 1
		; sleep, 200
		MouseMove, posX, posY
		yea1 := ""
		yea2 := ""
		Return
	}
	RegExMatch(wintitleoutput, "^Sylenth1|(?=(\/))", piss)
	if (piss = "Sylenth1"){
		gosub, Sylenth
		Return
	}
	RegExMatch(wintitleoutput, "^Massive|(?=(\/))", piss)
	if (piss = "Massive"){
		MouseGetPos, posX, posY
		WinGetPos, wx, wy, wWidth, wHeight
		yea1 := (wx + (wWidth*20/958))
		yea2 := (wy + (windowedcompensationpx*(31/48) + (wHeight*186/680)))
		Click, %yea1%, %yea2%, 1
		MouseMove, posX, posY
		yea1 := ""
		yea2 := ""
	}
}
else{
sendinput, {Blind}{2}
}
Return

vst3:
if(WinActive("ahk_class AbletonVstPlugClass") or WinActive("ahk_class Vst3PlugWindow")){
	WinGetTitle, wintitleoutput, A
	RegExMatch(wintitleoutput, "^Serum|(?=(\/))", piss)
	if (piss = "Serum"){
		MouseGetPos, posX, posY
		WinGetPos, wx, wy, wWidth, wHeight
		yea1 := (wx + (wWidth*325/900))
		yea2 := (wy + (windowedcompensationpx*(31/48) + 20))
		Click, %yea1%, %yea2%, 1
		; sleep, 200
		MouseMove, posX, posY
		yea1 := ""
		yea2 := ""
	}
	RegExMatch(wintitleoutput, "^Massive|(?=(\/))", piss)
	if (piss = "Massive"){
		MouseGetPos, posX, posY
		WinGetPos, wx, wy, wWidth, wHeight
		yea1 := (wx + (wWidth*20/958))
		yea2 := (wy + (windowedcompensationpx*(31/48) + (wHeight*300/680)))
		Click, %yea1%, %yea2%, 1
		MouseMove, posX, posY
		yea1 := ""
		yea2 := ""
	}
}
else{
sendinput, {Blind}{3}
}
Return

vst4:
if(WinActive("ahk_class AbletonVstPlugClass") or WinActive("ahk_class Vst3PlugWindow")){
	WinGetTitle, wintitleoutput, A
	RegExMatch(wintitleoutput, "^Serum|(?=(\/))", piss)
	if (piss = "Serum"){
		MouseGetPos, posX, posY
		WinGetPos, wx, wy, wWidth, wHeight
		yea1 := (wx + (wWidth*4/9))
		yea2 := (wy + (windowedcompensationpx*(31/48) + 20))
		Click, %yea1%, %yea2%, 1
		; sleep, 200
		MouseMove, posX, posY
		yea1 := ""
		yea2 := ""
	}
	RegExMatch(wintitleoutput, "^Massive|(?=(\/))", piss)
	if (piss = "Massive"){
		MouseGetPos, posX, posY
		WinGetPos, wx, wy, wWidth, wHeight
		yea1 := (wx + (wWidth*20/958))
		yea2 := (wy + (windowedcompensationpx*(31/48) + (wHeight*420/680)))
		Click, %yea1%, %yea2%, 1
		MouseMove, posX, posY
		yea1 := ""
		yea2 := ""
	}
}
else{
sendinput, {Blind}{4}
}
Return

vst5:
if(WinActive("ahk_class AbletonVstPlugClass") or WinActive("ahk_class Vst3PlugWindow")){
	WinGetTitle, wintitleoutput, A
	RegExMatch(wintitleoutput, "^Massive|(?=(\/))", piss)
	if (piss = "Massive"){
		MouseGetPos, posX, posY
		WinGetPos, wx, wy, wWidth, wHeight
		yea1 := (wx + (wWidth*20/958))
		yea2 := (wy + (windowedcompensationpx*(31/48) + (wHeight*530/680)))
		Click, %yea1%, %yea2%, 1
		MouseMove, posX, posY
		yea1 := ""
		yea2 := ""
	}
}
else{
sendinput, {Blind}{5}
}
Return

phaseplantloadosc:
	MouseGetPos, posX, posY
	WinGetPos, wx, wy, wWidth, wHeight
	if(clickcountmodifier = ""){
		clickcountmodifier = 0
	}
	
	quotient := wWidth/wHeight
	clickcount := Floor((-9 * quotient) + 21)
	
	clickcount := clickcount + clickcountmodifier
	if (clickcount < 5){
		clickcount := 5
	}
	if (noisefix = true){
		clickcount := clickcount + 1
	}
	;msgbox, % "quotient: " quotient "`nclickcount: " clickcount
	
	sweetspot := (wx + (wWidth/2.402))
	topbar := (wy + (wWidth/12.37) + (windowedcompensationpx*(31/48)))
	bottombar := (wy - 5 + (wHeight) - (wWidth/5.43))
	genclickspacing := (bottombar - topbar)/clickcount
	
	MouseMove, sweetspot, (topbar + 30)
	Sendinput {Blind}{WheelDown 600}
	sleep, 3
	Sendinput {Blind}{WheelDown 600}
	sleep, 25
	
	loop, % clickcount {
		if (noisefix = true){
			yea2 := (bottombar + 15 - (A_Index * genclickspacing))
		}
		Else{
			yea2 := (bottombar - (A_Index * genclickspacing))
		}
		Click, %sweetspot%, %yea2%
		sendinput, {right %rightamt%}
		sendinput, {down %downamt%}
		sendinput, {up %upamt%}
		sendinput, {%ppletter%}
		; sleep, 200
		sendinput, {return}
		Sendinput {WheelDown 30}
	}
	
	noisefix := false
	ppletter:= ""
	clickcountmodifier := 0
	MouseMove, posX, posY
Return

phaseplanta:
if(WinActive("ahk_class AbletonVstPlugClass") or WinActive("ahk_class Vst3PlugWindow")){
	WinGetTitle, wintitleoutput, A
	RegExMatch(wintitleoutput, "Phase\sPlant|(?=(\/))", piss)
	if (piss = "Phase Plant"){
		rightamt := 0
		downamt := 1
		upampt := 1
		gosub, phaseplantloadosc
	}
}
Return

phaseplantn:
if(WinActive("ahk_class AbletonVstPlugClass") or WinActive("ahk_class Vst3PlugWindow")){
	WinGetTitle, wintitleoutput, A
	RegExMatch(wintitleoutput, "Phase\sPlant|(?=(\/))", piss)
	if (piss = "Phase Plant"){
		rightamt := 0
		downamt := 2
		upampt := 0
		clickcountmodifier := -2
		
		noisefix := true
		gosub, phaseplantloadosc
	}
}
Return
phaseplants:
if(WinActive("ahk_class AbletonVstPlugClass") or WinActive("ahk_class Vst3PlugWindow")){
	WinGetTitle, wintitleoutput, A
	RegExMatch(wintitleoutput, "Phase\sPlant|(?=(\/))", piss)
	if (piss = "Phase Plant"){
		rightamt := 0
		downamt := 3
		upampt := 0
		gosub, phaseplantloadosc
	}
}
Return
phaseplantw:
if(WinActive("ahk_class AbletonVstPlugClass") or WinActive("ahk_class Vst3PlugWindow")){
	WinGetTitle, wintitleoutput, A
	RegExMatch(wintitleoutput, "Phase\sPlant|(?=(\/))", piss)
	if (piss = "Phase Plant"){
		rightamt := 0
		downamt := 4
		upampt := 0
		gosub, phaseplantloadosc
	}
}
Return
phaseplantd:
if(WinActive("ahk_class AbletonVstPlugClass") or WinActive("ahk_class Vst3PlugWindow")){
	WinGetTitle, wintitleoutput, A
	RegExMatch(wintitleoutput, "Phase\sPlant|(?=(\/))", piss)
	if (piss = "Phase Plant"){
		rightamt := 1
		downamt := 1
		upampt := 0
		gosub, phaseplantloadosc
	}
}
sendinput, {alt up}
Return
phaseplantf:
if(WinActive("ahk_class AbletonVstPlugClass") or WinActive("ahk_class Vst3PlugWindow")){
	WinGetTitle, wintitleoutput, A
	RegExMatch(wintitleoutput, "Phase\sPlant|(?=(\/))", piss)
	if (piss = "Phase Plant"){
		rightamt := 1
		downamt := 2
		upampt := 0
		gosub, phaseplantloadosc
	}
}
Return
phaseplanto:
if(WinActive("ahk_class AbletonVstPlugClass") or WinActive("ahk_class Vst3PlugWindow")){
	WinGetTitle, wintitleoutput, A
	RegExMatch(wintitleoutput, "Phase\sPlant|(?=(\/))", piss)
	if (piss = "Phase Plant"){
		rightamt := 3
		downamt := 10
		upampt := 0
		ppletter:= "o"
		gosub, phaseplantloadosc
	}
}
Return

phaseplantloadmod:
	MouseGetPos, posX, posY
	WinGetPos, wx, wy, wWidth, wHeight
	clickcount := 6
	sweetspot := (wx + wWidth - (wWidth/19))
	bottombar := (wy - 5 + (wHeight) - (wWidth/7.79))
	modclickspacing := (sweetspot - wx - 30)/clickcount
	
	MouseMove, sweetspot, bottombar
	Sendinput {WheelDown 600}
	sleep, 3
	Sendinput {WheelDown 600}
	sleep, 25
	
	loop, % clickcount {
		yea2 := (sweetspot - (A_Index * modclickspacing))
		Click, %yea2%, %bottombar%
		mousemove, 1, 3, 0, R
		; sleep, 100
		; msgbox, % downamt
		sendinput, {down %downamt%}
		sendinput, {right %rightamt%}
		sendinput, {down %downamt2%}
		Sendinput {Return}
		Sendinput {WheelDown 10}
		; sleep, 200
	}
	mousemove, posX, posY
Return

phaseplantl:
if(WinActive("ahk_class AbletonVstPlugClass") or WinActive("ahk_class Vst3PlugWindow")){
	WinGetTitle, wintitleoutput, A
	RegExMatch(wintitleoutput, "Phase\sPlant|(?=(\/))", piss)
	if (piss = "Phase Plant"){
		downamt := 1
		rightamt := 0
		downamt2 := 0
		gosub, phaseplantloadmod
	}
}
Return

;-----------------------------------;
;		  Cheats/Jokes		;
;-----------------------------------;

cheats:
InputBox, enteredcheat, A mysterious aura surrounds you..., Enter cheat:,,375,140
FileDelete, %A_ScriptDir%/resources/activecheat.txt
StringLower, enteredcheat, enteredcheat
if (enteredcheat = "gaster"){
exitapp
}
if (enteredcheat = "jazz"){
FileAppend,jazz,%A_ScriptDir%/resources/activecheat.txt
msgbox % "pianoroll cheat activated"
}
if (enteredcheat = "blackmidi" or enteredcheat = "black midi"){
FileAppend,blackmidi,%A_ScriptDir%/resources/activecheat.txt
msgbox % "pianoroll cheat activated"
}
if (enteredcheat = "subscribe to dylan tallchief" or enteredcheat = "#dylongang" or enteredcheat = "dylan tallchief" or enteredcheat = "dylantallchief"){
run, https://www.youtube.com/c/DylanTallchief?sub_confirmation=1
}
if (enteredcheat = "303" or enteredcheat = "sylenth"){
FileInstall, resources/arp303.mp3, %A_ScriptDir%/resources/arp303.mp3
SoundPlay, %A_ScriptDir%\resources\arp303.mp3, wait
FileDelete, %A_ScriptDir%\resources\arp303.mp3
msgbox, thank you for trying this demo
}
if (enteredcheat = "live enhancement sweet" or enteredcheat = "les" or enteredcheat = "sweet"){
FileInstall, resources/LES_vox.wav, %A_ScriptDir%/resources/LES_vox.wav
SoundPlay, %A_ScriptDir%\resources\LES_vox.wav, wait
FileDelete, %A_ScriptDir%\resources\LES_vox.wav
}
if (enteredcheat = "fl studio" or enteredcheat = "image line"){
FileInstall, resources/flstudio.mp3, %A_ScriptDir%/resources/flstudio.mp3
SoundPlay, %A_ScriptDir%\resources\flstudio.mp3, wait
FileDelete, %A_ScriptDir%\resources\flstudio.mp3
}
if (enteredcheat = "ghost" or enteredcheat = "ilwag" enteredcheat = "lvghst"){
FileInstall, resources/lvghst.mp3, %A_ScriptDir%/resources/lvghst.mp3
SoundPlay, %A_ScriptDir%\resources\lvghst.mp3, wait
FileDelete, %A_ScriptDir%\resources\lvghst.mp3
}
if (enteredcheat = "twitter" or enteredcheat = "yo twitter"){
FileInstall, resources/yotwitter.mp3, %A_ScriptDir%/resources/yotwitter.mp3
SoundPlay, %A_ScriptDir%\resources\yotwitter.mp3, wait
FileDelete, %A_ScriptDir%\resources\yotwitter.mp3
run, https://twitter.com/aevitunes
run, https://twitter.com/sylvianyeah
run, https://twitter.com/DylanTallchief
run, https://twitter.com/nyteout
run, https://twitter.com/InvertedSilence
run, https://twitter.com/FalseProdigyUS
}
if (enteredcheat = "bad time" or enteredcheat = "sans" or enteredcheat = "undertale"){
SoundBeep, 589, 94
sleep 31
SoundBeep, 589, 94
sleep 31
SoundBeep, 1180, 94
sleep 156
SoundBeep, 885, 94
sleep 281
SoundBeep, 841, 94
sleep 156
SoundBeep, 787, 94
sleep 156
SoundBeep, 689, 118
Sleep 100
SoundBeep, 598, 94
sleep 31
SoundBeep, 698, 94
sleep 31
SoundBeep, 787, 94
Sleep 400
}
if (enteredcheat = "beta" or enteredcheat = "testers" or enteredcheat = "credits" ){
Msgbox,,thank you :), % "My eternal gratitude goes to the following people for helping me improve LES over the course of its development:`n`nFalse Prodigy`nDirect`nAevin`nReach`nAzles`nFrection`nMr. Bill`nSamuel Robinson`nViticz`nNyteout"
}
if (enteredcheat = "owo" or enteredcheat = "uwu" or enteredcheat = "what's this" or enteredcheat = "what" ){
Msgbox,,owowowowoowoowowowoo, % "what's this????????? ^^ nya?"
}
if (enteredcheat = "als" or enteredcheat = "adg" or enteredcheat = "collab bro" ){
MsgBox, 4,Live Enhancement suite, Doing this will exit your current project without saving. Are you sure?
	IfMsgBox Yes
	{
		gosub coolfunc
		SetTitleMatchMode, 2
		WinClose, Ableton Live
		sendinput, {Shift down}{n}{shift up}
		sleep, 20
		FileCreateDir, resources\als Lessons
		FileInstall, resources\als Lessons\LessonsEN.txt, %A_ScriptDir%\resources\als Lessons\LessonsEN.txt
		FileInstall, resources\als.als, %A_ScriptDir%\resources\als.als
		WinWaitClose , Ableton Live
		Run, %A_ScriptDir%\resources\als.als
		sleep 10000
		Reload
		exitapp
	}
	Else{
		gosub coolfunc
		Reload
	}
}
if (enteredcheat = "kilohearts"){
FileAppend,kilohearts,%A_ScriptDir%/resources/activecheat.txt
msgbox % "phaseplant shortcuts activated"
	Hotkey, ~!a, phaseplanta
	Hotkey, ~!n, phaseplantn
	Hotkey, ~!s, phaseplants
	Hotkey, ~!w, phaseplantw
	Hotkey, ~!d, phaseplantd
	Hotkey, ~!f, phaseplantf
	Hotkey, ~!o, phaseplanto
	Hotkey, ~!l, phaseplantl
}
return

settingsinibad:
Msgbox, 4, Oops!, % "The settings.ini file is outdated or invalid and is required for operation. reset?`n(Make sure to make a copy of the old one before you click yes!)"
IfMsgBox Yes
	{
	FileDelete, %A_ScriptDir%\settings.ini
	FileInstall, settings.ini, %A_ScriptDir%/settings.ini
	}
Else{
	Msgbox, The program will shut down now.
	exitapp
	}
Return

;-----------------------------------;
;		  Timers/Clocks		;
;-----------------------------------;

watchforclose:
activenaw := 1
SetTitleMatchMode RegEx
if (WinActive(ahk_exe "Ableton\sLive.+") = 0){
;msgbox, ableton is now offline
    if (smarticon = 1){
    Menu, Tray, NoIcon
    }
	; Send {LControl up}{LAlt up}{LButton up}
    SetTimer, watchforopen, 1000
    if (stricton = 1){
		SetTimer, Clock, Delete
    }
    SetTimer, watchforclose, Delete
}
Return

watchforopen:
activenaw := 0
SetTitleMatchMode RegEx
if (WinActive(ahk_exe "Ableton\sLive.+") != 0){
;msgbox, ableton is online
    if (smarticon = 1){
    Menu, Tray, Icon
    }
    SetTimer, watchforclose, 1000
    SetTimer, Clock, 1000
    SetTimer, watchforopen, Delete
}
Return

coolfunc:
	;msgbox, % "coolfunc"
	if (trackname != ""){
		oldtrackname := trackname
		FileCreateDir, %A_ScriptDir%\resources\time\

		FileReadLine, OutputVar, %A_ScriptDir%\resources\time\%oldtrackname%_time.txt, 1
		if !(ErrorLevel = 1){
			;msgbox, % "file exists"
			FileDelete, %A_ScriptDir%\resources\time\%oldtrackname%_time.txt
			}
		FileAppend, % timer_%trackname%, %A_ScriptDir%\resources\time\%oldtrackname%_time.txt
	}

	trackname := ""
	DetectHiddenWindows, Off
	windows := ;
	WinGet windows, List
	Loop %windows% {
		id := windows%A_Index%
		WinGetTitle wt, ahk_id %id%
		if (RegExMatch(wt, "- Ableton Live ") != 0){
			mainwindowtitle := wt
			if (RegExMatch(wt, "\[") != 0 && RegExMatch(wt, "\[") != "" ){
				trackname := RegExReplace(wt, "([^\[]+)\[", "")
				trackname := RegExReplace(trackname, "\]\s\-\s([^\]]+)$", "")
				trackname := RegExReplace(trackname, "[\W_]+", "_")
			}
			else {
				trackname := "unsaved_project"
			}
		}
	}
	if (trackname = ""){
		Return
	}
	
	FileReadLine, OutputVar, %A_ScriptDir%\resources\time\%trackname%_time.txt, 1
	if !(ErrorLevel = 1){
		timer_%trackname% := OutputVar
	}
	else {
		return
	}
return

Clock:
	if (trackname = ""){
		gosub coolfunc
	}
	SetTitleMatchMode, 2
	if (trackname = "unsaved_project"){
		if (WinExist("] - Ableton Live ")){
			;Msgbox, % "track title changed! 1"
			gosub coolfunc
		}
	}
	else if !(WinExist("[" trackname "] - Ableton Live ")){
		;MsgBox, % "track title changed! 2"
		gosub coolfunc
	}

	if (timer_%trackname% = ""){
	timer_%trackname% := 0
	}
	timer_%trackname% := timer_%trackname% + 1
Return

requesttime:
	gosub coolfunc
	if (trackname = ""){
		MsgBox,48,Live Enhancement Suite, % "There was no open project detected.`nPlease open or focus Live and try again."
		Return
	}
	currenttime := ""

	if (timer_%trackname% = 0 or timer_%trackname% = ""){
		currenttime := "0 hours, 0 minutes, and 0 seconds"
	}
	else {
		hh := floor(timer_%trackname%/3600)
		mm := floor(timer_%trackname%/60 - (hh*60))
		ss := floor(timer_%trackname% - (hh*3600) - (mm*60))
		if (hh = 1){
			hhh := "hour"
		}
		Else{
			hhh := "hours"
		}
		if (mm = 1){
			mmm := "minute"
		}
		Else{
			mmm := "minutes"
		}
		currenttime := hh " " hhh ", " mm " " mmm ", and " ss " seconds"
	}

	if (trackname = "unsaved_project"){
		customboxtext := "The total time you've spent in unsaved projects is`n"
	}
	else {
		tracknamepretty := RegExReplace(trackname, "[\__]+", " ")
		customboxtext := "the total time you've spent in the [" tracknamepretty "] project is`n" 
	}

	Gui timemenu:+LastFoundExist
	IfWinExist
	{
		Gui timemenu: Destroy
	}

	Gui timemenu: -MaximizeBox -MinimizeBox +ToolWindow
	Gui timemenu: Font, Q5
	space = y+2
	Gui timemenu: Add, Text, x20 y30 vMyText Right, % customboxtext
	Gui timemenu: Add, Text, x20 %space% vMyText1, % currenttime "."
	Gui timemenu: Add, Button, x280 y75 w80 gInfo, Reset Time
	Gui timemenu: Add, Button, x+15 w80 gName default, Ok 
	Gui timemenu: Show, Restore w470 h110, Live Enhancement Suite , Time
	Return

	Info:
		Gui timemenu: Destroy
	  MsgBox, 4, Live Enhancement Suite, Are you sure?
	  IfMsgBox Yes
	  {
	  	timer_%trackname% := ""
	  	FileReadLine, OutputVar, %A_ScriptDir%\resources\time\%trackname%_time.txt, 1
			if !(ErrorLevel = 1){
				FileDelete, %A_ScriptDir%\resources\time\%oldtrackname%_time.txt
			}
	  }
	Return

	GuiClose:
	GuiEscape:
	Gui timemenu: Destroy
	Return

	Name:
	  Gui timemenu: Destroy
	Return

Return

checkshift:
if (pressingshit = 1){
	if (GetKeyState("LShift", p) = 0){
	stampselect := ""
	}
}
if (GetKeyState("LShift", p) = 1){
pressingshit := 1
}
Else{
pressingshit := 0
}
Return

tooltipboi:
SetTitleMatchMode, 2
WinWaitActive, Ableton
winget, ProcessID, PID, A
if !(hProcess := DllCall("OpenProcess", "uint", 0x0400, "int", 0, "uint", ProcessID, "ptr")){
    MsgBox, 0, Live Enhancement Suite Admin Warning, % "Hey there!`n`nIt seems you're running Ableton Live as an Administrator, and this might prevent LES from doing anything. Please run Ableton Live without elevated permissions (since it allows you to import files from your desktop etc).`nIf you have a good reason to run Ableton Live as an Admin, please run LES as an Administrator as well, this way things will work as intended.`n`n(This notification will only show up once)"
}
Traytip, Live Enhancement Suite, Double right click anywhere in Live to bring up custom menus!, 5
SetTimer, tooltipboi, Delete
Return

exitfunc:
gosub coolfunc
FileDelete,%A_ScriptDir%\resources\activecheat.txt
exitapp
Return

;-----------------------------------;
;		  Scales		;
;-----------------------------------;

majorscale:
stampselect := "majorscale2"
Return
majorscale2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
Return

minorscale:
stampselect := "minorscale2"
Return
minorscale2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

minorscaleh:
stampselect := "minorscaleh2"
Return
minorscaleh2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

minorscalem:
stampselect := "minorscalem2"
Return
minorscalem2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

dorian:
stampselect := "dorian2"
Return
dorian2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

phrygian:
stampselect := "phrygian2"
Return
phrygian2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

lydian:
stampselect := "lydian2"
Return
lydian2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

mixolydian:
stampselect := "mixolydian2"
Return
mixolydian2:
clipboardrescue := ClipboardAll
if(GetKeyState("LShift") = 0){
stampselect := ""
}

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

locrian:
stampselect := "locrian2"
Return
locrian2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

Blues:
stampselect := "Blues2"
Return
Blues2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

BluesMaj:
stampselect := "BluesMaj2"
Return
BluesMaj2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

Arabic:
stampselect := "Arabic2"
Return
Arabic2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

Gypsy:
stampselect := "Gypsy2"
Return
Gypsy2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
Return

Diminishedscale:
stampselect := "Diminishedscale2"
Return
Diminishedscale2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

Dominantbebop:
stampselect := "Dominantbebop2"
Return
Dominantbebop2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

Wholetone:
stampselect := "Wholetone2"
Return
Wholetone2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

chromatic:
stampselect := "chromatic2"
Return
chromatic2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

Majorpentatonic:
stampselect := "Majorpentatonic2"
Return
Majorpentatonic2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

Minorpentatonic:
stampselect := "Minorpentatonic2"
Return
Minorpentatonic2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

; -- Ableton push scales

Superlocrian:
stampselect := "Superlocrian2"
Return
Superlocrian2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

Bhairav:
stampselect := "Bhairav2"
Return
Bhairav2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

HungarianM:
stampselect := "HungarianM2"
Return
HungarianM2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

GypsyM:
stampselect := "GypsyM2"
Return
GypsyM2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

Hirajoshi:
stampselect := "Hirajoshi2"
Return
Hirajoshi2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 4}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

Insen:
stampselect := "Insen2"
Return
Insen2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 4}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

Iwato:
stampselect := "Iwato2"
Return
Iwato2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 4}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 4}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

Kumoi:
stampselect := "Kumoi2"
Return
Kumoi2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 4}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

Pelog:
stampselect := "Pelog2"
Return
Pelog2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

Spanish:
stampselect := "Spanish2"
Return
Spanish2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return


;    //////            chords             //////

octaves:
stampselect := "octaves2"
Return
octaves2:
clipboardrescue := ClipboardAll
;
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 12}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

pwrchord:
stampselect := "pwrchord2"
Return
pwrchord2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 7}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

maj:
stampselect := "maj2"
Return
maj2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 4}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

min:
stampselect := "min2"
Return
min2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 4}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

aug:
stampselect := "aug2"
Return
aug2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 4}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 4}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

dim:
stampselect := "dim2"
Return
dim2:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

maj7:
stampselect := "maj72"
Return
maj72:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 4}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 4}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

m7:
stampselect := "m72"
Return
m72:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 4}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

dominant7:
stampselect := "dominant72"
Return
dominant72:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 4}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

m9:
stampselect := "m92"
Return
m92:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 4}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 4}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

maj9:
stampselect := "maj92"
Return
maj92:
clipboardrescue := ClipboardAll

Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 4}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 4}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 3}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return 

fold3:
stampselect := "fold32"
Return
fold32:
clipboardrescue := ClipboardAll
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

fold7:
stampselect := "fold72"
Return
fold72:
clipboardrescue := ClipboardAll
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

fold9:
stampselect := "fold92"
Return
fold92:
clipboardrescue := ClipboardAll
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

thelick:
stampselect := "thelick2"
Return
clipboardrescue := ClipboardAll
thelick2:
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}{right 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}{right 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}{right 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{down 3}{right 1}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{down 4}{right 2}
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 2}{right 1}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

deathmidi:
stampselect := "deathmidi2"
Return
clipboardrescue := ClipboardAll
deathmidi2:
loop, 128{
Sendinput, {Ctrl Down}{c}{Ctrl Up}{Ctrl Down}{v}{Ctrl Up}{up 1}
}
loop, 10{
sleep, 500
Sendinput, {Ctrl Down}{a}{Ctrl Up}
Sendinput, {Ctrl Down}{d}{Ctrl Up}
}
if(pressingshit = 0){
stampselect := ""
}
Clipboard := clipboardrescue
clipboardrescue =   ;
return

;==========================
;=	 imported functions   =
;==========================

trimArray(arr) { ; Hash O(n)  https://stackoverflow.com/questions/46432447/how-do-i-remove-duplicates-from-an-autohotkey-array

    hash := {}, newArr := []

    for e, v in arr
        if (!hash[v])
            hash[(v)] := 1, newArr.push(v)

    return newArr
}
