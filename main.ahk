#Include WinHook.ahk

section := IniRead("config.ini", "browsers")
browsers := Map()
for k, keyVar in strsplit(section, "`n") {
    parts := strsplit(keyVar, "=", "`n`r")
    browsers[parts[1]] := { pathMatch: parts[2], groupName: "browser" . k }
}

SetTitleMatchMode "RegEx"

; Create window groups for each browser
for browserID, conf in browsers {
    GroupAdd conf.groupName, "ahk_exe " . conf.pathMatch
}

; Debug message to confirm script is running
MsgBox "Script started - monitoring browser windows"

ForeGroundChange(hWinEventHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime) {
    static Focus
    className := WinGetClass("ahk_id" . hwnd)
    MsgBox "className: " . className
    ; MsgBox "wParam: " . wParam . ", lParam: " . lParam . ", msg: " . msg . ", hwnd: " . hwnd
    ; if (wParam = 4 || wParam = 32772) {
    ;     MsgBox "Detected activation"
    ;     ; WinGetTitle title, "ahk_id" . lParam
    ;     for browserID, conf in browsers {
    ;         if (WinActive("ahk_group " . conf.groupName)) {
    ;             MsgBox "Detected activation of " . browserID
    ;             ; Run, "path/to/your/script.sh"
    ;             break
    ;         }
    ;     }
    ; }
}

WinHook.Event.Add(3, 3, "ForeGroundChange") ; 3 = EVENT_SYSTEM_FOREGROUND
Persistent