unit fontheight;
      // es kommen nur TrueType Schriftarten in Frage (Scalierbarkeit)
      // jede Form braucht diese UNIT
interface

  function SmallFonts : Boolean;

implementation

uses windows;

function SmallFonts : Boolean;
var dc : hdc;
begin
    dc := GetDC(0); Result:=(GetDeviceCaps(dc,LOGPIXELSX)=96); ReleaseDC(0,DC);
end;

end.

