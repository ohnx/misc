# list of names from https://www.howtogeek.com/224798/how-to-uninstall-windows-10s-built-in-apps-and-how-to-reinstall-them/

$bloat0 = "*3dbuilder*","*windowsalarms*","*windowscalculator*","*messaging*","*windowscamera*","*officehub*","*skypeapp*"
$bloat1 = "*getstarted*","*zunemusic*","*windowsmaps*","*solitairecollection*","*bingfinance*","*zunevideo*","*bingnews*","*onenote*"
$bloat2 = "*people*","*phone*","*photos*","*windowsstore*","*bingsports*","*soundrecorder*","*bingweather*","*sway*","*xboxapp*"

$bloats = $bloat0 + $bloat1 + $bloat2

Foreach ($bloat in $bloats)
{
  Get-AppxPackage $bloat | Remove-AppxPackage
}
