#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
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
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Region AutoIt3Wrapper directives section
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
#EndRegion AutoIt3Wrapper directives section

#include <File.au3>
#Include <Array.au3>
#include <Process.au3>
#include "resources\resources.au3"
#include "resources\_ModernMenuRaw.au3"
#include "resources\_SysTray.au3"
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <TabConstants.au3>
#include <StaticConstants.au3>
#Include <Misc.au3>
#include "resources\7Zip.au3"

#include "resources\_InetGetGUI.au3"

Run(@ScriptDir & "\bin\bash /Other/user_setup.sh", @SW_HIDE)

Global $szDrive, $szDir, $szFName, $szExt, $cygdrive,$cygfolder,$cygfolder1,$cygfile, $executableExtension, $executable, $exitAfterExec, $setContextMenu, $cygwinUsername,$cygwinTrayMenu,$shell,$cygwinNoMsgBox,$cygwinMirror,$cygwinPortsMirror,$cygwinFirstInstallAdditions
Global $xamppFirstInstallDeleteUnneeded, $cygwinDeleteInstallation, $installUnofficial,$ApacheFirstInstallDeleteUnneededFiles,$tray_openApachePortableConfig,$windowsPathToCygwin,$windowsAdditionalPath,$windowsPythonPath
Global $WS_GROUP,$BackupDir

$BackupDir = @ScriptDir & "\App\ApachePortable\Backup\"

Global $CYBESYSTEMSPATH, $CYBESYSTEMSPARENTPATH, $PARENTPATH, $REALPATH

$CYBESYSTEMSPATH = "$CYBESYSTEMSPATH"
$CYBESYSTEMSPARENTPATH = "$CYBESYSTEMSPARENTPATH"
$REALPATH = StringReplace(@ScriptDir, "\", "/")

Global $szDrive, $szDir, $szFName, $szExt,$windowsPathToCygwin

_PathSplit(@ScriptDir, $szDrive, $szDir, $szFName, $szExt)
if $windowsPathToCygwin == True then
	$path = EnvGet("PATH")
	If StringRight($path, 1) <> ";" Then
		$path &= ";"
	EndIf
	EnvSet("PATH",$path & @ScriptDir & "\cygwin\")
Else
	EnvSet("PATH",@ScriptDir & "\cygwin\")
EndIf

Global $tray_ReStartApache,$tray_phpMyAdmin,$AppsStopped,$tray_TrayExit,$tray_menu_seperator,$tray_menu_seperator2,$nSideItem3,$nTrayIcon1,$nTrayMenu1

If $CmdLine[0] == 2 And $CmdLine[2] == 'cybesystemsapp' Then
	$PARENTPATH = StringReplace(StringLeft(@scriptDir,StringInStr(@scriptDir,"\",0,-1)), "\", "/")
	ConsoleWrite($PARENTPATH)
Else
	;$PARENTPATH = StringReplace(@ScriptDir, "\", "/")
	$PARENTPATH = StringReplace(StringLeft(@scriptDir,StringInStr(@scriptDir,"\",0,-1)), "\", "/")
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
	$exitAfterExec = IniRead($iniFile, "Main", "ExitAfterExec", True)
	$setContextMenu = IniRead($iniFile, "Main", "SetContextMenu", False)
	$cygwinTrayMenu = IniRead($iniFile, "Main", "TrayMenu", True)
	$shell = IniRead($iniFile, "Main", "Shell", "mintty")
	$cygwinNoMsgBox = IniRead($iniFile, "Main", "NoMsgBox", False)
	$executableExtension = IniRead($iniFile, "Main", "ExecutableExtension", "exe,bat,sh,pl,bat")
	$cygwinMirror = IniRead($iniFile, "Main", "CygwinMirror", "ftp://lug.mtu.edu/cygwin")
	$cygwinPortsMirror = IniRead($iniFile, "Main", "CygwinPortsMirror", "ftp://ftp.cygwinports.org/pub/cygwinports")
	$cygwinFirstInstallAdditions = IniRead($iniFile, "Main", "CygwinFirstInstallAdditions", "")
	$xamppFirstInstallDeleteUnneeded = IniRead($iniFile, "Main", "XamppFirstInstallDeleteUnneeded", True)
	$installUnofficial = IniRead($iniFile, "Main", "InstallUnofficial", False)
	$windowsPathToCygwin = IniRead($iniFile, "Main", "WindowsPathToCygwin", True)
	$windowsAdditionalPath = IniRead($iniFile, "Main", "WindowsAdditionalPath", True)
	$windowsPythonPath = IniRead($iniFile, "Main", "WindowsPythonPath", True)
	$cygwinUsername = IniRead($iniFile, "Static", "Username", "")
	$cygwinDeleteInstallation = IniRead($iniFile, "Expert", "CygwinDeleteInstallation", False)
	$ApacheFirstInstallDeleteUnneededFiles = IniRead($iniFile, "Main", "ApacheFirstInstallDeleteUnneededFiles", False)

	$xamppFirstInstallDeleteUnneededFiles = IniRead($iniFile, "Main", "XamppFirstInstallDeleteUnneededFiles", True)
EndFunc


Func Bool(Const ByRef $checkbox)
    If GUICtrlRead($checkbox) = $GUI_CHECKED Then
        Return True
    ElseIf GUICtrlRead($checkbox) = $GUI_UNCHECKED Then
        Return False
    EndIf
EndFunc

Func ApachePortableSettingsGUI()
	Global $settings_form,$settings_chk_ExitAfterExec,$settings_chk_SetContextMenu,$settings_chk_TrayMenu, $settings_dropdown_shell, $settings_chk_NoMsgBox, $settings_input_ExecutableExtension,$settings_input_CygwinMirror,$settings_input_CygwinPortsMirror,$settings_chk_windows_to_cygwinpath
	Global $settings_input_CygwinFirstInstallAdditions, $settings_chk_XamppFirstInstallDeleteUnneeded, $settings_chk_InstallUnofficial, $settings_chk_CygwinDeleteInstallation,$settings_input_ApacheFirstInstallDeleteUnneededFiles,$settings_input_Username,$settings_btn_save,$settings_btn_cancel
	#Region ### START Koda GUI section ###
	$settings_form_1 = GUICreate("Cygwin Portable Launcher Settings", 412, 247, -1, -1)
	GUISetIcon("D:\005.ico")
	$PageControl1 = GUICtrlCreateTab(8, 8, 396, 200)
	GUICtrlSetFont(-1, 8, 400, 0, "MS Sans Serif")
	GUICtrlSetResizing(-1, $GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$TabSheet1 = GUICtrlCreateTabItem("Settings")
	$settings_chk_ExitAfterExec = GUICtrlCreateCheckbox("Exit after Execution", 24, 135, 233, 17)
	$settings_chk_SetContextMenu = GUICtrlCreateCheckbox("Set Windows Context Menus (registry)", 24, 87, 313, 17)
	$settings_chk_TrayMenu = GUICtrlCreateCheckbox("Use TrayMenu", 24, 111, 97, 17)
	$settings_dropdown_shell = GUICtrlCreateCombo("mintty", 168, 39, 225, 25)
	GUICtrlSetData(-1, "ConEmu")
	$settings_chk_NoMsgBox = GUICtrlCreateCheckbox("Disable Message Boxes (errors will not be show !)", 24, 159, 337, 17)
	$settings_lbl_shell = GUICtrlCreateLabel("Shell:", 24, 39, 30, 17)
	$settings_lbl_ExecutableExtension = GUICtrlCreateLabel("Executable File Extensions:", 24, 63, 133, 17)
	$settings_input_ExecutableExtension = GUICtrlCreateInput("settings_input_ExecutableExtension", 168, 63, 225, 21)
	$settings_chk_windows_to_cygwinpath = GUICtrlCreateCheckbox("Add Windows PATH variables to Cygwin", 24, 184, 361, 17)
	$TabSheet2 = GUICtrlCreateTabItem("Installer")
	$settings_lbl_CygwinMirror = GUICtrlCreateLabel("Cygwin Mirror:", 16, 39, 70, 17)
	$settings_input_CygwinMirror = GUICtrlCreateInput("settings_input_CygwinMirror", 128, 39, 257, 21)
	$settings_lbl_CygwinPortsMirror = GUICtrlCreateLabel("Cygwin Ports Mirror:", 16, 63, 97, 17)
	$settings_input_CygwinPortsMirror = GUICtrlCreateInput("settings_input_CygwinPortsMirror", 128, 63, 257, 21)
	$settings_lbl_CygwinFirstInstallAdditions = GUICtrlCreateLabel("First install additions:", 16, 87, 100, 17)
	$settings_input_CygwinFirstInstallAdditions = GUICtrlCreateInput("settings_input_CygwinFirstInstallAdditions", 128, 87, 257, 21)
	$settings_chk_XamppFirstInstallDeleteUnneeded = GUICtrlCreateCheckbox("Delete unneeded files", 16, 111, 145, 17)
	$settings_chk_InstallUnofficial = GUICtrlCreateCheckbox("Install unofficial Cygwin Tools", 16, 135, 241, 17)
	$TabSheet3 = GUICtrlCreateTabItem("Expert")
	$settings_chk_CygwinDeleteInstallation = GUICtrlCreateCheckbox("Delete complete installation (Reinstall)", 16, 63, 225, 17)
	$settings_lbl_Warning = GUICtrlCreateLabel("WARNING: Dont change anything here if not not exactly know what you doing", 16, 39, 376, 17)
	$settings_lbl_ApacheFirstInstallDeleteUnneededFiles = GUICtrlCreateLabel("Drop these folders on Reinstall:", 16, 87, 151, 17)
	$settings_input_ApacheFirstInstallDeleteUnneededFiles = GUICtrlCreateInput("settings_input_ApacheFirstInstallDeleteUnneededFiles", 176, 87, 209, 21)
	$settings_input_Username = GUICtrlCreateInput("settings_input_Username", 176, 111, 209, 21)
	$settings_lbl_username = GUICtrlCreateLabel("Username:", 16, 111, 55, 17)
	GUICtrlCreateTabItem("")
	$settings_btn_save = GUICtrlCreateButton("&Save", 246, 216, 75, 25, $WS_GROUP)
	$settings_btn_cancel = GUICtrlCreateButton("&Cancel", 326, 216, 75, 25, $WS_GROUP)

	#EndRegion ### END Koda GUI section ###


	if $exitAfterExec == True Then
		GUICtrlSetState($settings_chk_ExitAfterExec, $GUI_CHECKED)
	EndIf
	if $setContextMenu == True Then
		GUICtrlSetState($settings_chk_SetContextMenu, $GUI_CHECKED)
	EndIf
	if $cygwinTrayMenu == True Then
		GUICtrlSetState($settings_chk_TrayMenu, $GUI_CHECKED)
	EndIf
	if $cygwinNoMsgBox == True Then
		GUICtrlSetState($settings_chk_NoMsgBox, $GUI_CHECKED)
	EndIf
	if $xamppFirstInstallDeleteUnneeded == True Then
		GUICtrlSetState($settings_chk_XamppFirstInstallDeleteUnneeded, $GUI_CHECKED)
	EndIf
	if $installUnofficial == True Then
		GUICtrlSetState($settings_chk_InstallUnofficial, $GUI_CHECKED)
	EndIf
	if $cygwinDeleteInstallation == True Then
		GUICtrlSetState($settings_chk_CygwinDeleteInstallation, $GUI_CHECKED)
	EndIf
	if $windowsPathToCygwin == True Then
		GUICtrlSetState($settings_chk_windows_to_cygwinpath, $GUI_CHECKED)
	EndIf

	;Set variables
	GUICtrlSetData($settings_dropdown_shell,$shell)
	GUICtrlSetData($settings_input_ExecutableExtension,$executableExtension)
	GUICtrlSetData($settings_input_CygwinMirror,$cygwinMirror)
	GUICtrlSetData($settings_input_CygwinPortsMirror,$cygwinPortsMirror)
	GUICtrlSetData($settings_input_Username,$cygwinUsername)
	GUICtrlSetData($settings_input_CygwinFirstInstallAdditions,$cygwinFirstInstallAdditions)
	GUICtrlSetData($settings_input_ApacheFirstInstallDeleteUnneededFiles,$ApacheFirstInstallDeleteUnneededFiles)
	GUICtrlSetOnEvent($settings_btn_save, "ConfigSave")
	GUICtrlSetOnEvent($settings_btn_cancel, "ConfigExit")

	GUISetState(@SW_SHOW)
EndFunc


Func ConfigSave()
	IniWrite(@ScriptDir & "\ApachePortable.ini", "Main", "ExitAfterExec", Bool($settings_chk_ExitAfterExec))
	IniWrite(@ScriptDir & "\ApachePortable.ini", "Main", "SetContextMenu", Bool($settings_chk_SetContextMenu))
	IniWrite(@ScriptDir & "\ApachePortable.ini", "Main", "TrayMenu", Bool($settings_chk_TrayMenu))
	IniWrite(@ScriptDir & "\ApachePortable.ini", "Main", "Shell", GuiCtrlRead($settings_dropdown_shell))
	IniWrite(@ScriptDir & "\ApachePortable.ini", "Main", "NoMsgBox", Bool($settings_chk_NoMsgBox))
	IniWrite(@ScriptDir & "\ApachePortable.ini", "Main", "ExecutableExtension", GuiCtrlRead($settings_input_ExecutableExtension))
	IniWrite(@ScriptDir & "\ApachePortable.ini", "Main", "CygwinMirror", GuiCtrlRead($settings_input_CygwinMirror))
	IniWrite(@ScriptDir & "\ApachePortable.ini", "Main", "CygwinPortsMirror", GuiCtrlRead($settings_input_CygwinPortsMirror))
	IniWrite(@ScriptDir & "\ApachePortable.ini", "Main", "CygwinFirstInstallAdditions", GuiCtrlRead($settings_input_CygwinFirstInstallAdditions))
	IniWrite(@ScriptDir & "\ApachePortable.ini", "Main", "XamppFirstInstallDeleteUnneeded", Bool($settings_chk_XamppFirstInstallDeleteUnneeded))
	IniWrite(@ScriptDir & "\ApachePortable.ini", "Main", "InstallUnofficial", Bool($settings_chk_InstallUnofficial))
	IniWrite(@ScriptDir & "\ApachePortable.ini", "Main", "WindowsPathToCygwin", Bool($settings_chk_windows_to_cygwinpath))
	IniWrite(@ScriptDir & "\ApachePortable.ini", "Expert", "CygwinDeleteInstallation", Bool($settings_chk_CygwinDeleteInstallation))
	IniWrite(@ScriptDir & "\ApachePortable.ini", "Expert", "ApacheFirstInstallDeleteUnneededFiles", GuiCtrlRead($settings_input_ApacheFirstInstallDeleteUnneededFiles))
	IniWrite(@ScriptDir & "\ApachePortable.ini", "Static", "Username", GuiCtrlRead($settings_input_Username))
	GUIDelete($settings_form)
	ReadSettings()
EndFunc

Func ConfigExit()
	GUIDelete($settings_form)
EndFunc   ;==>ConfigExit

If Not FileExists(@ScriptDir & "\App\ApachePortable\xampp-portable-lite-win32-1.8.1-VC9.7z") then
	DownloadSetup()
 Endif

;If FileExists(@ScriptDir & "\App\ApachePortable\temp") then
;	DirRemove(@ScriptDir & "\App\ApachePortable\temp", 1)
; Endif

If FileExists(@ScriptDir & "\App\ApachePortable\xampp-portable-lite-win32-1.8.1-VC9.7z") then
	$ArcFile = @ScriptDir & "\App\ApachePortable\xampp-portable-lite-win32-1.8.1-VC9.7z"
	If @error Then Exit

	$Output = @ScriptDir & "\App\ApachePortable\temp"
	If @error Then Exit

	;$retResult = _7ZipExtractEx(0, $ArcFile, $Output)
	;If @error = 0 Then
		;If not FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp",@ScriptDir & "\")
		;	msgbox(0,"Error","FileMove failed!")
		;	exit(1)
		;endIf
EndIf


Func CybeTechMoveOriginals()
	DirCreate($BackupDir)
	DirCreate($BackupDir & "\apache\conf\")
	DirCreate($BackupDir & "\apache\conf\extra\")
	DirCreate($BackupDir & "\php\")

	For $iniMainValue = 1 To $iniMain[0][0]
		;ConsoleWrite($iniMain[$iniMainValue][0])
		;Is the selected file executable ?
		if $iniMain[$iniMainValue][0] == 'ApacheFirstInstallDeleteUnneededFiles' Then
			$ApacheFirstInstallDeleteUnneededFiles = StringSplit($iniMain[$iniMainValue][1], ",")

			for $iniMainExecutableExtensionArray=1 to ubound($ApacheFirstInstallDeleteUnneededFiles,1) -1

				;FileDelete (@ScriptDir & "\App\ApachePortable\CygwinConfig.exe")
				;DirRemove ( @ScriptDir & "\" & $ApacheFirstInstallDeleteUnneededFiles[$iniMainExecutableExtensionArray], 1)
				If not FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\" & $ApacheFirstInstallDeleteUnneededFiles[$iniMainExecutableExtensionArray] , $BackupDir & $ApacheFirstInstallDeleteUnneededFiles[$iniMainExecutableExtensionArray]) then
					;msgbox(0,"Error","FileMove " & @ScriptDir & "\App\ApachePortable\temp\xampp\" & $ApacheFirstInstallDeleteUnneededFiles[$iniMainExecutableExtensionArray] & " failed!")
					;exit(1)
				EndIf
			next
		EndIf
	next

	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\httpd.conf" , $BackupDir & "\apache\conf\httpd.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-ajp.conf" , $BackupDir & "\apache\conf\extra\httpd-ajp.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-default.conf" , $BackupDir & "\apache\conf\extra\httpd-default.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-autoindex.conf" , $BackupDir & "\apache\conf\extra\httpd-autoindex.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-dav.conf" , $BackupDir & "\apache\conf\extra\httpd-dav.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-info.conf" , $BackupDir & "\apache\conf\extra\httpd-info.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-languages.conf" , $BackupDir & "\apache\conf\extra\httpd-languages.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-mpm.conf" , $BackupDir & "\apache\conf\extra\httpd-mpm.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-multilang-errordoc.conf" , $BackupDir & "\apache\conf\extra\httpd-multilang-errordoc.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-proxy.conf" , $BackupDir & "\apache\conf\extra\httpd-proxy.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-ssl.conf" , $BackupDir & "\apache\conf\extra\httpd-ssl.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-userdir.conf" , $BackupDir & "\apache\conf\extra\httpd-userdir.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-vhosts.conf" , $BackupDir & "\apache\conf\extra\httpd-vhosts.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-xampp.conf" , $BackupDir & "\apache\conf\extra\httpd-xampp.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\apache\conf\extra\httpd-html.conf" , $BackupDir & "\apache\conf\extra\httpd-html.conf")
	FileMove(@ScriptDir & "\App\ApachePortable\temp\xampp\php\php.ini" , $BackupDir & "\php\php.ini")
EndFunc   ;==>CybeTechBuildTrayMenu


Func CybeTechRebuildPath()

	;------------------------------------------------------------------------------------------------------------------------
	;CybeSystems - LightTPD Config schreiben -> Portabel machen bzw. neuen Pfad erkennen, falls umkopiert
	;------------------------------------------------------------------------------------------------------------------------

	FileCopy(@ScriptDir & "\apache\conf\httpd.conf.dist", @ScriptDir & "\apache\conf\httpd.conf")
	FileCopy(@ScriptDir & "\apache\conf\extra\httpd-ajp.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-ajp.conf")
	FileCopy(@ScriptDir & "\apache\conf\extra\httpd-autoindex.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-autoindex.conf")
	FileCopy(@ScriptDir & "\apache\conf\extra\httpd-dav.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-dav.conf")
	FileCopy(@ScriptDir & "\apache\conf\extra\httpd-default.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-default.conf")
	FileCopy(@ScriptDir & "\apache\conf\extra\httpd-info.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-info.conf")
	FileCopy(@ScriptDir & "\apache\conf\extra\httpd-languages.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-languages.conf")
	FileCopy(@ScriptDir & "\apache\conf\extra\httpd-mpm.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-mpm.conf")
	FileCopy(@ScriptDir & "\apache\conf\extra\httpd-multilang-errordoc.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-multilang-errordoc.conf")
	FileCopy(@ScriptDir & "\apache\conf\extra\httpd-proxy.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-proxy.conf")
	FileCopy(@ScriptDir & "\apache\conf\extra\httpd-ssl.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-ssl.conf")
	FileCopy(@ScriptDir & "\apache\conf\extra\httpd-userdir.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-userdir.conf")
	FileCopy(@ScriptDir & "\apache\conf\extra\httpd-vhosts.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-vhosts.conf")
	FileCopy(@ScriptDir & "\apache\conf\extra\httpd-xampp.conf.dist", @ScriptDir & "\apache\conf\extra\httpd-xampp.conf")
	FileCopy(@ScriptDir & "\apache\conf\extra\proxy-html.conf.dist", @ScriptDir & "\apache\conf\extra\proxy-html.conf")
	FileCopy(@ScriptDir & "\php\php.ini.dist", @ScriptDir & "\php\php.ini")

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

	ConsoleWrite($PARENTPATH)
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


EndFunc   ;==>CybeTechBuildTrayMenu

Func DownloadSetup()
    Local $sFilePathURL = "http://www.cybesystems.com/xampp-portable-lite-win32-1.8.1-VC9.7z"
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
					FileMove(@ScriptDir & "\xampp-portable-lite-win32-1.8.1-VC9.7z",@ScriptDir & "\App\ApachePortable\xampp-portable-lite-win32-1.8.1-VC9.7z",1)
					GUISetState(@SW_HIDE, $hGUI)
					$downloadSuccess = True
                EndIf
    WEnd
EndFunc

ReadCmdLineParams()

Global $tray_ReStartApache,$tray_openbash,$AppsStopped,$tray_TrayExit,$tray_menu_seperator,$tray_menu_seperator2,$nSideItem3,$nTrayIcon1,$nTrayMenu1,$tray_openCygwinConfig,$tray_sub_QuickLaunch,$tray_sub_Drives,$tray_sub_QuickLink,$tray_menu_seperator_quick_launch,$tray_openXServer,$tray_openCygwinConfigPorts

if $cygwinTrayMenu == True and $CmdLine[0] == 0  and not _Singleton("ApachePortable.exe", 1) = 0 Then
BuildTrayMenu()
BuildMenu()
While 1
	Sleep(1000)
WEnd
EndIf

Func MenuRebuild()
	DeleteMenu()
	BuildMenu()
EndFunc   ;==>MMOwningRebuild

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
EndFunc   ;==>MMOwningBuildTrayMenu

Func ReStartApache()
	if ProcessExists("httpd.exe") Then
		While ProcessExists("httpd.exe")
			ProcessClose("httpd.exe")
		WEnd
	Else
		;ShellExecute(@ScriptDir & "\apache\bin\httpd.exe", "", @ScriptDir, "",@SW_HIDE)
		ShellExecute(@ScriptDir & "\apache\bin\httpd.exe", "", @ScriptDir, "",@SW_SHOW)
	EndIf
EndFunc   ;==>MMOwningBuildTrayMenu

Func BuildMenu()
	if ProcessExists("httpd.exe") Then
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

Func ReadCmdLineParams() 	;Read in the optional switch set in the users profile and set a variable - used in case selection
	;;Loop through every arguement
	;;$cmdLine[0] is an integer that is eqaul to the total number of arguements that we passwed to the command line

	Local $noCorrectParameter = True

	;Set Global Variables True/False first
	for $i = 1 to $cmdLine[0]
		select
			case $cmdLine[$i] = "-exit"
				if StringStripWS($CmdLine[$i + 1], 3) == 0 Then
					$exitAfterExec = False
				Else
					$exitAfterExec = True
				EndIf
				$noCorrectParameter = False

				Exit
		EndSelect
	Next

	for $i = 1 to $cmdLine[0]
		select
			;;If the arguement equal -h
			case $CmdLine[$i] = "-h"
				;check for missing argument
				if $i == $CmdLine[0] Then cmdLineHelpMsg()

				;Make sure the next argument is not another paramter
				if StringLeft($cmdline[$i+1], 1) == "-" Then
					cmdLineHelpMsg()
				Else
					;;Stip white space from the begining and end of the input
					;;Not alway nessary let it in just in case
					$msgHeader = StringStripWS($CmdLine[$i + 1], 3)
				endif
				$noCorrectParameter = False

		EndSelect
	Next

	;if no correct startup parameter is given try to use first parameter with path (needed for open with)
	If $CmdLine[0] <> 0 And $noCorrectParameter == True Then

	EndIf

EndFunc

Func cmdLineHelpMsg()
	ConsoleWrite('CybeSystems Apache Portable Launcher' & @LF & @LF & _
					'Syntax:' & @tab & 'ApachePortable.exe [options]' & @LF & @LF & _
					'Default:' & @tab & 'Display help message.' & @LF & @LF & _
					'Optional Options:' & @LF & _
					'-path ["path"]' & @tab & '-path "C:\Windows" open Windows folder' & @lf & _
					'-exit [0/1]' & @tab &  '-exit 0 let the cygwin window open, -exit 1 close the cygwin window after execution' & @lf)
	Exit
EndFunc

Exit