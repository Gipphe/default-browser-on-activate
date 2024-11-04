#Include JSON.ahk

config_str := FileRead('./config.json')
config := JSON.Load(config_str)

SetTitleMatchMode RegEx

; Create window groups for each browser
for browserID, browserMatchPath in config.browsers {
    GroupAdd browserID, "ahk_exe " . browserMatchPath
}

; Set up a window message hook for window activation
Gui +LastFound
hwnd := WinExist()
DllCall("RegisterShellHookWindow", "UInt", hwnd)
MsgNum := DllCall("RegisterWindowMessage", "Str", "SHELLHOOK")
OnMessage(MsgNum, "ShellMessage")

ShellMessage(wParam, lParam) {
    ; HSHELL_WINDOWACTIVATED := 4
    ; HSHELL_RUDEAPPACTIVATED := 32772
    if (wParam = 4 || wParam = 32772) {
        WinGetTitle, title, ahk_id %lParam%
        for browserID, browserName in config.browsers {
            if (WinActive("ahk_group " . browserID)) {
                MsgBox, "Detected activation of " . browserName
                ; Run, "path/to/your/script.sh"
                break
            }
        }
    }
}

