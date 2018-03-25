unit kopieren;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, jpeg, ExtCtrls, ComCtrls;

type
  TInstallieren = class(TForm)
    Rahmen: TShape;
    imgHund: TImage;
    Mitteilung: TStaticText;
    cmdAbbruch: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cmdAbbruchClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private-Deklarationen}
  public
    { Public-Deklarationen}
  end;

function DelTree(DirName : string): Boolean;

var
  Installieren: TInstallieren;


implementation

uses ShellApi, ras, Dateneingabe, fpd_language;

{$R *.DFM}

procedure TInstallieren.FormCreate(Sender: TObject);
begin
  If Installieren.Width < (Rahmen.Width + 40) Then
    Installieren.Width := Rahmen.Width + 40;

  Mitteilung.Caption := s[0088];
end;

Function DelTree(DirName : string): Boolean;
{
uses ShellAPI;
Completely deletes a directory regardless
of whether the directory is filled or has
subdirectories.  No confirmation is requested
so be careful. If the operation is successful
then True is returned, False otherwise.

Usage:
if DelTree('c:\TempDir') then
  ShowMessage('Directory deleted!')
else
  ShowMessage('Errors occured!');
}
var
 SHFileOpStruct : TSHFileOpStruct;
 DirBuf         : array [0..255] of char;
begin
 try
  Fillchar(SHFileOpStruct,Sizeof(SHFileOpStruct),0);
  FillChar(DirBuf, Sizeof(DirBuf), 0 );
  StrPCopy(DirBuf, DirName);
  with SHFileOpStruct do begin
   Wnd    := 0;
   pFrom  := @DirBuf;
   wFunc  := FO_DELETE;
   fFlags := FOF_ALLOWUNDO;
   fFlags := fFlags or FOF_NOCONFIRMATION;
   fFlags := fFlags or FOF_SILENT;
  end;
   Result := (SHFileOperation(SHFileOpStruct) = 0);
  except
   Result := False;
 end;
end;


procedure TInstallieren.cmdAbbruchClick(Sender: TObject);
var verz    : String[20];
    meldung : String;
    info    : String;
begin
  If cmdAbbruch.Caption = 'OK' Then Halt; // Installation abgeschlossen

  // fragen, ob wirklich abgebrochen werden soll
  meldung := s[0089];
  info := s[0090];

  If Application.MessageBox(
        PChar(meldung), PChar(info), MB_YesNo) = ID_No Then Exit;


  // wenn wirklich abbrechen, dann fragen, ob bereits kopierte Dateien gelöscht
  // werden sollen
  meldung := s[0091];
  info := s[0079];

  If Application.MessageBox(PChar(meldung), PChar(info), MB_YesNo) = ID_Yes Then
  Begin
    DelTree(InstDir);

    If OS = 0 Then verz := WinDir + 'command\'
              Else verz := WinDir;
    DeleteFile(verz + 'unrar.exe');
    DeleteFile(verz + 'xarc.exe');
    DeleteFile(verz + 'unzip.exe');
    DeleteFile(verz + 'zip.exe');

    { Eintrag im DFÜ Netzwerk entfernen }
    If not netzwerk and not internet
     Then RasDeleteEntry(nil, PChar('Fido-Paket deluxe'));

    Application.MessageBox(PChar(s[0092]), PChar(s[0079]), MB_Ok);
  End;

  Halt(3);
end;


procedure TInstallieren.FormPaint(Sender: TObject);
var a: Integer;
begin
  For a:=0 To Installieren.ClientHeight Do
  Begin
    Installieren.Canvas.pen.color := rgb(0,0,255 - Round(255/Installieren.Clientheight*a));
    Installieren.Canvas.moveto(0,a);
    Installieren.Canvas.lineto(Installieren.clientwidth,a);
  End;
end;

end.
