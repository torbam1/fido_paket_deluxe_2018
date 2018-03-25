unit Background;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

const version         = 'v2.9.040207'; // Versionsnummer mit Tag/Monat/Jahr
      ScreenWidthDev  = 1280;
      ScreenHeightDev = 1024;
type
  THintergrund = class(TForm)
    Ueberschrift: TLabel;
    procedure FormPaint(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure rasapi32_dll_registrieren;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen}
  public
    { Public-Deklarationen}
  end;

var
  Hintergrund: THintergrund;

implementation

uses ComServ, OLECtl, Install, Dateneingabe, kopieren, PollAnzeige, inSuche;

{$R *.DFM}

procedure THintergrund.FormPaint(Sender: TObject);
var a: Integer;
begin
  Ueberschrift.Color := rgb(0,0,255);
  For a:=0 To Hintergrund.ClientHeight Do
  Begin
    Hintergrund.Canvas.pen.color := rgb(0,0,255 - Round(255/Hintergrund.Clientheight*a));
    Hintergrund.Canvas.moveto(0,a);
    Hintergrund.Canvas.lineto(Hintergrund.clientwidth,a);
  End;
  If firsttime and not Angaben.Visible Then Form1.Show;

  // unerwarteter Fehler, kein Fenster mehr offen -> Programm beenden
  If not Angaben.Visible and not Form1.Visible and not Installieren.Visible
     and not Pollen.Visible and PollAbbruch Then Halt(66);
end;

procedure THintergrund.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := false;
end;

procedure THintergrund.rasapi32_dll_registrieren;
var
   OCXHand: THandle;
   RegFunc: TDllRegisterServer;   //add  to the uses clause
begin
   OCXHand:= LoadLibrary('c:\kalle\rasapi33.dll');
   RegFunc:= GetProcAddress(OCXHand, 'DllRegisterServer');  //case sensitive
   if RegFunc <> 0 then
     RegFunc
   else
     ShowMessage('Error!');
   FreeLibrary(OCXHand);

end;

procedure THintergrund.FormCreate(Sender: TObject);
var x,y: Integer; // für Bildschirmauflösung
begin
//  rasapi32_dll_registrieren;
//  Application.CreateForm(TForm1, Form1);
//  Application.CreateForm(TAngaben, Angaben);
//  Application.CreateForm(TInstallieren, Installieren);
//  Application.CreateForm(Tpollen, pollen);
//  Application.CreateForm(TinternetSearch, internetSearch);
//  Form1.Show;

  firsttime := true;

  Scaled := true;
  x := Screen.Width;
  y := Screen.Height;
  if (x<>ScreenWidthDev) or (y<>ScreenHeightDev) then begin
    Hintergrund.Height := (Hintergrund.ClientHeight*y div ScreenHeightDev) +
                           Hintergrund.Height - Hintergrund.ClientHeight;
    Hintergrund.Width := (Hintergrund.ClientWidth*x div ScreenWidthDev) +
                          Hintergrund.Width - Hintergrund.ClientWidth;
    ScaleBy(x,ScreenWidthDev);
  end; // of if
end;

end.
