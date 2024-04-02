for /f %%i in (0.txt) do shutdown -r -m \\%%i -f -t 20 -c "Restarting for Patch update"

pause