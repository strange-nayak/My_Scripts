for /f %%i in (test.txt) do shutdown -r -m \\%%i -f -t 20 -c "Restarting for Patch update"

Pause