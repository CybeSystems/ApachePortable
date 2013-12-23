#NoTrayIcon
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=App/AppInfo/appicon.ico
#AutoIt3Wrapper_UseUpx=N
#AutoIt3Wrapper_Res_Description=CybeSystems
#AutoIt3Wrapper_Res_Fileversion=0.8.0.0
#AutoIt3Wrapper_Res_ProductVersion=0.8
#AutoIt3Wrapper_Res_LegalCopyright=Thiemo Borger
#AutoIt3Wrapper_Res_Language=1031
#AutoIt3Wrapper_Res_Icon_Add=other/resources/plus.ico
#AutoIt3Wrapper_Res_Icon_Add=other/resources/view_refresh.ico
#AutoIt3Wrapper_Res_Icon_Add=other/resources/window_close.ico
#AutoIt3Wrapper_Res_Icon_Add=other/resources/preferences_desktop_display.ico
#AutoIt3Wrapper_Res_Icon_Add=other/resources/applications_development.ico
#AutoIt3Wrapper_Res_Icon_Add=other/resources/help_about.ico
#AutoIt3Wrapper_Res_Icon_Add=other/resources/messagebox_info.ico
#AutoIt3Wrapper_Res_Icon_Add=other/resources/network.ico
#AutoIt3Wrapper_Res_Icon_Add=other/resources/system_log_out.ico
#AutoIt3Wrapper_Res_Icon_Add=other/resources/package_utilities.ico
#AutoIt3Wrapper_Res_File_Add=other/resources/cs_sidebar.bmp, rt_bitmap, CYBETECH_SIDEBAR
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#region AutoIt3Wrapper directives section
;===============================================================================================================
;** AUTOIT3 settings
#AutoIt3Wrapper_Run_Debug_Mode=n                ;(Y/N)Run Script with console debugging. Default=N
;===============================================================================================================
;** AUT2EXE settings
;===============================================================================================================
;** Target program Resource info
;===============================================================================================================
; Obfuscator
;===============================================================================================================
#endregion AutoIt3Wrapper directives section

#include <File.au3>
#include <Array.au3>
#include <Process.au3>
#include "other\resources\resources.au3"
#include "other\resources\_ModernMenuRaw.au3"
#include "other\resources\_SysTray.au3"
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <TabConstants.au3>
#include <StaticConstants.au3>
#include <Misc.au3>
#include "other\resources\7Zip.au3"
#include "other\resources\_InetGetGUI.au3"

Global $XamppMirror, $XamppFileName, $ApacheFirstInstallDeleteUnneeded, $ApacheFirstInstallDeleteUnneededFiles, $WindowsPathToApache, $XamppDeleteUneededFolders, $XamppUneededFolders, $ApachePort, $ApacheEnableSSL, $ApacheSSLPort

$AppDir = @ScriptDir & "\App\Apache2"
$OtherDir = @ScriptDir & "\Other"
$BackupDir = $OtherDir & "\Backup"
$TempDir = $OtherDir & "\Temp"

$CYBESYSTEMSPATH = "$CYBESYSTEMSPATH"
$CYBESYSTEMSPARENTPATH = "$CYBESYSTEMSPARENTPATH"
$CYBESYSTEMSSSLPORT = "$CYBESYSTEMSSSLPORT"
$CYBESYSTEMSPORT = "$CYBESYSTEMSPORT"
$CYBESYSTEMSSSLPORT = "$CYBESYSTEMSSSLPORT"
$CYBESYSTEMSENABLESSL = "$CYBESYSTEMSENABLESSL"

$ApacheAppDir = StringReplace($AppDir, "\", "/")
$ApacheDataDir = StringReplace(@ScriptDir & "\Data", "\", "/")

Local $iniMain = IniReadSection(@ScriptDir & "\Apache2.ini", "Special")
Local $iniFile = @ScriptDir & "\Apache2.ini"
If @error Then
	MsgBox(4096, "", "Apache2.ini not found")
	Exit
Else
	ReadSettings()
	ReadCmdLineParams()
	CheckExistingInstallation()
EndIf

Func CheckExistingInstallation()
	If FileExists($TempDir) Then
		DirRemove($TempDir, 1)
		DirCreate($TempDir)
	EndIf

	If Not FileExists($AppDir & "\apache") Then
 		If Not FileExists($TempDir & "\" & $XamppFileName) Then
 			DownloadSetup()
 		EndIf

 		If FileExists($TempDir & "\" & $XamppFileName) Then

 			$ArcFile = $TempDir & "\" & $XamppFileName
			If @error Then Exit

			$Output = $TempDir
			If @error Then Exit

			$retResult = _7ZipExtractEx(0, $ArcFile, $Output)
			If @error = 0 Then
				CybeTechMoveFolders()
				CybeTechRebuildPath()
			EndIf
		EndIf
	Else
		CybeTechRebuildPath()
	EndIf
EndFunc

Func ReadSettings()
	$XamppMirror = IniRead($iniFile, "Special", "XamppMirror", "http://www.cybesystems.com/")
	$XamppFileName = IniRead($iniFile, "Special", "XamppFileName", "xampp-portable-lite-win32-1.8.1-VC9.7z")
	$XamppDeleteUneededFolders = IniRead($iniFile, "Special", "XamppDeleteUneededFolders", True)
	$XamppUneededFolders = IniRead($iniFile, "Special", "XamppUneededFolders", "")

	$ApachePort = IniRead($iniFile, "Special", "ApachePort", "80")
	$ApacheEnableSSL = IniRead($iniFile, "Special", "ApacheEnableSSL", True)
	$ApacheSSLPort = IniRead($iniFile, "Special", "ApacheSSLPort", "443")

	$ApacheFirstInstallDeleteUnneeded = IniRead($iniFile, "Special", "ApacheFirstInstallDeleteUnneeded", False)
	$ApacheFirstInstallDeleteUnneededFiles = IniRead($iniFile, "Special", "ApacheFirstInstallDeleteUnneededFiles", False)
	$WindowsPathToApache = IniRead($iniFile, "Special", "WindowsPathToCygwin", True)
EndFunc   ;==>ReadSettings

Func GetWindowsPath()
	Global $szDrive, $szDir, $szFName, $szExt, $WindowsPathToApache
	_PathSplit(@ScriptDir, $szDrive, $szDir, $szFName, $szExt)
	If $WindowsPathToApache == True Then
		$path = EnvGet("PATH")
		If StringRight($path, 1) <> ";" Then
			$path &= ";"
		EndIf
		EnvSet("PATH", $path & $AppDir & "\cygwin\")
	Else
		EnvSet("PATH", $AppDir & "\cygwin\")
	EndIf
EndFunc

Func Bool(Const ByRef $checkbox)
	If GUICtrlRead($checkbox) = $GUI_CHECKED Then
		Return True
	ElseIf GUICtrlRead($checkbox) = $GUI_UNCHECKED Then
		Return False
	EndIf
EndFunc   ;==>Bool

Func CybeTechMoveFolders()
	DirMove($TempDir & "\xampp\apache", $AppDir, 1)
	DirMove($TempDir & "\xampp\contrib", $AppDir, 1)
	DirMove($TempDir & "\xampp\install", $AppDir, 1)
	DirMove($TempDir & "\xampp\licenses", $AppDir, 1)
	DirMove($TempDir & "\xampp\locale", $AppDir, 1)
	DirMove($TempDir & "\xampp\mailoutput", $AppDir, 1)
	DirMove($TempDir & "\xampp\mailtodisk", $AppDir, 1)
	DirMove($TempDir & "\xampp\sendmail", $AppDir, 1)
	DirMove($TempDir & "\xampp\htdocs", $ApacheDataDir, 1)
	DirMove($TempDir & "\xampp\mysql", $AppDir, 1)
	DirMove($TempDir & "\xampp\perl", $AppDir, 1)
	DirMove($TempDir & "\xampp\php", $AppDir, 1)
	DirMove($TempDir & "\xampp\webdav", $AppDir, 1)
	DirMove($TempDir & "\xampp\php", $AppDir, 1)
	DirMove($TempDir & "\xampp\tmp", $AppDir, 1)
	;Dont overwrite data dir if exist
	If Not FileExists($ApacheDataDir & "\cgi-bin") Then
		DirMove($TempDir & "\xampp\cgi-bin", $ApacheDataDir & "\cgi-bin", 1)
	EndIf
	If Not FileExists($ApacheDataDir & "\security") Then
		DirMove($TempDir & "\xampp\security", $ApacheDataDir & "\security", 1)
	EndIf
	If Not FileExists($ApacheDataDir & "\xampp\phpMyAdmin") Then
		DirMove($TempDir & "\xampp\phpMyAdmin", $ApacheDataDir & "\htdocs\phpMyAdmin", 1)
	EndIf

EndFunc   ;==>CybeTechMoveFolders

Func CybeTechRebuildPath()

	FileDelete($AppDir & "\apache\conf\httpd.conf")
	FileDelete($AppDir & "\apache\conf\extra\httpd-ajp.conf")
	FileDelete($AppDir & "\apache\conf\extra\httpd-autoindex.conf")
	FileDelete($AppDir & "\apache\conf\extra\httpd-dav.conf")
	FileDelete($AppDir & "\apache\conf\extra\httpd-default.conf")
	FileDelete($AppDir & "\apache\conf\extra\httpd-info.conf")
	FileDelete($AppDir & "\apache\conf\extra\httpd-languages.conf")
	FileDelete($AppDir & "\apache\conf\extra\httpd-mpm.conf")
	FileDelete($AppDir & "\apache\conf\extra\httpd-multilang-errordoc.conf")
	FileDelete($AppDir & "\apache\conf\extra\httpd-proxy.conf")
	FileDelete($AppDir & "\apache\conf\extra\httpd-ssl.conf")
	FileDelete($AppDir & "\apache\conf\extra\httpd-userdir.conf")
	FileDelete($AppDir & "\apache\conf\extra\httpd-vhosts.conf")
	FileDelete($AppDir & "\apache\conf\extra\httpd-xampp.conf")
	FileDelete($AppDir & "\apache\conf\extra\proxy-html.conf")
	FileDelete($AppDir & "\php\php.ini")

	FileCopy($OtherDir & "\Configs\httpd.conf.dist", $AppDir & "\apache\conf\httpd.conf")
	FileCopy($OtherDir & "\Configs\httpd-ajp.conf.dist", $AppDir & "\apache\conf\extra\httpd-ajp.conf")
	FileCopy($OtherDir & "\Configs\httpd-autoindex.conf.dist", $AppDir & "\apache\conf\extra\httpd-autoindex.conf")
	FileCopy($OtherDir & "\Configs\httpd-dav.conf.dist", $AppDir & "\apache\conf\extra\httpd-dav.conf")
	FileCopy($OtherDir & "\Configs\httpd-default.conf.dist", $AppDir & "\apache\conf\extra\httpd-default.conf")
	FileCopy($OtherDir & "\Configs\httpd-info.conf.dist", $AppDir & "\apache\conf\extra\httpd-info.conf")
	FileCopy($OtherDir & "\Configs\httpd-languages.conf.dist", $AppDir & "\apache\conf\extra\httpd-languages.conf")
	FileCopy($OtherDir & "\Configs\httpd-mpm.conf.dist", $AppDir & "\apache\conf\extra\httpd-mpm.conf")
	FileCopy($OtherDir & "\Configs\httpd-multilang-errordoc.conf.dist", $AppDir & "\apache\conf\extra\httpd-multilang-errordoc.conf")
	FileCopy($OtherDir & "\Configs\httpd-proxy.conf.dist", $AppDir & "\apache\conf\extra\httpd-proxy.conf")
	FileCopy($OtherDir & "\Configs\httpd-ssl.conf.dist", $AppDir & "\apache\conf\extra\httpd-ssl.conf")
	FileCopy($OtherDir & "\Configs\httpd-userdir.conf.dist", $AppDir & "\apache\conf\extra\httpd-userdir.conf")
	FileCopy($OtherDir & "\Configs\httpd-vhosts.conf.dist", $AppDir & "\apache\conf\extra\httpd-vhosts.conf")
	FileCopy($OtherDir & "\Configs\httpd-xampp.conf.dist", $AppDir & "\apache\conf\extra\httpd-xampp.conf")
	FileCopy($OtherDir & "\Configs\proxy-html.conf.dist", $AppDir & "\apache\conf\extra\proxy-html.conf")
	FileCopy($OtherDir & "\Configs\php.ini.dist", $AppDir & "\php\php.ini")

	_ReplaceStringInFile($AppDir & "\apache\conf\httpd.conf", $CYBESYSTEMSPATH, $ApacheAppDir)

	if $ApacheEnableSSL == True then
		_ReplaceStringInFile($AppDir & "\apache\conf\httpd.conf", $CYBESYSTEMSENABLESSL, "LoadModule ssl_module modules/mod_ssl.so")
	else
		_ReplaceStringInFile($AppDir & "\apache\conf\httpd.conf", $CYBESYSTEMSENABLESSL, "#LoadModule ssl_module modules/mod_ssl.so")
	EndIf

	_ReplaceStringInFile($AppDir & "\apache\conf\httpd.conf", $CYBESYSTEMSPORT, $ApachePort)

	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-ajp.conf", $CYBESYSTEMSPATH, $ApacheAppDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-autoindex.conf", $CYBESYSTEMSPATH, $ApacheAppDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-dav.conf", $CYBESYSTEMSPATH, $ApacheAppDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-default.conf", $CYBESYSTEMSPATH, $ApacheAppDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-info.conf", $CYBESYSTEMSPATH, $ApacheAppDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-languages.conf", $CYBESYSTEMSPATH, $ApacheAppDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-mpm.conf", $CYBESYSTEMSPATH, $ApacheAppDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-multilang-errordoc.conf", $CYBESYSTEMSPATH, $ApacheAppDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-proxy.conf", $CYBESYSTEMSPATH, $ApacheAppDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-ssl.conf", $CYBESYSTEMSPATH, $ApacheAppDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-ssl.conf", $CYBESYSTEMSSSLPORT, $ApacheSSLPort)

	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-userdir.conf", $CYBESYSTEMSPATH, $ApacheAppDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-vhosts.conf", $CYBESYSTEMSPATH, $ApacheAppDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-xampp.conf", $CYBESYSTEMSPATH, $ApacheAppDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-html.conf", $CYBESYSTEMSPATH, $ApacheAppDir)
	_ReplaceStringInFile($AppDir & "\php\php.ini", $CYBESYSTEMSPATH, $ApacheAppDir)

	_ReplaceStringInFile($AppDir & "\apache\conf\httpd.conf", $CYBESYSTEMSPARENTPATH, $ApacheDataDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-ajp.conf", $CYBESYSTEMSPARENTPATH, $ApacheDataDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-autoindex.conf", $CYBESYSTEMSPARENTPATH, $ApacheDataDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-dav.conf", $CYBESYSTEMSPARENTPATH, $ApacheDataDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-default.conf", $CYBESYSTEMSPARENTPATH, $ApacheDataDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-info.conf", $CYBESYSTEMSPARENTPATH, $ApacheDataDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-languages.conf", $CYBESYSTEMSPARENTPATH, $ApacheDataDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-mpm.conf", $CYBESYSTEMSPARENTPATH, $ApacheDataDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-multilang-errordoc.conf", $CYBESYSTEMSPARENTPATH, $ApacheDataDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-proxy.conf", $CYBESYSTEMSPARENTPATH, $ApacheDataDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-ssl.conf", $CYBESYSTEMSPARENTPATH, $ApacheDataDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-userdir.conf", $CYBESYSTEMSPARENTPATH, $ApacheDataDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-vhosts.conf", $CYBESYSTEMSPARENTPATH, $ApacheDataDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-xampp.conf", $CYBESYSTEMSPARENTPATH, $ApacheDataDir)
	_ReplaceStringInFile($AppDir & "\apache\conf\extra\httpd-html.conf", $CYBESYSTEMSPARENTPATH, $ApacheDataDir)
	_ReplaceStringInFile($AppDir & "\php\php.ini", $CYBESYSTEMSPARENTPATH, $ApacheDataDir)
EndFunc   ;==>CybeTechRebuildPath

Func DownloadSetup()
	Local $sFilePathURL = $XamppMirror & $XamppFileName
	Local $hGUI, $iButton, $iLabel, $iProgressBar, $sFilePath

	$hGUI = GUICreate("XAMPP Downloader", 370, 90, -1, -1)
	$iLabel = GUICtrlCreateLabel("XAMPP is missing - This file is needed!", 5, 5, 270, 40)
	$iButton = GUICtrlCreateButton("&Download", 275, 2.5, 90, 25)
	$iProgressBar = GUICtrlCreateProgress(5, 60, 360, 20)
	GUISetState(@SW_SHOW, $hGUI)
	Local $downloadSuccess = False
	While $downloadSuccess == False
		$sFilePath = _InetGetGUI($sFilePathURL, $iLabel, $iProgressBar, $iButton, $TempDir)
		If @error Then
			Switch @extended ; Check what the actual error was by using the @extended command.
				Case 0
					MsgBox(64, "Error", "Check the URL or your Internet Connection!")

				Case 1
					MsgBox(64, "Fail", "Seems the download was canecelled, but the file was >> " & $sFilePath)

			EndSwitch
		Else
			;MsgBox(64, "Success", "Downloaded >> " & $sFilePath & @CRLF & @CRLF & "Please restart this program")
;~ 			FileMove(@ScriptDir & "\" & $XamppFileName, @ScriptDir & "\" & $XamppFileName, 1)
			GUISetState(@SW_HIDE, $hGUI)
			$downloadSuccess = True
		EndIf
	WEnd
EndFunc   ;==>DownloadSetup

Func ReStartApache()
	if ProcessExists("httpd.exe") Then
		While ProcessExists("httpd.exe")
			ProcessClose("httpd.exe")
		WEnd
	Else
		ShellExecute($AppDir & "\apache\bin\httpd.exe", "", $AppDir, "",@SW_HIDE)
;~ 		ShellExecute(@ScriptDir & "\apache\bin\httpd.exe", "", @ScriptDir, "",@SW_SHOW)
	EndIf
EndFunc   ;==>MMOwningBuildTrayMenu

Global $tray_ReStartApache, $tray_phpMyAdmin, $tray_TrayExit, $tray_menu_seperator, $tray_menu_seperator2, $nSideItem3, $nTrayIcon1, $nTrayMenu1

If $CmdLine[0] == 0 And Not _Singleton("Apache2.exe", 1) = 0 Then
	GetWindowsPath()
	BuildTrayMenu()
	BuildMenu()
	ReStartApache()
	While 1
		Sleep(1000)
	WEnd
EndIf

Func MenuRebuild()
	DeleteMenu()
	BuildMenu()
EndFunc   ;==>MenuRebuild

Func DeleteMenu()
	_TrayDeleteItem($tray_TrayExit)
	_TrayDeleteItem($tray_menu_seperator)
	_TrayDeleteItem($tray_menu_seperator2)
	_TrayDeleteItem($tray_phpMyAdmin)
	_TrayDeleteItem($tray_ReStartApache)
EndFunc   ;==>DeleteMenu

Func BuildTrayMenu()
	Opt("GUIOnEventMode", 1)
	$nTrayIcon1 = _TrayIconCreate("Apache2.exe", "Apache2.exe", "MMO_ICON")
	$nTrayMenu1 = _TrayCreateContextMenu()
	$nSideItem3 = _CreateSideMenu($nTrayMenu1)
	_SetSideMenuText($nSideItem3, "ApachePortable")
	_SetSideMenuColor($nSideItem3, 0x00FFFF)
	_SetSideMenuBkColor($nSideItem3, 0xb6b6b6)
	_SetSideMenuBkGradColor($nSideItem3, 0xb6b6b6)
	_SetTrayBkColor(0xe6e6e6)
	_SetTrayIconBkColor(0xe6e6e6)
	_SetTraySelectBkColor(0xb5b6b6)
	_SetTraySelectTextColor(0xffffff)
	_SetSideMenuImage($nSideItem3, "Apache2.exe", "CYBETECH_SIDEBAR")
EndFunc   ;==>BuildTrayMenu

Func BuildMenu()
	If ProcessExists("httpd.exe") Then
		$tray_ReStartApache = _TrayCreateItem("Apache beenden")
		_TrayItemSetIcon($tray_ReStartApache, "shell32.dll", -28)
		GUICtrlSetOnEvent(-1, "ReStartApache")
	Else
		$tray_ReStartApache = _TrayCreateItem("Apache starten")
		_TrayItemSetIcon($tray_ReStartApache, "shell32.dll", -138)
		GUICtrlSetOnEvent(-1, "ReStartApache")
	EndIf

	$tray_menu_seperator2 = _TrayCreateItem("")
	_TrayItemSetIcon($tray_menu_seperator2, "", 0)

	$tray_phpMyAdmin = _TrayCreateItem("phpMyAdmin")
	_TrayItemSetIcon($tray_phpMyAdmin, "shell32.dll", -15)
	GUICtrlSetOnEvent(-1, "TrayEvent")

	$tray_TrayExit = _TrayCreateItem("Beenden")
	_TrayItemSetIcon($tray_TrayExit, "shell32.dll", -28)
	GUICtrlSetOnEvent(-1, "TrayEvent")
	_TrayIconSetState()
	;TrayMenuRightClick()
EndFunc   ;==>BuildMenu


Func TrayEvent()
	Local $Msg = @GUI_CtrlId
	Switch $Msg
		Case $tray_TrayExit
			While ProcessExists("httpd.exe")
				ProcessClose("httpd.exe")
			WEnd
			_TrayIconDelete($nTrayIcon1)
			CleanUpSysTray()
			Exit
		Case $tray_phpMyAdmin
			ShellExecute("http://127.0.0.1/phpMyAdmin")
	EndSwitch
EndFunc   ;==>TrayEvent


Func CleanUpSysTray()
	$count = _SysTrayIconCount()
	For $i = $count - 1 To 0 Step -1
		$handle = _SysTrayIconHandle($i)
		$visible = _SysTrayIconVisible($i)
		$pid = WinGetProcess($handle)
		$name = _ProcessGetName($pid)
		$title = WinGetTitle($handle)
		$tooltip = _SysTrayIconTooltip($i)
		If $pid = -1 Then _SysTrayIconRemove($i)
	Next

	If @OSVersion = "WIN_7" Then
		$countwin7 = _SysTrayIconCount(2)
		For $i = $countwin7 - 1 To 0 Step -1
			$handle = _SysTrayIconHandle($i, 2)
			$visible = _SysTrayIconVisible($i, 2)
			$pid = WinGetProcess($handle)
			$name = _ProcessGetName($pid)
			$title = WinGetTitle($handle)
			$tooltip = _SysTrayIconTooltip($i, 2)
			If $pid = -1 Then _SysTrayIconRemove($i, 2)
		Next
	EndIf
EndFunc   ;==>CleanUpSysTray

Func ReadCmdLineParams() ;Read in the optional switch set in the users profile and set a variable - used in case selection
	;;Loop through every arguement
	;;$cmdLine[0] is an integer that is eqaul to the total number of arguements that we passwed to the command line

	Local $noCorrectParameter = True

	;Set Global Variables True/False first
	For $i = 1 To $CmdLine[0]
		Select
			Case $CmdLine[$i] = "-exit"
				If StringStripWS($CmdLine[$i + 1], 3) == 0 Then
					$exitAfterExec = False
				Else
					$exitAfterExec = True
				EndIf
				$noCorrectParameter = False

				Exit
		EndSelect
	Next

	For $i = 1 To $CmdLine[0]
		Select
			;;If the arguement equal -h
			Case $CmdLine[$i] = "-h"
				;check for missing argument
				If $i == $CmdLine[0] Then cmdLineHelpMsg()

				;Make sure the next argument is not another paramter
				If StringLeft($CmdLine[$i + 1], 1) == "-" Then
					cmdLineHelpMsg()
				Else
					;;Stip white space from the begining and end of the input
					;;Not alway nessary let it in just in case
					$msgHeader = StringStripWS($CmdLine[$i + 1], 3)
				EndIf
				$noCorrectParameter = False

		EndSelect
	Next

	;if no correct startup parameter is given try to use first parameter with path (needed for open with)
	If $CmdLine[0] <> 0 And $noCorrectParameter == True Then

	EndIf

EndFunc   ;==>ReadCmdLineParams

Func cmdLineHelpMsg()
	ConsoleWrite('CybeSystems Apache Portable Launcher' & @LF & @LF & _
			'Syntax:' & @TAB & 'Apache2.exe [options]' & @LF & @LF & _
			'Default:' & @TAB & 'Display help message.' & @LF & @LF & _
			'Optional Options:' & @LF & _
			'-path ["path"]' & @TAB & '-path "C:\Windows" open Windows folder' & @LF & _
			'-exit [0/1]' & @TAB & '-exit 0 let the cygwin window open, -exit 1 close the cygwin window after execution' & @LF)
	Exit
EndFunc   ;==>cmdLineHelpMsg
