unit Logfile;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, StdCtrls, ComCtrls,
  InfoBtn, Background;

type
  TfrmLogfile = class(TForm)
    Logfile: TListBox;
    Datumsauswahl: TDateTimePicker;
    CBzurueck: TInfoButton;
    CBlogfileKuerzen: TInfoButton;
    LogInfo: TLabel;
    logBinkD: TInfoButton;
    logIRC: TInfoButton;
    logHPT: TInfoButton;
    procedure tastendruecke(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CBzurueckClick(Sender: TObject);
    procedure CBlogfileKuerzenClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    function  getFileSize(fname: String): String;
    procedure logFileOeffnen(logname: String);
    procedure logBinkDClick(Sender: TObject);
    procedure logIRCClick(Sender: TObject);
    procedure logHPTClick(Sender: TObject);
    procedure DatumsauswahlCloseUp(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen}
  public
    { Public-Deklarationen}
  end;

  function  getFileSizeVal(fname: String): Integer;

var
  frmLogfile: TfrmLogfile;

implementation

{$R *.DFM}

uses HMenue, fpd_language, config;

procedure TfrmLogfile.tastendruecke(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Hot-Keys
  Case Key of
   VK_Escape: CBzurueckClick(Sender);
   Ord('K'): If ssAlt in Shift Then CBlogfileKuerzenClick(Sender);
   Ord('1'): If ssAlt in Shift Then logBinkDClick(Sender);
   Ord('2'): If ssAlt in Shift Then logIRCClick(Sender);
   Ord('3'): If ssAlt in Shift Then logHPTClick(Sender);
  End;
end;


function getFileSizeVal(fname: String): Integer;
// Dateigrösse bestimmen
var f           : File of Char;
    i           : Integer;
begin
  Assignfile(f, fname);
  {$I-}
  Reset(f);
  i := FileSize(f) div 1024; // in Kilobytes
  Closefile(f);
  {$I+}
  IF IOResult <> 0 Then getFileSizeVal := -1 // Logfile nicht vorhanden
                   Else getFileSizeVal := i;
end;

procedure TfrmLogfile.CBzurueckClick(Sender: TObject);
// zurück zum Hauptmenü
begin
  frmLogfile.Close;
end;

procedure TfrmLogfile.CBlogfileKuerzenClick(Sender: TObject);
// angezeigtes Logfile kürzen, wenn dieses grösser als 300 KB ist
var f, g         : Textfile;
    Buf, Buf2    : Array[1..31744] of Char; // 31K buffer
    logName      : String;
    logNameTemp  : String;
    i            : Integer;
    zuViel       : Real;
    anzahlZeilen : Longword;
    zeile        : String;
begin
  // Dateiname des gerade angezeigten Logfiles bestimmen
  logName := InstDir+'\';
  If not logBinkD.enabled  Then logName := logName + 'binkley\binkd.log';
  If not logIRC.enabled Then logName := logName + 'golded\golded.log';
  If not logHPT.enabled    Then logName := logName + 'binkley\hpt\hpt.log';
  logNameTemp := Copy(logName,1,Length(logName)-3) + 'tmp';

  i := getFileSizeVal(logName); // Dateigrösse bestimmen
  If i <= 300 Then Begin
    Application.MessageBox(PChar(s[0150]), sprache_Hinweis, MB_OK);
    Exit;
  End;

  zuViel := 1 - (300 / i); // Logfile zu groß in Prozent
  anzahlZeilen := 0;

  Assignfile(f, logName);
  System.SetTextBuf(f, Buf); // dem Logfile einen Buffer zuweisen
  Reset(f);
  While not EOF(f) Do Begin
    Readln(f);
    Inc(anzahlZeilen);
  End;

  zuViel := anzahlZeilen * zuViel; // ungefähre Zeilenanzahl, die zu viel ist

  Reset(f);
  Assignfile(g, logNameTemp);
  System.SetTextBuf(g, Buf2); // dem Logfile einen Buffer zuweisen
  Rewrite(g);
  For i := 1 to Trunc(zuViel) Do Readln(f);

  While not EOF(f) Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;

  Closefile(f);
  Closefile(g);
  Erase(f);
  Rename(g, logName);

  If not logBinkD.enabled  Then logBinkDClick(Sender);
  If not logIRC.enabled Then logIRCClick(Sender);
  If not logHPT.enabled    Then logHPTClick(Sender);
end;

function TfrmLogfile.getFileSize(fname: String): String;
var f           : File of Char;
    f_groesse   : String;
    log_groesse : String;
    i           : Integer;
begin
  Assignfile(f, fname);
  {$I-}
  Reset(f);
  Str(FileSize(f) div 1024, f_groesse);
  Closefile(f);
  {$I+}
  IF IOResult <> 0 Then Begin
    Result := 'n/a'; // not available -> Logfile nicht vorhanden
    Exit;
  End;

  log_groesse := '';
  While Length(f_groesse) > 3 Do Begin
    i := Length(f_groesse);
    log_groesse := '.' + Copy(f_groesse,i-2,3) + log_groesse;
    Delete(f_groesse,i-2,3);
  End;
  log_groesse := f_groesse + log_groesse;

  Result := log_groesse;
end;

procedure TfrmLogfile.FormShow(Sender: TObject);
begin
  // beim Aufrufen der Form das BinkD-Logfile anzeigen
  logBinkDClick(Sender);
end;

procedure TfrmLogfile.logFileOeffnen(logname: String);
var log_groesse : String;
    f           : Textfile;
    Buf         : Array[1..31744] of Char; // 31K buffer
    zeile       : String;
    zeile2      : String;
    i, j        : Integer;
    oldFileMode : Byte;
begin
  log_groesse := getFileSize(logname);
  If log_groesse = 'n/a'
   Then LogInfo.Caption := s[0151]
   Else LogInfo.Caption := Format(s[0152], [log_groesse]);

  CBlogfileKuerzen.Enabled := not (log_groesse = 'n/a');

  Logfile.Items.Clear;

  Assignfile(f, logname);
  oldFileMode := FileMode;
//  FileMode := 0;
  System.SetTextBuf(f, Buf); // dem Logfile einen Buffer zuweisen
  {$I-} Reset(f); {$I+}
  FileMode := oldFileMode;
  IF IOResult <> 0 Then Exit;

  While not EOF(f) Do Begin
    Readln(f, zeile);

    If Pos('binkd.log', logname) > 0 Then Begin
       Delete(zeile,1,2);
       zeile2 := '';

       For j := 1 to 3 Do Begin
         i := Pos(' ', zeile);
         zeile2 := zeile2 + Copy(zeile,1,i);
         Delete(zeile,1,i);
       End;

       i := Pos(' ', zeile);
       Delete(zeile,1,i);
       zeile := zeile2 + zeile;
    End;

    If (Pos('hpt.log', logname) > 0) and (Length(zeile) > 2)
     Then Delete(zeile,1,2);

    Logfile.Items.Add(zeile);
    Application.ProcessMessages;
  End;
  Closefile(f);

  Logfile.ItemIndex := Logfile.Items.Count-1;
end;

procedure TfrmLogfile.logBinkDClick(Sender: TObject);
begin
  logFileOeffnen(InstDir+'\binkley\binkd.log');

  Datumsauswahl.DateTime := Now;

  logBinkD.Enabled := false;
  logBinkD.Refresh;
  logIRC.Enabled := true;
  logIRC.Refresh;
  logHPT.Enabled := true;
  logHPT.Refresh;

  Logfile.SetFocus;
end;

procedure TfrmLogfile.logIRCClick(Sender: TObject);
begin
  logFileOeffnen(InstDir+'\irc-chat.log');

  If Logfile.Items.Count = 0 Then Logfile.Items.Add(s[0224]);

  Datumsauswahl.DateTime := Now;

  logBinkD.Enabled := true;
  logBinkD.Refresh;
  logIRC.Enabled := false;
  logIRC.Refresh;
  logHPT.Enabled := true;
  logHPT.Refresh;

  Logfile.SetFocus;
end;

procedure TfrmLogfile.logHPTClick(Sender: TObject);
begin
  logFileOeffnen(InstDir+'\binkley\hpt\hpt.log');

  Datumsauswahl.DateTime := Now;

  logBinkD.Enabled := true;
  logBinkD.Refresh;
  logIRC.Enabled := true;
  logIRC.Refresh;
  logHPT.Enabled := false;
  logHPT.Refresh;

  Logfile.SetFocus;
end;

procedure TfrmLogfile.DatumsauswahlCloseUp(Sender: TObject);
var suchDatum : String;
    datum     : String;
    monat     : Integer;
    i         : Integer;
begin
  datum := DateToStr(Datumsauswahl.Date);
  suchDatum := Copy(datum,1,2) + ' ';

  datum := Copy(datum,4,2);
  monat := StrToInt(datum); // Val(datum, monat, i);

  Case monat of
    1: suchDatum := suchDatum + 'Jan';
    2: suchDatum := suchDatum + 'Feb';
    3: suchDatum := suchDatum + 'Mar';
    4: suchDatum := suchDatum + 'Apr';
    5: suchDatum := suchDatum + 'May';
    6: suchDatum := suchDatum + 'Jun';
    7: suchDatum := suchDatum + 'Jul';
    8: suchDatum := suchDatum + 'Aug';
    9: suchDatum := suchDatum + 'Sep';
   10: suchDatum := suchDatum + 'Oct';
   11: suchDatum := suchDatum + 'Nov';
   12: suchDatum := suchDatum + 'Dec';
  End;

  For i := 0 to (Logfile.Items.Count-1) Do
    If Pos(suchDatum, Logfile.Items.Strings[i]) > 0 Then Begin
      Logfile.ItemIndex := i;
      break;
    End;
end;

procedure TfrmLogfile.FormCreate(Sender: TObject);
var DC  : hDc;
begin
  If otherResolution and not bigFonts Then Begin
//    frmLogfile.Height:= (frmLogfile.ClientHeight*y div ScreenHeightDev) +
//                         frmLogfile.Height - frmLogfile.ClientHeight;
//    frmLogfile.Width:= (frmLogfile.ClientWidth*y div ScreenWidthDev) +
//                        frmLogfile.Width - frmLogfile.ClientWidth;
    ScaleBy(x,ScreenWidthDev);
  end; // of if

  If bigFonts Then Begin
    DC := GetDC(0);
    ScaleBy(96,GetDeviceCaps(DC,LOGPIXELSX));
    ReleaseDC(0,DC);
    Refresh;
  End;

  If frmLogfile.Width < (Logfile.Width + 30) Then
    frmLogfile.Width := Logfile.Width + 30;
  If frmLogfile.Height < (CBzurueck.Top + CBzurueck.Height + 40) Then Begin
    frmLogfile.Height := CBzurueck.Top + CBzurueck.Height + 40;
  end;

  Font.OnChange(Self);

  If bigFonts Then Begin
    Datumsauswahl.Width := Datumsauswahl.Width + 50;
    logBinkD.Left := logBinkD.Left - 40;
    logIRC.Left := logIRC.Left - 30;
    logHPT.Left := logHPT.Left - 14;
    logBinkD.Width := logBinkD.Width + 10;
    logIRC.Width := logIRC.Width + 16;
    logHPT.Width := logHPT.Width + 14;
    CBlogfileKuerzen.Width := CBlogfileKuerzen.Width + 12;
  End;

  If sprache <> 'deutsch' Then Begin
    frmLogfile.Caption := ' ' + s[0153];
    CBlogfileKuerzen.Caption := s[0154];
    CBzurueck.Caption := s[0155];
  End;
end;

procedure TfrmLogfile.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  Konfiguration.Visible := true;
end;

end.
