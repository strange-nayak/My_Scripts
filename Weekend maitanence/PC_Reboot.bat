for /f %%i in (machine_list.txt) do shutdown -r -m \\%%i -f -t 20 -c "Restarting for Patch update"