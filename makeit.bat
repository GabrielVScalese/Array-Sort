set projectName=main
@echo off

    if exist "%projectName%.obj" del "%projectName%.obj"
    if exist "%projectName%.exe" del "%projectName%.exe"

    \masm32\bin\ml /c /coff "%projectName%.asm"
    if errorlevel 1 goto errasm

    \masm32\bin\PoLink /SUBSYSTEM:CONSOLE "%projectName%.obj"
    if errorlevel 1 goto errlink
    dir "%projectName%.*"
    goto TheEnd

  :errlink
    echo _
    echo Link error
    goto TheEnd

  :errasm
    echo _
    echo Assembly Error
    goto TheEnd
    
  :TheEnd

pause
