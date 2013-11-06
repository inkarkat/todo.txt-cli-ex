@echo off %DEBUG%
"C:\cygwin\bin\bash" -c "CHERE_INVOKING=1 . /etc/profile; . ~/.bashrc; exec %*"
