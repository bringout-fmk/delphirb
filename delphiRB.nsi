; delphiRB.nsi
;
; This script attempts to test most of the functionality of NSIS.
;
; 
;
; This script is perhaps one of the simplest NSIs you can make. All of the
; optional settings are left to their default settings. The instalelr simply 
; prompts the user asking them where to install, and drops of notepad.exe
; there. If your Windows directory is not C:\windows, change it below.
;

; The name of the installer
Name "DelphiRB, Sigma-com"
InstType Normal
ShowInstDetails show
SetOverwrite on

; The file to write
OutFile "z:\fmk\delphiRB.exe"

; The default installation directory
InstallDir c:\sigma
InstallDirRegKey HKLM SOFTWARE\sigma-com\util ""

; The text to prompt the user to enter a directory
DirText "Instalacija DelphiRB 01.33 na vas racunar. Odaberite direktorij"


Section "DLL (required)"
  SectionIn 1
  SetOutPath $SYSDIR
  SetOverwrite on
  File "c:\windows\system32\ace32.dll"
  File "c:\windows\system32\adsloc32.dll"
  File "c:\windows\system32\adslocal.cfg"
  File "c:\windows\system32\axcws32.dll"
  File "c:\windows\system32\extend.chr"
  File "c:\windows\system32\ansi.chr"
SectionEnd


Section "DELPHIRB "
  SectionIn 1
  SetOutPath $INSTDIR
  SetOverwrite on
  File delphirb.exe


;SectionEnd
;Section "DELPHIRB Start Menu Group"
;  SectionIn 1

  SetOutPath $INSTDIR
  CreateDirectory "$SMPROGRAMS\sigma-com\util"
  CreateShortCut "$SMPROGRAMS\sigma-com\util\DelphiRB.lnk" \
                 "$INSTDIR\DelphiRB.exe"
                 
SectionEnd


Function .onInstSuccess
  MessageBox MB_ICONQUESTION \
             "Setup je zavrsen ..." 

FunctionEnd

; eof
