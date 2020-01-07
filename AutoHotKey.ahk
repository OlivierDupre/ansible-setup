; Must be located in the startup folder.
; To find the startup folder running
; Win+R -> shell:startup

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force

; Run Ubuntu directly with F12, starting bash
^F12::
Process, Exist, ubuntu1804.exe
If !ErrorLevel ; is not running
{
    Run, ubuntu1804.exe
    return
}
pid := ErrorLevel
IfWinNotActive ahk_pid %pid%
    WinActivate ahk_pid %pid%
else
    WinMinimize ahk_pid %pid%
return

; Start terminator with CTRL-F12, if installed as described here: 
; - https://medium.com/@bhupathy/install-terminator-on-windows-with-wsl-2826591d2156 
; - https://www.pofilo.fr/post/20190727-terminator/
; And setup with:
; - https://gist.github.com/Raneomik/202f5adb964723b16d14c3799d28e1e2
F12::
Process, Exist, vcxsrv.exe
If !ErrorLevel ; is not running
{
    Run, D:\workspace\tech\ansible-setup\wsl-terminator.vbs
    return
}
pid := ErrorLevel
IfWinNotActive ahk_pid %pid%
    WinActivate ahk_pid %pid%
else
    WinMinimize ahk_pid %pid%
return