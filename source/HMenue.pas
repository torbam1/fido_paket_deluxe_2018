unit HMenue;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs,
  StdCtrls, ShellApi, InfoBtn, Buttons, fontheight, ExtCtrls,
  FileCtrl, CoolTrayIcon, Menus, WinInet, wexeclib;

const
WM_TRAYEVENT = WM_USER+100;

type
  THauptmenue = class(TForm)
    Info: TLabel;
    CBPollen: TInfoBitBtn;
    CBConfig: TInfoBitBtn;
    CBHilfe: TInfoBitBtn;
    CBEditor: TInfoBitBtn;
    CBEchos: TInfoBitBtn;
    CBEnde: TInfoBitBtn;
    CBbugReport: TInfoBitBtn;
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    ShowWindow1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Systray: TCoolTrayIcon;
    procedure Tastendruecke(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CheckInstallationMoved;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CBPollenClick(Sender: TObject);
    procedure CBConfigClick(Sender: TObject);
    procedure CBHilfeClick(Sender: TObject);
    procedure CBEditorClick(Sender: TObject);
    procedure CBEchosClick(Sender: TObject);
    procedure CBEndeClick(Sender: TObject);
    procedure CBbugReportClick(Sender: TObject);
    procedure Pointdaten_lesen;
    procedure alle_Areas_abbestellen;
    procedure erstelle_delpoint;
    procedure point_abmelden(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ShowWindow1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Minimize(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Events_pruefen;
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    function  IsUserOnline: Boolean;
  private
    { Private-Deklarationen}
  public
    { Public-Deklarationen}
  end;

var
  Hauptmenue        : THauptmenue;
  WinDir            : String;
  InstDir           : String;
//  sprache           : String[20]; // Sprache (deutsch, englisch, flaemisch)
  netznummer        : Word;
  nodenummer        : String[4];
  node_aka_hex      : String[8];
  node_aka_dez      : String[15]; // zone:netz/node
  pointname         : String;
  point_aka         : String[21]; // zone:netz/node.point
  Username          : String[50]; // Username für ppp Login
  Passwort          : String[20]; // Passwort für ppp Login
  Verbindung_Name   : String;
  otherProvider     : Boolean;
  lokal_netz        : Boolean;
  internet          : Boolean;
  not_auflegen      : Boolean;
  otherResolution   : Boolean = false;
  x,y               : Integer; // für Bildschirmauflösung
  bigFonts          : Boolean = false;
  comspec           : Array[0..2*MAX_PATH] of Char;
  autoPoll          : Integer; // 0 = deaktiviert, sonst 5-60 Minuten
  minimiert         : Boolean = false;
  noRAS             : Boolean; // keine RAS-Funktionen gefunden
  forced            : Boolean; // true = nicht nach Internet-Verbindung suchen
  Fenster_Top,
  Fenster_Left      : Integer; // Fenster-Koordinaten (Hauptmenü)
  anzahl            : Byte = 1;
  ResizeErlaubt     : Boolean = True;

implementation

uses Background, Echos, Verbindung, PollAnzeige, Logfile, FidoInfos,
     ras, fpd_language, config, Output, copydir, crc;

{$R *.DFM}

{ liefert die Wochennummer und das Jahr, zu dem die Woche gehört }
procedure DateToWeek(ADate:TDateTime; var AWeek,AYear:Word);
var
  FirstWeekDay  : Integer;  { Wochentag, mit dem die Woche beginnt
                              (siehe Delphi-Wochentage)
                              2 : Montag (nach DIN 1355) }
  FirstWeekDate : Integer;  { 1 : Beginnt am ersten Januar
                              4 : Erste-4 Tage-Woche (nach DIN 1355)
                              7 : Erste volle Woche }
  Month, Day    : Word;
begin
  FirstWeekDay := 2; // Woche beginnt mit Montag
  FirstWeekDate := 4;
  ADate:=ADate-((DayOfWeek(ADate)-FirstWeekDay+7) mod 7)+ 7-FirstWeekDate;
  DecodeDate(ADate,AYear,Month,Day);
  AWeek:=(Trunc(ADate-EncodeDate(AYear,1,1)) div 7)+1;
end;

procedure MoveFiles(sourcedir, destdir: String);
var sourcemask : string[12];
    sr         : TSearchRec;
    found      : integer;

 procedure FormPath(var s:string);
 begin
   s := extractfilepath(s); {nur path-angabe verwenden}
   if s = '' then s := ExpandFileName(''); {ins aktuelle dir}
   if s[length(s)] <> '\' then s := s + '\';
 end;

begin
  sourcemask := ExtractFileName(sourcedir); {Name + ext}
  FormPath(DestDir);
  FormPath(SourceDir);

  if sourcemask = '' then sourcemask := '*.*';
  {all files in directory}
  found := findfirst(sourcedir+sourcemask, faAnyFile, sr);
  while found=0 do begin
    if (sr.name<>'.') and {nur Dateien}
       (sr.name<>'..') and
       ((sr.attr and (faDirectory or faVolumeID)) = 0)
    then begin
      if MoveFileEx(PChar(sourcedir+sr.name),
             PChar(destdir+sr.name), MOVEFILE_REPLACE_EXISTING) {Overwrite existing}
       then FileSetAttr(destdir+sr.name, 0); // alle Attribute löschen
    end;
    found := findnext(sr);
  end;
  sysutils.findclose(sr);
end;

procedure DeleteFiles(sourcedir: String);
var sourcemask : string[12];
    sr         : TSearchRec;
    found      : integer;

 procedure FormPath(var s:string);
 begin
   s := extractfilepath(s); {nur path-angabe verwenden}
   if s = '' then s := ExpandFileName(''); {ins aktuelle dir}
   if s[length(s)] <> '\' then s := s + '\';
 end;

begin
  sourcemask := ExtractFileName(sourcedir); {Name + ext}
  FormPath(SourceDir);

  if sourcemask = '' then sourcemask := '*.*';
  {all files in directory}
  found := findfirst(sourcedir+sourcemask, faAnyFile, sr);
  while found=0 do begin
    if (sr.name<>'.') and {nur Dateien}
       (sr.name<>'..') and
       ((sr.attr and (faDirectory or faVolumeID)) = 0)
    then begin
      DeleteFile(PChar(sourcedir+sr.name));
    end;
    found := findnext(sr);
  end;
  sysutils.findclose(sr);
end;

procedure THauptmenue.Events_pruefen;
var f, g                      : Textfile;
    zeile                     : String;
    lastDailyEvent            : TDate;
    lastWeeklyEvent           : TDate;
    lastMonthlyEvent          : TDate;
    heute                     : TDate;
    jahr, monat, woche, tag   : Word;
    jahrEvt, monatEvt, tagEvt : Word;
    wocheEvt                  : Word;
    fehler                    : LongBool;
    cmd                       : Array[0..2*MAX_PATH] of Char;
    nodetextGefunden,
    point265lstGefunden,
    boxlistGefunden,
    netzlistGefunden,
    echolistGefunden          : Boolean;

begin
  Assignfile(f, InstDir + '\binkley\events.dat');
  {$I-} Reset(f); {$I+}
  IF IOResult = 0
   Then Begin
     {$I-}
     Readln(f, zeile);
     lastDailyEvent := StrToDate(zeile);
     Readln(f, zeile);
     lastWeeklyEvent := StrToDate(zeile);
     Readln(f, zeile);
     lastMonthlyEvent := StrToDate(zeile);
     Closefile(f);
     {$I+}
     If IOResult <> 0 Then Begin
       // altes Datum setzen, damit Events auf jeden Fall ausgeführt werden
       // nur monatichen Event nicht ausführen
       lastDailyEvent   := EncodeDate(1980,1,1); // 01.01.1980
       lastWeeklyEvent  := EncodeDate(1980,1,1);
       lastMonthlyEvent := Date;
     End;
   End
   Else Begin
     // altes Datum setzen, damit Events auf jeden Fall ausgeführt werden
     // nur monatichen Event nicht ausführen
     lastDailyEvent   := EncodeDate(1980,1,1); // 01.01.1980
     lastWeeklyEvent  := EncodeDate(1980,1,1);
     lastMonthlyEvent := Date;
   End;

  // das aktuelle (heutige) Datum
  heute := Date;
  DecodeDate(heute,jahr,monat,tag);

  // tägliche Events
  If lastDailyEvent <> heute Then Begin
    // pflege ausführen: Mails aus Bad Area tossen und...
    lstrcpy(cmd, PChar(InstDir+'\binkley\hpt\hpt.exe toss -b'));
    DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 0, False);

    // ...bsy Files und hpt.lck löschen
    DeleteFiles(InstDir+'\binkley\flags\*.bsy');
    DeleteFiles(InstDir+'\binkley\outecho\*.bsy');
    If FileExists(InstDir+'\binkley\hpt\hpt.lck')
     Then DeleteFile(InstDir+'\binkley\hpt\hpt.lck');

    lastDailyEvent := heute;
  End;

  // wöchentliche Events
  DateToWeek(heute, woche, jahr);
  DateToWeek(lastWeeklyEvent, wocheEvt, jahrEvt);
  If wocheEvt <> woche Then Begin
    // neu requesten: NODETEXT, POINT265.LST
    // NODETEXT -> nodehtm.zip  = html Infos vom Node
    nodetextGefunden := False;
    point265lstGefunden := False;
    Assignfile(g, InstDir + '\BINKLEY\OUTECHO\' + node_aka_hex + '.REQ');
    {$I-} Reset(g); {$I+}
    IF IOResult <> 0 Then Rewrite(g)
    Else Begin
      While not EOF(g) Do Begin // nicht mehrmals requesten..
        Readln(g, zeile);
        If zeile = 'NODETEXT' Then nodetextGefunden := True;
        If zeile = 'POINT265.LST' Then point265lstGefunden := True;
      End;
      Closefile(g);
      Append(g);
    End;
    If not nodetextGefunden Then Writeln(g, 'NODETEXT');
    If (netznummer = 2457) and ((nodenummer = '265') or (nodenummer = '266'))
     Then If not point265lstGefunden Then Writeln(g, 'POINT265.LST');
    Closefile(g);

    // nodecomp.bat aufrufen -> Nodeliste compilieren
    lstrcpy(cmd, comspec);
    lstrcat(cmd, PChar(InstDir+'\binkley\nodecomp.bat'));
    DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 1, False);

    lastWeeklyEvent := heute;
  End;

  // monatliche Events
  DecodeDate(lastMonthlyEvent,jahrEvt,monatEvt,tagEvt);
  If monatEvt <> monat Then Begin
    // neu requesten: BOXLIST, NETZLIST, ECHOLIST
    // BOXLIST  -> box.lst      = Echos, die nur beim Node aufliegen
    // NETZLIST -> netz.lst     = Echos, die netzweit aufliegen
    // ECHOLIST -> echo0002.zip = Fido-Echos
    boxlistGefunden := False;
    netzlistGefunden := False;
    echolistGefunden := False;
    Assignfile(g, InstDir + '\BINKLEY\OUTECHO\' + node_aka_hex + '.REQ');
    {$I-} Reset(g); {$I+}
    IF IOResult <> 0 Then Rewrite(g)
    Else Begin
      While not EOF(g) Do Begin // nicht mehrmals requesten..
        Readln(g, zeile);
        If zeile = 'BOXLIST' Then boxlistGefunden := True;
        If zeile = 'NETZLIST' Then netzlistGefunden := True;
        If zeile = 'ECHOLIST' Then echolistGefunden := True;
      End;
      Closefile(g);
      Append(g);
    End;
    If not boxlistGefunden Then Writeln(g, 'BOXLIST');
    If not netzlistGefunden Then Writeln(g, 'NETZLIST');
    If not echolistGefunden Then Writeln(g, 'ECHOLIST');
    Closefile(g);

    // REQ-File für Binkley erstellen zum Requesten der Pointliste bei Monika
    If (node_aka_dez <> '2:249/3110') and (node_aka_dez <> '2:249/3114') Then Begin
      Assignfile(f, InstDir + '\BINKLEY\OUTECHO\00F90C26.REQ');
      Rewrite(f);
      Writeln(f, 'PNT0002');
      Writeln(f, '%REPORT_OFF');
      Writeln(f, '%TIC_OFF');
      Closefile(f);
      Assignfile(f, InstDir + '\BINKLEY\OUTECHO\00F90C26.CLO');
      Rewrite(f);
      Closefile(f);
    End;

    // 'sqpack' und 'hptutil link' aufrufen
    lstrcpy(cmd, PChar(InstDir+'\binkley\hpt\sqpack.exe'));
    DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 1, True);

    lstrcpy(cmd, PChar(InstDir+'\binkley\hpt\hptutil.exe link'));
    DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 1, True);

    lastMonthlyEvent := heute;
  End;

  // Event-Datei updaten
  Assignfile(f, InstDir + '\binkley\events.dat');
  Rewrite(f);
  Writeln(f, DateToStr(lastDailyEvent));
  Writeln(f, DateToStr(lastWeeklyEvent));
  Writeln(f, DateToStr(lastMonthlyEvent));
  Closefile(f);
end;

function existdir(name:string):boolean;
var found: integer;
    sr: Tsearchrec;
begin {auf leerem lw gibts gar kein dir ->error 18
       sonst 0 wenn found; ungueltiger pfad=error 3}
  Result:=false;
  if name = '' then exit;
  if name[length(name)] <> '\' then name := name + '\';
  found := findfirst(name+'*',fadirectory,sr); {dir '.' gibts immer wenn lw nicht leer}
  Result := found in [0,18]; {found oder keine weiteren dateien}
  sysutils.findclose(sr);
end;

{Erzeugt auch tiefere Verzeichnisebenen in einem Arbeitsgang}
function CreateDirFull(name:string): boolean;
var i: byte;
    s: string;
begin
  Result := true;
  if name = '' then exit;
  if existdir(name) then exit;

  s := '';
  repeat
    if name = '' then exit; {naechstes dir}
    i := pos('\',name);
    if i=0 then i := length(name); {dann eben den rest}
    s := s+ copy(name, 1, i);
    delete(name, 1, i);

    if not existdir(s) then
    if not CreateDir(s) then begin
      Result := false;
      exit;
    end;
  until name='';
end;

{ evtl. noch als Param OverwriteExisting angeben }
{ Verzeichnisse ohne filemask immer mit abschliessendem '\' angeben
  da alles nach dem letzten '\' als filemask gewertet wird }
function CopyDirectory(sourcedir,destdir:string; withsubdirs: boolean): boolean;
var sourcemask : string[12];
    sr         : TSearchRec;
    found      : integer;
    fail       : boolean;

 procedure FormPath(var s:string);
 begin
   s := extractfilepath(s); {nur path-angabe verwenden}
   if s = '' then s := ExpandFileName(''); {ins aktuelle dir}
   if s[length(s)] <> '\' then s := s + '\';
 end;

begin
  Result := false;
  fail := false;

  sourcemask := ExtractFileName(sourcedir); {Name + ext}
  FormPath(DestDir);
  FormPath(SourceDir);

  if not existdir(sourcedir) then exit;

  if not existdir(destdir) then
  if not createdirfull(destdir) then exit; {!!! createdir kann nur eine
                                                Ebene erstellen}

  if sourcemask = '' then sourcemask := '*.*';
  {all files in directory}
  found := findfirst(sourcedir+sourcemask, faAnyFile, sr);
  while found=0 do begin
    if (sr.name<>'.') and {nur Dateien}
       (sr.name<>'..') and
       ((sr.attr and (faDirectory or faVolumeID)) = 0)
    then begin
      Application.ProcessMessages;

      if not copyfile(PChar(sourcedir+sr.name),
             PChar(destdir+sr.name), false) {Overwrite existing}
       then fail:=true
       else FileSetAttr(destdir+sr.name, 0); // alle Attribute löschen
    end;
    found := findnext(sr);
  end;
  sysutils.findclose(sr);

  {recursive with other directorys}
  if withsubdirs then begin
    found := findfirst(sourcedir + '*.*', faDirectory, sr);
    while found=0 do begin
      if (sr.name <> '.') and
         (sr.name <> '..') and
         ((sr.attr and faDirectory ) = faDirectory)
      then begin
        if not CopyDirectory(sourcedir+sr.name+'\'+sourcemask,
        destdir + sr.name + '\',withsubdirs)
         then fail := true;
      end;
      found := findnext(sr);
    end;
    sysutils.FindClose(sr);
  end;

  Result := not fail;
end;

procedure THauptmenue.Pointdaten_lesen;
var f      : Textfile;
    zeile  : String;
    i      : Integer;
begin
  pointname := '';
  point_aka := '';

  Assignfile(f, InstDir + '\golded\golded.cfg');
  {$I-} Reset(f); {$I+}
  If IOResult = 0 Then Begin
    zeile := '';
    While not EOF(f) and (Pos('USERNAME', zeile) <> 1) Do Readln(f, zeile);
    If Pos('USERNAME', zeile) = 1 Then Begin
      Delete(zeile,1,9);
      While (Length(zeile) > 2) and (zeile[1] = ' ') Do Delete(zeile,1,1);
      While (Length(zeile) > 2) and (zeile[Length(zeile)] = ' ') Do
       Delete(zeile,Length(zeile),1); // Leerzeichen am Anfang und Ende löschen
      pointname := zeile;
    End;
    While not EOF(f) and (Pos('ADDRESS', zeile) <> 1) Do Readln(f, zeile);
    If Pos('ADDRESS', zeile) = 1 Then Begin
      Delete(zeile,1,8);
      While (Length(zeile) > 2) and (zeile[1] = ' ') Do Delete(zeile,1,1);
      i := Pos(' ', zeile);
      If i > 1 Then zeile := Copy(zeile,1,i-1);
      point_aka := zeile;
    End;
    Closefile(f);
  End;
end;

// Funktion liest 'quelle' zeilenweise aus und aendert vorgegebene 'zeile' durch 'parameter'
function LineParser (FidoPfad, quelle, parameter: string; zeile : integer): boolean;
 var
  cfgF, tempF             : TextFile;
  ln_content              : string;
  counter1                : integer;
begin
  //Filepointer cfgF auf die cgf- Datei im Programmpfad setzen
  AssignFile(cfgF, FidoPfad + quelle);
  AssignFile(tempF,FidoPfad + '\temp.dat');

  // oeffnet Datei "tempF" zum schreiben
  ReWrite(tempF);

  // Oeffnet Datei "cfgF" zum lesen
  Reset(cfgF);

  counter1 := 1;

  //Auslesen bis Dateiende
  while not Eof(cfgF) do
  begin
    Readln(cfgF, ln_content);

    if counter1 = zeile then
      begin
        Writeln(tempF, parameter);
      end

    else
      begin
        Writeln(tempF, ln_content);
      end;


    counter1 := counter1 + 1;

  end;

  // Dateien schließen
  CloseFile(cfgF);
  CloseFile(tempF);

  DeleteFile(FidoPfad + quelle);
  RenameFile(FidoPfad + '\temp.dat' , FidoPfad + quelle);

  // Rückgabewert bei erfolgreichem Ende
  Result := True;
end;


// Funktion liest 'quelle' ein, sucht nach string 'old_parameter' und ersetzt ihn
// jedes mal durch string 'new_parameter'
function FileParser (FidoPfad, quelle, old_parameter, new_parameter: string): boolean;
 var
  cfgF, tempF             : TextFile;
  ln_content              : string;
begin
  //Filepointer cfgF auf die Datei im Programmpfad setzen
  AssignFile(cfgF, FidoPfad + quelle);
  AssignFile(tempF,FidoPfad + '\temp.dat');

  // oeffnet Datei "tempF" zum schreiben
  ReWrite(tempF);

  // Oeffnet Datei "cfgF" zum lesen
  Reset(cfgF);

  //Auslesen bis Dateiende
  while not Eof(cfgF) do
  begin
    Readln(cfgF, ln_content);
    //String wird ersetzt, falls gefunden
    ln_content := StringReplace(ln_content, old_parameter, new_parameter, [rfReplaceAll, rfIgnoreCase]);
    Writeln(tempF, ln_content);
  end;


  // Dateien schließen
  CloseFile(cfgF);
  CloseFile(tempF);

  DeleteFile(FidoPfad + quelle);
  RenameFile(FidoPfad + '\temp.dat' , FidoPfad + quelle);

  // Rückgabewert bei erfolgreichem Ende
  Result := True;
end;

// Funktion kuerzt Lange Windowsnamen in 8+3- Namen
// uebernommen von http://www.delphi-fundgrube.de/faq03.htm
function ShortFilename(LongName:string):string;
var ShortName : PChar;
begin
  ShortName:=StrAlloc(Max_Path);
  GetShortPathName(PChar(LongName), ShortName, Max_Path);
  Result:=string(ShortName);
  StrDispose(ShortName);
end;

procedure THauptmenue.CheckInstallationMoved;
var
  aktWinDir, aktPfad, verzeichnisse, datei : string;
  WindowsDir : array [0..255] of Char;
  laufwerk : char;
begin
  //Dateipfad des Programms extrahieren
  aktPfad := ExtractFilePath(Application.ExeName);
  //Programmpfad in Segmente aufteilen, da wir am Ende ein '\' zuviel haben
  ProcessPath(aktPfad, laufwerk, verzeichnisse, datei);
  //Den neuen Pfad ohne Backslash aus den Segmenten zusammensetzen
  aktPfad := laufwerk + ':' + verzeichnisse;
  //Lange Verzeichnisnamen kuerzen ...
  aktPfad := ShortFileName(aktPfad);

  //Windowsverzeichnis ins Array auslesen
  GetWindowsDirectory (WindowsDir, 255);
  //Arrayinhalt in String kopieren, der hat nur noetige Laenge (anders Probleme)
  aktWinDir := StrPas (WindowsDir);
  If (aktWinDir[Length(aktWinDir)] <> '\') Then aktWinDir := aktWinDir + '\';

  //hier kann man entscheiden, ob Routinen ausgefuehrt werden ...

  If (Lowercase(aktWinDir) <> Lowercase(WinDir)) Then Begin
    LineParser(aktPfad, '\mh-fido.cfg', aktWinDir+'\', 4);
    WinDir := aktWinDir;
  End;
  If (Lowercase(aktPfad) <> Lowercase(InstDir)) Then Begin
    LineParser(aktPfad, '\mh-fido.cfg', aktPfad  , 5);
    FileParser(aktPfad, '\Binkley\nodecomp.bat'        , InstDir, aktPfad);
    FileParser(aktPfad, '\Binkley\pflege.bat'          , InstDir, aktPfad);
    FileParser(aktPfad, '\Binkley\pflege2.bat'         , InstDir, aktPfad);
    FileParser(aktPfad, '\Binkley\poll.bat'            , InstDir, aktPfad);
    FileParser(aktPfad, '\Binkley\pollman.bat'         , InstDir, aktPfad);
    FileParser(aktPfad, '\Binkley\hpt\goldarea.bat'    , InstDir, aktPfad);
    FileParser(aktPfad, '\Binkley\hpt\impexp.bat'      , InstDir, aktPfad);
    FileParser(aktPfad, '\Binkley\hpt\pktdate.bat'     , InstDir, aktPfad);
    FileParser(aktPfad, '\Binkley\hpt\toss.bat'        , InstDir, aktPfad);
    FileParser(aktPfad, '\Binkley\hpt\config'          , InstDir, aktPfad);
    FileParser(aktPfad, '\Binkley\hpt\config.sic'      , InstDir, aktPfad);
    FileParser(aktPfad, '\Binkley\hpt\goldarea.bat'    , InstDir, aktPfad);
    FileParser(aktPfad, '\Binkley\NODELIST\iproute.cfg', InstDir, aktPfad);
    FileParser(aktPfad, '\Golded\rungold.bat'          , InstDir, aktPfad);
    FileParser(aktPfad, '\Golded\scan.bat'             , InstDir, aktPfad);
    FileParser(aktPfad, '\Golded\goldarea.inc'         , InstDir, aktPfad);
    If ParamStr(1) <> 'test' Then InstDir := aktPfad;
  End;
end;

procedure THauptmenue.FormCreate(Sender: TObject);
var f           : Textfile;
    i, j        : Integer;
    zeile       : String[4];
    meldung     : String;
    DC          : hDc;
    dname       : String;
begin
  Scaled := true;
  x := Screen.Width;
  y := Screen.Height;
  if (x<>ScreenWidthDev) or (y<>ScreenHeightDev) then begin
(*    Hauptmenue.Height := (Hauptmenue.ClientHeight*y div ScreenHeightDev) +
                          Hauptmenue.Height - Hauptmenue.ClientHeight;
    Hauptmenue.Width  := (Hauptmenue.ClientWidth*x div ScreenWidthDev) +
                          Hauptmenue.Width - Hauptmenue.ClientWidth;
//    ScaleBy(x,ScreenWidthDev);*)
    If not SmallFonts Then Begin
      bigFonts := true;
      DC := GetDC(0);
      ScaleBy(96,GetDeviceCaps(DC,LOGPIXELSX));
      ReleaseDC(0,DC);
      Refresh;
    End;
  end; // of if
  Font.OnChange(Self);

  not_auflegen := false;

  ChDir(ExtractFilePath(ParamStr(0))); // in das Fido-Verzeichnis wechseln

  Assignfile(f, 'mh-fido.cfg');
  {$I-} Reset(f); {$I+}
  IF IOResult <> 0 Then Begin
    meldung := 'Konfigurationsdatei (mh-fido.cfg) nicht gefunden.' + Chr(13)
               + 'Installation nicht vollständig oder beschädigt.' + Chr(13)
               + Chr(13)
               + 'Config file (mh-fido.cfg) not found.' + Chr(13)
               + 'Installation not completed or damaged.';
    Application.MessageBox(PChar(meldung), 'Fehler / Error', MB_OK);
//    Hauptmenue.Close; // Programm beenden
    Halt(1); // Programm beenden
  End;
  Readln(f, zeile);

  netznummer := StrToInt(zeile); //  Val(zeile, netznummer, i);
  Readln(f, nodenummer);
  Readln(f, node_aka_hex);
  Readln(f, WinDir);
  Readln(f, InstDir);
  Readln(f, Username);
  Readln(f, Passwort);
  Readln(f, Verbindung_Name);
  lokal_netz := (Verbindung_Name = '-l');
  internet := (Verbindung_Name <> 'Fido-Paket deluxe') and (Verbindung_Name <> '-l');
  Readln(f, Sprache);
  Readln(f, node_aka_dez);
  If not EOF(f) Then Readln(f, autoPoll)
                Else autoPoll := -5; // deaktiviert, Slider auf 5 Minuten
  Closefile(f);

  sprachen_strings_initialisieren(sprache);

  otherProvider := (Verbindung_Name = 'otherProvider') or (Verbindung_Name = s[0085]);

  If sprache = 'russisch' Then Font.Charset := RUSSIAN_CHARSET;

  If sprache <> 'deutsch' Then Begin
    Systray.Hint := s[0104];
    popupmenu1.Items.Items[0].Caption := s[0109];
    popupmenu1.Items.Items[1].Caption := s[0110];
  End;

  CheckInstallationMoved;

  // InstDir aus der gelesenen cfg überprüfen
  If not FileExists(InstDir+'\mh-fido.cfg') Then Begin
    meldung := 'Programmdateien im Verzeichnis ' + InstDir + ' nicht gefunden.' + Chr(13)
               + 'Wurde das Laufwerk oder der Pfad geändert?' + Chr(13)
               + Chr(13)
               + 'Program files in directory ' + InstDir + ' not found.' + Chr(13)
               + 'Did the drive or the path change?';
    Application.MessageBox(PChar(meldung), 'Fehler / Error', MB_OK);
    Hauptmenue.Close; // Programm beenden
  End;

  // WinDir aus der gelesenen cfg überprüfen
  If not ExistDir(WinDir) Then Begin
    meldung := 'Windows-Verzeichnis ' + WinDir + ' nicht gefunden.' + Chr(13)
               + 'Wurde das Laufwerk oder der Pfad geändert?' + Chr(13)
               + Chr(13)
               + 'Windows directory ' + WinDir + ' not found.' + Chr(13)
               + 'Did the drive or the path change?';
    Application.MessageBox(PChar(meldung), 'Fehler / Error', MB_OK);
    Hauptmenue.Close; // Programm beenden
  End;

  Application.OnMinimize := Minimize;

  If FileExists(InstDir + '\windows.cfg') Then Begin
    Assignfile(f, InstDir + '\windows.cfg');
    {$I-}
    Reset(f);
    Readln(f, zeile);
    If zeile <> '' Then Fenster_Top := StrToInt(zeile); // Val(zeile, Fenster_Top, i);
    Readln(f, zeile);
    If zeile <> '' Then Fenster_Left := StrToInt(zeile); // Val(zeile, Fenster_Left, i);
    Closefile(f);
    {$I+}
    If IOResult <> 0 Then Begin
      Fenster_Top := -1;
      Fenster_Left := -1;
    End;
  End
  Else Begin
    Fenster_Top := -1;
    Fenster_Left := -1;
  End;

  Info.Caption := Format(s[0112], [version]);
  If sprache <> 'deutsch' Then Begin
    Hauptmenue.Caption := s[0111];
    CBPollen.Caption := s[0113];
    CBEditor.Caption := s[0114];
    CBEchos.Caption := s[0115];
    CBHilfe.Caption := s[0118];
    CBConfig.Caption := s[0240];
    CBEnde.Caption := s[0119];
    CBbugReport.Caption := s[0120];
  End;

  statusmeldung := '';

  If Hauptmenue.Width < (Info.Left + Info.Width + 10) Then
    Hauptmenue.Width := Info.Left + Info.Width + 10;
  If Hauptmenue.Height < (Info.Top + Info.Height + 40) Then
    Hauptmenue.Height := Info.Top + Info.Height + 40;

  If bigFonts Then Begin
    Hauptmenue.Width := Hauptmenue.Width + 60;
    i := Hauptmenue.Width - 50;
    j := (Hauptmenue.Width - i) div 2;
    CBPollen.Width := i;
    CBPollen.Left  := j;
    CBEditor.Width := i;
    CBEditor.Left  := j;
    CBEchos.Width := i;
    CBEchos.Left  := j;
    CBHilfe.Width := i;
    CBHilfe.Left  := j;
    CBConfig.Width := i;
    CBConfig.Left  := j;
    CBEnde.Width := i;
    CBEnde.Left  := j;
    Hauptmenue.Width := Hauptmenue.Width + 5;
    Info.Left := Hauptmenue.Width - Info.Width - 10;
    CBbugReport.Width := Info.Left - CBbugReport.Left - 12;
  End;

  Refresh;
  Application.ProcessMessages;

  // lokal -> keine Wählverbindung (für Henning)
  If not lokal_netz Then
   lokal_netz := (ParamStr(1) = '-l') or (ParamStr(1) = '/l');


  // wenn forced, dann Internetverbindung annehmen, nicht suchen
  forced := (ParamStr(1) = '-f') or (ParamStr(2) = '-f') or lokal_netz;

  // Wenn config vom HPT in Ordnung (>= 1kb), dann Sicherheitskopie anfertigen,
  // ansonsten Sicherheitskopie zurückspielen
  dname := InstDir+'\binkley\hpt\config';
  i := Logfile.getFileSizeVal(dname); // Filegrösse in kb
  If i >= 1 Then CopyFile(PChar(dname), PChar(dname+'.sic'), false)
            Else CopyFile(PChar(dname+'.sic'), PChar(dname), false);


  // COMSPEC-Variable auslesen (Batches so starten, damit Fenster bei
  // Beendigung autmatisch geschlossen wird)
  If (GetEnvironmentVariable('ComSpec', comspec, SizeOf(comspec)) <> 0)
   Then lstrcat(comspec, ' /C ')
   Else Begin
     If FileExists(WinDir+'command.com')
      Then lstrcat(comspec, PChar(WinDir+'command.com /C '))
      Else If FileExists(WinDir+'system32\command.com')
       Then lstrcat(comspec, PChar(WinDir+'command.com /C '))
       Else If FileExists('c:\command.com')
        Then lstrcat(comspec, 'c:\command.com /C ')
        Else Begin
          If Pos('WINNT', UpperCase(WinDir)) > 0 Then comspec := 'cmd /C '
                                                 Else comspec := 'command.com /C ';
        End;
    End;

  Pointdaten_lesen;

  SetEnvironmentVariable('FIDOCONF', ''); // Umgebungsvariable FIDOCONF löschen

  // noRAS ist true, wenn keine rasapi32.dll und keine rnaph.dll gefunden wurde
  // mit den RAS Funktionen -> nur Internet über Netzwerkkarte möglich
  noRAS := not rasapi32_vorhanden and not rnaph_vorhanden;
  If noRAS Then otherProvider := true;

  // prüfen, ob Packer noch im Windows-Verzeichnis (also im Path) verfügbar,
  // und wenn nicht, dann von Backup-Verzeichnis neu einspielen
  If not FileExists(WinDir + 'zip.exe') or not FileExists(WinDir + 'unzip.exe')
   or not FileExists(WinDir + 'unrar.exe') or not FileExists(WinDir + 'xarc.exe')
  Then CopyDirectory(InstDir+'\packer\', WinDir, False);

  ResizeErlaubt := False; // jetzt kein Resize mehr erlauben, nun steht die Größe

  // nicht abmelden? gut, dann Events prüfen
//  If ParamStr(1) <> '-out' Then Events_pruefen;
// wird jetzt in FormResize gemacht, weil hier noch keine Form angezeigt werden kann
end;


procedure THauptmenue.CBPollenClick(Sender: TObject);
var fehler            : LongBool;
    meldung           : String;
    info              : String;
    UName, PWort      : String;
    already_connected : Boolean;
    cmd               : Array[0..2*MAX_PATH] of Char;
    stat              : Textfile;
    anz_netmail       : String[5];
    anz_cc            : String[5];
    zeile             : String[20];
//    i                 : Integer;
begin
  If ParamStr(1) <> '-out' Then Hauptmenue.Hide;

  // Verzeichnis für lokalen Secure Inbound anlegen, falls nicht existiert
  {$I-} MkDir(InstDir + '\binkley\files\sec\sec'); {$I+}
  IOResult;

  Try
    Pollen.Show;
    If minimiert Then ShowWindow(Pollen.handle,sw_minimize);
    Application.ProcessMessages;
  Except
    On EAccessViolation Do Begin
    End;
  End;

(*
  // bis zu 1 Sekunde prüfen, ob Internet-Verbindung bereits besteht
  If internet and not forced Then For i := 1 To 100 Do Begin
    Sleep(10);
    Application.ProcessMessages;
    If IsUserOnline Then break;
  End;
*)

  // bereits aktive Verbindung -> nicht wählen und nachher nicht auflegen
//  already_connected := internet and aktiveVerbindungen(Verbindung_Name);
  already_connected := IsUserOnline;

  If forced or noRAS
   Then already_connected := true;
  not_auflegen := already_connected;

  If internet and otherProvider and not already_connected Then Begin
    meldung := s[0012] + s[0014];
    info := sprache_Hinweis;
    Application.MessageBox(PChar(meldung), PChar(info), MB_OK);
  End;

  // bereits aktive Verbindung -> nicht wählen und nachher nicht auflegen
// //  already_connected := internet and aktiveVerbindungen;
//  If forced Then already_connected := true;
//  not_auflegen := already_connected;

  If otherProvider and not already_connected Then Begin
    meldung := s[0121];
    info := sprache_Fehler;
    Application.MessageBox(PChar(meldung), PChar(info), MB_OK);
    Pollen.Close;
    If (ParamStr(1) <> '-out') and not minimiert Then Hauptmenue.Visible := True;
    Application.ProcessMessages;
    Exit;
  End;

  If not lokal_netz and not already_connected Then Begin
  // otherProvider muss hier nicht mehr abgefangen werden, da oben schon
  // in diesem Fall ausgestiegen wird, wenn nicht already_connected
    statusmeldung := '';
    If internet Then Begin
                  getParams(Verbindung_Name, UName, PWort);
                  Username := UName;
                  Passwort := PWort;
                  If Passwort = '' Then
                    Passwort := InputBox(s[0017], s[0122], '');
                  If Passwort = '' Then Begin
                    Pollen.Close;
                    If not minimiert Then Hauptmenue.Visible := True;
                    Application.ProcessMessages;
                    Exit;
                  End;
                End;
    waehlen(Verbindung_Name, Username, Passwort);
    Repeat Application.ProcessMessages; until (statusmeldung = 'Connected')
                 or (statusmeldung = 'Disconnected')
                 or (Pos(sprache_Fehler, statusmeldung) > 0)
                 or (Pos('geschlossen', statusmeldung) > 0)
                 or (Pos('antwortet nicht', statusmeldung) > 0)
                 or (Pos('#', statusmeldung) = 1)
                 or PollAbbruch;

    Application.ProcessMessages;
    If PollAbbruch Then Begin
      If not not_auflegen Then auflegen(Verbindung_Name);
      Pollen.Close;
      If (ParamStr(1) <> '-out') and not minimiert  Then Hauptmenue.Visible := True;
      Application.ProcessMessages;
      Exit;
    End;

    If statusmeldung <> 'Connected' Then Begin
      Pollen.CBAbbruch.Enabled := false;
      Application.ProcessMessages;
      meldung := Format(s[0018], [statusmeldung]);
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
      Pollen.CBAbbruch.Enabled := true;
      Pollen.Close;
      If (ParamStr(1) <> '-out') and not minimiert  Then Hauptmenue.Visible := true;
      If not not_auflegen Then auflegen(Verbindung_Name);
      Exit;
    End;
  End;

  If not lokal_netz and not internet
   Then Pollen.Info.Caption := s[0019]
   Else Pollen.Info.Caption := '';
  Pollen.Info3.Visible := True;
  Pollen.Left := Screen.Width - Pollen.Width - 20;
  Application.ProcessMessages;

  lstrcpy(cmd, comspec);
  lstrcat(cmd, PChar(InstDir+'\binkley\poll.bat'));
  DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 2, True);

  lstrcpy(cmd, PChar(InstDir + '\binkley\binkd.exe -p binkd.cfg'));
  If minimiert Then DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 0, True)
               Else DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 1, True);

  lstrcpy(cmd, comspec);
  lstrcat(cmd, PChar(InstDir+'\binkley\hpt\toss.bat'));
  If minimiert Then DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 0, True)
               Else DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 2, True);

//  GetWindowRect(prozessinfo.hprocess,r); // die Maße des Fensters in das rect
//  meldung := 'r.top: ' + inttostr(r.top) + chr(13)
//            +'r.bottom: ' + inttostr(r.bottom) + chr(13)
//            +'pollen.top: ' + inttostr(pollen.top);
//  Application.MessageBox(PChar(meldung), 'Fehler', MB_OK);
//  If (Pollen.Top > r.Top) and (Pollen.Top+Pollen.Height < r.Bottom) Then
//   Pollen.Top := r.Bottom + 10;
(*
  Repeat
    Application.ProcessMessages;
  Until (WaitforSingleObject(prozessinfo.hProcess,0)<>WAIT_TIMEOUT)
        or (Application.terminated) or PollAbbruch;
*)

//  If PollAbbruch Then RunProcess1.AbortWait := TRUE;
                      // TerminateProcess(prozessinfo.hProcess,1);
                      // CloseHandle(prozessinfo.hProcess);

  If not not_auflegen Then auflegen(Verbindung_Name);
  Pollen.Close;
  If (ParamStr(1) <> '-out') and not minimiert  Then Hauptmenue.Visible := True;

  If fehler Then Begin // Fehler
    Str(GetLastError, meldung);
    meldung := Format(s[0023], [meldung]);
    Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
  End
  Else Begin
   Assignfile(stat, InstDir+'\binkley\hpt\stat.log');
   If not minimiert Then Begin
     {$I-} Erase(stat); {$I+}
     IOResult; // IOResult zurücksetzen
   End
   Else Begin
    {$I-} Reset(stat); {$I+}
    IF IOResult = 0 Then Begin
      anz_netmail := '0';
      anz_cc := '0';
      While not EOF(stat) Do Begin
        Readln(stat, zeile);
        If Pos('netmail', zeile) > 0 Then Begin
          Delete(zeile,1,9);
          anz_netmail := zeile;
        End
        Else If Pos('cc', zeile) > 0 Then Begin
          Delete(zeile,1,4);
          anz_cc := zeile;
        End;
      End;
      meldung := Format(s[0123], [anz_netmail, anz_cc]);
      {$I-}
      Closefile(stat);
      Erase(stat);
      {$I+}
      IOResult; // IOResult zurücksetzen
      If (anz_netmail <> '0') or (anz_cc <> '0') Then
       Application.MessageBox(PChar(meldung), sprache_Info, MB_OK);
    End;
   End;
  End;

  If FileExists(InstDir + '\binkley\FidoInfo\node\_changed.fpd')
     and (ParamStr(1) <> '-out') Then Begin
    Application.MessageBox(PChar(s[0242]), sprache_Info, MB_OK);
    DeleteFile(InstDir + '\binkley\FidoInfo\node\_changed.fpd');
  End;
end;

procedure THauptmenue.FormPaint(Sender: TObject);
var a: Integer;
begin
  For a:=0 To Hauptmenue.ClientHeight Do
  Begin
    Hauptmenue.Canvas.pen.color := rgb(0,0,255 - Round(255/Hauptmenue.Clientheight*a));
    Hauptmenue.Canvas.moveto(0,a);
    Hauptmenue.Canvas.lineto(Hauptmenue.clientwidth,a);
  End;

  If anzahl = 2 Then Begin
    Fenster_Top := Hauptmenue.Top;
    Fenster_Left := Hauptmenue.Left;
  End;

  CBPollen.Refresh;
end;

procedure THauptmenue.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var f: Textfile;
begin
(*
  If frmIrcMain.Visible Then
   If Application.MessageBox(PChar(s[0243]), PChar(s[0083]),
                             MB_YesNo+MB_DEFBUTTON2) = IDNo Then Begin
     CanClose := False;
     Exit;
   End;
*)

  Assignfile(f, InstDir + '\windows.cfg');
  {$I-}
  Rewrite(f);
  Writeln(f, Hauptmenue.Top);
  Writeln(f, Hauptmenue.Left);
  Closefile(f);
  {$I+}
  IOResult;

  Halt;
end;

procedure THauptmenue.Tastendruecke(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Case Key of
   Ord('P'): CBPollenClick(Sender);
   Ord('E'): CBEditorClick(Sender);
   Ord('B'): CBEchosClick(Sender);
   Ord('I'): CBHilfeClick(Sender);
   Ord('K'): CBConfigClick(Sender);
   Ord('X'): If ssAlt in Shift Then CBEndeClick(Sender);
  End;
end;

procedure THauptmenue.CBConfigClick(Sender: TObject);
begin
//  Hauptmenue.Enabled := false;
  Konfiguration.ShowModal;
end;

procedure THauptmenue.CBHilfeClick(Sender: TObject);
begin
  Hauptmenue.Hide;
  If not fidoInfo.Visible Then fidoInfo.ShowModal;
end;

procedure THauptmenue.CBEditorClick(Sender: TObject);
var fehler      : LongBool;
    meldung     : String;
    cmd         : Array[0..2*MAX_PATH] of Char;
    f           : Textfile;
begin
  If FileExists(InstDir + '\killhrg.tmp') Then Begin
    Assignfile(f, InstDir + '\killhrg.tmp');
    Erase(f);

    Application.MessageBox(PChar(s[0251]), sprache_Hinweis, MB_OK);

    // Rules der hardrock.ger als Netmail an den Point schreiben
    lstrcpy(cmd, PChar(InstDir+'\binkley\hpt\hpt post -nf "Michael Haase" '
            + '-nt "' + pointname + '" -af "2:2457/2" -at "' + point_aka
            + '" -s "Rules der HARDROCK.GER" -f "pvt" '
            + InstDir+'\hardro_g.rul'));
    DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 0, True);
  End;

  Hauptmenue.Enabled := false;
  Hauptmenue.Hide;

  lstrcpy(cmd, comspec);
  lstrcat(cmd, PChar(InstDir+'\golded\rungold.bat'));
  DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 1, True);
//  WaitForSingleObject(prozessinfo.hProcess, infinite);
//  CloseHandle(prozessinfo.hProcess);
{ todo: EAccessViolation muss hier noch abgefangen werden bei Visible.. }
  Hauptmenue.Visible := true;
  Hauptmenue.Enabled := true;

  If fehler Then Begin // Fehler
    Str(GetLastError, meldung);
    meldung := Format(s[0125], [meldung]);
    Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
  End;
end;

procedure THauptmenue.CBEchosClick(Sender: TObject);
begin
//  Hauptmenue.Hide;
  If not EchoVerwaltung.Visible Then EchoVerwaltung.ShowModal;
end;

procedure THauptmenue.CBEndeClick(Sender: TObject);
begin
  Hauptmenue.Close;
end;

procedure THauptmenue.CBbugReportClick(Sender: TObject);
begin
(*
  // eMail mit Bug-Report an Autor senden mit Prognamen und Versionsnummer
  ShellExecute(Self.Handle, nil,
           PChar('mailto:m.haase@gmx.net?subject=Bug-Report zur Version ' + version),
           nil, nil, SW_NORMAL);
*)
end;

procedure THauptmenue.erstelle_delpoint;
Var f           : Textfile;
    zeile       : String;
    pointnr     : String;
    pointnr_hex : String;
    passwort,
    areafixpw,
    filefixpw,
    pktpw       : String;
begin
  passwort := '';
  areafixpw := '';
  filefixpw := '';
  pktpw := '';

  // Pointnummer und Passwörter auslesen
  Assignfile(f, InstDir + '\binkley\hpt\config');
  {$I-}
  Reset(f);
  While not EOF(f) Do Begin
    Readln(f, zeile);
    If Pos('Address ', zeile) = 1 Then Begin
      Delete(zeile,1,Pos('.',zeile));
      pointnr := zeile;
    End
    Else If Pos('Password ', zeile) = 1 Then Begin
      Delete(zeile,1,9);
      passwort := zeile;
    End
    Else If Pos('pktpwd ', zeile) = 1 Then Begin
      Delete(zeile,1,7);
      pktpw := zeile;
    End
    Else If Pos('areafixpwd ', zeile) = 1 Then Begin
      Delete(zeile,1,11);
      areafixpw := zeile;
    End
    Else If Pos('filefixpwd ', zeile) = 1 Then Begin
      Delete(zeile,1,11);
      filefixpw := zeile;
    End
    Else If Pos('EchoArea ', zeile) = 1 Then Break; // nicht mehr weiter suchen
  End;
  Closefile(f);
  {$I+}
  IOResult;

  // PPPPZZZZ.DEL mit Passwörtern erstellen
  pointnr_hex := numb2hex(StrToInt(pointnr));
  While Length(pointnr_hex) < 4 Do pointnr_hex := '0' + pointnr_hex; // 4-stellig machen
  Assignfile(f, InstDir + '\binkley\outecho\' + pointnr_hex + '0002.DEL');
  Rewrite(f);
  Writeln(f, 'POINTNUMBER=' + pointnr);
  Writeln(f, 'NODENUMBER=' + nodenummer);
  Writeln(f, 'PASSWORD=' + passwort);
  Writeln(f, 'AREAFIXPW=' + areafixpw);
  Writeln(f, 'TICKERPW=' + filefixpw);
  Writeln(f, 'PKTPW=' + pktpw);
  Closefile(f);

  // CLO-File für Binkley erstellen zum Crash-Pollen der PPPPZZZZ.DEL Datei
  Assignfile(f, InstDir + '\BINKLEY\OUTECHO\' + node_aka_hex + '.CLO');
  Rewrite(f);
  Writeln(f, '^' + InstDir + '\BINKLEY\OUTECHO\' + pointnr_hex + '0002.DEL');
  Closefile(f);
end;


procedure THauptmenue.alle_Areas_abbestellen;
var f           : Textfile;
    Diffliste   : TMemo;
    fehler      : LongBool;
    cmd         : Array[0..2*MAX_PATH] of Char;
begin
  // alle Echos abbestellen
  Diffliste := TMemo.Create(Self);
  Diffliste.Parent := Hauptmenue;
  Diffliste.Visible := False;
  Diffliste.Clear;
  Diffliste.Lines.Add('-*');
  Echoverwaltung.echoAnAbBestellen(Diffliste);
  Diffliste.Free;

  // alle Fileareas abbestellen
  Assignfile(f, InstDir+'\binkley\hpt\filefix.chg');
  Rewrite(f);
  Writeln(f, '-*');
  Closefile(f);

  // Mail für Areafix und Filefix erstellen
  lstrcpy(cmd, comspec);
  lstrcat(cmd, PChar(InstDir+'\binkley\hpt\goldarea.bat'));
  DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 0, True);
end;


procedure THauptmenue.point_abmelden(Sender: TObject);
var sr          : TSearchRec;
    found       : integer;
begin
  // evtl. vorhandene Request-Dateien löschen
  found := findfirst(InstDir+'\binkley\outecho\*.req', faAnyFile, sr);
  while found=0 do begin
    if (sr.name<>'.') and {nur Dateien}
       (sr.name<>'..') and
       ((sr.attr and (faDirectory or faVolumeID)) = 0)
    then DeleteFile(InstDir+'\binkley\outecho\'+sr.name);
    found := findnext(sr);
  end;
  sysutils.findclose(sr);

  // ppppzzzz.del Datei erstellen
  erstelle_delpoint;

  // alle Mail- und Fileareas für alte Pointnummer abbestellen
  alle_Areas_abbestellen;

  // Abmelden
  CBPollenClick(Sender);
end;

procedure THauptmenue.FormShow(Sender: TObject);
Var meldung: String;
begin
  If sprache <> 'deutsch' Then Begin
    Pollen.Info.Caption := s[0048];
    Pollen.Info2.Caption := s[0049];
  End;

  // prüfen, ob Point sich abmelden will
  If ParamStr(1) = '-out' Then Begin
    // Sicherheitsabfrage
    meldung := s[0126];
    If Application.MessageBox(PChar(meldung), PChar(s[0127]),
           MB_YesNo+MB_DEFBUTTON2) = IDNo Then Begin
      Application.Terminate;
      Exit;
    End;
    point_abmelden(Sender);
    Application.terminate; // Programm beenden
  End;
end;

function THauptmenue.IsUserOnline: Boolean;
var connect_status: dword;
    ergebnis: boolean;
begin
(*
  connect_status := 1 user uses a modem
                    2 user uses a lan
                    4 user uses a proxy
                    8 Modem_Busy (no longer used)
                   16 RAS_installed
                   32 Internet_Connection_Offline
                   64 Internet_Connection_Configured
*)
  ergebnis := InternetGetConnectedState(@connect_status,0);
  If (ParamStr(1) = 'debug') Then Begin
    If ergebnis Then Application.Messagebox(pchar('ergebnis: '+inttostr(connect_status)+' (online)'),'debug',mb_ok)
                Else Application.Messagebox(pchar('ergebnis: '+inttostr(connect_status)+' (offline)'),'debug',mb_ok);
  End;
  if ergebnis and not lokal_netz Then Begin
    If ((connect_status and INTERNET_CONNECTION_MODEM) <> 0) or
       ((connect_status and INTERNET_CONNECTION_PROXY) <> 0)
     Then ergebnis := True
     Else ergebnis := False;
  end;
  result := ergebnis;
end;

procedure THauptmenue.Timer1Timer(Sender: TObject);
begin
  CBPollenClick(Sender);
end;

procedure THauptmenue.ShowWindow1Click(Sender: TObject);
begin
  Systray.ShowMainForm;
  minimiert := false;
  If Timer1.Enabled Then Timer1.Enabled := false;
  Sleep(200);
  Application.ProcessMessages;
  Systray.IconVisible := false;
end;

procedure THauptmenue.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure THauptmenue.Minimize(Sender: TObject);
begin
  minimiert := true;
  If autoPoll > 0 Then Begin
    Timer1.Enabled := False;
    Timer1.Interval := autoPoll * 60000;
    Timer1.Enabled := True;
  End;
end;

procedure THauptmenue.FormResize(Sender: TObject);
begin
  // Fenster-Koordinaten setzen
  If Fenster_Top > -1 Then Hauptmenue.Top := Fenster_Top;
  If Fenster_Left > -1 Then Hauptmenue.Left := Fenster_Left;

  // Form bereits sichtbar? dann Zähler erhöhen (Events_pruefen geht erst,
  // wenn Forms alle erstellt)
  If Hauptmenue.Visible and (anzahl = 1) Then Inc(anzahl);

  // nicht abmelden? gut, dann Events prüfen
  If (anzahl = 2) and (ParamStr(1) <> '-out') Then Events_pruefen;
end;

procedure THauptmenue.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  Resize := ResizeErlaubt;
end;

end.
