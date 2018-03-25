unit FidoInfos;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs,
  StdCtrls, InfoBtn, HTMLLite, PBFolderDialog, ExtCtrls, ComCtrls,
  OleCtrls;

type
  TfidoInfo = class(TForm)
    CBzurueck: TInfoButton;
    CBFido: TInfoButton;
    CBNode: TInfoButton;
    htmlFenster: ThtmlLite;
    CBgolded: TInfoButton;
    CBsonstiges: TInfoButton;
    OpenDialog1: TOpenDialog;
    zurueck: TInfoButton;
    vor: TInfoButton;
    CBHandbuch: TInfoButton;
    CBcheckDNS: TInfoButton;
    procedure tastendruecke(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CBzurueckClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CBFidoClick(Sender: TObject);
    procedure CBNodeClick(Sender: TObject);
    procedure CBgoldedClick(Sender: TObject);
    procedure CBSonstigesClick(Sender: TObject);
    procedure datei_oeffnen(name: String);
    procedure vorClick(Sender: TObject);
    procedure zurueckClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CBHandbuchClick(Sender: TObject);
    procedure CBcheckDNSClick(Sender: TObject);
  private
    { Private-Deklarationen}
  public
    { Public-Deklarationen}
  end;

var
  fidoInfo  : TfidoInfo;

implementation

uses HMenue, config, fontheight, Background, Output, AcrobatPDF, fpd_language,
  {pdf,} ShellApi, winsock;

{$R *.DFM}

var
  acrobat   : Boolean;
//  Pdf1      : TPdf;
  firsttime : Boolean;


procedure RegisterPDF;
var
  hOCX:integer;
  pReg: procedure;
begin
  hOCX := LoadLibrary(PChar(InstDir+'\pdf.ocx'));
  if (hOCX <> 0) Then
  begin
    pReg := GetProcAddress(hOCX,'DllRegisterServer');
    pReg; { Call the registration function }
    FreeLibrary(hOCX);
  end
end;

procedure TfidoInfo.tastendruecke(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Case Key of
   VK_Escape: CBzurueckClick(Sender);
   Ord('1'): If ssAlt in Shift Then CBFidoClick(Sender);
   Ord('2'): If ssAlt in Shift Then CBNodeClick(Sender);
   Ord('3'): If ssAlt in Shift Then CBgoldedClick(Sender);
   Ord('4'): If ssAlt in Shift Then CBsonstigesClick(Sender);
   Ord('F'): If ssAlt in Shift Then CBHandbuchClick(Sender);
   Ord('P'): If ssAlt in Shift Then CBcheckDNSClick(Sender);
  End;
end;


procedure TfidoInfo.CBzurueckClick(Sender: TObject);
begin
  fidoInfo.Close;
end;

procedure TfidoInfo.FormShow(Sender: TObject);
begin
  fidoInfo.WindowState := wsMaximized;
  htmlFenster.Height := fidoInfo.Height - 90;
  htmlFenster.Width  := fidoInfo.Width - 8;
  htmlFenster.Visible := True;
(*
  If Pdf1 <> NIL Then Begin
    Pdf1.Visible := False;
    Pdf1.Top := htmlFenster.Top;
    Pdf1.Left := htmlFenster.Left;
    Pdf1.Height := htmlFenster.Height;
    Pdf1.Width := htmlFenster.Width;
  End;
*)

  CBzurueck.Top := fidoInfo.Height - 66;
  CBzurueck.Left := fidoInfo.Width - 178;

  CBFido.Top := htmlFenster.Height;
  CBNode.Top := htmlFenster.Height;
  CBgolded.Top := htmlFenster.Height;
  CBsonstiges.Top := htmlFenster.Height;
  CBHandbuch.Top := CBFido.Top + CBFido.Height;
  CBcheckDNS.Top := CBHandbuch.Top;
  zurueck.Top := CBsonstiges.Top + CBsonstiges.Height;
  vor.Top := zurueck.Top;

  If bigFonts Then Begin
    CBFido.Width := CBFido.Width + 25;
    CBNode.Left := CBFido.Left + CBFido.Width;
    CBNode.Width := CBNode.Width + 25;
    CBgolded.Left := CBNode.Width + CBNode.Left;
    CBgolded.Width := CBgolded.Width + 50;
    CBsonstiges.Left := CBgolded.Left + CBgolded.Width;
    CBsonstiges.Width := CBsonstiges.Width + 25;
    CBHandbuch.Width := CBHandbuch.Width + 50;
    CBcheckDNS.Left := CBHandbuch.Left + CBHandbuch.Width;
    CBcheckDNS.Width := CBcheckDNS.Width + 30;
    zurueck.Left := zurueck.Left + 25;
    CBzurueck.Width := CBzurueck.Width + 25;
    vor.Left := vor.Left + 25;
  End;

  zurueck.Visible := false;
  vor.Visible := false;

  htmlFenster.ViewImages := true;

  htmlFenster.LoadFromFile(InstDir+'\binkley\FidoInfo\fido.htm');
  Caption := htmlFenster.DocumentTitle;
end;

procedure TfidoInfo.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  zurueck.Visible := false;
  vor.Visible := false;
  Hauptmenue.Visible := true;
end;

procedure TfidoInfo.CBFidoClick(Sender: TObject);
begin
  htmlFenster.Visible := True;
//  If Pdf1 <> NIL Then Pdf1.Visible := False;
  htmlFenster.ViewImages := true;
  htmlFenster.LoadFromFile(InstDir+'\binkley\FidoInfo\fido.htm');
  Caption := htmlFenster.DocumentTitle;
  CBFido.Enabled := false;
  CBFido.Refresh;
  CBNode.Enabled := true;
  CBNode.Refresh;
  CBgolded.Enabled := true;
  CBgolded.Refresh;
  CBsonstiges.Refresh;
  zurueck.Visible := false;
  vor.Visible := false;
end;

procedure TfidoInfo.CBNodeClick(Sender: TObject);
begin
  htmlFenster.Visible := True;
//  If Pdf1 <> NIL Then Pdf1.Visible := False;
  htmlFenster.ViewImages := true;
  htmlFenster.LoadFromFile(InstDir+'\binkley\FidoInfo\node\node.htm');
  Caption := htmlFenster.DocumentTitle;
  CBFido.Enabled := true;
  CBFido.Refresh;
  CBNode.Enabled := false;
  CBNode.Refresh;
  CBgolded.Enabled := true;
  CBgolded.Refresh;
  CBsonstiges.Refresh;
  zurueck.Visible := false;
  vor.Visible := false;
end;

procedure TfidoInfo.CBgoldedClick(Sender: TObject);
begin
  htmlFenster.Visible := True;
//  If Pdf1 <> NIL Then Pdf1.Visible := False;
  htmlFenster.LoadFromFile(InstDir+'\golded\goldusr.txt');
  Caption := htmlFenster.DocumentTitle;
  CBFido.Enabled := true;
  CBFido.Refresh;
  CBNode.Enabled := true;
  CBNode.Refresh;
  CBgolded.Enabled := false;
  CBgolded.Refresh;
  CBsonstiges.Refresh;
  zurueck.Visible := false;
  vor.Visible := false;
end;


function GetDrives(DriveType:integer; var DriveList:String):byte;
(*
  {Wechselplatten:}
  LWCount:=GetDrives(DRIVE_REMOVABLE);
  {Festplatten:}
  LWCount:=GetDrives(DRIVE_FIXED);
  {Netzlaufwerke:}
  LWCount:=GetDrives(DRIVE_REMOTE);
  {CD-ROM:}
  LWCount:=GetDrives(DRIVE_CDROM);
  {RAM-Disks:}
  LWCount:=GetDrives(DRIVE_RAMDISK);
*)
var Drives  : array [1..255] of char;
    LWListe : TStringList;
    i         : byte;
    Len     : DWord;
begin
  LWListe:=TStringList.Create;
  {Alle Laufwerke ermitteln}
  Len:=GetLogicalDriveStrings(255,@Drives);
  for i:=1 to Len-2 do
    if (i mod 4)=1 then
      LWListe.Add(copy(Drives,i,3));
  {Laufwerke des angegebenen Typs zählen}
  Result:=0;
  DriveList := '';
  for i:=0 to LWListe.Count-1 do begin
    if GetDriveType(PChar(LWListe[i]))=DriveType then begin
      Result:=Result+1;
      DriveList := DriveList + copy(LWListe[i],1,1)
    end;
  end;
  LWListe.Destroy;
end;

function VolumeID(DriveChar: Char): string;
var
  OldErrorMode      : Integer;
  NotUsed, VolFlags : DWORD;
  Buf               : array [0..MAX_PATH] of Char;
begin
  OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    GetVolumeInformation(PChar(DriveChar + ':\'), Buf,
                         sizeof(Buf), nil, NotUsed, VolFlags,
                         nil, 0);
    Result := Format('[%s]',[Buf]);
  finally
    SetErrorMode(OldErrorMode);
  end;
end;


procedure TfidoInfo.datei_oeffnen(name: String);
var i         : Integer;
    ext       : String;
    cap       : String;
begin
  OpenDialog1.Filename := name;

  ext := LowerCase(name);
  i := Length(ext);
  While (i > 0) and (ext[i] <> '.') Do Dec(i);
  If (i > 0) Then ext := Copy(ext,i+1,Length(ext));

  If ((ext = 'htm') or (ext = 'html')) Then Begin
    htmlFenster.LoadFromFile(name);
    Caption := htmlFenster.DocumentTitle;
    If Caption = '' Then Begin
      cap := name;
      Delete(cap,1,Length(OpenDialog1.InitialDir)+1);
      Caption := 'Sonstiges (' + cap + ')';
    End;
  End
  Else If (ext = 'jpg') or (ext = 'gif') Then Begin
    htmlFenster.LoadImageFile(name);
    cap := name;
    Delete(cap,1,Length(OpenDialog1.InitialDir)+1);
    Caption := 'Sonstiges (' + cap + ')';
  End
  Else {If ext = 'txt' Then} Begin
    htmlFenster.LoadTextFile(name);
    cap := name;
    Delete(cap,1,Length(OpenDialog1.InitialDir)+1);
    Caption := 'Sonstiges (' + cap + ')';
  End;
end;


procedure TfidoInfo.CBSonstigesClick(Sender: TObject);
var DriveList : String;
    LWCount   : byte;
    i         : Integer;
    name      : String;
    pfad      : String;
    ext       : String[4];
    meldung   : TStringList;
    cdName    : String;
begin
  htmlFenster.Visible := True;
//  If Pdf1 <> NIL Then Pdf1.Visible := False;
  CBFido.Enabled := true;
  CBFido.Refresh;
  CBNode.Enabled := true;
  CBNode.Refresh;
  CBgolded.Enabled := true;
  CBgolded.Refresh;
  CBsonstiges.Refresh;
  zurueck.Visible := false;
  vor.Visible := false;

  cdName := '';
  LWCount := GetDrives(DRIVE_CDROM, DriveList);
  For i := 1 to LWCount Do Begin
    cdName := VolumeID(DriveList[i]);
    If (cdName = '[FIDO]') or (Pos('WIF-CD', cdName) > 0) Then break;
  End;

  If (LWCount = 0) or ( (cdName <> '[FIDO]')
                  and (Pos('WIF-CD', cdName) = 0) ) Then Begin
    meldung := TStringList.Create;
    meldung.Add('');
    meldung.Add(' ' + s[0156]);
    htmlFenster.LoadTextStrings(meldung);
    meldung.Free;
    Exit;
  End;

  pfad := LowerCase(DriveList[i]+':\sonst');
  OpenDialog1.InitialDir := pfad;
  OpenDialog1.Filter := 'All Files (*.*)|*.*' +
    '|HTML Files (*.htm,*.html)|*.htm;*.html' +
    '|Text Files (*.txt)|*.txt' +
    '|' + s[0157] + ' (*.jpg)|*.jpg';
  If OpenDialog1.Execute Then Begin
    name := OpenDialog1.Filename;
    If Length(name) < (Length(pfad)+6) Then Exit; // Pfad + Name
    If LowerCase(Copy(name,1,Length(pfad))) <> OpenDialog1.InitialDir Then Exit;

    ext := LowerCase(Copy(name,Length(name)-3,4));
    htmlFenster.ViewImages := (ext = '.jpg') or (ext = '.gif');

    zurueck.Visible := true;
    vor.Visible := true;

    datei_oeffnen(name);
  End;
end;

procedure TfidoInfo.vorClick(Sender: TObject);
var i         : Integer;
    name      : String;
    pfad      : String;
    SearchRec : TSearchRec;
    gefunden  : Boolean;
begin
  pfad := OpenDialog1.Filename;
  i := Length(pfad);
  While (i > 0) and (pfad[i] <> '\') Do Dec(i);
  If (i = 0) Then Exit;

  name := Copy(pfad,i+1,Length(pfad));
  pfad := Copy(pfad,1,i);

  gefunden := false;
  FindFirst(pfad+'*.*', faAnyFile-(faVolumeID+faDirectory), SearchRec);
  If SearchRec.Name = name Then gefunden := true;

  While not gefunden and (FindNext(SearchRec) = 0) Do
    If SearchRec.Name = name Then gefunden := true;

  If gefunden Then Begin
    gefunden := false;
    If (FindNext(SearchRec) = 0) Then Begin
      gefunden := true;
      name := SearchRec.Name;
    End;
  End;
  FindClose(SearchRec);
  If not gefunden Then Exit;

  name := pfad + name;
  datei_oeffnen(name);
end;

procedure TfidoInfo.zurueckClick(Sender: TObject);
var i         : Integer;
    name      : String;
    lastname  : String;
    pfad      : String;
    SearchRec : TSearchRec;
    gefunden  : Boolean;
begin
  pfad := OpenDialog1.Filename;
  i := Length(pfad);
  While (i > 0) and (pfad[i] <> '\') Do Dec(i);
  If (i = 0) Then Exit;

  name := Copy(pfad,i+1,Length(pfad));
  pfad := Copy(pfad,1,i);

  FindFirst(pfad+'*.*', faAnyFile-(faVolumeID+faDirectory), SearchRec);
  lastname := SearchRec.Name;
  gefunden := false;

  While not gefunden and (FindNext(SearchRec) = 0) Do
    If SearchRec.Name = name Then gefunden := true
                             Else lastname := SearchRec.Name;

  FindClose(SearchRec);
  If lastname = '' Then gefunden := false;
  If not gefunden Then Exit;

  name := pfad + lastname;
  datei_oeffnen(name);
end;

procedure TfidoInfo.FormCreate(Sender: TObject);
var DC: hDc;
begin
  firsttime := True;

  Scaled := true;
  x := Screen.Width;
  y := Screen.Height;
  if (x<>ScreenWidthDev) or (y<>ScreenHeightDev) then begin
    If not SmallFonts Then Begin
      bigFonts := true;
      DC := GetDC(0);
      ScaleBy(96,GetDeviceCaps(DC,LOGPIXELSX));
      ReleaseDC(0,DC);
      Refresh;
    End;
  end; // of if
  Font.OnChange(Self);

  If sprache <> 'deutsch' Then Begin
    fidoInfo.Caption := s[0158];
    CBFido.Caption := s[0159];
    CBNode.Caption := s[0160];
    CBgolded.Caption := s[0161];
    CBsonstiges.Caption := s[0162];
    CBcheckDNS.Caption := s[0290];
    CBHandbuch.Caption := s[0291];
    zurueck.Caption := s[0164];
    vor.Caption := s[0165];
    CBzurueck.Caption := s[0166];
  End;
end;

procedure TfidoInfo.CBHandbuchClick(Sender: TObject);
begin
  ShellExecute(Handle,'open',
  PChar(InstDir + '\binkley\FidoInfo\fpd.pdf'), nil, nil, SW_SHOWNORMAL);

(*
  If firsttime Then Begin
    firsttime := False;
    acrobat := AcrobatIsInstalled;
    If acrobat Then Begin
      // pdf.ocx registrieren
      RegisterPDF;

//      CreateEmbeddedPdfViewer(pdf1, fidoInfo);
//      Pdf1 := TPdf.Create(Self);
//      Pdf1.Parent := Pdf1;
    End;
(*
    If Pdf1 <> NIL Then Begin
      Pdf1.Top := htmlFenster.Top;
      Pdf1.Left := htmlFenster.Left;
      Pdf1.Height := htmlFenster.Height;
      Pdf1.Width := htmlFenster.Width;
      If not bigFonts Then Begin
        If Pdf1 <> NIL Then If Pdf1.Width > 750 Then Pdf1.Width := 750;
      End
      Else Begin
        If Pdf1 <> NIL Then If Pdf1.Width > 938 Then Pdf1.Width := 938;
      End;
    End;
*)
(*
  End;

  htmlFenster.Visible := False;

(*
  If Pdf1 <> NIL Then Begin // PDF anzeigen
    Pdf1.Visible := True;
    Pdf1.src := InstDir + '\binkley\FidoInfo\fpd.pdf';
  End
*)
(*
  If acrobat Then Begin // PDF anzeigen
    Application.CreateForm(TfrmPdf, frmPdf);
    frmPdf.Pdf1.src := InstDir + '\binkley\FidoInfo\fpd.pdf';
//    fidoInfo.Visible := False; // manchmal Fehler, kehrt nicht sauber zurück
    frmPdf.ShowModal;
//    Sleep(10000);
    fidoInfo.Visible := True;
    CBFidoClick(Sender);
    Exit;
  End
  Else Begin // Hinweis anzeigen, wo es den Acrobat Reader gibt
    Application.MessageBox(PChar(s[0249]), sprache_Fehler, MB_OK);
    CBFidoClick(Sender);
    Exit;
  End;
*)
end;

function GetIpFromDns(dns:String):String;
type PPInAddr= ^PInAddr;
var
 WSAData: TWSAData;
 RemoteHost: PHostEnt;
 Addr: PPInAddr;
begin
  result:=''; // default is empty
  if WSAStartup(MAKEWORD(2,0),WSAData)=0 then
  begin
    RemoteHost := gethostbyName(PChar(dns));
    if (RemoteHost = NIL) Then result := ''
    else begin
      Addr:=Pointer(RemoteHost^.h_addr_list);
      Result:=StrPas(inet_ntoa(Addr^^));
    end;

    WSACleanup;
  end;
end;

procedure TfidoInfo.CBcheckDNSClick(Sender: TObject);
var url, dns, ip: AnsiString;
    f: TextFile;
    zeile: String;
    i: Integer;
    meldung: String;
begin
  dns := '';

  // lese DNS des Nodes aus binkd.cfg
  Assignfile(f, InstDir + '\binkley\binkd.cfg');
  {$I-}
  Reset(f);
  While not EOF(f) Do Begin
    Readln(f, zeile);
    if (Pos('node ', zeile) = 1) Then Begin
      Delete(zeile, 1, 5);
      While (Length(zeile) > 1) and (zeile[1] = ' ') Do Delete(zeile,1,1);
      i := Pos(' ', zeile);
      if (i > 0) Then Delete(zeile, 1, i);
      While (Length(zeile) > 1) and (zeile[1] = ' ') Do Delete(zeile,1,1);
      i := Pos(' ', zeile);
      if (i > 1) Then Begin
        dns := Copy(zeile, 1, i-1);
        i := Pos(';', dns); // nur einen DNS-Eintrag
        if (i > 1) Then Delete(dns, i, Length(dns));
      End;
      Break; // nicht weiter suchen
    End;
  End;
  Closefile(f);
  {$I+}

  // wenn Fehler beim Lesen aufgetreten, dann abbrechen
  If (IOResult <> 0) Then Begin
      meldung := s[0292];
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
      Exit;
  End;
  // wenn kein DNS enthalten, dann abbrechen
  If (dns = '') Then Begin
      meldung := s[0293];
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
      Exit;
  End;

  // DNS-Lookup
  ip := GetIpFromDns(dns);

  // IP-Adressen vergleichen, um DNS-Cache zu testen
  url := 'http://www.it-dienste.de/fpd/dnslookup.php?dn=';
  url := url + dns + '&ip=' + ip;
  ShellExecute(0, 'open', PChar(url), nil, nil, SW_SHOW);
end;

end.
