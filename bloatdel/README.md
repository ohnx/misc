# bloatdel

remove bloatware from windows 10 using powershell (run as administrator)

Don't forget to enable scripts:

```
Set-ExecutionPolicy Unrestricted
```

Be sure to also remove re-installing using:

```
Computer Configuration > Administrative Templates > Windows Components > Cloud Content > Turn off Microsoft consumer experiences.
```

This script does not uninstall:

* Skype video
* Candy Crush
* Twitter
* Microsoft Wi-Fi
