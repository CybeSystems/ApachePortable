#NoTrayIcon
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=resources/apache2.ico
#AutoIt3Wrapper_UseUpx=N
#AutoIt3Wrapper_Res_Description=CybeSystems
#AutoIt3Wrapper_Res_Fileversion=0.8.0.0
#AutoIt3Wrapper_Res_ProductVersion=0.8
#AutoIt3Wrapper_Res_LegalCopyright=Thiemo Borger
#AutoIt3Wrapper_Res_Language=1031
#AutoIt3Wrapper_Res_Icon_Add=resources/plus.ico
#AutoIt3Wrapper_Res_Icon_Add=resources/view_refresh.ico
#AutoIt3Wrapper_Res_Icon_Add=resources/window_close.ico
#AutoIt3Wrapper_Res_Icon_Add=resources/preferences_desktop_display.ico
#AutoIt3Wrapper_Res_Icon_Add=resources/applications_development.ico
#AutoIt3Wrapper_Res_Icon_Add=resources/help_about.ico
#AutoIt3Wrapper_Res_Icon_Add=resources/messagebox_info.ico
#AutoIt3Wrapper_Res_Icon_Add=resources/network.ico
#AutoIt3Wrapper_Res_Icon_Add=resources/system_log_out.ico
#AutoIt3Wrapper_Res_Icon_Add=resources/package_utilities.ico
#AutoIt3Wrapper_Res_File_Add=resources/ct_sidebar.bmp, rt_bitmap, CYBETECH_SIDEBAR
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

Global $szDrive, $szDir, $szFName, $szExt, $cygdrive, $cygfolder, $cygfolder1, $cygfile, $executableExtension, $executable, $exitAfterExec, $setContextMenu, $cygwinUsername, $cygwinTrayMenu, $shell, $cygwinNoMsgBox, $cygwinMirror, $cygwinPortsMirror, $cygwinFirstInstallAdditions
Global $xamppFirstInstallDeleteUnneeded, $cygwinDeleteInstallation, $installUnofficial, $ApacheFirstInstallDeleteUnneededFiles, $tray_openApachePortableConfig, $WindowsPathToApache, $windowsAdditionalPath, $windowsPythonPath
Global $WS_GROUP, $BackupDir
Global $tray_ReStartApache, $tray_phpMyAdmin, $AppsStopped, $tray_TrayExit, $tray_menu_seperator, $tray_menu_seperator2, $nSideItem3, $nTrayIcon1, $nTrayMenu1
Global $CYBESYSTEMSPATH, $CYBESYSTEMSPARENTPATH, $PARENTPATH, $REALPATH
Global $szDrive, $szDir, $szFName, $szExt, $WindowsPathToApache


$BackupDir = @ScriptDir & "\App\ApachePortable\Backup\"

$CYBESYSTEMSPATH = "$CYBESYSTEMSPATH"
$CYBESYSTEMSPARENTPATH = "$CYBESYSTEMSPARENTPATH"
$REALPATH = StringReplace(@ScriptDir, "\", "/")

_PathSplit(@ScriptDir, $szDrive, $szDir, $szFName, $szExt)
If $WindowsPathToApache == True Then
	$path = EnvGet("PATH")
	If StringRight($path, 1) <> ";" Then
		$path &= ";"
	EndIf
	EnvSet("PATH", $path & @ScriptDir & "\cygwin\")
Else
	EnvSet("PATH", @ScriptDir & "\cygwin\")
EndIf


If $CmdLine[0] == 2 And $CmdLine[2] == 'cybesystemsapp' Then
	$PARENTPATH = StringReplace(StringLeft(@ScriptDir, StringInStr(@ScriptDir, "\", 0, -1)), "\", "/")
	ConsoleWrite($PARENTPATH)
Else
	;$PARENTPATH = StringReplace(@ScriptDir, "\", "/")
	$PARENTPATH = $REALPATH
	ConsoleWrite($PARENTPATH)
EndIf

Local $iniMain = IniReadSection(@ScriptDir & "\ApachePortable.ini", "Main")
Local $iniFile = @ScriptDir & "\ApachePortable.ini"
If @error Then
	MsgBox(4096, "", "ApachePortable.ini not found")
Else
	ReadSettings()
EndIf

Func ReadSettings()
	Global $XamppMirror, $XamppFileName, $ApacheFirstInstallDeleteUnneeded, $ApacheFirstInstallDeleteUnneededFiles, $WindowsPathToApache
	$XamppMirror = IniRead($iniFile, "Main", "XamppMirror", "http://www.cybesystems.com/")
	$XamppFileName = IniRead($iniFile, "Main", "XamppFileName", "xampp-portable-lite-win32-1.8.1-VC9.7z")
	$ApacheFirstInstallDeleteUnneeded = IniRead($iniFile, "Main", "ApacheFirstInstallDeleteUnneeded", False)
	$ApacheFirstInstallDeleteUnneededFiles = IniRead($iniFile, "Main", "ApacheFirstInstallDeleteUnneededFiles", False)
	$WindowsPathToApache = IniRead($iniFile, "Main", "WindowsPathToCygwin", True)
EndFunc   ;==>ReadSettings

Func Bool(Const ByRef $checkbox)
	If GUICtrlRead($checkbox) = $GUI_CHECKED Then
		Return True
	ElseIf GUICtrlRead($checkbox) = $GUI_UNCHECKED Then
		Return False
	EndIf
EndFunc   ;==>Bool


If Not FileExists(@ScriptDir & "\App\ApachePortable\" & $XamppFileName) Then
	DownloadSetup()
EndIf

If FileExists(@ScriptDir & "\App\ApachePortable\temp") Then
	DirRemove(@ScriptDir & "\App\ApachePortable\temp", 1)
EndIf

If Not FileExists(@ScriptDir & "\apache") Then
	If FileExists(@ScriptDir & "\App\ApachePortable\" & $XamppFileName) Then
		$ArcFile = @ScriptDir & "\App\ApachePortable\" & $XamppFileName
		If @error Then Exit

		$Output = @ScriptDir & "\App\ApachePortable\temp"
		If @error Then Exit

		$retResult = _7ZipExtractEx(0, $ArcFile, $Output)
		If @error = 0 Then
	;~ 		CybeTechMoveOriginals()
			CybeTechMoveFolders()
			CybeTechRebuildPath()
	;~ 		If not DirMove(@ScriptDir & "\App\ApachePortable\temp\xampp\*",@ScriptDir ,1) then
	;~ 			msgbox(0,"Error","FileMove failed!")
	;~ 			exit(1)
	;~ 		endIf
		EndIf
	EndIf
Else
	CybeTechRebuildPath()
EndIf


Func CybeTechMoveFolders()
	DirMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache", @ScriptDir, 1)
	DirMove(@ScriptDir & "\App\ApachePortable\temp\xampp\cgi-bin", @ScriptDir, 1)
	DirMove(@ScriptDir & "\App\ApachePortable\temp\xampp\htdocs", @ScriptDir, 1)
	DirMove(@ScriptDir & "\App\ApachePortable\temp\xampp\mysql", @ScriptDir, 1)
	DirMove(@ScriptDir & "\App\ApachePortable\temp\xampp\perl", @ScriptDir, 1)
	DirMove(@ScriptDir & "\App\ApachePortable\temp\xampp\php", @ScriptDir, 1)
	DirMove(@ScriptDir & "\App\ApachePortable\temp\xampp\phpMyAdmin", @ScriptDir & "\htdocs", 1)
	DirMove(@ScriptDir & "\App\ApachePortable\temp\xampp\webdav", @ScriptDir, 1)
	DirMove(@ScriptDir & "\App\ApachePortable\temp\xampp\php", @ScriptDir, 1)
	DirMove(@ScriptDir & "\App\ApachePortable\temp\xampp\tmp", @ScriptDir, 1)
EndFunc   ;==>CybeTechMoveFolders

Func CybeTechMoveOriginals()
	DirRemove($BackupDir, 1)
	DirCreate($BackupDir)
	DirCreate($BackupDir & "\apache\conf\")
	DirCreate($BackupDir & "\apache\conf\extra\")
	DirCreate($BackupDir & "\php\")

	For $iniMainValue = 1 To $iniMain[0][0]
		;ConsoleWrite($iniMain[$iniMainValue][0])
		;Is the selected file executable ?
		If $iniMain[$iniMainValue][0] == 'ApacheFirstInstallDeleteUnneededFiles' Then
			$ApacheFirstInstallDeleteUnneededFiles = StringSplit($iniMain[$iniMainValue][1], ",")

			For $iniMainExecutableExtensionArray = 1 To UBound($ApacheFirstInstallDeleteUnneededFiles, 1) - 1

				;FileDelete (@ScriptDir & "\App\ApachePortable\CygwinConfig.exe")
				;DirRemove ( @ScriptDir & "\" & $ApacheFirstInstallDeleteUnneededFiles[$iniMainExecutableExtensionArray], 1)
				If Not FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\" & $ApacheFirstInstallDeleteUnneededFiles[$iniMainExecutableExtensionArray], $BackupDir & $ApacheFirstInstallDeleteUnneededFiles[$iniMainExecutableExtensionArray]) Then
					;msgbox(0,"Error","FileMove " & @ScriptDir & "\App\ApachePortable\temp\xampp\" & $ApacheFirstInstallDeleteUnneededFiles[$iniMainExecutableExtensionArray] & " failed!")
					;exit(1)
				EndIf
			Next
		EndIf
	Next

	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\httpd.conf", $BackupDir & "\apache\conf\httpd.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-ajp.conf", $BackupDir & "\apache\conf\extra\httpd-ajp.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-default.conf", $BackupDir & "\apache\conf\extra\httpd-default.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-autoindex.conf", $BackupDir & "\apache\conf\extra\httpd-autoindex.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-dav.conf", $BackupDir & "\apache\conf\extra\httpd-dav.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-info.conf", $BackupDir & "\apache\conf\extra\httpd-info.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-languages.conf", $BackupDir & "\apache\conf\extra\httpd-languages.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-mpm.conf", $BackupDir & "\apache\conf\extra\httpd-mpm.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-multilang-errordoc.conf", $BackupDir & "\apache\conf\extra\httpd-multilang-errordoc.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-proxy.conf", $BackupDir & "\apache\conf\extra\httpd-proxy.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-ssl.conf", $BackupDir & "\apache\conf\extra\httpd-ssl.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-userdir.conf", $BackupDir & "\apache\conf\extra\httpd-userdir.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-vhosts.conf", $BackupDir & "\apache\conf\extra\httpd-vhosts.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-xampp.conf", $BackupDir & "\apache\conf\extra\httpd-xampp.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-html.conf", $BackupDir & "\apache\conf\extra\httpd-html.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\php\php.ini", $BackupDir & "\php\php.ini")
EndFunc   ;==>CybeTechMoveOriginals


Func CybeTechRebuildPath()

	;------------------------------------------------------------------------------------------------------------------------
	;CybeSystems - LightTPD Config schreiben -> Portabel machen bzw. neuen Pfad erkennen, falls umkopiert
	;------------------------------------------------------------------------------------------------------------------------

	FileDelete(@ScriptDir & "\apache\conf\httpd.conf")
	FileDelete(@ScriptDir & "\apache\conf\extra\httpd-ajp.conf")
	FileDelete(@ScriptDir & "\apache\conf\extra\httpd-autoindex.conf")
	FileDelete(@ScriptDir & "\apache\conf\extra\httpd-dav.conf")
	FileDelete(@ScriptDir & "\apache\conf\extra\httpd-default.conf")
	FileDelete(@ScriptDir & "\apache\conf\extra\httpd-info.conf")
	FileDelete(@ScriptDir & "\apache\conf\extra\httpd-languages.conf")
	FileDelete(@ScriptDir & "\apache\conf\extra\httpd-mpm.conf")
	FileDelete(@ScriptDir & "\apache\conf\extra\httpd-multilang-errordoc.conf")
	FileDelete(@ScriptDir & "\apache\conf\extra\httpd-proxy.conf")
	FileDelete(@ScriptDir & "\apache\conf\extra\httpd-ssl.conf")
	FileDelete(@ScriptDir & "\apache\conf\extra\httpd-userdir.conf")
	FileDelete(@ScriptDir & "\apache\conf\extra\httpd-vhosts.conf")
	FileDelete(@ScriptDir & "\apache\conf\extra\httpd-xampp.conf")
	FileDelete(@ScriptDir & "\apache\conf\extra\proxy-html.conf")
	FileDelete(@ScriptDir & "\php\php.ini")

	FileCopy(@ScriptDir & "\App\Configs\httpd.conf.dist", @ScriptDir & "\apache\conf\httpd.conf")
	FileCopy(@ScriptDir & "\App\Configs\httpd-ajp.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-ajp.conf")
	FileCopy(@ScriptDir & "\App\Configs\httpd-autoindex.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-autoindex.conf")
	FileCopy(@ScriptDir & "\App\Configs\httpd-dav.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-dav.conf")
	FileCopy(@ScriptDir & "\App\Configs\httpd-default.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-default.conf")
	FileCopy(@ScriptDir & "\App\Configs\httpd-info.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-info.conf")
	FileCopy(@ScriptDir & "\App\Configs\httpd-languages.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-languages.conf")
	FileCopy(@ScriptDir & "\App\Configs\httpd-mpm.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-mpm.conf")
	FileCopy(@ScriptDir & "\App\Configs\httpd-multilang-errordoc.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-multilang-errordoc.conf")
	FileCopy(@ScriptDir & "\App\Configs\httpd-proxy.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-proxy.conf")
	FileCopy(@ScriptDir & "\App\Configs\httpd-ssl.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-ssl.conf")
	FileCopy(@ScriptDir & "\App\Configs\httpd-userdir.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-userdir.conf")
	FileCopy(@ScriptDir & "\App\Configs\httpd-vhosts.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-vhosts.conf")
	FileCopy(@ScriptDir & "\App\Configs\httpd-xampp.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-xampp.conf")
	FileCopy(@ScriptDir & "\App\Configs\proxy-html.conf.dist", @ScriptDir & "\apache\conf\extra\proxy-html.conf")
	FileCopy(@ScriptDir & "\App\Configs\php.ini.dist", @ScriptDir & "\php\php.ini")

	_ReplaceStringInFile(@ScriptDir & "\apache\conf\httpd.conf", $CYBESYSTEMSPATH, $REALPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-ajp.conf", $CYBESYSTEMSPATH, $REALPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-autoindex.conf", $CYBESYSTEMSPATH, $REALPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-dav.conf", $CYBESYSTEMSPATH, $REALPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-default.conf", $CYBESYSTEMSPATH, $REALPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-info.conf", $CYBESYSTEMSPATH, $REALPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-languages.conf", $CYBESYSTEMSPATH, $REALPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-mpm.conf", $CYBESYSTEMSPATH, $REALPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-multilang-errordoc.conf", $CYBESYSTEMSPATH, $REALPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-proxy.conf", $CYBESYSTEMSPATH, $REALPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-ssl.conf", $CYBESYSTEMSPATH, $REALPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-userdir.conf", $CYBESYSTEMSPATH, $REALPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-vhosts.conf", $CYBESYSTEMSPATH, $REALPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-xampp.conf", $CYBESYSTEMSPATH, $REALPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-html.conf", $CYBESYSTEMSPATH, $REALPATH)
	_ReplaceStringInFile(@ScriptDir & "\php\php.ini", $CYBESYSTEMSPATH, $REALPATH)

	_ReplaceStringInFile(@ScriptDir & "\apache\conf\httpd.conf", $CYBESYSTEMSPARENTPATH, $PARENTPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-ajp.conf", $CYBESYSTEMSPARENTPATH, $PARENTPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-autoindex.conf", $CYBESYSTEMSPARENTPATH, $PARENTPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-dav.conf", $CYBESYSTEMSPARENTPATH, $PARENTPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-default.conf", $CYBESYSTEMSPARENTPATH, $PARENTPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-info.conf", $CYBESYSTEMSPARENTPATH, $PARENTPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-languages.conf", $CYBESYSTEMSPARENTPATH, $PARENTPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-mpm.conf", $CYBESYSTEMSPARENTPATH, $PARENTPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-multilang-errordoc.conf", $CYBESYSTEMSPARENTPATH, $PARENTPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-proxy.conf", $CYBESYSTEMSPARENTPATH, $PARENTPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-ssl.conf", $CYBESYSTEMSPARENTPATH, $PARENTPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-userdir.conf", $CYBESYSTEMSPARENTPATH, $PARENTPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-vhosts.conf", $CYBESYSTEMSPARENTPATH, $PARENTPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-xampp.conf", $CYBESYSTEMSPARENTPATH, $PARENTPATH)
	_ReplaceStringInFile(@ScriptDir & "\apache\conf\extra\httpd-html.conf", $CYBESYSTEMSPARENTPATH, $PARENTPATH)
	_ReplaceStringInFile(@ScriptDir & "\php\php.ini", $CYBESYSTEMSPARENTPATH, $PARENTPATH)
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
		$sFilePath = _InetGetGUI($sFilePathURL, $iLabel, $iProgressBar, $iButton, @ScriptDir)
		If @error Then
			Switch @extended ; Check what the actual error was by using the @extended command.
				Case 0
					MsgBox(64, "Error", "Check the URL or your Internet Connection!")

				Case 1
					MsgBox(64, "Fail", "Seems the download was canecelled, but the file was >> " & $sFilePath)

			EndSwitch
		Else
			;MsgBox(64, "Success", "Downloaded >> " & $sFilePath & @CRLF & @CRLF & "Please restart this program")
			FileMove(@ScriptDir & "\" & $XamppFileName, @ScriptDir & "\" & $XamppFileName, 1)
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
		ShellExecute(@ScriptDir & "\apache\bin\httpd.exe", "", @ScriptDir, "",@SW_HIDE)
;~ 		ShellExecute(@ScriptDir & "\apache\bin\httpd.exe", "", @ScriptDir, "",@SW_SHOW)
	EndIf
EndFunc   ;==>MMOwningBuildTrayMenu

ReadCmdLineParams()

Global $tray_ReStartApache, $tray_openbash, $AppsStopped, $tray_TrayExit, $tray_menu_seperator, $tray_menu_seperator2, $nSideItem3, $nTrayIcon1, $nTrayMenu1, $tray_openCygwinConfig, $tray_sub_QuickLaunch, $tray_sub_Drives, $tray_sub_QuickLink, $tray_menu_seperator_quick_launch, $tray_openXServer, $tray_openCygwinConfigPorts

If $CmdLine[0] == 0 And Not _Singleton("ApachePortable.exe", 1) = 0 Then
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
	$nTrayIcon1 = _TrayIconCreate("ApachePortable.exe", "ApachePortable.exe", "MMO_ICON")
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
	_SetSideMenuImage($nSideItem3, "ApachePortable.exe", "CYBETECH_SIDEBAR")
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
			'Syntax:' & @TAB & 'ApachePortable.exe [options]' & @LF & @LF & _
			'Default:' & @TAB & 'Display help message.' & @LF & @LF & _
			'Optional Options:' & @LF & _
			'-path ["path"]' & @TAB & '-path "C:\Windows" open Windows folder' & @LF & _
			'-exit [0/1]' & @TAB & '-exit 0 let the cygwin window open, -exit 1 close the cygwin window after execution' & @LF)
	Exit
EndFunc   ;==>cmdLineHelpMsg
