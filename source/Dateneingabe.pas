unit Dateneingabe;
// Hinweis: Versionsnummer steht in Unit Background, da diese Unit auch
// im Hauptmenü des Fido Pakets eingebunden wird

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ComCtrls, StdCtrls, FileCtrl, ExtCtrls, Mask, PBFolderDialog, Psock,
  WinInet;

type
  TAngaben = class(TForm)
    Name: TLabel;
    plz: TLabel;
    TBOrt: TEdit;
    Telefon: TLabel;
    BS: TRadioGroup;
    Pfad: TLabel;
    CBok: TButton;
    CBexit: TButton;
    ListeDevices: TComboBox;
    Device: TLabel;
    LBetriebssystem: TLabel;
    TBName: TEdit;
    TBTelefon: TMaskEdit;
    CdpNodelist: TComboBox;
    LCDPNode: TLabel;
    LBeschreibung: TLabel;
    VerzeichnisAuswahl: TPBFolderDialog;
    CBInstallDir: TButton;
    Timer: TTimer;
    CdpNodelist2: TComboBox;
    CdpNodelist_internet: TComboBox;
    CdpNodelist2_internet: TComboBox;
    CdpNodelist_dstn: TComboBox;
    CdpNodelist2_dstn: TComboBox;
    lstEntries: TComboBox;
    ProfiKonfig: TGroupBox;
    CBProxy: TComboBox;
    TBProxyIP: TEdit;
    ProxyPort: TMaskEdit;
    LFakeInfo: TLabel;
    CBProxyPwd: TCheckBox;
    TBProxyUser: TEdit;
    TBProxyPwd: TEdit;
    CBechoListe: TComboBox;
    CBupdate: TButton;
    chkIstSchonPoint: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure CBexitClick(Sender: TObject);
    procedure CBokClick(Sender: TObject);
    function  WindowsDirectory: string;
    procedure windows_version_auslesen;
    procedure node_aka_hex_bestimmen(node_nr, netz_nr: Word);
    procedure cdp_nodes_auslesen;
    procedure CdpNodes_auflisten(inet: Boolean);
    procedure GetEntries(Var anzahl: Integer);
    function  daten_pruefen: Boolean;
    procedure Dateien_in_Zielverzeichnis_kopieren;
    procedure FormShow(Sender: TObject);
    procedure Verknuepfungen_auf_Desktop_und_Startmenue_erstellen;
    procedure Umlaut_wandeln(Feld: Byte; Umlaut: String; Var Key: Char);
    procedure TBNameKeyPress(Sender: TObject; var Key: Char);
    procedure TBOrtKeyPress(Sender: TObject; var Key: Char);
    procedure TBTelefonKeyPress(Sender: TObject; var Key: Char);
    procedure noPoint(meldung: String);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CBInstallDirClick(Sender: TObject);
    procedure cfg_schreiben;
    procedure Form_vorbereiten(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ListeDevicesChange(Sender: TObject);
    procedure RBinternetClick;
    procedure Update_durchfuehren(Sender: TObject);
    procedure CBProxyChange(Sender: TObject);
    procedure TBTelefonClick(Sender: TObject);
    procedure CBProxyPwdClick(Sender: TObject);
    procedure CBupdateClick(Sender: TObject);
    procedure CdpNodelistChange(Sender: TObject);
  private
    { Private-Deklarationen}
  public
    { Public-Deklarationen}
    function  IsUserOnline: Boolean;
    function  IsUserOnlineLAN: Boolean;
  end;
function GetDefaultBrowser: String;

var
  Angaben            : TAngaben;   // das Eingabeformular
  OS                 : Integer;    // das Betriebssystem des Anwenders
                                   // -1 = nicht automatisch erkannt
                                   //  0 = Windows 9x
                                   //  1 = Windows NT / 2000
  WinDir             : String; // Pfad zum Windows-Verzeichnis
  InstDir            : String;     // das Installationsverzeichnis
  temp_Aka_Dez       : String[5];  // temp. Pointnummer, dezimal
  point_nr           : String[5];  // zugewiesene Pointnummer, dezimal
  SessionPassword,                 // Passwörter
  AreafixPassword,
  PktPassword,
  FiletickerPassword : String[8];
  AreafixName,
  FiletickerName     : String[20];
  eMail              : String[60]; // eMail Adresse des Nodes
  Voice              : String[20]; // Voice Telefonnummer des Nodes
  dateienKopiert     : Boolean;    // wurden bereits Datein auf Platte kopiert?
  telNummerNode      : String[30]; // Telefonnummer (Data) des Nodes
  firsttime          : Boolean;    // erster Aufruf der Routine?
  debug              : Boolean;    // zum Testen, wenn als Parameter debug
                                   // übergeben wird, dann werden Testdaten
                                   // benutzt, man braucht nichts in das
                                   // Formular eingeben und es wird nicht
                                   // rausgewählt
  iv                 : String[5];  // internationale Vorwahl (z.B. '49-')
  Node_Name          : String;     // Name des Nodes
  NodeAKA            : String[15]; // die AKA des Nodes im Format z:nnnn/nnnn
  node_aka_hex       : String[12]; // Netz- und Nodenummer, hex, 8-stellig
  node_nr            : Word = 265;
  netz_nr            : Word = 2457;
  zone_nr            : Word = 2;
  Node_IP            : String[55]; // IP-Adresse des Nodes mit Port
  Username           : String[50]; // User-Name für ppp Login
  Passwort           : String[20]; // Passwort für ppp Login
  nichtFragen        : Boolean;    // Installations-Verzeichnis nicht autom.
                                   // abfragen (wenn Verz. bereits existiert)
  netzwerk           : Boolean;    // keine Wählverbindung, sondern Netzwerk
  internet           : Boolean;    // Fido over Internet?
  otherProvider      : Boolean;    // anderer Internet-Provider
  nameProvider       : String;     // Name des Internet-Providers
  already_connected  : Boolean;    // steht die Internet-Verbindung bereits?
  forced             : Boolean;    // -f als Parameter übergeben, Internetverb. steht
  internetOnly       : Boolean;    // nur Internet (kein DFÜ-Netzwerk installiert)?
  not_auflegen       : Boolean;    // Verbindung nicht trennen
  stop               : Integer;    // -1 = ok, > -1 = Prog mit Errorlevel (stop) beenden
  aktDir             : String;     // das Verzeichnis mit der Setup.exe
  comspec            : Array[0..2*MAX_PATH] of Char; // comspec Variable des Systems
  cdn                : String;     // cdn-Datei (xxxxxxxx.cdn)
  cdn_uebergeben     : Boolean;    // wurde eine CDN-Datei übergeben?
  updaten            : Boolean;    // nur Update durchführen?
  alte_Version       : String[15]; // Versionsnummer der vorhandenen Installation
  noRAS              : Boolean;    // keine RAS-Funktionen gefunden
  ProxyAuth          : String;     // User+Passwort für Proxy

implementation

uses Install, copydir, crc, Binkley, CDP, Golded, Background,
     kopieren, DFUE_Netzwerk, ShlObj, ActiveX, ComObj, Registry, ras,
     PollAnzeige, Verbindung, inSuche, fpd_language, Output, updatecdp,
  cdn_input;

{$R *.DFM}

procedure TAngaben.FormCreate(Sender: TObject);
var x,y: Integer; // für Bildschirmauflösung
begin
  x := Screen.Width;
  y := Screen.Height;
  If y > 650 Then Scaled := true;
  if (x<>ScreenWidthDev) or (y<>ScreenHeightDev) then begin
    Hintergrund.Height := (Hintergrund.ClientHeight*y div ScreenHeightDev) +
                           Hintergrund.Height - Hintergrund.ClientHeight;
    Hintergrund.Width := (Hintergrund.ClientWidth*x div ScreenWidthDev) +
                          Hintergrund.Width - Hintergrund.ClientWidth;
//    ScaleBy(x,ScreenWidthDev);
  end; // of if

  VerzeichnisAuswahl.RootFolder := foMyComputer;

  // wenn stop > -1, dann Programm mit Errorlevel {stop} beenden
  stop := -1;
end;

procedure TAngaben.Form_vorbereiten(Sender: TObject);
var i       : Integer; // Anzahl der vorhandenen Verbindungen im DFÜ Netzwerk
    meldung : String;
begin
  InstDir := 'c:\Fido'; // Standard-Vorgabe als Installationsverzeichnis setzen

  If sprache <> 'deutsch' Then Begin // zwei Hint-Texte werden dann gelöscht,
    Angaben.Caption := s[0027];      // daher eine Unterscheidung, und die
    Name.Caption := s[0028];         // deutschen Beschriftungen sind schon
    TBName.Hint := s[0029];          // in der Form drin
    plz.Caption := s[0030];
    Telefon.Caption := s[0031];
    TBTelefon.Hint := s[0032];
    Device.Caption := s[0036];
    BS.Caption := s[0039];
    LBetriebssystem.Caption := s[0040];
    CBInstallDir.Caption := s[0041];
    LCDPNode.Caption := s[0043];
    LBeschreibung.Caption := s[0044];
    CBok.Caption := s[0045];
    CBexit.Caption := s[0046];
    ProfiKonfig.Caption := s[0211];
    CBProxy.Items.Strings[0] := s[0212];
    CBupdate.Caption := s[0262];
    chkIstSchonPoint.Caption := s[0270];

    Installieren.Caption := Angaben.Caption;

    Pollen.Caption := s[0047];
    Pollen.Info.Caption := s[0048];
    Pollen.Info2.Caption := s[0049];
    Pollen.Info3.Text := '';
    Pollen.CBAbbruch.Caption := s[0050];
  End;

  Pfad.Caption := Format(s[0042], [Upcase(InstDir[1])]);
  TBProxyIP.Text := s[0213];
  LFakeInfo.Caption := s[0250];


  // wenn als erster oder zweiter Parameter 'debug' angegeben wurde,
  // dann debug-Variable auf true setzen, sonst false
  debug := (ParamStr(1) = 'debug') or (ParamStr(2) = 'debug');

  // wenn keine Wählverbindung, sondern direkt übers Netzwerk die
  // Verbindung aufgebaut werden soll, dann Parameter -l angeben
  netzwerk := (ParamStr(1) = '-l') or (ParamStr(1) = '/l')
           or (ParamStr(2) = '-l') or (ParamStr(2) = '/l');

  cdn := ParamStr(1);
  i := Length(cdn);
  cdn_uebergeben := (i > 4) and (UpperCase(Copy(cdn,i-3,4)) = '.CDN');
  If not cdn_uebergeben Then Begin
    cdn := ParamStr(2);
    i := Length(cdn);
    cdn_uebergeben := (i > 4) and (UpperCase(Copy(cdn,i-3,4)) = '.CDN');
  End;

  If cdn_uebergeben Then If not FileExists(cdn) Then Begin
    meldung := Format(s[0051], [cdn]);
    If Pos('\', cdn) = 0 Then meldung := meldung + chr(13) + s[0052];
    Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    stop := 20;
    Exit;
  End
  Else Begin
    chkIstSchonPoint.Checked := True;
    chkIstSchonPoint.Enabled := False;
  End;


  nichtFragen := False;

  dateienKopiert := false; // noch keine Dateien auf Platte kopiert

  aktDir := ParamStr(0);
  i := Length(aktDir);
  While (aktDir[i] <> '\') and (i > 0) Do Dec(i);
  aktDir := Copy(aktDir,1,i); // bis (einschliesslich) zum letzten Backslash

  WinDir := WindowsDirectory; // Windows-Verzeichnis auslesen inkl. Laufwerk und
                              // abschliessendem Backslash, z.B. C:\WINNT\

  // Windows-Version erkennen und bei Win95a ggf. die rnaph.dll
  // ins \windows\system Verzeichnis kopieren (für DFÜ Netzwerk)
  // und bei Win95 die vorhandene wsock32.dll nach ws2_32.dll umkopieren
  windows_version_auslesen;

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
          If OS=1 Then comspec := 'cmd /C ' // Win 9x
                  Else comspec := 'command.com /C '; // Win NT
        End;
    End;

  SetEnvironmentVariable('FIDOCONF', ''); // Umgebungsvariable FIDOCONF löschen

  // Formulargröße anpassen, falls große Schriftarten verwendet werden
  If Angaben.Width < (CdpNodelist.Width + 50) Then
    Angaben.Width := CdpNodelist.Width + 50;
  If Angaben.Width < (CBupdate.Left + CBupdate.Width + 25) Then
    Angaben.Width := CBupdate.Left + CBupdate.Width + 25;
  If Angaben.Height < (CBok.Top + CBok.Height + 15) Then
    Angaben.Height := CBok.Top + CBok.Height + 15;

  CBProxy.ItemIndex := 0;
  TBProxyIP.Width := 120;
  ProxyPort.Left := TBProxyIP.Left + TBProxyIP.Width + 20;

  internetOnly := false;

  If updaten Then Exit;

  // noRAS ist true, wenn keine rasapi32.dll und keine rnaph.dll gefunden wurde
  // mit den RAS Funktionen -> nur Internet über Netzwerkkarte möglich
  noRAS := not rasapi32_vorhanden and not rnaph_vorhanden;
  If noRAS Then internetOnly := true;
  If not noRAS and not alle_RAS_Funktionen_vorhanden Then
      Application.MessageBox(PChar(s[0170]), PChar(s[0083]), MB_OK);

  // Annehmen (forcieren), dass eine Internetverbindung besteht
  forced := (ParamStr(1) = '-f') or (ParamStr(2) = '-f') or noRAS;

  // Anzahl der Verbindungen im DFÜ Netzwerk auslesen
  // -1 = kein DFÜ Netzwerk installiert, >=0 = Anzahl vorhandener Verbindungen
  If noRAS Then i := -1
           Else i := get_Anzahl_Verbindungen;
  If i = -1 Then
  // prüfen, ob Internetverbindung steht (Standleitung), dann Auswahl auf
  // Internet-Verbindungen beschränken, sonst:
  // Meldung: DFÜ Netzwerk erst installieren;
  // Abbruch der Installation mit Errorlevel 10
  Begin
    internetSearch.Show;
    inSuche.suchen(forced);

    If IsUserOnline or forced Then Begin
      internetOnly := true;
      forced := true;

      Application.MessageBox(PChar(s[0053]), sprache_Hinweis, MB_OK)
    End
    Else Begin
      Application.MessageBox(PChar(s[0054]), PChar(s[0055]), MB_OK);
      stop := 10;
      Exit;
    End;
  End;

  // Liste mit im System vorhandenen Devices erstellen
  Devices_auflisten(ListeDevices);

  If (ListeDevices.Items.Count = 0) and not internetOnly and not forced Then
  // DFÜ Netzwerk ist installiert, aber keine Devices (Modem, ISDN-Karte..)
  // gefunden.
  // Meldung: erst Modem oder ISDN-Karte für DFÜ-Netzwerk installieren;
  // Abbruch der Installation mit Errorlevel 11
  Begin
    internetSearch.Show;
    inSuche.suchen(forced);

    If IsUserOnline or forced Then Begin
      internetOnly := true;
      forced := true;

      ListeDevices.Items.Add(s[0056]);
      ListeDevices.Items.Add(s[0093]); // LAN

      Application.MessageBox(PChar(s[0053]), sprache_Hinweis, MB_OK);
    End
    Else Begin
      Application.MessageBox(PChar(s[0057]), PChar(s[0055]), MB_OK);
      stop := 11;
      Exit;
    End;
  End;

  // wenn Verbindung(en) vorhanden, dann nach wahrscheinlichem
  // Modem oder ISDN-Karte suchen, um den Auswahlbalken
  // direkt dort zu plazieren
  // wahrscheinlich ist ein Device dann, wenn es bei einer bereits vorhandenen
  // Verbindung im DFÜ Netzwerk zu einer Wählverbindung (keine Netzwerk)
  // benutzt wird
  If internetOnly Then i := 0
                  Else GetEntries(i);
  If i > 0 Then wahrscheinliches_Device_suchen(lstEntries, ListeDevices);

  // Nodes aus CDP-Nodeliste (cdpnodes.lst) auslesen und in Auswahlfeld
  // eintragen; wenn Henning Schroeer in der Liste, dann Auswahlbalken
  // auf dessen Eintrag setzen
  cdp_nodes_auslesen;

  // als Default erstmal Internet-IP-Nodes auflisten
  RBinternetClick;
end;

procedure TAngaben.CBexitClick(Sender: TObject);
begin
  // der Abbruch-Button wurde gedrückt -> Programm beenden
  Angaben.Close;
end;

function ShortFilename(LongName:string):string;
var ShortName : PChar;
begin
  ShortName:=StrAlloc(Max_Path);
  If GetShortPathName(PChar(LongName), ShortName, Max_Path) = 0
   Then Result := ''
   Else Result:=string(ShortName);
  StrDispose(ShortName);
end;

function GetDefaultBrowser: String;
var
    FReg  : TRegistry;
    name  : String;
begin
    Result := '';
    {$I-}
    FReg := TRegistry.Create;
    FReg.RootKey := HKEY_CLASSES_ROOT;
    FReg.OpenKeyReadOnly('htmlfile\shell\open\command');

    name := FReg.ReadString('');
    If (Length(name) > 0) and (name[1] = '"') Then Begin
      While (name[Length(name)] <> '"') and (Length(name) > 1) Do
       Delete(name,Length(name),1);
      If Length(name) > 2 Then Begin
        Delete(name,1,1);
        Delete(name,Length(name),1);
      End;
    End;
    name := ShortFilename(name);

    Result := name;
    FReg.Free;
    {$I+}
    IOResult;
end;

function TAngaben.IsUserOnline: Boolean;
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
  if ergebnis and not netzwerk Then Begin
    If ((connect_status and INTERNET_CONNECTION_MODEM) <> 0) or
       ((connect_status and INTERNET_CONNECTION_PROXY) <> 0)
     Then ergebnis := True
     Else ergebnis := False;
  end;
  result := ergebnis;
end;

function TAngaben.IsUserOnlineLAN: Boolean;
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
  if ergebnis and not netzwerk Then Begin
    If ((connect_status and INTERNET_CONNECTION_LAN) <> 0)
     Then ergebnis := True
     Else ergebnis := False;
  end;
  result := ergebnis;
end;

function TAngaben.WindowsDirectory: string;
//--------------------------------------------------------
//
// Windows-Verzeichnis finden
//
// (Unit Windows)
//--------------------------------------------------------
var WinDir:PChar;
begin
    WinDir:=StrAlloc(Max_Path);
    GetWindowsDirectory(WinDir,Max_Path);
    Result:=String(WinDir);
    if Result[length(Result)]<>'\' then Result:=Result+'\';
    StrDispose(WinDir);
end;


type
  TWindowsVersion = (wvUnknown,
                     wvWin95, wvWin95OSR2, wvWin98, wvWin98SE, wvWinME, wvWinNT3, wvWinNT4, wvWin2000, wvWinXP);
//=================================================================================================================
// Win32Platform        1           1           1        1         1        2         2          2           2
// Win32MajorVersion    4           4           4        4         4        3         4          5           5
// Win32MinorVersion    0           0           10       10        90       ?         0          0           1
// Win32BuildNumber     ?        67109975    67766222  67766446  73010104   ?        1381       2195         ?
// Win32CSDVersion      ?          'B'          ''       A         SP       SP        SP         ?           ?
//------------------------------------------------------------------------------
//
// ermitteln der Windows-Version
//
// Info aus der Faq von http://www.delphi-fundgrube.de
// Die deutsche Faq ist als Zip-File downloadbar
//------------------------------------------------------------------------------
function GetWindowsVersion(var VerString:string; var win95: Boolean;
                           var win95a: Boolean): TWindowsVersion;
var osInfo : tosVersionInfo;
begin
  Result := wvUnknown;
  OS := -1; // Windows-Version nicht erkannt
  win95 := false;
  win95a := false;

  osInfo.dwOSVersionInfoSize:= Sizeof( osInfo );
  GetVersionEx( osInfo );

  with osInfo do begin
    VerString:=' (Version ' + IntToStr( osInfo.dwMajorVersion ) +
               '.' + IntToStr( osInfo.dwMinorVersion ) + '.';

    case dwPlatformId of
      VER_PLATFORM_WIN32_WINDOWS : begin
        case dwMinorVersion of
          0 : if Trim(szCSDVersion[1]) = 'B' then begin
                Result:= wvWin95OSR2;
                VerString := 'Windows 95B' + VerString;
              end
              else begin
                Result:= wvWin95;
                VerString := 'Windows 95A' + VerString;
              end;
         10 : if Trim(szCSDVersion[1]) = 'A' then begin
                Result:= wvWin98SE;
                VerString := 'Windows 98SE' + VerString;
              end
              else begin
                Result:= wvWin98;
                VerString := 'Windows 98' + VerString;
              end;
         90 : if (dwBuildNumber = 73010104) then begin
                Result:= wvWinME;
                VerString := 'Windows ME' + VerString;
              end;
        end;
        OS := 0; // Windows 9x
        VerString:=VerString + IntToStr(LoWord( osInfo.dwBuildNumber ));
      end;
      VER_PLATFORM_WIN32_NT      : begin
        case dwMajorVersion of
          3 : begin Result:= wvWinNT3; VerString := 'Windows NT3' + VerString; end;
          4 : begin Result:= wvWinNT4; VerString := 'Windows NT4' + VerString; end;
          5 : case dwMinorVersion of
                0 : begin
                      Result:= wvWin2000;
                      VerString := 'Windows 2000' + VerString;
                    end;
                1 : begin
                      Result:= wvWinXP;
                      VerString := 'Windows XP' + VerString;
                    end;
              end;
        end;
        OS := 1; // Windows NT/2000/XP
        VerString:=VerString + IntToStr(osInfo.dwBuildNumber );
      end;
    end;
    VerString:=VerString + ')';
  end;
end;

procedure TAngaben.windows_version_auslesen;
var WinVerStr : String;
    win95     : Boolean;
    win95a    : Boolean;
    HilfStr   : array[0..50] of Char;
    Pfad      : String;

begin
  GetWindowsVersion(WinVerStr, Win95, Win95a);
  StrFmt(HilfStr, '%s', [PChar(WinVerStr)]);
(*
       then StrFmt(HilfStr,'Windows 98 (Version %d.%.2d.%d)',
              [OsVinfo.dwMajorVersion, OsVinfo.dwMinorVersion,
              OsVinfo.dwBuildNumber AND $FFFF])
         StrFmt(HilfStr,'Windows 95 (Version %d.%d Build %d)',
                [OsVinfo.dwMajorVersion, OsVinfo.dwMinorVersion,
                OsVinfo.dwBuildNumber AND $FFFF]);
       Then StrFmt(HilfStr,'Windows 2000 (Version %d.%.2d.%d)',
                   [OsVinfo.dwMajorVersion, OsVinfo.dwMinorVersion,
                   OsVinfo.dwBuildNumber AND $FFFF])
       Else StrFmt(HilfStr,'Windows NT (Version %d.%.2d.%d)',
                   [OsVinfo.dwMajorVersion, OsVinfo.dwMinorVersion,
                   OsVinfo.dwBuildNumber AND $FFFF]);
*)

  If OS = -1
   Then Begin
     // Auslesen der Windows-Version gescheitert, manuelle Auswahlmöglichkeit
     // dem Benutzer zeigen
     BS.Visible := True;
     LBetriebssystem.Visible := False;
   End
   Else LBetriebssystem.Caption := Format(s[0059], [HilfStr]);

  // wenn Win95a, dann rnaph.dll ins Systemverzeichnis kopieren, wird
  // für DFÜ Netzwerk benötigt (automatisches setzen / lesen von Einstellungen)
  pfad := WinDir + 'system\rnaph.dll';
  If win95a Then Begin
    {$I-}
    CopyFile(PChar(aktDir+'fido\sonst\rnaph.dll'), PChar(pfad), false);
    FileSetAttr(PChar(pfad), 0); // alle Attribute löschen
    {$I+}
    If IOResult <> 0 Then Begin
    End;
  End;

  // wenn Win95, dann vorhandene wsock32.dll in ws2_32.dll umkopieren,
  // falls letztere nicht existiert
  pfad := WinDir + 'system\';
  If win95 and not FileExists(pfad+'ws2_32.dll') Then Begin
    {$I-}
    CopyFile(PChar(pfad+'wsock32.dll'), PChar(pfad+'ws2_32.dll'), false);
    {$I+}
    If IOResult <> 0 Then Begin
    End;
  End;
end;


function ibn(zeile: String): Boolean;
var z    : string;
    i, j : integer;
begin
  z := UpperCase(zeile);
  i := Pos(',IBN:', z); // IBN-Userflag suchen
  If i = 0 Then i := Pos(',IBN,', z);
  If i = 0 Then Begin
    j := Length(z);
    If (j > 4) Then Begin
      Dec(j,4);
      Delete(z,1,j);
      If (z = ',IBN') Then i := 1; // IBN-Flag am Ende gefunden
    End;
  End;
  ibn := (i > 0);
end;

procedure TAngaben.cdp_nodes_auslesen;
var f        : Textfile;  // cdpnodes.lst oder cdpnodes.upd
    zeile    : String;    // gelesene Zeile aus cdpnodes.lst
    telnum   : String;    // Telefonnummer (Data) des jeweiligen Nodes
    vorwahl  : String;    // nur die Vorwahl von der Telefonnummer (Data)
    iv_node  : String[9]; // die internationale Vorwahl des Nodes
    sysname  : String;    // System-Name des jeweiligen Nodes
    ort      : String;    // Ort des Nodes
    nodename : String;    // Name des jeweiligen Nodes
    system   : String;    // Formatierter String: Telnummer, Systemname, Nodename
    port     : String;    // BinkP Port für IP-Verbindung
    z        : String[1]; // Zone der AKA
    n        : String[4]; // Netz der AKA
    aka      : String[15];
    i        : Integer;   // Zählvariable
begin
  If FileExists(aktDir+'fido\sonst\cdpnodes.upd')
   Then AssignFile(f, aktDir+'fido\sonst\cdpnodes.upd')
   Else AssignFile(f, aktDir+'fido\sonst\cdpnodes.lst');
  {$I-} Reset(f); {$I+}
  i := IOResult;
  If not (i = 0) Then Begin
    Str(i, zeile);
    Application.MessageBox(PChar(Format(s[0060], [aktDir, zeile])), sprache_Fehler, MB_OK);
    stop := 15;
    Exit;
  End;

  CdpNodelist_internet.Items.Clear; // Listen loeschen
  CdpNodelist2_internet.Items.Clear;
  CdpNodelist_dstn.Items.Clear;
  CdpNodelist2_dstn.Items.Clear;

  z := '';
  n := '';

//  zeile := ' ';
  If (stop = -1) Then While not EOF(f) Do Begin
    Readln(f, zeile);
    While (Copy(zeile,1,1) = ';') and not EOF(f) Do Readln(f, zeile);
    If zeile = '' Then break;

    If Copy(zeile,1,4) = 'Pvt,' Then Delete(zeile,1,3);

    If (Copy(zeile,1,5) = 'Zone,') Then z := Copy(zeile,6,1)
    Else If (Copy(zeile,1,5) = 'Host,') Then Begin
      Delete(zeile,1,5);
      i := Pos(',', zeile);
      n := Copy(zeile,1,i-1);
    End
    Else If (zeile[1] = ',') // keine HUBs (die können wechseln!)
         // und nur IP-Nodes
         and ((Pos(',PPP:', UpperCase(zeile)) > 0) or ibn(zeile)) Then Begin

     Delete(zeile,1,1);
     i := Pos(',', zeile);
     aka := z + ':' + n + '/' + Copy(zeile,1,i-1); // Node-AKA
     Delete(zeile,1,i);
     i := Pos(',', zeile);
     sysname := Copy(zeile,1,i-1); // System-Name
     Delete(zeile,1,i);
     i := Pos(',', zeile);
     ort := Copy(zeile,1,i-1); // Ort des Nodes
     Delete(zeile,1,i);
     i := Pos(',', zeile);
     nodename := Copy(zeile,1,i-1); // Node-Name
     Node_Name := nodename;
     Delete(zeile,1,i);

     // Fido IP over Internet
     vorwahl := 'INet';
     telnum := '-';
     zeile := zeile + ',PPP:' + sysname;
     If Pos(':', sysname) = 0 Then Begin // kein Port mit angegeben (Standard)
       // nachsehen, ob beim IBN-Flag noch ein Port angegeben wurde
       i := Pos(',IBN:', zeile);
       If i > 0 Then Begin
         port := Copy(zeile,i+4,Length(zeile)); // bis inkl. ",IBN" wegschneiden
         i := Pos(',', port);
         If i > 0 Then port := Copy(port,1,i-1);
         zeile := zeile + port;
       End;
     End;
     zeile := zeile + ':-:-:-';
     sysname := ort;

     If Length(sysname)  > 22 Then sysname  := Copy(sysname,1,22);
     If Length(nodename) > 20 Then nodename := Copy(nodename,1,20);
     system := Format('%-7s %-22s %-19s', [vorwahl, sysname, nodename]);

     // alle Unterstriche durch Leerzeichen ersetzen
     For i := 1 To Length(system) Do If system[i] = '_' Then system[i] := ' ';

     // Eintrag der Auswahlliste hinzufügen
     If vorwahl = 'INet' Then CdpNodelist_internet.Items.Add(system)
                         Else CdpNodelist_dstn.Items.Add(system);

      // Vorwahl bzw. Sysname (wegen Sortierung notwendig), Name, AKA,
      // Telefonnummer, Flags
     If vorwahl = 'INet' Then system := sysname + ',49-,' + Node_Name + ',' + aka + ',' + telnum + zeile
                         Else system := vorwahl + ',' + iv_node + ',' + Node_Name + ',' + aka + ',' + telnum + zeile;
     // Eintrag der unsichtbaren Liste hinzufügen
     If vorwahl = 'INet' Then CdpNodelist2_internet.Items.Add(system)
                         Else CdpNodelist2_dstn.Items.Add(system);
    End;
  End;

  CdpNodelist_internet.Items.Add(s[0289]);
  CdpNodelist2_internet.Items.Add(s[0289]); // unwichtig, was hier drin steht

  CdpNodes_auflisten(true); // alle Nodes auflisten
  CdpNodelist.ItemIndex := 0; // Auswahlbalken auf ersten Eintrag setzen
  For i := 0 to (CdpNodelist.Items.Count-1) Do
    If Pos('Christian von Busse', CdpNodelist.Items.Strings[i]) > 0 Then Begin
      // wenn Christian von Busse in der Liste vorhanden ist, dann
      // Auswahlbalken auf dessen Eintrag setzen
      CdpNodelist.ItemIndex := i;
      break;
    End;

  {$I-} Closefile(f); {$I+}
  IOResult;

  If (CdpNodelist.Items.Count = 0)
     and (FileExists(aktDir+'fido\sonst\cdpnodes.upd')) Then Begin
    Application.MessageBox(PChar(s[0284]), sprache_Fehler, MB_OK);
    DeleteFile(aktDir+'fido\sonst\cdpnodes.upd');
    If not FileExists(aktDir+'fido\sonst\cdpnodes.upd') Then cdp_nodes_auslesen; // nochmal durchlaufen, aber diesmal Standard-Liste
  End;

end;

procedure TAngaben.node_aka_hex_bestimmen(node_nr, netz_nr: Word);
begin
  { CLO Name aus AKA des Nodes ohne Zone generieren }
  node_aka_hex := Numb2Hex(node_nr); // Nodenummer
  While Length(node_aka_hex) < 4 Do node_aka_hex := '0' + node_aka_hex; // 4-stellig machen
  node_aka_hex := Numb2Hex(netz_nr) + node_aka_hex; // Netznummer davor
  While Length(node_aka_hex) < 8 Do node_aka_hex := '0' + node_aka_hex; // 8-stellig machen

  // NodeAKA neu setzen
  NodeAKA := Copy(NodeAKA,1,2) + IntToStr(netz_nr) + '/' + IntToStr(node_nr);
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

procedure TAngaben.CBokClick(Sender: TObject);
var fehler      : Integer;
    i           : Integer;
    zeile       : String;
    iv_node     : String[9];
    ppp_string  : String;
    port        : String;
    fehler2     : LongBool;
//    prozessinfo : TProcessInformation;
    cmd         : Array[0..2*MAX_PATH] of Char;
    mailfile    : Textfile;
    mailtext    : String;
begin
  If debug Then Begin
    TBName.Text := 'Test Tester';
    TBOrt.Text := '57223 Kreuztal';
    TBTelefon.Text := '02732-123456';
  End;

  // Dateien im Outecho-Verzeichnis löschen, die von einem vorherigen
  // Versuch ggf. noch vorhanden sind
  DeleteFiles(InstDir+'\binkley\outecho\*.*');

  // ins Installations-Verzeichnis wechseln (wegen FidoInst.log bei Fehler)
  {$I-} MkDir(InstDir); {$I+}
  IOResult; // IOResult nur abfragen, damit es gelöscht ist
  ChDir(InstDir);

  i := CdpNodelist.ItemIndex;
  zeile := CdpNodelist.Items.Strings[i];

  // eingegebene Daten korrekt? True=Fehler
  // wenn Fehler, dann Abbruch und wieder zurück zum Eingabe-Formular
  If daten_pruefen = True Then Exit;

  nonCdpNode := (zeile = s[0289]);
  zeile := CdpNodelist2.Items.Strings[i];

  If (not nonCdpNode) Then Begin
    // AKA des gewählten Nodes bestimmen
    ppp_string := zeile;
    i := Pos(',', zeile);
    Delete(zeile,1,i);
    i := Pos(',', zeile);
    iv_node := Copy(zeile,1,i-1);
    Delete(zeile,1,i);
    i := Pos(',', zeile);
    Node_Name := Copy(zeile,1,i-1);
    Delete(zeile,1,i);
    i := Pos(',', zeile);
    telNummerNode := Copy(zeile,i+1,Length(zeile));
    NodeAKA := Copy(zeile,1,i-1);

    // die IP-Adresse und Portnummer für den gewählten Node bestimmen
    i := Pos(',PPP:', ppp_string);
    Delete(ppp_string,1,i+4);
    i := Pos(':', ppp_string);
    Node_IP := Copy(ppp_string,1,i-1); // IP
    Delete(ppp_string,1,i);
    i := Pos(':', ppp_string);
    port := Copy(ppp_string,1,i-1); // Port
    If port <> '-' Then Node_IP := Node_IP + ':' + port; // IP:Port
    Delete(ppp_string,1,i);
  End;

  // CDN Daten manuell eingeben, weil Daten schon bekannt?
  If (nonCdpNode or (chkIstSchonPoint.Checked and not cdn_uebergeben)) Then Begin
    cdnEntered := False;
//    Angaben.Hide;        // Eingabe-Formular verstecken
    cdninput.Showmodal;
    Hintergrund.Update;  // blauen Hintergrund neu zeichnen
//    Angaben.Show;        // Eingabe-Formular zeigen

    If not cdnEntered Then Exit;
  End;

  Val(Copy(NodeAKA,1,1), zone_nr, fehler);
  zeile := Copy(NodeAKA,3,Length(NodeAKA));
  i := Pos('/', zeile);
  Val(Copy(zeile,1,i-1), netz_nr, fehler);
  Delete(zeile,1,i);
  Val(zeile, node_nr, fehler);
  If ParamStr(2) = '-aka' Then Begin // für Henning in der Firma
    NodeAKA := '2:2457/266';
    zone_nr := 2;
    netz_nr := 2457;
    node_nr := 266;
  End;

  If (not nonCdpNode) Then Begin
    // die Telefonnummer (Data) des Nodes zuzüglich vorher eventueller
    // Nummer für eine Telefonanlage zum rauswählen und der eventuellen
    // Call-By-Call Nummer
    i := Pos(',', telNummerNode);
    telNummerNode := Copy(telNummerNode,1,i-1);
  End
  Else Begin
    telNummerNode := '--Unpublished-';
  End;

  internet := True; // gibt keine Auswahl mehr, wird nur noch Internet unterstützt

  // Name des Internet-Providers
  If internet Then nameProvider := lstEntries.Items.Strings[lstEntries.ItemIndex]
              Else nameProvider := 'Fido-Paket deluxe';

  // sollte eigentlich nicht nötig sein, da immer einer selektiert
  If nameProvider = '' Then nameProvider := s[0085];

  // LAN = keine Internet-Prüfung
  netzwerk := nameProvider = s[0254];
  if netzwerk Then forced := True;

  // otherProvider
  otherProvider := nameProvider = s[0085];

  node_aka_hex_bestimmen(node_nr, netz_nr);

  // wenn Windows Version nicht automatisch erkannt, dann Benutzerangabe
  // auswerten
  If OS = -1 Then OS := BS.ItemIndex;

  // temp. Pointnummer bilden aus CRC über Name, PLZ_Ort, Telefonnummer
  temp_Aka_Dez := crc_bilden_dez(TBName.Text+ TBOrt.Text + TBTelefon.Text);

  // neue Verbindung "Fido-Paket deluxe" im DFÜ-Netzwerk
  // erstellen, oder ersetzen, falls vorhanden
  If not netzwerk and not internet Then If neue_Verbindung_erstellen(ListeDevices) = False Then
  Begin
    // Fehler beim Erstellen der Verbindung aufgetreten;
    // Abbruch der Installation mit Errorlevel 12
    Application.MessageBox(PChar(s[0058]), PChar(s[0055]), MB_OK);
    Halt(12);
  End;

  Angaben.Hide;        // Eingabe-Formular verstecken
  Installieren.Show;   // Formular mit Fortschrittsanz. der Installation zeigen
  Hintergrund.Update;  // blauen Hintergrund neu zeichnen
  Installieren.Update; // Installieren-Formular neu auf Hintergrund zeichnen

  // alle Dateien in das angegebene Installations-Verzeichnis kopieren
  Dateien_in_Zielverzeichnis_kopieren;

  // Verzeichnis für FLS (File List Server) Ergebnisdateien anlegen
  {$I-} MkDir(InstDir + '\binkley\files\fls'); {$I+}
  IOResult;

  // Proxy Anmeldung notwendig?
  If (not CBProxyPwd.Visible) or (not CBProxyPwd.Checked) or
     ((TBProxyUser.Text = 'user') and (TBProxyPwd.Text = 'passwort'))
   Then ProxyAuth := ''
   Else ProxyAuth := TBProxyUser.Text + '/' + TBProxyPwd.Text;

  // BinkD ohne Pointdaten für ersten Poll mit temp. Pointnummer konfigurieren
  BinkD_temp_konfigurieren(temp_Aka_Dez, TBName.Text, TBOrt.Text,
                           CBProxy.ItemIndex, TBProxyIP.Text, ProxyPort.Text,
                           ProxyAuth);

  // CDP Datei an Node schicken, CDN Datei mit Pointdaten empfangen
  fehler := Pointdaten_anfordern(TBName.Text, TBOrt.Text, TBTelefon.Text,
                                 Application.Handle, lstEntries, isUserOnline);
  If fehler <> 0 Then Begin
    // Fehler aufgetreten (näheres siehe in der Funktion Pointdaten_anfordern);
    // Installieren-Anzeige schließen; Eingabe-Formular wieder anzeigen, damit
    // der Benutzer seine Auswahl ändern und dann erneut versuchen kann
    nichtFragen := true;
    Angaben.Visible := true;
    Installieren.Close;
    Hintergrund.Update; // blauen Hintergrund neu zeichnen
    Angaben.Update;     // Eingabe-Formular neu zeichnen
    Exit;               // auf Benutzereingabe im Formular warten
  End;

  BinkD_fertig_konfigurieren; // AKA (zugewiesene Pointnummer) eintragen

  HPT_konfigurieren(TBName.Text, TBOrt.Text);

  Fastlist_konfigurieren;

  Golded_konfigurieren(TBName.Text);

  cfg_schreiben;

(*
  If cdn_uebergeben Then Begin
    If node_anpollen(lstEntries, isUserOnline) = false Then Begin
      // Fehler aufgetreten (näheres siehe in der Funktion node_anpollen);
      // Installieren-Anzeige schließen; Eingabe-Formular wieder anzeigen, damit
      // der Benutzer seine Auswahl ändern und dann erneut versuchen kann
      nichtFragen := true;
      Angaben.Visible := true;
      Installieren.Close;
      Hintergrund.Update; // blauen Hintergrund neu zeichnen
      Angaben.Update;     // Eingabe-Formular neu zeichnen
      Exit;               // auf Benutzereingabe im Formular warten
    End;
    If not not_auflegen Then auflegen(nameProvider);
  End;
*)

  // inst.bat ausführen
  lstrcpy(cmd, comspec);
  lstrcat(cmd, PChar(InstDir+'\binkley\inst.bat'));
  DosOutput.starteProgrammRedirect(InstDir, cmd, fehler2, 2, True);
  SysUtils.DeleteFile(InstDir+'\binkley\inst.bat');

  // goldarea.bat ausführen
  lstrcpy(cmd, comspec);
  lstrcat(cmd, PChar(InstDir+'\binkley\hpt\goldarea.bat'));
  DosOutput.starteProgrammRedirect(InstDir, cmd, fehler2, 0, True);

  // nodecomp.bat aufrufen -> Nodeliste compilieren
  lstrcpy(cmd, comspec);
  lstrcat(cmd, PChar(InstDir+'\binkley\nodecomp.bat'));
  DosOutput.starteProgrammRedirect(InstDir, cmd, fehler2, 0, False);

  // erster Poll mit zugewiesener Pointnummer und Passwort, Areas anbestellen
  If not cdn_uebergeben Then normalPoll;

  // Icons und Verknüpfung im Startmenü erstellen
  Verknuepfungen_auf_Desktop_und_Startmenue_erstellen;

  // von der Installation vorhandene Netmails löschen (Anbestellung der Mail-
  // und File-Areas)
  {$I-}
  DeleteFile(InstDir+'\binkley\netmail\1.msg');
  DeleteFile(InstDir+'\binkley\netmail\2.msg');
  {$I+}
  IOResult;

  // Begrüssungs-Netmail mit Node als Absender erstellen
  Assignfile(mailfile, InstDir+'\binkley\hpt\welcome.txt');
  Rewrite(mailfile);
  While Pos('_', node_name) > 0 Do node_name[Pos('_', node_name)] := ' ';
  mailtext := Format(s[0248], [node_name, Voice, eMail, Background.Version]);
  For i := 1 To Length(mailtext) Do Write(mailfile, mailtext[i]);
  Closefile(mailfile);
  lstrcpy(cmd, PChar(InstDir+'\binkley\hpt\hpt post -nf "' + node_name + '" '
          + '-nt "' + TBName.Text + '" -af "' + NodeAKA + '" -at "' + NodeAKA
          + '.' + point_nr + '" -s "neu im Fido" -d '
          + InstDir+'\binkley\hpt\welcome.txt'));
  DosOutput.starteProgrammRedirect(InstDir, cmd, fehler2, 0, False);

  MaxoutFortschrittsanzeige;
  Pollen.Close; // Status-Fenster über Pollvorgang schließen
  Installieren.Mitteilung.Caption := s[0022];
  Installieren.cmdAbbruch.Caption := 'OK'; // nicht ändern (wird abgefragt)!
  Installieren.Visible := True; // Anzeige, daß die Installation beendet ist
end;

function TAngaben.daten_pruefen: Boolean;
Var i      : Integer;
    name   : String;
begin
  daten_pruefen := False; // kein (offensichtlicher) Fehler in den Angaben

//  intVorwahl := '';

  // Name prüfen
  If TBName.Text = '' Then
  Begin
    // kein Name eingegeben
    daten_pruefen := True;
    Application.MessageBox(PChar(s[0063]), PChar(s[0062]), MB_OK);
    TBName.SetFocus;
    Exit;
  End;
  If (Pos(' ', TBName.Text) < 1) or (Length(TBName.Text) < 6) Then
  Begin
    // Name unvollständig (Vor- und Nachname muss eingegeben werden)
    daten_pruefen := True;
    Application.MessageBox(PChar(s[0064]), PChar(s[0062]), MB_OK);
    TBName.SetFocus;
    Exit;
  End
  Else Begin // Nachname groß schreiben
    name := TBName.Text;
    i := Length(name);
    While (name[i] <> ' ') Do Dec(i);
    Inc(i);
    name[i] := UpCase(name[i]);
    TBName.Text := name;
  End;

  // Ort prüfen
  If TBOrt.Text = '' Then
  Begin
    // kein Ort eingegeben
    daten_pruefen := True;
    Application.MessageBox(PChar(s[0065]), PChar(s[0062]), MB_OK);
    TBOrt.SetFocus;
    Exit;
  End;
  If Length(TBOrt.Text) < 2 Then
  Begin
    // ungültiger Ort
    daten_pruefen := True;
    Application.MessageBox(PChar(s[0066]), PChar(s[0062]), MB_OK);
    TBOrt.SetFocus;
    Exit;
  End;

  // Telefonnummer prüfen
  If TBTelefon.Text = '' Then
  Begin
    // keine Telefonnummer eingegeben
    daten_pruefen := True;
    Application.MessageBox(PChar(s[0067]), PChar(s[0062]), MB_OK);
    TBTelefon.SetFocus;
    Exit;
  End;
  If (Pos('-', TBTelefon.Text) = 0)
     and (Pos('/', TBTelefon.Text) = 0) Then
  Begin
    // Vorwahl und Rufnummer nicht mit '-' getrennt
    daten_pruefen := True;
    Application.MessageBox(PChar(s[0068]), PChar(s[0062]), MB_OK);
    TBTelefon.SetFocus;
    Exit;
  End;
  If Length(TBTelefon.Text) < 8 Then
  Begin
    // ungültige Telefonnummer
    daten_pruefen := True;
    Application.MessageBox(PChar(s[0069]), PChar(s[0062]), MB_OK);
    TBTelefon.SetFocus;
    Exit;
  End;

  // prüfen, ob auf ausgewähltem Installations-Laufwerk mind. 20 MB frei sind;
  // 10 MB werden für die Programme benötigt, Rest ist Minimum für Messagebase
  If DiskFree(Byte(InstDir[1])-64) < 20480 Then
  Begin
    // nicht genug Speicherplatz auf gewähltem Laufwerk
    daten_pruefen := True;
    Application.MessageBox(PChar(Format(s[0071], [InstDir[1]])), sprache_Fehler, MB_OK);
    CBInstallDir.SetFocus;
    Exit;
  End;

end;


procedure TAngaben.Dateien_in_Zielverzeichnis_kopieren;
Var first: Byte;
begin
  // Packer in Pfad je nach BS kopieren, ohne Unterverzeichnisse
  first := 1; // erster Aufruf der CopyDirectory-Funktion, dort wird
              // beim ersten Aufruf der Fortschrittsbalken im Formulat erzeugt

  If not (Paramstr(2) = 'test') Then Begin
//  If OS = 0 Then CopyDirectory(aktDir+'fido\packer\', WinDir + 'command\', False, first, updaten)
//            Else CopyDirectory(aktDir+'fido\packer\', WinDir, False, first, updaten);
  CopyDirectory(aktDir+'fido\packer\', WinDir, False, first, updaten);

  // Packer zusätzlich noch ins Fido-Paket-Installations-Verzeichnis kopieren,
  // falls z.B. Windows mal neu installiert wird, als Backup
  CopyDirectory(aktDir+'fido\packer\', InstDir + '\Packer\', False, first, updaten);

  // Fido-Programme in Installations-Verzeichnis kopieren, mit Unterverzeichnissen
  // und alle File-Attribute löschen (insbesondere ReadOnly)
  CopyDirectory(aktDir+'fido\binkley\', InstDir + '\Binkley\', True, first, updaten);
  CopyDirectory(aktDir+'fido\golded\',  InstDir + '\Golded\',  True, first, updaten);
  CopyDirectory(aktDir+'fido\menu\',    InstDir + '\',         True, first, updaten);
  CopyFile(PChar(aktDir+'fido\binkley\hpt\confrep.bat'), PCHar(InstDir + '\Binkley\hpt\confrep.bat'), false);
  CopyFile(PChar(aktDir+'fido\Info.txt'), PCHar(InstDir + '\Info.txt'), false);
  CopyFile(PChar(aktDir+'fido\whatsnew.txt'), PCHar(InstDir + '\whatsnew.txt'), false);
  End Else Begin // zum lokalen Testen aus dem Compiler heraus
  CopyDirectory('\kalle\fido\binkley\', InstDir + '\Binkley\', True, first, updaten);
  CopyDirectory('\kalle\fido\golded\',  InstDir + '\Golded\',  True, first, updaten);
  CopyDirectory('\kalle\fido\menu\',    InstDir + '\',         True, first, updaten);
  CopyFile('\kalle\fido\binkley\hpt\confrep.bat', PCHar(InstDir + '\Binkley\hpt\confrep.bat'), false);
  CopyFile('\kalle\fido\Info.txt', PCHar(InstDir + '\Info.txt'), false);
  CopyFile('\kalle\fido\whatsnew.txt', PCHar(InstDir + '\whatsnew.txt'), false);
  End;

  dateienKopiert := true;
end;

procedure TAngaben.cfg_schreiben;
var f: Textfile;
begin
  Assignfile(f, InstDir+'\mh-fido.cfg');
  Rewrite(f);
  Writeln(f, netz_nr);      // Netznummer des Nodes
  Writeln(f, node_nr);      // Nodenummer des Nodes
  Writeln(f, node_aka_hex); // Netz- und Nodenummer des Nodes, hex
  Writeln(f, WinDir);       // Windows-Verzeichnis mit abschließendem Backslash
  Writeln(f, InstDir);      // Installations-Verzeichnis ohne Backslash am Ende
  Writeln(f, Username);     // Username für ppp Login
  Writeln(f, Passwort);     // Passwort für ppp Login
  If netzwerk or forced Then Writeln(f, '-l')
  Else If not internet
   Then Writeln(f, 'Fido-Paket deluxe')
   Else Begin
     If otherProvider
      Then Writeln(f, 'otherProvider')
      Else Writeln(f, nameProvider);
   End;
  Writeln(f, Sprache);
  Writeln(f, NodeAKA);
  Writeln(f, '-5'); // AutoPoll deaktiviert, Slider auf 5 Minuten
  Writeln(f, version);
  Closefile(f);
end;

procedure TAngaben.Verknuepfungen_auf_Desktop_und_Startmenue_erstellen;
var
  MyObject  : IUnknown;
  MySLink   : IShellLink;
  MyPFile   : IPersistFile;
  FileName  : String;
  Directory : String;
  WFileName : WideString;
  MyReg     : TRegIniFile;
begin
  MyObject := CreateComObject(CLSID_ShellLink);
  MySLink := MyObject as IShellLink;
  MyPFile := MyObject as IPersistFile;
  FileName := InstDir + '\Fido.exe';
  with MySLink do begin
    If netzwerk Then SetArguments('-l') // optionale Parameter
    Else If internet and not forced Then SetArguments('-i')
    Else If internet and forced Then SetArguments('-i -f')
    Else SetArguments('');
    SetPath(PChar(FileName));
    SetWorkingDirectory(PChar(ExtractFilePath(FileName)));
  end;
  MyReg := TRegIniFile.Create(
    'Software\MicroSoft\Windows\CurrentVersion\Explorer');

// Use the next line of code to put the shortcut on your desktop
  Directory := MyReg.ReadString('Shell Folders','Desktop','');

// Use the next three lines to put the shortcut on your start menu
//  // in den Unterordner Fido im Startmenü
//  Directory := MyReg.ReadString('Shell Folders','Start Menu','')+'\Fido';
//  // direkt im Startmenü
//  Directory := MyReg.ReadString('Shell Folders','Start Menu','');
//  CreateDir(Directory);

  WFileName := Directory+'\'+s[0072]+'.lnk';  // auf Desktop
  MyPFile.Save(PWChar(WFileName),False);

  // direkt im Startmenü unerhalb von Programme
  Directory := MyReg.ReadString('Shell Folders','Programs','') + '\Fido';
  {$I-} MkDir(Directory); {$I+} // Unterverzeichnis Fido (Start/Programme/Fido)
  IF IOResult <> 0 Then;
  WFileName := Directory+'\'+s[0072]+'.lnk'; // im Startmenü
  MyPFile.Save(PWChar(WFileName),False);

  MySLink.SetArguments('-out'); // optionale Parameter
  WFileName := Directory+'\'+s[0073]+'.lnk'; // im Startmenü
  MyPFile.Save(PWChar(WFileName),False);

  FileName := InstDir + '\Info.txt';
  with MySLink do begin
    SetPath(PChar(FileName));
    SetArguments(''); // optionale Parameter
    SetWorkingDirectory(PChar(ExtractFilePath(FileName)));
  end;
  WFileName := Directory+'\Info.lnk'; // im Startmenü
  MyPFile.Save(PWChar(WFileName),False);

  FileName := InstDir + '\Uninst.exe';
  with MySLink do begin
    SetPath(PChar(FileName));
    SetWorkingDirectory(PChar(ExtractFilePath(FileName)));
  end;
  // im Startmenü
  WFileName := Directory+'\'+s[0074]+'.lnk';
  MyPFile.Save(PWChar(WFileName),False);

  MyReg.Free;
end;


procedure TAngaben.FormShow(Sender: TObject);
begin
  If firsttime Then Form_vorbereiten(Sender);
  internet := false;
  not_auflegen := false;

  If updaten Then Begin
    Form1.Enabled := false;
    Form1.Close;      // Willkommens-Formular verstecken
    Update_durchfuehren(Sender);
    Exit;
  End;

  If ExistDir(InstDir) and not nichtFragen and (stop = -1) Then CBInstallDirClick(Sender);
  Form1.Enabled := false;
  Form1.Close;      // Willkommens-Formular verstecken

  Application.ProcessMessages;
  TBName.SetFocus; // Fokus auf das erste Feld (Namenseingabe) setzen
end;

procedure TAngaben.Umlaut_wandeln(Feld: Byte; Umlaut: String; Var Key: Char);
begin
  If Feld = 1 Then
  Begin
    TBName.Text := TBName.Text + Umlaut;
    TBName.SelStart := Length(TBName.Text);
  End;
  If Feld = 2 Then
  Begin
    TBOrt.Text := TBOrt.Text + Umlaut;
    TBOrt.SelStart := Length(TBOrt.Text);
  End;

  Key := Chr(255); // ungültiges Zeichen
end;

procedure TAngaben.TBNameKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = Chr(13) { Return } Then TBOrt.SetFocus; // wie TAB
  Case Key of
   'ä': Umlaut_wandeln(1, 'ae', Key);
   'ö': Umlaut_wandeln(1, 'oe', Key);
   'ü': Umlaut_wandeln(1, 'ue', Key);
   'Ä': Umlaut_wandeln(1, 'Ae', Key);
   'Ö': Umlaut_wandeln(1, 'Oe', Key);
   'Ü': Umlaut_wandeln(1, 'Ue', Key);
   'ß': Umlaut_wandeln(1, 'ss', Key);
  end;

  If TBName.SelStart = 0 Then Key := Upcase(Key);

  If Not ((Key >= 'A') and (Key <= 'Z')) and Not ((Key >= 'a') and (Key <= 'z'))
     and (Key <> ' ') and (Key <> '-') and (Key <> Chr(8)) { DEL } Then Key := Chr(7);
end;

procedure TAngaben.TBOrtKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = Chr(13) { Return } Then TBTelefon.SetFocus; // wie TAB
  Case Key of
   'ä': Umlaut_wandeln(2, 'ae', Key);
   'ö': Umlaut_wandeln(2, 'oe', Key);
   'ü': Umlaut_wandeln(2, 'ue', Key);
   'Ä': Umlaut_wandeln(2, 'Ae', Key);
   'Ö': Umlaut_wandeln(2, 'Oe', Key);
   'Ü': Umlaut_wandeln(2, 'Ue', Key);
   'ß': Umlaut_wandeln(2, 'ss', Key);
  end;

  If TBName.SelStart = 0 Then Key := Upcase(Key);

  If Not ((Key >= 'A') and (Key <= 'Z')) and Not ((Key >= 'a') and (Key <= 'z'))
     and Not ((Key >= '0') and (Key <= '9'))
     and (Key <> ' ') and (Key <> Chr(8)) { DEL } Then Key := Chr(7);
end;

procedure TAngaben.TBTelefonKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = Chr(13) { Return } Then ListeDevices.SetFocus; // wie TAB
  If Key = '/' Then Key := '-';
end;

procedure TAngaben.noPoint(meldung: String);
Var noPointText: String;
begin
  If meldung = '' Then meldung := Format(s[0075], [InstDir]);

  If (Pos(sprache_Fehlercode, meldung) > 0)
   Then noPointText := meldung + Chr(13) + Chr(13)
   Else noPointText := s[0076] + meldung + Chr(13) + Chr(13);

  noPointText := noPointText + s[0077];

  PollAbbruch := false; // sonst wird das Prog durch einen Halt(66) in Background
                        // bei FormPaint beendet, da keine Fenster mehr offen sind
  Application.MessageBox(PChar(noPointText), 'Fehler', MB_OK);
end;

procedure TAngaben.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var verz    : String[20];
    meldung : String;
    info    : String;
begin
  If dateienKopiert Then Begin
    // fragen, ob bereits kopierte Dateien gelöscht werden sollen
    meldung := s[0078];
    info := s[0079];

    If Application.MessageBox(PChar(meldung), PChar(info), MB_YesNo) = ID_Yes Then
    Begin
      ChDir('\');
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

      Application.MessageBox(PChar(s[0080]), PChar(s[0079]), MB_Ok);
    End;
  End;

  Halt(1);
end;

procedure TAngaben.CBInstallDirClick(Sender: TObject);
var altInstDir : String;
    meldung    : String;
    info       : String;
    antwort    : Integer;
    abbruch    : Boolean;
begin
  abbruch := not VerzeichnisAuswahl.Execute;

  If abbruch Then Begin
    VerzeichnisAuswahl.Folder := InstDir;
    If not Form1.Enabled Then Exit;
  End;

  altInstDir := InstDir;
  If altInstDir = '' Then altInstDir := 'C:\';

  InstDir := VerzeichnisAuswahl.Folder;
  If InstDir = '' Then InstDir := 'C:\';
  If InstDir[Length(InstDir)] <> '\' Then InstDir := InstDir + '\';
  InstDir := InstDir +'Fido';

  If Pos(' ', InstDir) > 0 Then Begin
    meldung := Format(s[0081], [InstDir]);
    info := sprache_Info;

    Application.MessageBox(PChar(meldung), PChar(info), MB_OK);
    InstDir := altInstDir;
    VerzeichnisAuswahl.Folder := InstDir;
    CBInstallDirClick(Sender);
    Exit;
  End;

  If updaten Then Exit;

  meldung := Format(s[0082], [InstDir]);
  info := s[0083];

  If ExistDir(InstDir) Then Begin
    cdn := InstDir;
    If (cdn[Length(cdn)] <> '\') Then cdn := cdn + '\';
    cdn := cdn + 'point.cdn';
    If FileExists(cdn) Then Begin
      antwort := Application.MessageBox(PChar(s[0255]), sprache_Info, MB_YesNo);
      If antwort = ID_Yes Then Begin
        cdn_uebergeben := True;
        CopyFile(PChar(cdn), 'c:\point.cdn', false);
        DelTree(InstDir);
        {$I-}
        MkDir(InstDir);
        CopyFile('c:\point.cdn', PChar(cdn), false);
        DeleteFile('c:\point.cdn');
        {$I+}
        IOResult;
      End;
    End;

    If not cdn_uebergeben Then Begin
      antwort := Application.MessageBox(PChar(meldung),
                   PChar(info), MB_YesNoCancel+MB_DefButton2);
      If antwort = ID_Yes Then DelTree(InstDir)
      Else If antwort = ID_No Then Begin
         InstDir := altInstDir;
         If Form1.Enabled Then CBInstallDirClick(Sender);
      End
      Else Begin stop := 25; Application.Terminate; End;
    End;
  End;

  Pfad.Caption := Format(s[0084], [UpperCase(InstDir)]);
end;

procedure TAngaben.TimerTimer(Sender: TObject);
begin
  If stop > -1 Then Begin
//    self.close;
    Halt(stop);
  End;

  If PollAbbruch Then Pollen.Close;
end;


procedure TAngaben.CdpNodes_auflisten(inet: Boolean);
var i: Integer;
begin
  CdpNodelist.Clear;
  CdpNodelist2.Clear;

  If inet Then Begin
    For i := 1 to CdpNodelist_internet.Items.Count Do Begin
      CdpNodelist.Items.Add(CdpNodelist_internet.Items.Strings[i-1]);
      CdpNodelist2.Items.Add(CdpNodelist2_internet.Items.Strings[i-1]);
    End;
  End
  Else Begin
    For i := 1 to CdpNodelist_dstn.Items.Count Do Begin
      CdpNodelist.Items.Add(CdpNodelist_dstn.Items.Strings[i-1]);
      CdpNodelist2.Items.Add(CdpNodelist2_dstn.Items.Strings[i-1]);
    End;
  End;
end;


procedure TAngaben.ListeDevicesChange(Sender: TObject);
begin
  RBinternetClick;

//  CdpNodes_auflisten(Pos('nternet',
//                     ListeDevices.Items.Strings[ListeDevices.ItemIndex]) > 0);
//  CdpNodelist.ItemIndex := 0; // Auswahlbalken auf ersten Eintrag setzen
end;



procedure TAngaben.GetEntries(Var anzahl: Integer);
var
  bufsize: Longint;
  numEntries: Longint;
  entries, p: LPRasEntryName;
  x: Integer;
  res: Integer;
begin
  lstEntries.Items.Clear;

  If anzahl > 0 Then Begin
    entries := AllocMem(SizeOf(TRasEntryName));
    entries^.dwSize := SizeOf(TRasEntryName);
    bufsize := SizeOf(TRasEntryName);
    res := RasEnumEntries(nil, nil, entries, bufsize, numEntries);
    if res = ERROR_BUFFER_TOO_SMALL then
      begin
      ReallocMem(entries, bufsize);
      FillChar(entries^, bufsize, 0);
      entries^.dwSize := SizeOf(TRasEntryName);
      res := RasEnumEntries(nil, nil, entries, bufsize, numEntries);
      end;
    if res = 0 then
      begin
      if numEntries > 0 then
        begin
        p := entries;
        for x := 0 to numEntries - 1 do
          begin
          lstEntries.Items.Add(p^.szEntryName);
          Inc(p);
          end;
        end;
      end;
//    else
//      ShowMessage('RasEnumEntries failed.');
    FreeMem(entries);
  End;

  lstEntries.Items.Add(s[0085]);
  lstEntries.Items.Add(s[0254]);
  lstEntries.ItemIndex := 0;
  If IsUserOnlineLAN Then lstEntries.ItemIndex := (lstEntries.Items.Count-1);
end;


procedure TAngaben.RBinternetClick;
Var i: Integer;
begin
  CdpNodes_auflisten(true); // Internet-Nodes auflisten
  CdpNodelist.ItemIndex := 0; // Auswahlbalken auf ersten Eintrag setzen

  For i := 0 to (CdpNodelist.Items.Count-1) Do
  If Pos('Christian von Busse', CdpNodelist.Items.Strings[i]) > 0 Then Begin
    // wenn Christian von Busse in der Liste vorhanden ist, dann
    // Auswahlbalken auf dessen Eintrag setzen
    CdpNodelist.ItemIndex := i;
    break;
  End;

  // Liste mit im System vorhandenen Devices verstecken und
  // Internet-Provider auflisten
  ListeDevices.Visible := false;
  lstEntries.Visible := true;

  ProfiKonfig.Visible := true;

end;

Function DaysInMonth(Month:Byte;Year:Word):Byte;
Begin
  DaysInMonth := 28; // nur um Compiler-Warnung zu unterdrücken, nicht wichtig

  Case Month Of
     1:DaysInMonth:=31;
     2:Begin
         If (Year Mod 100)=0 Then      {Centuary}
           If (Year Mod 400)=0 Then
             DaysInMonth:=29
           Else
             DaysInMonth:=28
         Else                          {Non Centuary}
           If (Year Mod 4)=0 Then
             DaysInMonth:=29
           Else
             DaysInMonth:=28;
       End;
     3:DaysInMonth:=31;
     4:DaysInMonth:=30;
     5:DaysInMonth:=31;
     6:DaysInMonth:=30;
     7:DaysInMonth:=31;
     8:DaysInMonth:=31;
     9:DaysInMonth:=30;
    10:DaysInMonth:=31;
    11:DaysInMonth:=30;
    12:DaysInMonth:=31;
  End;
End;

procedure TAngaben.Update_durchfuehren(Sender: TObject);
var f, g         : Textfile;
    zeile        : String;
    zeile2       : String;
    i            : Integer;
    abbruch      : Boolean;
    meldung      : String;
    info         : String;
    antwort      : Integer;
    fehler       : LongBool;
    cmd          : Array[0..2*MAX_PATH] of Char;
    heute        : TDateTime;
    jahr, monat,
    tag          : Word;
    gefunden     : Boolean;
    gefunden2    : Boolean;
    gefunden3    : Boolean;
    browser      : String;
    zeilenAnzahl : Integer;
    point_nr     : String[5];
    Arealiste    : TListBox;
    echoname     : String;
begin
  If firsttime Then Form_vorbereiten(Sender);
  firsttime := False;
  internet := false;
  not_auflegen := false;

  Form1.Enabled := false;
  Form1.Close;      // Willkommens-Formular verstecken
  Angaben.Hide;
  Application.ProcessMessages;

  // Verzeichnis mit vorhandener Installation auswählen lassen
  VerzeichnisAuswahl.NewFolderEnabled := false;
  VerzeichnisAuswahl.NewFolderVisible := false;
  abbruch := false;
  Repeat
    CBInstallDirClick(Sender);

    meldung := Format(s[0086], [InstDir]);
    info := sprache_Info;

    If (InstDir <> '') and FileExists(InstDir+'\point.cdn') Then abbruch := true
    Else Begin
      antwort := Application.MessageBox(PChar(meldung),
                   PChar(info), MB_OkCancel);
      If antwort <> ID_Ok Then Angaben.Close;
    End;
  Until abbruch;


  Installieren.Show;   // Formular mit Fortschrittsanz. der Installation zeigen
  Hintergrund.Update;  // blauen Hintergrund neu zeichnen
  Installieren.Update; // Installieren-Formular neu auf Hintergrund zeichnen
  Application.ProcessMessages;

  // ins Installations-Verzeichnis wechseln (wegen FidoInst.log bei Fehler)
  ChDir(InstDir);

  cdn_auslesen(InstDir+'\point.cdn');

  // cfg lesen
  Username := '';
  Passwort := '';
  NodeAKA := '';
  alte_Version := '1.0';

  {$I-}
  Assignfile(f, InstDir+'\mh-fido.cfg');
  Reset(f);
  Readln(f, netz_nr);      // Netznummer des Nodes
  Readln(f, node_nr);      // Nodenummer des Nodes
  Readln(f, node_aka_hex); // Netz- und Nodenummer des Nodes, hex
  Readln(f);               // Windows-Verzeichnis mit abschließendem Backslash
  Readln(f, InstDir);      // Installations-Verzeichnis ohne Backslash am Ende
  Readln(f, Username);     // Username für ppp Login
  Readln(f, Passwort);     // Passwort für ppp Login
  Readln(f, nameProvider); // Internet Provider oder DFÜ Verbindung (oder lokal)
  netzwerk := (nameProvider = '-l');
  otherProvider := (nameProvider = 'otherProvider') or (nameProvider = s[0085]);
  internet := (nameProvider <> 'Fido-Paket deluxe') and (nameProvider <> '-l');
  Readln(f);               // Sprache
  Readln(f, NodeAKA);
  Readln(f);               // AutoPoll (de)aktiviert und Minuten
  Readln(f, alte_Version); // Versionsnummer der vorhandenen Installation
  Closefile(f);
  {$I+}
  If not (IOResult = 0) Then Begin
    If alte_Version = '' Then alte_Version := '1.0';
  End;
  If Pos('1.4ß', alte_Version) > 0 Then alte_Version := '1.3';
  If Pos('1.5ß', alte_Version) > 0 Then alte_Version := '1.4';
  If Pos('1.6ß', alte_Version) > 0 Then alte_Version := '1.5';
  If Pos('1.6b', alte_Version) > 0 Then alte_Version := '1.51';
  If Pos('1.7b', alte_Version) > 0 Then alte_Version := '1.6';
  If Pos('1.8b', alte_Version) > 0 Then alte_Version := '1.7';
  If Pos('1.9b', alte_Version) > 0 Then alte_Version := '1.8';
  If Pos('2.0b', alte_Version) > 0 Then alte_Version := '1.9';
  If Pos('2.1b', alte_Version) > 0 Then alte_Version := '2.0';
  If Pos('2.2b', alte_Version) > 0 Then alte_Version := '2.1';
  If Pos('2.3b', alte_Version) > 0 Then alte_Version := '2.2';
  If Pos('2.4b', alte_Version) > 0 Then alte_Version := '2.3';
  If Pos('2.5b', alte_Version) > 0 Then alte_Version := '2.4';
  If Pos('2.6b', alte_Version) > 0 Then alte_Version := '2.5';
  If Pos('2.7b', alte_Version) > 0 Then alte_Version := '2.6';
  If Pos('2.8b', alte_Version) > 0 Then alte_Version := '2.7';
  If Pos('2.9b', alte_Version) > 0 Then alte_Version := '2.8';
  If Pos('2.9', alte_Version) > 0 Then alte_Version := '2.8'; // v2.9 nochmal released wegen Bug
  If Pos('1.6.0204', alte_Version) > 0 Then alte_Version := '1.51';
  If (Length(alte_Version) > 4) Then Begin
    If (Pos('1.51', alte_Version) = 0)
      Then alte_Version := Copy(alte_Version,2,3)
      Else alte_Version := Copy(alte_Version,2,4);
  End;

  // alle Dateien in das angegebene Installations-Verzeichnis kopieren
  Dateien_in_Zielverzeichnis_kopieren;

  // lock.hpt loeschen, falls es existiert
  SysUtils.DeleteFile(InstDir+'\binkley\hpt\lock.hpt');

  If (alte_Version = '1.0') or (alte_Version = '1.1') Then Begin
    // pflege.bat
    Assignfile(f, InstDir + '\binkley\pflege.bat');
    Rewrite(f);
    Writeln(f, '@echo off');
    Writeln(f, 'cd ' + InstDir + '\binkley\hpt');
    Writeln(f, 'hpt toss -b');
    Writeln(f, 'rem sqpack');
    Writeln(f, 'rem hptutil link');
    Writeln(f);
    Writeln(f, 'cd ' + InstDir + '\binkley\flags');
    Writeln(f, 'if exist *.bsy del *.bsy>nul');
    Writeln(f, 'cd ..\outecho');
    Writeln(f, 'if exist *.bsy del *.bsy>nul');
    Writeln(f, 'cd ' + InstDir + '\binkley\hpt');
    Writeln(f, 'if exist hpt.lck del hpt.lck>nul');
    Writeln(f, 'cd ' + InstDir + '\binkley');
    Writeln(f, 'del *.bsy /s>nul');
    Closefile(f);

    // pflege2.bat
    Assignfile(f, InstDir + '\binkley\pflege2.bat');
    Rewrite(f);
    Writeln(f, '@echo off');
    Writeln(f, 'cd ' + InstDir + '\binkley\hpt');
    Writeln(f, 'sqpack');
    Writeln(f, 'hptutil link');
    Closefile(f);

    // golded.cfg
    Assignfile(f, InstDir + '\golded\golded.cfg');
    Assignfile(g, InstDir + '\golded\goldcfg.tmp');
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('ORIGIN ', zeile) = 1
       Then zeile := 'ORIGIN www.fido-deluxe.de.vu    ' + s[0104] + ' -IP- deluxe';
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir+'\golded\golded.cfg');

    // Husky config
    Assignfile(f, InstDir + '\binkley\hpt\config');
    Assignfile(g, InstDir + '\binkley\hpt\config.tmp');
    Reset(f);
    Rewrite(g);
    For i := 1 To 85 Do Begin
      Readln(f, zeile);
      Writeln(g, zeile);
    End;
    Readln(f);
    Writeln(g, 'Outbound        ' + InstDir + '\binkley\outecho\');
    While Not EOF(f) Do
    Begin
      Readln(f, zeile);
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir+'\binkley\hpt\config');

    alte_Version := '1.2'; // damit auch die neueren Updates ausgeführt werden
  End; // Version 1.0 und 1.1

  If (alte_Version = '1.2') or (alte_Version = '1.3') Then Begin
    Assignfile(f, InstDir + '\binkley\binkd.cfg');
    Assignfile(g, InstDir + '\binkley\binkdcfg.tmp');
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('node 2:2457/265 ', zeile) = 1 Then Begin
        While (Length(zeile) > 1) and (zeile[Length(zeile)] = ' ') Do
         Delete(zeile, Length(zeile), 1); // Leerzeichen am Ende löschen
        While (Length(zeile) > 1) and (Pos(' ', zeile) > 0) Do
         Delete(zeile,1,1); // bleibt nur Passwort übrig
//        zeile := 'node 2:2457/265 -crc fls.dynodns.net;fls.dyns.cx;fls.dyndns.org '
        zeile := 'node 2:2457/265 fls.dynodns.net;fls.dyns.cx;fls.dyndns.org '
                 + zeile;
      End;
      If Pos('#include binkd.inc', zeile) > 0 Then zeile := 'include binkd.inc';
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir+'\binkley\binkd.cfg');

    Assignfile(f, InstDir + '\binkley\nodecomp.bat');
    Assignfile(g, InstDir + '\binkley\nodecomp.tmp');
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('iprouted.exe', zeile) = 0 Then Begin
      // damit der Eintrag bei mehrfachem Update nicht mehrmals vorhanden ist
        If Pos('fastlst.exe', zeile) = 1 Then Begin
          Writeln(g, zeile);
          zeile := 'iprouted.exe';
        End;
        Writeln(g, zeile);
      End;
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir+'\binkley\nodecomp.bat');

    // iproute.cfg
    Assignfile(f, InstDir + '\binkley\nodelist\iproute.cfg');
    Rewrite(f);
    Writeln(f, '#       global stuff');
    Writeln(f, 'nodelist: ' + InstDir + '\binkley\nodelist');
    Writeln(f, 'flags:    ibn');
    Writeln(f, 'nopack:    ' + NodeAKA);
    Writeln(f, '#       binkd stuff');
    Writeln(f, 'binkd:    ' + InstDir + '\binkley\binkd.inc');
    Writeln(f, 'binkdcfg: ' + InstDir + '\binkley\binkd.cfg');
    Writeln(f, 'linux:    no');
    Writeln(f, 'biflavor: -');
    Closefile(f);

    // nodecomp.bat aufrufen -> Nodeliste compilieren
    lstrcpy(cmd, comspec);
    lstrcat(cmd, PChar(InstDir+'\binkley\nodecomp.bat'));
    DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 1, True);

    // Golded Adressmakros
    If not FileExists(InstDir+'\golded\adrmacro.cfg') Then Begin
      Assignfile(f, InstDir+'\golded\adrmacro.cfg');
      Rewrite(f);
      Writeln(f, 'ADDRESSMACRO   areamgr,AreaMgr,' + NodeAKA + ',' + AreafixPassword);
      Writeln(f, 'ADDRESSMACRO   areafix,AreaMgr,' + NodeAKA + ',' + AreafixPassword);
      Writeln(f, 'ADDRESSMACRO   filescan,FileScan,' + NodeAKA + ',' + FiletickerPassword);
//      Writeln(f, 'ADDRESSMACRO   hs,Henning Schroeer,2:2457/265');
      Writeln(f, 'ADDRESSMACRO   mh,Michael Haase,2:2432/280');
//      Writeln(f, 'ADDRESSMACRO   nm,Natanael Mignon,2:2457/667');
//      Writeln(f, 'ADDRESSMACRO   sb,Stefan Buschmann,2:2457/265.25');
      Closefile(f);
    End;

    // Golded Farbkonfiguration
    If not FileExists(InstDir+'\golded\gedcolor.cfg') Then Begin
      Assignfile(f, InstDir+'\golded\gedcolor.cfg');
      Rewrite(f);
      Writeln(f, 'Color Reader Window LGrey on Black');
      Writeln(f, 'Color Reader Quote LGreen on Black');
      Writeln(f, 'Color Reader Quote2 Green on Black');
      Writeln(f, 'Color Reader URL    White on Black');
      Writeln(f, 'Color Stylecode B   White on Black');
      Writeln(f, 'Color Stylecode I   White on Black');
      Writeln(f, 'Color Stylecode BI  White on Black');
      Writeln(f, 'Color Stylecode U   White on Black');
      Writeln(f, 'Color Stylecode BU  White on Black');
      Writeln(f, 'Color Stylecode IU  White on Black');
      Writeln(f, 'Color Stylecode BIU White on Black');
      Closefile(f);
    End;

    // golded.cfg
    Assignfile(f, InstDir + '\golded\golded.cfg');
    Assignfile(g, InstDir + '\golded\goldcfg.tmp');
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('Color Reader Quote lgreen', zeile) = 1 Then Begin
        If not EOF(f) Then Readln(f);
        zeile := 'Include gedcolor.cfg';
      End
      Else If Pos(';   Address macros', zeile) = 1 Then Begin
        If not EOF(f) Then Readln(f);
        zeile := 'Include adrmacro.cfg';
      End;
      If (Pos('COLOR STYLECODE ', zeile) = 0)
         and (Pos('ADDRESSMACRO   ', zeile) = 0) Then Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir+'\golded\golded.cfg');

    // falls durch vorherige Beta die Golded *.tpl zerstört wurden, dann
    // neu einspielen
    If not FileExists(InstDir + '\golded\golded.tpl')
     Then RenameFile(InstDir + '\golded\gold_tpl.sic', InstDir + '\golded\golded.tpl')
     Else DeleteFile(InstDir + '\golded\gold_tpl.sic');
    If not FileExists(InstDir + '\golded\netmail.tpl')
     Then RenameFile(InstDir + '\golded\netm_tpl.sic', InstDir + '\golded\netmail.tpl')
     Else DeleteFile(InstDir + '\golded\netm_tpl.sic');

    alte_Version := '1.4';
  End;

  If (alte_Version = '1.4') Then Begin
    // Verzeichnis für FLS (File List Server) Ergebnisdateien anlegen
    {$I-} MkDir(InstDir + '\binkley\files\fls'); {$I+}
    IOResult;

    // FLS Ergebnisdateien in FLS Verzeichnis verschieben nach Tossen,
    // nicht mehr als Netmail aufbereiten
    Assignfile(f, InstDir + '\binkley\hpt\toss.bat');
    Assignfile(g, InstDir + '\binkley\hpt\toss.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('Suchergebnis vom FLS', zeile) = 0 Then Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\hpt\toss.bat');
    {$I+}
    IOResult;

    // in binkd.cfg -crc entfernen für andere BinkD Version 0.9.5 Snapshot
    Assignfile(f, InstDir + '\binkley\binkd.cfg');
    Assignfile(g, InstDir + '\binkley\binkdcfg.tmp');
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If (Pos('node ', zeile) > 0) and (Pos(' -crc ', zeile) > 0) Then Begin
        i := Pos(' -crc ', zeile);
        Delete(zeile,i,5);
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir+'\binkley\binkd.cfg');

    // Husky config OptGrp (Rechte setzen) und LinkGrp (für AutoAreaCreate) auf
    // alle Gruppen A-Z setzen,
    // Archivareas (Bad, Dupe und Carbon Echo) auf Gruppe Z setzen
    // und CarbonArea auskommentieren (bei neuer hpt Version nicht mehr vorhanden)
    Assignfile(f, InstDir + '\binkley\hpt\config');
    Assignfile(g, InstDir + '\binkley\hpt\config.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('export off', zeile) = 1 Then zeile := 'export on';
      If Pos('linkgrp', zeile) = 1 Then zeile := 'linkgrp A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z';
      If Pos('optgrp', zeile) > 0 Then zeile := 'optgrp A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z';
      If Pos('BadArea', zeile) = 1 Then zeile[Length(zeile)] := 'Z';
      If Pos('DupeArea', zeile) = 1 Then zeile[Length(zeile)] := 'Z';
      If Pos('LocalArea carbonArea', zeile) = 1 Then zeile[Length(zeile)] := 'Z';
      If Pos('CarbonArea', zeile) = 1 Then zeile := '#' + zeile;
      If (Pos('routeFile al ', zeile) = 1) or (Pos('route al ', zeile) = 1) Then Begin
        // Bug des Beta Updates beheben
        Delete(zeile,1,Length('routeFile al '));
        Writeln(g, 'route normal ' + zeile);
        Writeln(g, 'routeFile normal ' + zeile);
        Writeln(g);
        While (Pos('Inbound ', zeile) <> 1) and not EOF(f) Do Readln(f, zeile);
        If Pos('Inbound ', zeile) = 0 Then Begin
          meldung := 'Achtung! Husky Config defekt. Es wird abgebrochen.' + #13
                     + 'Bitte Autor Michael Haase (m.haase@gmx.net) '
                     + 'benachrichtigen, oder neu installieren.' + #13
                     + 'Bitte fido\binkley\hpt\config zu mir schicken. Danke.';
          Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
          Closefile(f);
          Closefile(g);
          Halt;
        End;
      End;
      If Pos('route ', zeile) = 1 Then Begin
        Writeln(g, zeile);
        Writeln(g, 'routeFile ' + Copy(zeile,7,Length(zeile)));
        While (zeile <> '') and not EOF(f) Do Readln(f, zeile);
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir+'\binkley\hpt\config');
    {$I+}
    IOResult;

    // Golded netmail.tpl korrigieren durch Bug in der Beta
    Assignfile(f, InstDir + '\golded\netmail.tpl');
    Assignfile(g, InstDir + '\golded\netmtpl.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If (Pos('@Quote ', zeile) = 1) or (zeile = '@Quote') Then break;
      Writeln(g, zeile);
    End;
    If Pos('@Quote', zeile) = 0 Then Begin
      Closefile(f);
      Closefile(g);
      Erase(g);
      Exit;
    End;
    Writeln(g, zeile);
    Writeln(g);
    Writeln(g, ';   ----------------------------------------------------------------------');
    Writeln(g, ';   Sign the message with your first name.');
    Writeln(g, ';   ----------------------------------------------------------------------');
    Writeln(g);
    Writeln(g, 'Gruss,');
    Writeln(g, '@CFName');
    Writeln(g);
    Writeln(g, '--- @longpid @version');
    Writeln(g);
    Writeln(g, ';');
    Writeln(g, ';   End of template. Confused? Me too! :-)');
    Writeln(g, ';   ----------------------------------------------------------------------');
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\golded\netmail.tpl');
    {$I+}
    IOResult;

    // goldarea.cfg noch ein Include goldgrp.cfg einfügen und Gruppen-Konfig löschen
    Assignfile(f, InstDir + '\golded\goldarea.cfg');
    Assignfile(g, InstDir + '\golded\goldarea.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('AREALISTSORT', zeile) = 1 Then Begin
        Writeln(g, zeile);
        Writeln(g, 'Include goldgrp.cfg');
        zeile := 'AREASEP'; // falls EOF(f) schonmal belegen
        If not EOF(f) Then Begin
          Readln(f, zeile);
          If Pos('goldgrp.cfg', zeile) > 0 Then zeile := 'AREASEP';
        End;
      End;
      If Pos('AREASEP', zeile) = 0 Then Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir+'\golded\goldarea.cfg');
    {$I+}
    IOResult;

    // goldgrp.cfg erzeugen, wenn nicht vorhanden
    Assignfile(f, InstDir + '\golded\goldgrp.cfg');
    {$I-}
    If not FileExists(InstDir + '\golded\goldgrp.cfg') Then Begin
      Rewrite(f);
      Writeln(f, ';AREASEP !A "CCC Echos" A Echo');
      Writeln(f, 'AREASEP !A "Fido Echo" A Echo');
      Writeln(f, 'AREASEP !Z "Archivareas" Z Echo');
      Closefile(f);
    End
    Else Begin
      If (FileGetAttr(InstDir + '\golded\goldgrp.cfg') and faReadOnly) > 0
       Then FileSetAttr(InstDir + '\golded\goldgrp.cfg',
                        FileGetAttr(InstDir + '\golded\goldgrp.cfg')
                        xor faReadOnly); // Schreibschutz entfernen
      Assignfile(g, InstDir + '\golded\goldgrp.tmp');
      Reset(f);
      Rewrite(g);
      While not EOF(f) Do Begin
        Readln(f, zeile);
        If zeile <> 'AREASEP !Z "Archivareas" Z Echo' Then Writeln(g, zeile);
      End;
      Writeln(f, 'AREASEP !Z "Archivareas" Z Echo');
      Closefile(f);
      Closefile(g);
      Erase(f);
      Rename(g, InstDir+'\golded\goldgrp.cfg');
    End;
    {$I+}
    IOResult;

    // wenn poll.bat nicht existiert, aber poll.tmp, dann umbenennen
    // (kam durch einen Bug in der Beta)
    If not FileExists(InstDir + '\binkley\poll.bat')
       and FileExists(InstDir + '\binkley\poll.tmp') Then
     RenameFile(InstDir + '\binkley\poll.tmp', InstDir + '\binkley\poll.bat');

    // in poll.bat ein leeres Paket zum Pollen erzeugen statt eines mit Inhalt "a"
    // und bei neuer nodehtm.zip mit alter Version vergleichen
    Assignfile(f, InstDir + '\binkley\poll.bat');
    Assignfile(g, InstDir + '\binkley\poll.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('.dut echo', zeile) > 0 Then Begin
        i := Pos('.dut echo', zeile);
        If i = 30 Then zeile := Copy(zeile,22,9) + 'clo'
                  Else zeile := Copy(zeile,14,9) + 'clo';
        zeile := 'if not exist ' + zeile + ' ..\makepoll.exe ' + zeile;
      End;
      If Pos('if not exist nodehtm.zip goto echos', zeile) = 1 Then Begin
        Writeln(g, zeile);
        Writeln(g, 'filecmp.exe nodehtm.zip nodehtm_.zip -noerror');
        Writeln(g, 'if errorlevel 1 goto nodeweiter');
        Writeln(g, 'goto nodeweiter2');
        Writeln(g, ':nodeweiter');
        Writeln(g, 'unzip -o -q -j nodehtm.zip');
        Writeln(g, 'echo changed>_changed.fpd');
        Writeln(g, ':nodeweiter2');
        Writeln(g, 'if exist nodehtm_.zip del nodehtm_.zip');
        Writeln(g, 'ren nodehtm.zip nodehtm_.zip');
        While not EOF(f) and (zeile <> '') Do Readln(f, zeile);
      End;
      If Pos('binkd.exe', zeile) > 0 Then Break;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir+'\binkley\poll.bat');
    {$I+}
    IOResult;

    // wegen Fehler in der Beta die nodehtm_.zip nochmal neu einspielen lassen
    If FileExists(InstDir + '\binkley\FidoInfo\node\nodehtm_.zip') Then Begin
      CopyFile(PChar(InstDir + '\binkley\FidoInfo\node\nodehtm_.zip'),
               PChar(InstDir + '\binkley\files\sec\nodehtm.zip'), False);
      DeleteFile(InstDir + '\binkley\FidoInfo\node\nodehtm_.zip');
    End;

    // DNS Einträge bei Henning nochmal ändern (Reihenfolge tauschen)
    Assignfile(f, InstDir + '\binkley\binkd.cfg');
    Assignfile(g, InstDir + '\binkley\binkdcfg.tmp');
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('node 2:2457/265 ', zeile) = 1 Then Begin
        While (Length(zeile) > 1) and (zeile[Length(zeile)] = ' ') Do
         Delete(zeile, Length(zeile), 1); // Leerzeichen am Ende löschen
        While (Length(zeile) > 1) and (Pos(' ', zeile) > 0) Do
         Delete(zeile,1,1); // bleibt nur Passwort übrig
         zeile := 'node 2:2457/265 fls.dynodns.net;fls.dyns.cx;fls.dyndns.org '
                  + zeile;
      End;
      If Pos('#include binkd.inc', zeile) > 0 Then zeile := 'include binkd.inc';
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir+'\binkley\binkd.cfg');

    // pollman.bat erstellen zum manuellen Pollen
    CopyFile(PChar(InstDir+'\binkley\poll.bat'),
             PChar(InstDir+'\binkley\pollman.bat'), False);
    Assignfile(f, InstDir + '\binkley\pollman.bat');
    {$I-}
    Append(f);
    Writeln(f, 'binkd.exe -p binkd.cfg');
    Writeln(f, 'call hpt\toss.bat');
    Writeln(f, 'cd ' + InstDir + '\binkley');
    Closefile(f);
    {$I+}
    IOResult;

    // wöchentliche Events auf Montags setzen
    Assignfile(f, InstDir + '\binkley\events.dat');
    Assignfile(g, InstDir + '\binkley\events.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    Readln(f);
    // das aktuelle (heutige) Datum
    heute := Date;
    While DayOfWeek(heute) <> 2 Do Begin // letzten Montag bestimmen
      DecodeDate(heute, jahr, monat, tag);
      If tag = 1 Then Begin
        If monat = 1 Then Begin monat := 12; Dec(jahr); End
                     Else Dec(monat);
        tag := DaysInMonth(monat, jahr);
      End
      Else Dec(tag);
      heute := EncodeDate(jahr, monat, tag);
    End;
    Writeln(g, DateToStr(heute));
    While not EOF(f) Do Begin
      Readln(f, zeile);
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\events.dat');
    {$I+}
    IOResult;

    // Fehler in Beta korrigieren, wo nodecomp.tmp nicht wieder zu bat
    // umbenannt wurde
    If not FileExists(InstDir + '\binkley\nodecomp.bat')
       and FileExists(InstDir + '\binkley\nodecomp.tmp') Then
     RenameFile(InstDir + '\binkley\nodecomp.tmp',
                InstDir + '\binkley\nodecomp.bat');

    // nodecomp.bat korrigieren
    Assignfile(f, InstDir + '\binkley\nodecomp.bat');
    Assignfile(g, InstDir + '\binkley\nodecomp.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    Readln(f);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('xarc -r', zeile) > 0 Then
       zeile := 'for %%i in (*.a??) do xarc %%i /o /q';
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\nodecomp.bat');
    {$I+}
    IOResult;

    // komplette Nodeliste nochmal neu requesten wegen Bug mit den Diffs
    gefunden := False;
    Assignfile(f, InstDir + '\BINKLEY\OUTECHO\' + node_aka_hex + '.REQ');
    {$I-} Reset(f); {$I+}
    IF IOResult <> 0 Then Rewrite(f)
    Else Begin
      While not EOF(f) Do Begin // nicht mehrmals requesten..
        Readln(f, zeile);
        If zeile = 'NODE0002' Then gefunden := True;
      End;
      Closefile(f);
      Append(f);
    End;
    If not gefunden Then Writeln(f, 'NODE0002');
    Closefile(f);

(* am 11.01.2003 rausgenommen
    // fastlst.cfg korrigieren
    Assignfile(f, InstDir + '\binkley\nodelist\fastlst.cfg');
    Assignfile(g, InstDir + '\binkley\nodelist\fastlst.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    Readln(f);
    gefunden := False;
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('point265.lst', zeile) > 0 Then gefunden := True;
      Writeln(g, zeile);
    End;
    If not gefunden Then Begin
      Writeln(g);
      Writeln(g, '  NodeList point265.lst   ; Points in "Boss," format');
      Writeln(g, '    GermanPointList');
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\nodelist\fastlst.cfg');
    {$I+}
    IOResult;
*)

    // in impexp.bat hinzufügen, daß stat.log angezeigt werden soll
    Assignfile(f, InstDir + '\binkley\hpt\impexp.bat');
    Assignfile(g, InstDir + '\binkley\hpt\impexp.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If zeile = 'cd ..\hpt' Then Begin
        Writeln(g, zeile);
        Writeln(g, 'if exist stat.log del stat.log');
        Writeln(g, 'hpt toss');
        Writeln(g, 'if exist stat.log type stat.log');
        While (zeile <> 'hpt scan') Do Readln(f, zeile);
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\hpt\impexp.bat');
    {$I+}
    IOResult;

    // 'sqpack' und 'hptutil link' aufrufen
    lstrcpy(cmd, PChar(InstDir+'\binkley\hpt\sqpack.exe'));
    DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 1, True);

    lstrcpy(cmd, PChar(InstDir+'\binkley\hpt\hptutil.exe link'));
    DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 1, True);

    // pflege ausführen: Mails aus Bad Area tossen und...
    lstrcpy(cmd, PChar(InstDir+'\binkley\hpt\hpt.exe toss -b'));
    DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 0, True);

    // ...bsy Files und hpt.lck löschen
    DeleteFiles(InstDir+'\binkley\flags\*.bsy');
    DeleteFiles(InstDir+'\binkley\outecho\*.bsy');
    If FileExists(InstDir+'\binkley\hpt\hpt.lck')
     Then DeleteFile(InstDir+'\binkley\hpt\hpt.lck');

    alte_Version := '1.5';
  End;

  If (alte_Version = '1.5') Then Begin
    // in golded.cfg Origin ändern
    Assignfile(f, InstDir + '\golded\golded.cfg');
    Assignfile(g, InstDir + '\golded\golded.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('www.fido.debox.de', zeile) > 0 Then Begin
        i := Pos('www.fido.debox.de', zeile);
        info := Copy(zeile,1,i-1) + 'www.fido-deluxe.de.vu';
        Delete(zeile,1,i+16);
        zeile := info + zeile;
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\golded\golded.cfg');
    {$I+}
    IOResult;

    // in pflege.bat 'sqpack' in 'sqpack *' ändern
    Assignfile(f, InstDir + '\binkley\pflege.bat');
    Assignfile(g, InstDir + '\binkley\pflege.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('sqpack', zeile) > 0 Then zeile := 'rem sqpack *';
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\pflege.bat');
    {$I+}
    IOResult;

    // in pflege2.bat 'sqpack' in 'sqpack *' ändern
    Assignfile(f, InstDir + '\binkley\pflege2.bat');
    {$I-}
    Rewrite(f);
    Writeln(f, '@echo off');
    Writeln(f, 'cd C:\Fido\binkley\hpt');
    Writeln(f, 'sqpack *');
    Writeln(f, 'hptutil link');
    Closefile(f);
    {$I+}
    IOResult;

    // in Husky config loglevels auf 2345789 ändern
    // (sonst wächst das Logfile zu schnell) 
    Assignfile(f, InstDir + '\binkley\hpt\config');
    Assignfile(g, InstDir + '\binkley\hpt\config.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('loglevels ', zeile) = 1 Then zeile := 'loglevels 2345789';
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\hpt\config');
    {$I+}
    IOResult;

    // in golded.cfg Versionsnummer in Tearline schreiben
    // (nochmal, weil in letzter Version falscher Pfad zu golded..)
    Assignfile(f, InstDir + '\golded\golded.cfg');
    Assignfile(g, InstDir + '\golded\golded.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('TEARLINE ', zeile) = 1 Then
       zeile := 'TEARLINE FPD ' + Background.version + '  @longpid @version';
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\golded\golded.cfg');
    {$I+}
    IOResult;

    // in binkd.cfg Node 2457/267 noch eintragen, wenn Henning Node ist
    // (für FLS, der pollt auf der IP Line 2457/267)
    Assignfile(f, InstDir + '\binkley\binkd.cfg');
    Assignfile(g, InstDir + '\binkley\binkd.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('node 2:2457/265 ', zeile) = 1 Then Begin
        Writeln(g, zeile);
        zeile[15] := '7';
        If not EOF(f) Then Begin
          info := zeile;
          Readln(f, zeile);
          If zeile <> info Then Writeln(g, info); // nicht doppelt schreiben..
        End;
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\binkd.cfg');
    {$I+}
    IOResult;

    // in iproute.cfg Node 2457/267 noch eintragen, wenn Henning Node ist
    // (für FLS, der pollt auf der IP Line 2457/267)
    Assignfile(f, InstDir + '\binkley\nodelist\iproute.cfg');
    Assignfile(g, InstDir + '\binkley\nodelist\iproute.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If zeile = 'nopack:    2:2457/265' Then Begin
        Writeln(g, zeile);
        zeile[Length(zeile)] := '7';
        If not EOF(f) Then Begin
          info := zeile;
          Readln(f, zeile);
          If zeile <> info Then Writeln(g, info); // nicht doppelt schreiben..
        End;
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\nodelist\iproute.cfg');
    {$I+}
    IOResult;

    alte_Version := '1.51';
  End;

  If (alte_Version = '1.51') Then Begin
    // Golded Dateien aktualisieren
    CopyFile(PChar(aktDir+'fido\golded\goldhelp.cfg'), PCHar(InstDir + '\golded\goldhelp.cfg'), false);
    CopyFile(PChar(aktDir+'fido\golded\goldchrs.cfg'), PCHar(InstDir + '\golded\goldchrs.cfg'), false);

    // in golded.cfg neue Keywords für URLs/eMails einfügen
    // und Fenstergrösse wegen neuer Golded-Version fest auf 25 Zeilen setzen
    // und Charset-Warnung (XLat-Workaround) abschalten
    // und Versionsnummer in Tearline updaten
    // und für russisch Aenderung hinzufügen
    Assignfile(f, InstDir + '\golded\golded.cfg');
    Assignfile(g, InstDir + '\golded\golded.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    gefunden := False;
    gefunden2 := False;
    gefunden3 := False;
    browser := GetDefaultBrowser;
    If browser = '' Then browser := 'c:\progra~1\intern~1\iexplore.exe';
    While not EOF(f) Do Begin
      Readln(f, zeile);

      If Pos('TEARLINE ', zeile) = 1 Then
       zeile := 'TEARLINE FPD ' + Background.version + '  @longpid @version';

      If zeile='SCREENMAXCOL 1' Then zeile := 'SCREENMAXCOL 0';
      If zeile='SCREENMAXROW 1' Then zeile := 'SCREENMAXROW 25';

      If Pos('PeekURLOptions', zeile) = 1 Then gefunden := True; // ist schon vorhanden
      If not gefunden and (Pos('IMPORTBEGIN', zeile) > 0) Then Begin
        Writeln(g, 'PeekURLOptions FromTop');
        Writeln(g, 'URLHandler ' + browser + ' @url');
        Writeln(g, 'HighlightURLs yes');
        Writeln(g);
        gefunden := True;
      End;

      If Pos('UseCharset no', zeile) = 1 Then gefunden2 := True; // ist schon vorhanden
      If not gefunden2 and (Pos('INCLUDE GOLDCHRS.CFG', zeile) > 0) Then Begin
        Writeln(g, 'UseCharset no');
        Writeln(g, zeile);
        zeile := 'UseCharset yes';
        gefunden2 := True;
      End;

      If Pos('; russsian H configuration', zeile) = 1 Then gefunden3 := True; // ist schon vorhanden

      Writeln(g, zeile);
    End;
    If (sprache = 'russisch') and (not gefunden3) Then Begin
      Writeln(g, '; russsian H configuration...');
      Writeln(g, 'EditSoftCRXLat H');
      Writeln(g, 'DispSoftCR Yes');
      Writeln(g, '; end russion H configuration...');
      Writeln(g);
    End;

    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\golded\golded.cfg');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der golded.cfg aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // in gedcolor.cfg neues Keyword für URLs/eMails einfügen
    Assignfile(f, InstDir + '\golded\gedcolor.cfg');
    Assignfile(g, InstDir + '\golded\gedcolor.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    gefunden := False;
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('Color Reader URL', zeile) = 1 Then gefunden := True; // ist schon vorhanden
      If not gefunden and (Pos('Color Stylecode', zeile) = 1) Then Begin
        Writeln(g, 'Color Reader URL    White on Black');
        gefunden := True;
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\golded\gedcolor.cfg');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der gedcolor.cfg aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // gedcolors.cfg löschen (wurde in der Beta durch einen Schreibfehler
    // angelegt statt gedcolor.cfg..
    If FileExists(InstDir+'\golded\gedcolors.cfg')
     Then DeleteFile(InstDir+'\golded\gedcolors.cfg');

    // Pointliste in fastlst.cfg schreiben
    Assignfile(f, InstDir + '\binkley\nodelist\fastlst.cfg');
    Assignfile(g, InstDir + '\binkley\nodelist\fastlst.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    Readln(f);
    gefunden := False;
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('r24pnt.???', zeile) > 0 Then gefunden := True;
      Writeln(g, zeile);
    End;
    If not gefunden Then Begin
      Writeln(g);
      Writeln(g, '  NodeList r24pnt.???');
      Writeln(g, '    MsgRem SUE  ; log comments beginning with S, U or E');
      Writeln(g, '    NodeDiff r24pnt_d.???');
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\nodelist\fastlst.cfg');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der fastlst.cfg aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // Pointliste requesten
    gefunden := False;
    Assignfile(f, InstDir + '\BINKLEY\OUTECHO\' + node_aka_hex + '.REQ');
    {$I-} Reset(f); {$I+}
    IF IOResult <> 0 Then Rewrite(f)
    Else Begin
      While not EOF(f) Do Begin // nicht mehrmals requesten..
        Readln(f, zeile);
        If zeile = 'PNT0002' Then gefunden := True;
      End;
      Closefile(f);
      Append(f);
    End;
    If not gefunden Then Writeln(f, 'PNT0002');
    Closefile(f);

    // in poll.bat Pointlistenteil reinschreiben
    Assignfile(f, InstDir + '\binkley\poll.bat');
    Assignfile(g, InstDir + '\binkley\poll.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    gefunden := False;
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('if exist r24pnt_d.???', zeile) = 1 Then gefunden := True; // ist schon vorhanden
      If not gefunden and (Pos('if exist box.lst', zeile) = 1) Then Begin
        Writeln(g, 'if exist r24pnt_d.??? copy r24pnt_d.??? ..\..\nodelist\*.*');
        Writeln(g, 'if exist r24pnt_d.??? del r24pnt_d.???>nul');
        gefunden := True;
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\poll.bat');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der poll.bat aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // in nodecomp.bat Pointlistteil einfügen
    Assignfile(f, InstDir + '\binkley\nodecomp.bat');
    Assignfile(g, InstDir + '\binkley\nodecomp.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    gefunden := False;
    gefunden2 := False;
    gefunden3 := False;
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('if exist pnt0002.zip', zeile) = 1 Then gefunden := True; // ist schon vorhanden
      If not gefunden and (zeile='') Then Begin
        Writeln(g, 'if exist pnt0002.zip copy pnt0002.zip C:\Fido\binkley\nodelist\pnt0002.zip');
        Writeln(g, 'if exist pnt0002.zip del pnt0002.zip');
        gefunden := True;
      End;
      If gefunden Then Begin
        If Pos('if exist pnt0002.zip', zeile) = 1 Then gefunden2 := True; // ist schon vorhanden
        If not gefunden2 and (zeile='') Then Begin
          Writeln(g, 'if exist pnt0002.zip unzip -o -q -j pnt0002.zip');
          Writeln(g, 'if exist pnt0002.zip del pnt0002.zip');
          gefunden2 := True;
        End;
      End;
      If gefunden2 Then Begin
        If Pos('if exist r24pnt_d.z??', zeile) = 1 Then gefunden3 := True; // ist schon vorhanden
        If not gefunden3 and (Pos('del nodediff.z??', zeile) = 1) Then Begin
          Writeln(g, 'if exist r24pnt_d.z?? unzip -o -q -j r24pnt_d.z??');
          Writeln(g, 'if exist r24pnt_d.z?? del r24pnt_d.z??');
          gefunden3 := True;
        End;
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\nodecomp.bat');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der nodecomp.bat aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // Pointdiff-Filearea anbestellen
    Assignfile(f, InstDir + '\binkley\hpt\filefix.chg');
    Rewrite(f);
    Writeln(f, '+R24PNT_D');
    Closefile(f);

    // Hardrock.ger abbestellen, falls anbestellt
    Assignfile(f, InstDir + '\aktiv.lst');
    Assignfile(g, InstDir + '\aktiv.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    gefunden := False;
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If (Pos('HARDROCK.GER', zeile) = 1)
       Then gefunden := True
       Else Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\aktiv.lst');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der aktiv.lst aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    If gefunden Then Begin
      Assignfile(f, InstDir + '\binkley\hpt\areafix.chg');
      Rewrite(f);
      Writeln(f, '-hardrock.ger');
      Closefile(f);
      Assignfile(f, InstDir + '\killhrg.tmp');
      Rewrite(f);
      Writeln(f, 'hardrock.ger');
      Closefile(f);
    End;

    // in goldarea.bat Flags korrigieren
    Assignfile(f, InstDir + '\binkley\hpt\goldarea.bat');
    Assignfile(g, InstDir + '\binkley\hpt\goldarea.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      i := Pos('"pvt,loc"', zeile);
      If (i > 0)
       Then zeile := Copy(zeile,1,i-1) + '"k/s pvt loc"' +
                     Copy(zeile,i+9,Length(zeile));
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\hpt\goldarea.bat');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der goldarea.bat aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // goldarea.bat ausführen (filefix.chg verarbeiten)
    lstrcpy(cmd, comspec);
    lstrcat(cmd, PChar(InstDir+'\binkley\hpt\goldarea.bat'));
    DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 0, True);

    If sprache <> 'deutsch' Then Begin
    // deutsche Texte löschen
      DeleteFile(PChar(InstDir+'\golded\goldlang.cfg'));
      DeleteFile(PChar(InstDir+'\golded\goldhelp.cfg'));
    End;
    If sprache = 'englisch' Then Begin
    // englisches Sprachfile benutzen
      CopyFile(PChar(InstDir+'\golded\goldlang.eng'), PChar(InstDir+'\golded\goldlang.cfg'), false);
      CopyFile(PChar(InstDir+'\golded\goldhelp.eng'), PChar(InstDir+'\golded\goldhelp.cfg'), false);
    End;
    If sprache = 'russisch' Then Begin
    // russisches Sprachfile und Charsets benutzen
      CopyFile(PChar(InstDir+'\golded\goldlang.rus'), PChar(InstDir+'\golded\goldlang.cfg'), false);
      CopyFile(PChar(InstDir+'\golded\goldhelp.rus'), PChar(InstDir+'\golded\goldhelp.cfg'), false);
      CopyFile(PChar(InstDir+'\golded\goldchrs.rus'), PChar(InstDir+'\golded\goldchrs.cfg'), false);
    End;
    If sprache = 'flaemisch' Then Begin
    // hollaendisches Sprachfile benutzen
      CopyFile(PChar(InstDir+'\golded\goldlang.nl'), PChar(InstDir+'\golded\goldlang.cfg'), false);
      CopyFile(PChar(InstDir+'\golded\goldhelp.eng'), PChar(InstDir+'\golded\goldhelp.cfg'), false);
    End;

    // poll.bat ergaenzen
    Assignfile(f, InstDir + '\binkley\poll.bat');
    Assignfile(g, InstDir + '\binkley\poll.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    Readln(f);
    gefunden := False;
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('if errorlevel 0 goto nodeweiter2', zeile) > 0 Then gefunden := True;
      If (Pos('if errorlevel 1 goto nodeweiter', zeile) > 0) and not gefunden Then Begin
        Writeln(g, 'if errorlevel 0 goto nodeweiter2');
        Writeln(g, 'filecmp.exe nodehtm.zip nodehtm_.zip -noerror');
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\poll.bat');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der poll.bat aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // pollman.bat ergaenzen
    Assignfile(f, InstDir + '\binkley\pollman.bat');
    Assignfile(g, InstDir + '\binkley\pollman.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    Readln(f);
    gefunden := False;
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('if errorlevel 0 goto nodeweiter2', zeile) > 0 Then gefunden := True;
      If (Pos('if errorlevel 1 goto nodeweiter', zeile) > 0) and not gefunden Then Begin
        Writeln(g, 'if errorlevel 0 goto nodeweiter2');
        Writeln(g, 'filecmp.exe nodehtm.zip nodehtm_.zip -noerror');
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\pollman.bat');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der poll.bat aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    alte_Version := '1.6';
  End;

  If (alte_Version = '1.6') Then Begin
    // Golded Datei aktualisieren
    CopyFile(PChar(aktDir+'fido\golded\goldkeys.cfg'), PCHar(InstDir + '\golded\goldkeys.cfg'), false);

    // in Husky config AdvisoryLock setzen
    Assignfile(f, InstDir + '\binkley\hpt\config');
    Assignfile(g, InstDir + '\binkley\hpt\config.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    gefunden := False;
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('AdvisoryLock on', zeile) > 0 Then gefunden := True;
      If (Pos('lockfile ', zeile) > 0) and not gefunden Then
        Writeln(g, 'AdvisoryLock on');
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir+'\binkley\hpt\config');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der Husky config aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // makepoll.pas und lock.hpt löschen
    If FileExists(InstDir+'\binkley\makepoll.pas')
     Then DeleteFile(InstDir+'\binkley\makepoll.pas');
    If FileExists(InstDir+'\binkley\hpt\lock.hpt')
     Then DeleteFile(InstDir+'\binkley\hpt\lock.hpt');

    // in golded.cfg Pfad zum Browser auf kurzen Pfad korrigieren
    Assignfile(f, InstDir + '\golded\golded.cfg');
    Assignfile(g, InstDir + '\golded\golded.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    browser := GetDefaultBrowser;
    If browser = '' Then browser := 'c:\progra~1\intern~1\iexplore.exe';
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('URLHandler ', zeile) = 1 Then
      If not gefunden and (Pos('IMPORTBEGIN', zeile) > 0) Then
        zeile := 'URLHandler ' + browser + ' @url';
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\golded\golded.cfg');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der golded.cfg aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    alte_Version := '1.7';
  End;

  If (alte_Version = '1.7') Then Begin
    alte_Version := '1.8';
  End;

  If (alte_Version = '1.8') Then Begin
    // pflege.bat HPT Lockfile korrigieren
    Assignfile(f, InstDir + '\binkley\pflege.bat');
    Assignfile(g, InstDir + '\binkley\pflege.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('if exist hpt.lck', zeile) > 0 Then
        zeile := 'if exist lock.hpt del lock.hpt>nul';
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir+'\binkley\pflege.bat');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der pflege.bat aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // wenn otherProvider, dann vielleicht LAN-Verbindung?
    If otherProvider Then Begin
      antwort := Application.MessageBox(PChar(s[0253]), PChar(s[0094]),
                                        MB_YesNo+MB_DefButton2);
      If antwort = ID_Yes Then Begin
        otherProvider := False;
        netzwerk := True;
      End;
    End;

    alte_Version := '1.9';
  End;

  If (alte_Version = '1.9') Then Begin
    // if exist mit Wildcards korrigieren in poll.bat
    // und makepoll.exe wieder durch echo. ersetzen
    Assignfile(f, InstDir + '\binkley\poll.bat');
    Assignfile(g, InstDir + '\binkley\poll.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    gefunden := False;
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos(' goto pollen', zeile) > 0 Then gefunden := True;
      If (Pos(' ..\makepoll.exe ', zeile) > 0) and not gefunden Then Begin
        i := Pos(' ..\makepoll.exe ', zeile);
        zeile2 := Copy(zeile,i+17,Length(zeile));
        Writeln(g, 'if exist ', zeile2, ' goto pollen');
        Writeln(g, 'type nul>', zeile2);
        zeile := Copy(zeile,1,i) + '..\makepoll.exe ' + zeile2;
        Writeln(g, zeile);
        zeile := ':pollen';
      End;
      If (Pos('rem>>', zeile) = 1) Then zeile := 'type nul>' + Copy(zeile,6,Length(zeile));
      If Pos('if exist *.bsy', zeile) > 0 Then zeile := 'for %%i in (*.bsy) do del %%i>nul';
      If Pos('if exist *.csy', zeile) > 0 Then zeile := 'for %%i in (*.csy) do del %%i>nul';
      If Pos('if exist *.try', zeile) > 0 Then zeile := 'for %%i in (*.try) do del %%i>nul>nul';
      If Pos('del *.bsy>nul', zeile) = 1 Then zeile := 'for %%i in (*.bsy) do del %%i>nul>nul';
      If Pos('del *.csy>nul', zeile) = 1 Then zeile := 'for %%i in (*.csy) do del %%i>nul>nul';
      If Pos('del *.try>nul', zeile) = 1 Then zeile := 'for %%i in (*.try) do del %%i>nul>nul';
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir+'\binkley\poll.bat');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der poll.bat aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // if exist mit Wildcards korrigieren in pollman.bat
    // und makepoll.exe wieder durch echo. ersetzen
    Assignfile(f, InstDir + '\binkley\pollman.bat');
    Assignfile(g, InstDir + '\binkley\pollman.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    gefunden := False;
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos(' goto pollen', zeile) > 0 Then gefunden := True;
      If (Pos(' ..\makepoll.exe ', zeile) > 0) and not gefunden Then Begin
        i := Pos(' ..\makepoll.exe ', zeile);
        zeile2 := Copy(zeile,i+17,Length(zeile));
        Writeln(g, 'if exist ', zeile2, ' goto pollen');
        Writeln(g, 'rem>>', zeile2);
        zeile := Copy(zeile,1,i) + '..\makepoll.exe ' + zeile2;
        Writeln(g, zeile);
        zeile := ':pollen';
      End;
      If Pos('if exist *.bsy', zeile) > 0 Then zeile := 'for %%i in (*.bsy) do del %%i>nul';
      If Pos('if exist *.csy', zeile) > 0 Then zeile := 'for %%i in (*.csy) do del %%i>nul';
      If Pos('if exist *.try', zeile) > 0 Then zeile := 'for %%i in (*.try) do del %%i>nul>nul';
      If Pos('del *.bsy>nul', zeile) = 1 Then zeile := 'for %%i in (*.bsy) do del %%i>nul>nul';
      If Pos('del *.csy>nul', zeile) = 1 Then zeile := 'for %%i in (*.csy) do del %%i>nul>nul';
      If Pos('del *.try>nul', zeile) = 1 Then zeile := 'for %%i in (*.try) do del %%i>nul>nul';
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir+'\binkley\pollman.bat');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der pollman.bat aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // if exist mit Wildcards korrigieren in pflege.bat
    Assignfile(f, InstDir + '\binkley\pflege.bat');
    Assignfile(g, InstDir + '\binkley\pflege.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('if exist *.bsy', zeile) > 0 Then zeile := 'for %%i in (*.bsy) do del %%i>nul';
      If Pos('del *.bsy /s>nul', zeile) = 1 Then zeile := 'for %%i in (*.bsy) do del %%i>nul';
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir+'\binkley\pflege.bat');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der pflege.bat aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // if exist mit Wildcards korrigieren in toss.bat
    // und pktdate.exe auskommentieren
    Assignfile(f, InstDir + '\binkley\hpt\toss.bat');
    Assignfile(g, InstDir + '\binkley\hpt\toss.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If (Pos('pktdate.exe', zeile) > 0) and (Pos('for %%i', zeile) = 1) Then
        zeile := 'rem ' + zeile;
      If Pos('if exist *.pkt move', zeile) > 0 Then zeile := 'move *.pkt sec>nul';
      If Pos('if exist sic\*.* for', zeile) > 0 Then zeile := 'for %%i in (sic\*.*) do del %%i>nul';
      If Pos('del sic\*.*>nul', zeile) = 1 Then zeile := 'for %%i in (sic\*.*) do del %%i>nul';
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir+'\binkley\hpt\toss.bat');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der toss.bat aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // DNS Einträge bei Henning nochmal ändern (Reihenfolge tauschen)
    // und DNS-Eintrag von Kristof ergänzen
    // und kill-old-bsy aktivieren
    Assignfile(f, InstDir + '\binkley\binkd.cfg');
    Assignfile(g, InstDir + '\binkley\binkdcfg.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('# kill-old-bsy 1800', zeile) > 0 Then
        zeile := 'kill-old-bsy 2700';
      If Pos('node 2:2457/265 ', zeile) = 1 Then Begin
        While (Length(zeile) > 1) and (zeile[Length(zeile)] = ' ') Do
         Delete(zeile, Length(zeile), 1); // Leerzeichen am Ende löschen
        While (Length(zeile) > 1) and (Pos(' ', zeile) > 0) Do
         Delete(zeile,1,1); // bleibt nur Passwort übrig
         zeile := 'node 2:2457/265 fls.dyns.cx;fls.dyndns.org;fls.dynodns.net '
                  + zeile;
      End;
      If Pos('node 2:240/2110 ', zeile) = 1 Then Begin
        While (Length(zeile) > 1) and (zeile[Length(zeile)] = ' ') Do
         Delete(zeile, Length(zeile), 1); // Leerzeichen am Ende löschen
        While (Length(zeile) > 1) and (Pos(' ', zeile) > 0) Do
         Delete(zeile,1,1); // bleibt nur Passwort übrig
         zeile := 'node 2:240/2110 meerschwein.dyndns.org;gsw.dyndns.org '
                  + zeile;
      End;
      If Pos('#include binkd.inc', zeile) > 0 Then zeile := 'include binkd.inc';
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir+'\binkley\binkd.cfg');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der binkd.cfg aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // in Husky config loglevels auf 24589ACDEF ändern
    // (sonst wächst das Logfile zu schnell)
    // und screenloglevels hinzufügen
    // und logEchoToScreen hinzufügen
    // und tempDir hinzufügen
    Assignfile(f, InstDir + '\binkley\hpt\config');
    Assignfile(g, InstDir + '\binkley\hpt\config.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    gefunden := False;
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('tempDir ', zeile) = 1 Then gefunden := True;
      If (Pos('MsgBaseDir ', zeile) > 0) and not gefunden Then Begin
        Writeln(g, 'tempDir      ' + InstDir + '\binkley\hpt\temp\');
        gefunden := True;
      End;
      If Pos('loglevels ', zeile) = 1 Then Begin
        zeile := 'loglevels 24589ACDEF';
        If not EOF(f) Then Begin
          Writeln(g, zeile);
          Readln(f, zeile);
          If Pos('screenloglevels ', zeile) = 0 Then Begin
            Writeln(g, 'screenloglevels 2345789ACDEF');
            Writeln(g, 'logEchoToScreen');
          End;
        End;
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\hpt\config');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der Husky config aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // in golded.cfg EditMsgSize auskommentieren (nicht mehr in neuer
    // Golded-Version vorhanden)
    // und eingestellte Zeilenanzahl auslesen - wenn Zeilenanzahl 25 ist,
    // dann bei Bildschirmaufloesung ab 1024x768 hoeher setzen
    zeilenAnzahl := 25; // Default-Wert
    Assignfile(f, InstDir + '\golded\golded.cfg');
    Assignfile(g, InstDir + '\golded\golded.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('SCREENMAXROW ', zeile) = 1 Then Begin
        zeile2 := Copy(zeile,14,3); // max. 3 Zeichen
        i := StrToInt(zeile2);
        If (i > 24) and (i < 101) Then zeilenAnzahl := i;
        If (Screen.Height > 760) and (zeilenAnzahl = 25) Then Begin
          If (Screen.Height > 1000) Then zeilenAnzahl := 50
          Else zeilenAnzahl := 30;
          zeile := 'SCREENMAXROW ' + IntToStr(zeilenAnzahl);
        End;
      End;
      If Pos('EDITMSGSIZE ', zeile) = 1 Then
       zeile := ';' + zeile;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\golded\golded.cfg');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der golded.cfg aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // in rungold.bat mode con einfuegen zum Anpassen der Fenstergroesse
    // an die eingestellte Zeilenanzahl
    Assignfile(f, InstDir + '\golded\rungold.bat');
    Assignfile(g, InstDir + '\golded\rungold.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    gefunden := False;
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('mode con ', zeile) = 1 Then gefunden := True;
      If (Pos('geddjg.exe', zeile) > 0) and not gefunden Then Begin
        gefunden := True; // nur einmal einfuegen!
        Writeln(g, 'mode con lines=' + IntToStr(zeilenAnzahl) + ' cols=80');
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\golded\rungold.bat');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der rungold.bat aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // in goldarea.cfg ArealistSort an neue Golded-Version anpassen
    Assignfile(f, InstDir + '\golded\goldarea.cfg');
    Assignfile(g, InstDir + '\golded\goldarea.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('AREALISTSORT ', zeile) = 1 Then
       zeile := 'AREALISTSORT T+G+S+A+D';
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\golded\goldarea.cfg');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der goldarea.cfg aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // Verzeichnis für tempDir (Husky Config) anlegen
    {$I-} MkDir(InstDir + '\binkley\hpt\temp'); {$I+}
    IOResult;

    alte_Version := '2.0';
  End;

  If (alte_Version = '2.0') Then Begin
    alte_Version := '2.1';
  End;

  If (alte_Version = '2.1') Then Begin
    // poll.bat korrigieren
    Assignfile(f, InstDir + '\binkley\poll.bat');
    Assignfile(g, InstDir + '\binkley\poll.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    Readln(f);
    gefunden := False;
    While not gefunden and not EOF(f) Do Begin
      Readln(f, zeile);
      Writeln(g, zeile);
      If Pos('if exist echo0002.zip', zeile) > 0 Then gefunden := True;
    End;
    If gefunden Then Begin
      Readln(f, zeile);
      If Pos('cd ', zeile) = 1 Then Begin
        Writeln(g, 'if exist echo0002.zip del echo0002.zip>nul');
        Writeln(g);
        Writeln(g, zeile);
        gefunden := False;
        While not gefunden and not EOF(f) Do Begin
          Readln(f, zeile);
          If Pos('if not exist', zeile) > 0 Then gefunden := True;
        End;
      End;
      Writeln(g, zeile);
    End;
    While not EOF(f) Do Begin
      Readln(f, zeile);
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\poll.bat');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der poll.bat aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // pollman.bat korrigieren
    Assignfile(f, InstDir + '\binkley\pollman.bat');
    Assignfile(g, InstDir + '\binkley\pollman.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    Readln(f);
    gefunden := False;
    While not gefunden and not EOF(f) Do Begin
      Readln(f, zeile);
      Writeln(g, zeile);
      If Pos('if exist echo0002.zip', zeile) > 0 Then gefunden := True;
    End;
    If gefunden Then Begin
      Readln(f, zeile);
      If Pos('cd ', zeile) = 1 Then Begin
        Writeln(g, 'if exist echo0002.zip del echo0002.zip>nul');
        Writeln(g);
        Writeln(g, zeile);
        gefunden := False;
        While not gefunden and not EOF(f) Do Begin
          Readln(f, zeile);
          If Pos('if not exist', zeile) > 0 Then gefunden := True;
        End;
      End;
      Writeln(g, zeile);
    End;
    While not EOF(f) Do Begin
      Readln(f, zeile);
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\pollman.bat');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der pollman.bat aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // alte Echolisten löschen
    DeleteFiles(InstDir + '\binkley\files\sec\ECHO0002.*');

    If sprache = 'englisch' Then Begin
    // englisches Sprachfile in Golded benutzen (war in vorherigem Update
    // broken, nachtraeglich gefixed)
      DeleteFile(PChar(InstDir+'\golded\goldlang.cfg'));
      DeleteFile(PChar(InstDir+'\golded\goldhelp.cfg'));
      CopyFile(PChar(InstDir+'\golded\goldlang.eng'), PChar(InstDir+'\golded\goldlang.cfg'), false);
      CopyFile(PChar(InstDir+'\golded\goldhelp.eng'), PChar(InstDir+'\golded\goldhelp.cfg'), false);
    End;

    // point265.lst löschen, Henning ist ausgetragen
    DeleteFile(PChar(InstDir+'\binkley\nodelist\point265.lst'));

    // point265.lst aus fastlst.cfg auskommentieren
    // und 10251.UPD hinzufuegen
    Assignfile(f, InstDir + '\binkley\nodelist\fastlst.cfg');
    Assignfile(g, InstDir + '\binkley\nodelist\fastlst.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);

    gefunden := False;
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('10251.UPD', zeile) > 0 Then gefunden := True;
      If Pos('point265.lst', zeile) > 0 Then Begin
        If zeile[1] <> ';' Then zeile := ';' + zeile;
        If not EOF(f) Then Begin
          Writeln(g, zeile);
          Readln(f, zeile);
          If zeile[1] <> ';' Then zeile := ';' + zeile;
        End;
      End;
      Writeln(g, zeile);
    End;
    If not gefunden Then Begin
      Writeln(g);
      Writeln(g, '  NodeList 10251.UPD     ; Points in "Boss," format');
      Writeln(g, '    GermanPointList');
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\nodelist\fastlst.cfg');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der fastlst.cfg aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // point265.lst in poll.bat durch 10251.UPD ersetzen
    Assignfile(f, InstDir + '\binkley\poll.bat');
    Assignfile(g, InstDir + '\binkley\poll.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    Readln(f);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      While (Pos('point265.lst', zeile) > 0) Do Begin
        i := Pos('point265.lst', zeile);
        zeile := Copy(zeile,1,i-1) + '10251.UPD' + Copy(zeile,i+12,Length(zeile));
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\poll.bat');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der poll.bat aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // point265.lst in pollman.bat durch 10251.UPD ersetzen
    Assignfile(f, InstDir + '\binkley\pollman.bat');
    Assignfile(g, InstDir + '\binkley\pollman.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    Readln(f);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      While (Pos('point265.lst', zeile) > 0) Do Begin
        i := Pos('point265.lst', zeile);
        zeile := Copy(zeile,1,i-1) + '10251.UPD' + Copy(zeile,i+12,Length(zeile));
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\pollman.bat');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der pollman.bat aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // Info-Mail von Henning an seine Points schreiben, daß er aufhört
    If NodeAKA = '2:2457/265' Then Begin
      Assignfile(f, InstDir + '\point.cdn');
      {$I-}
      Reset(f);
      While not EOF(f) and (point_nr = '') Do Begin
        Readln(f, zeile);
        zeile := UpperCase(zeile);
        If Pos('POINTNUMBER=', zeile) = 1 Then point_nr := Copy(zeile,13,5);
      End;
      Closefile(f);
      {$I+}
      If point_nr = '' Then point_nr := '1';

      Assignfile(g, InstDir+'\binkley\hpt\notice.txt');
      Rewrite(g);
      Writeln(g, 'dies ist die mail');
      Closefile(g);
      lstrcpy(cmd, PChar(InstDir+'\binkley\hpt\hpt post -nf "Henning Schroeer" '
              + '-nt "' + TBName.Text + '" -af "2:2457/265" -at "2:2457/265.'
              + point_nr + '" -s "Info" -d '
              + InstDir+'\binkley\hpt\notice.txt'));
      DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 0, False);
    End;

    // in golded.cfg eingestellte Zeilenanzahl auslesen - wenn
    // Zeilenanzahl 25 ist, dann bei Bildschirmaufloesung ab 1024x768
    // hoeher setzen
    // und Twitmode aktivieren
    // und Internet-Browser mit start oeffnen
    zeilenAnzahl := 25; // Default-Wert
    Assignfile(f, InstDir + '\golded\golded.cfg');
    Assignfile(g, InstDir + '\golded\golded.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    browser := GetDefaultBrowser;
    If browser = '' Then browser := 'c:\progra~1\intern~1\iexplore.exe';
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('SCREENMAXROW ', zeile) = 1 Then Begin
        zeile2 := Copy(zeile,14,3); // max. 3 Zeichen
        i := StrToInt(zeile2);
        If (i > 24) and (i < 101) Then zeilenAnzahl := i;
        If (Screen.Height > 760) and (zeilenAnzahl = 25) Then Begin
          If (Screen.Height > 1000) Then zeilenAnzahl := 50
          Else zeilenAnzahl := 30;
          zeile := 'SCREENMAXROW ' + IntToStr(zeilenAnzahl);
        End;
      End;
      If Pos('Show, Blank, Skip', zeile) > 0 Then Begin
        Writeln(g, ';   (Show, Blank, Skip, Ignore, Kill)');
        Writeln(g, ';   ------------------------------------------------------------------');
        Writeln(g, 'TWITMODE Kill');
        Writeln(g);
        Writeln(g, ';   ------------------------------------------------------------------');
        Writeln(g, ';   Here you define "Twit" names and addresses.');
        Writeln(g, ';   ------------------------------------------------------------------');
        Writeln(g, 'TWITNAME VIREQ/2');
        Writeln(g, ';TWITNAME 7:654/321.ALL     ; Twit all nodes and points matching this.');
        Writeln(g);
        Writeln(g, ';   ------------------------------------------------------------------');
        Writeln(g, ';   Here you define Twit subjects.');
        Writeln(g, ';   ------------------------------------------------------------------');
        Writeln(g, ';TWITSUBJ "sfcrack"');
        Writeln(g, ';TWITSUBJ "jehova"');
        Writeln(g, ';TWITSUBJ "senna"');
        Writeln(g, ';TWITSUBJ "test"');
        Writeln(g, ';TWITSUBJ "hasch legal"');
        Writeln(g, 'TWITSUBJ "Dein Filerequest"');
        Writeln(g, 'TWITSUBJ "Filerequest response"');
        Writeln(g, 'TWITSUBJ "MaxF''req v"');
        For i := 1 To 21 Do If not EOF(f) Then Readln(f);
        zeile := 'TWITSUBJ "FileScan report"';
      End;
      If (Pos('URLHandler ', zeile) = 1) and (Pos(' start ', zeile) = 0)
       Then zeile := 'URLHandler start ' + browser + ' @url';

      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\golded\golded.cfg');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der golded.cfg aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // in rungold.bat mode con einfuegen zum Anpassen der Fenstergroesse
    // an die eingestellte Zeilenanzahl
    Assignfile(f, InstDir + '\golded\rungold.bat');
    Assignfile(g, InstDir + '\golded\rungold.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    gefunden := False;
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('mode con ', zeile) = 1 Then gefunden := True;
      If (Pos('geddjg.exe', zeile) > 0) and not gefunden Then Begin
        gefunden := True; // nur einmal einfuegen!
        Writeln(g, 'mode con lines=' + IntToStr(zeilenAnzahl) + ' cols=80');
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\golded\rungold.bat');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der rungold.bat aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    alte_Version := '2.2';
  End;

  If (alte_Version = '2.2') Then Begin
    // in golded.cfg Internet-Browser korrigieren
    Assignfile(f, InstDir + '\golded\golded.cfg');
    Assignfile(g, InstDir + '\golded\golded.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    browser := GetDefaultBrowser;
    If browser = '' Then browser := 'c:\progra~1\intern~1\iexplore.exe';
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If (Pos('URLHandler ', zeile) = 1) and (Pos(' start ', zeile) = 0)
       Then zeile := 'URLHandler start ' + browser + ' @url';
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\golded\golded.cfg');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der golded.cfg aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    alte_Version := '2.3';
  End;

  If (alte_Version = '2.3') Then Begin
    Arealiste := TListBox.Create(Installieren);
    Arealiste.Parent := Installieren;
    Arealiste.Visible := False;
    Arealiste.Items.Clear;

    // aktiv.lst lesen mit den anbestellten Areas, nicht mehr anbestellte
    // Areas aus Husky Config löschen (wurden wegen Bug beim Abbestellen
    // nicht gelöscht)
    Assignfile(f, InstDir + '\aktiv.lst');
    {$I-}
    Reset(f);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      i := Pos(' ', zeile);
      If (i > 1) Then Delete(zeile,i,Length(zeile)); // nur Areaname
      Arealiste.Items.Add(zeile);
    End;
    Closefile(f);
    {$I+}
    IOResult;

    // aktive Areas mit Husky Config abgleichen und nicht mehr anbestellte
    // Areas aus Husky Config löschen
    Assignfile(f, InstDir + '\binkley\hpt\config');
    Assignfile(g, InstDir + '\binkley\hpt\config.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('EchoArea ', zeile) = 1 Then Begin
        i := 0;
        echoname := zeile;
        Delete(echoname,1,Length('EchoArea '));
        While (Length(echoname) > 1) and (echoname[1] = ' ') Do Delete(echoname,1,1);
        If Length(echoname) > 1 Then Delete(echoname,Pos(' ', echoname),Length(echoname));
        If Length(echoname) > 1 Then i := Arealiste.Items.IndexOf(echoname);
        If i > -1 Then Writeln(g, zeile)
        Else Begin // Mails löschen
          Delete(zeile,1,9); // 'EchoArea ' löschen
          Delete(zeile,1,Pos(' ', zeile)); // bis Pfad löschen
          zeile := Copy(zeile,1,Pos(' ', zeile)-1); // Pfad der Area
          DeleteFile(zeile+'.sqd');
          DeleteFile(zeile+'.sqi');
          DeleteFile(zeile+'.sql');
        End;
      End
      Else Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir+'\binkley\hpt\config');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der Husky config aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    alte_Version := '2.4';
  End;

  If (alte_Version = '2.4') Then Begin
    // DNS Einträge bei Christian korrigieren (war abgeschnitten)
    Assignfile(f, InstDir + '\binkley\binkd.cfg');
    Assignfile(g, InstDir + '\binkley\binkdcfg.tmp');
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('node 2:240/2188 ', zeile) = 1 Then Begin
        While (Length(zeile) > 1) and (zeile[Length(zeile)] = ' ') Do
         Delete(zeile, Length(zeile), 1); // Leerzeichen am Ende löschen
        While (Length(zeile) > 1) and (Pos(' ', zeile) > 0) Do
         Delete(zeile,1,1); // bleibt nur Passwort übrig
         zeile := 'node 2:240/2188 binkd.kruemel.org;kruemel.dnsalias.com;kruemel.dyns.cx '
                  + zeile;
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir+'\binkley\binkd.cfg');

    // Pointlistverarbeitung in poll.bat einfuegen
    Assignfile(f, InstDir + '\binkley\poll.bat');
    Assignfile(g, InstDir + '\binkley\poll.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    gefunden := False;
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If (Pos('if exist tossing.now', zeile) > 0) Then Begin
        Writeln(g, zeile);
        Readln(f, zeile); // Leerzeile
        Writeln(g, zeile);
        Readln(f, zeile);
        If (Pos('\Fido\binkley\files\sec', zeile) > 0) Then Begin
          Writeln(g, 'cd ' + InstDir + '\binkley\files');
          Writeln(g, 'if exist pnt0002.zip copy pnt0002.zip ..\nodelist\pnt0002.zip');
          Writeln(g, 'if exist pnt0002.zip del pnt0002.zip>nul');
          Writeln(g, 'if exist *.tic del *.tic>nul');
          Writeln(g);
        End
        Else gefunden := True;
      End;
      If not gefunden Then Begin
        If (Pos('if exist box.lst', zeile) > 0) Then Begin
          Writeln(g, 'if exist pnt0002.zip copy pnt0002.zip ..\..\nodelist\pnt0002.zip');
          Writeln(g, 'if exist pnt0002.zip del pnt0002.zip>nul');
        End;
        If (Pos('if not exist echo0002.zip goto update', zeile) > 0) Then Begin
          zeile := 'if not exist echo0002.zip goto pntlist';
        End;
        If (Pos(':update', zeile) > 0) Then Begin
        Writeln(g, ':pntlist');
        Writeln(g, 'cd ' + InstDir + '\binkley\nodelist');
        Writeln(g, 'if not exist pnt0002.zip goto update');
        Writeln(g, 'unzip -o -q  -j pnt0002.zip');
        Writeln(g, 'del pnt0002.zip');
        Writeln(g);
        End;
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\poll.bat');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der poll.bat aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // Pointlistverarbeitung in pollman.bat einfuegen
    Assignfile(f, InstDir + '\binkley\pollman.bat');
    Assignfile(g, InstDir + '\binkley\pollman.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    gefunden := False;
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If (Pos('if exist tossing.now', zeile) > 0) Then Begin
        Writeln(g, zeile);
        Readln(f, zeile); // Leerzeile
        Writeln(g, zeile);
        Readln(f, zeile);
        If (Pos('\Fido\binkley\files\sec', zeile) > 0) Then Begin
          Writeln(g, 'cd ' + InstDir + '\binkley\files');
          Writeln(g, 'if exist pnt0002.zip copy pnt0002.zip ..\nodelist\pnt0002.zip');
          Writeln(g, 'if exist pnt0002.zip del pnt0002.zip>nul');
          Writeln(g, 'if exist *.tic del *.tic>nul');
          Writeln(g);
        End
        Else gefunden := True;
      End;
      If not gefunden Then Begin
        If (Pos('if exist box.lst', zeile) > 0) Then Begin
          Writeln(g, 'if exist pnt0002.zip copy pnt0002.zip ..\..\nodelist\pnt0002.zip');
          Writeln(g, 'if exist pnt0002.zip del pnt0002.zip>nul');
        End;
        If (Pos('if not exist echo0002.zip goto update', zeile) > 0) Then Begin
          zeile := 'if not exist echo0002.zip goto pntlist';
        End;
        If (Pos(':update', zeile) > 0) Then Begin
        Writeln(g, ':pntlist');
        Writeln(g, 'cd ' + InstDir + '\binkley\nodelist');
        Writeln(g, 'if not exist pnt0002.zip goto update');
        Writeln(g, 'unzip -o -q  -j pnt0002.zip');
        Writeln(g, 'del pnt0002.zip');
        Writeln(g);
        End;
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\pollman.bat');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der pollman.bat aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // alte TIC-Files und Pointlist-Duplikate löschen
    {$I-}
    DeleteFiles(InstDir+'\binkley\files\*.tic');
    RenameFile(InstDir+'\binkley\files\pnt0002.zip', InstDir+'\binkley\files\sic_pnt0002.zip');
    DeleteFiles(InstDir+'\binkley\files\pnt0002.z*');
    RenameFile(InstDir+'\binkley\files\sic_pnt0002.zip', InstDir+'\binkley\files\pnt0002.zip');

    RenameFile(InstDir+'\binkley\files\sec\pnt0002.zip', InstDir+'\binkley\files\sec\sic_pnt0002.zip');
    DeleteFiles(InstDir+'\binkley\files\sec\pnt0002.z*');
    RenameFile(InstDir+'\binkley\files\sec\sic_pnt0002.zip', InstDir+'\binkley\files\sec\pnt0002.zip');
    {$I+}

    // RegKey in fastlst.cfg eintragen
    Assignfile(f, InstDir + '\binkley\nodelist\fastlst.cfg');
    Assignfile(g, InstDir + '\binkley\nodelist\fastlst.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If (Pos('RegKey YourRegistrationKey', zeile) > 0) Then
       zeile := 'RegKey YKF6GM1JWUXKMRPUXM4WTFJFRKCS';
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\nodelist\fastlst.cfg');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der fastlst.cfg aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // DNS Einträge bei Monika ändern/korrigieren
    Assignfile(f, InstDir + '\binkley\binkd.cfg');
    Assignfile(g, InstDir + '\binkley\binkdcfg.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('node 2:249/3110 ', zeile) = 1 Then Begin
        While (Length(zeile) > 1) and (zeile[Length(zeile)] = ' ') Do
         Delete(zeile, Length(zeile), 1); // Leerzeichen am Ende löschen
        While (Length(zeile) > 1) and (Pos(' ', zeile) > 0) Do
         Delete(zeile,1,1); // bleibt nur Passwort übrig
         zeile := 'node 2:249/3110 monis.fidosoft.de;monisbox.dyndns.org;monis.yi.org '
                  + zeile;
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir+'\binkley\binkd.cfg');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der binkd.cfg aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    alte_Version := '2.5';
  End;

  If (alte_Version = '2.5') Then Begin
    // Pfad zur Pointliste in poll.bat korrigieren
    // und Export geschriebener Mails einfügen
    // und Pfad zum Outecho-Verzeichnis von relativ in absolut ändern
    Assignfile(f, InstDir + '\binkley\poll.bat');
    Assignfile(g, InstDir + '\binkley\poll.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    gefunden := false;
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If (Pos('cd ' + InstDir + '\files', zeile) > 0) Then
       zeile := 'cd ' + InstDir + '\binkley\files';
      If (Pos('cd outecho', zeile) > 0) Then
       zeile := 'cd ' + InstDir + '\binkley\outecho';
      If (Pos(':export', zeile) > 0) Then gefunden := true;
      If (Pos('set EMXOPT', zeile) > 0) and not gefunden Then Begin
        Writeln(g, ':export');
        Writeln(g, 'cd ' + InstDir + '\binkley\hpt');
        Writeln(g, 'hpt scan');
        Writeln(g, 'hpt pack');
        Writeln(g);
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\poll.bat');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der poll.bat aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // Pfad zur Pointliste in pollman.bat korrigieren
    // und Export geschriebener Mails einfügen
    // und Pfad zum Outecho-Verzeichnis von relativ in absolut ändern
    Assignfile(f, InstDir + '\binkley\pollman.bat');
    Assignfile(g, InstDir + '\binkley\pollman.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    gefunden := false;
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If (Pos('cd ' + InstDir + '\files', zeile) > 0) Then
       zeile := 'cd ' + InstDir + '\binkley\files';
      If (Pos('cd outecho', zeile) > 0) Then
       zeile := 'cd ' + InstDir + '\binkley\outecho';
      If (Pos(':export', zeile) > 0) Then gefunden := true;
      If (Pos('set EMXOPT', zeile) > 0) and not gefunden Then Begin
        Writeln(g, ':export');
        Writeln(g, 'cd ' + InstDir + '\binkley\hpt');
        Writeln(g, 'hpt scan');
        Writeln(g, 'hpt pack');
        Writeln(g);
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\pollman.bat');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der pollman.bat aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // Export geschriebener Mails beim Verlassen von Golded in scan.bat
    // verhindern (wird jetzt beim Pollen gemacht)
    // und Export geschriebener Mails einfügen
    Assignfile(g, InstDir + '\golded\scan.bat');
    {$I-}
    Rewrite(g);
    Writeln(g, '@echo off');
    Writeln(g, 'goto ende');
    Writeln(g, 'cd ' + InstDir + '\binkley\hpt');
    Writeln(g, 'hpt scan');
    Writeln(g, 'hpt pack');
    Writeln(g, ':ende');
    Closefile(g);
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der scan.bat aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    alte_Version := '2.6';
  End;

  If (alte_Version = '2.6') Then Begin
    // DNS Einträge bei Monika ändern/korrigieren
    Assignfile(f, InstDir + '\binkley\binkd.cfg');
    Assignfile(g, InstDir + '\binkley\binkdcfg.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('node 2:249/3110 ', zeile) = 1 Then Begin
        While (Length(zeile) > 1) and (zeile[Length(zeile)] = ' ') Do
         Delete(zeile, Length(zeile), 1); // Leerzeichen am Ende löschen
        While (Length(zeile) > 1) and (Pos(' ', zeile) > 0) Do
         Delete(zeile,1,1); // bleibt nur Passwort übrig
         zeile := 'node 2:249/3110 monisbox.dyndns.org;bbsdd.de;monis.yi.org '
                  + zeile;
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir+'\binkley\binkd.cfg');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der binkd.cfg aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    alte_Version := '2.7';
  End;

  If (alte_Version = '2.7') Then Begin
    // neue Nodediff-Area NODEDIFZ anbestellen
    // (alte NODEDIFF sicherheitshalber nicht abbestellen)
    Assignfile(f, InstDir + '\binkley\hpt\filefix.chg');
    Rewrite(f);
    Writeln(f, '+NODEDIFZ');
    Closefile(f);

    // goldarea.bat ausführen (filefix.chg verarbeiten)
    lstrcpy(cmd, comspec);
    lstrcat(cmd, PChar(InstDir+'\binkley\hpt\goldarea.bat'));
    DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 0, True);

    alte_Version := '2.8';
  End;

  If (alte_Version = '2.8') Then Begin
    // goldlang.cfg an neue Golded-Version anpassen
    Assignfile(f, InstDir + '\golded\goldlang.cfg');
    Assignfile(g, InstDir + '\golded\goldlang.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    Readln(f);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If (Pos('ST_EDITSTATUS', zeile) > 0) Then zeile := 'ST_EDITSTATUS        "Editor %i,%i (%02X). %s"';
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\golded\goldlang.cfg');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der goldlang.cfg aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // goldlang.eng an neue Golded-Version anpassen
    Assignfile(f, InstDir + '\golded\goldlang.eng');
    Assignfile(g, InstDir + '\golded\goldlang.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    Readln(f);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If (Pos('ST_EDITSTATUS', zeile) > 0) Then zeile := 'ST_EDITSTATUS        "Editor %i,%i (%02X). %s"';
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\golded\goldlang.eng');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der goldlang.eng aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // goldlang.esp an neue Golded-Version anpassen
    Assignfile(f, InstDir + '\golded\goldlang.esp');
    Assignfile(g, InstDir + '\golded\goldlang.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    Readln(f);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If (Pos('ST_EDITSTATUS', zeile) > 0) Then zeile := 'ST_EDITSTATUS        "Editor %i,%i (%02X). %s"';
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\golded\goldlang.esp');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der goldlang.esp aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // goldlang.nl an neue Golded-Version anpassen
    Assignfile(f, InstDir + '\golded\goldlang.nl');
    Assignfile(g, InstDir + '\golded\goldlang.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    Readln(f);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If (Pos('ST_EDITSTATUS', zeile) > 0) Then zeile := 'ST_EDITSTATUS        "Editor %i,%i (%02X). %s"';
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\golded\goldlang.nl');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der goldlang.nl aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // goldlang.rus an neue Golded-Version anpassen
    Assignfile(f, InstDir + '\golded\goldlang.rus');
    Assignfile(g, InstDir + '\golded\goldlang.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    Readln(f);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If (Pos('ST_EDITSTATUS', zeile) > 0) Then zeile := 'ST_EDITSTATUS        "Editor %i,%i (%02X). %s"';
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\golded\goldlang.rus');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der goldlang.rus aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    alte_Version := '2.9';
  End;

  // folgendes bei jedem Update ausfuehren
    // in goldrun.bat Golded-Exe je nach Windows-Version setzen
    Assignfile(f, InstDir + '\golded\rungold.bat');
    Assignfile(g, InstDir + '\golded\rungold.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    gefunden := False;
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If (Pos('rem fuer Win 9x', zeile) > 0) and not gefunden Then Begin
        gefunden := True;
        Writeln(g, zeile);
        If OS = 1 Then Write(g, 'rem ');
        Writeln(g, 'geddjg.exe');
        Writeln(g);
        Writeln(g, 'rem fuer Win NT/2000');
        If OS <> 1 Then Write(g, 'rem ');
        For i := 1 To 4 Do Readln(f);
        zeile := 'gedcyg.exe';
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir+'\golded\rungold.bat');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der rungold.bat aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // in golded.cfg Tearline aktualisieren
    Assignfile(f, InstDir + '\golded\golded.cfg');
    Assignfile(g, InstDir + '\golded\golded.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('TEARLINE ', zeile) = 1 Then
       zeile := 'TEARLINE FPD ' + Background.version + '  @longpid @version';
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\golded\golded.cfg');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der golded.cfg aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;

    // EolChg ausfuehren, um evtl. korrupte Husky Config zu reparieren
    lstrcpy(cmd, comspec);
    lstrcat(cmd, PChar(InstDir+'\binkley\hpt\confrep.bat'));
    DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 0, True);

    // doppelte Echo-Areas in Husky Config eliminieren
    Assignfile(f, InstDir + '\binkley\hpt\config');
    Assignfile(g, InstDir + '\binkley\hpt\config.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    CBechoListe.Items.Clear;
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('EchoArea ', zeile) = 1 Then Begin
        zeile2 := Copy(zeile,10,Length(zeile));
        i := Pos(' ', zeile2);
        zeile2 := Copy(zeile2,1,i-1);
        If zeile <> '' Then Begin
          If CBechoListe.Items.IndexOf(zeile2) = -1
           Then CBechoListe.Items.Add(zeile2)
           Else zeile2 := '######';
        End;
      End;
      If (zeile2 <> '######') Then Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\hpt\config');
    {$I+}
    If IOResult <> 0 Then Begin
      meldung := 'Fehler beim Ändern der Husky config aufgetreten,' + #13
                 + 'Update unvollständig!';
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    End;


  // cfg mit neuer Versionsnummer schreiben
  cfg_schreiben;

  MaxoutFortschrittsanzeige;

  Installieren.Mitteilung.Caption := s[0087];
  Installieren.cmdAbbruch.Caption := 'OK'; // nicht ändern (wird abgefragt)!
end;

procedure TAngaben.CBProxyChange(Sender: TObject);
begin
  If CBProxy.ItemIndex = 0 Then Begin
    TBProxyIP.Visible := false;
    ProxyPort.Visible := false;
  End
  Else Begin
    TBProxyIP.Visible := true;
    ProxyPort.Visible := true;
    TBProxyIP.SetFocus;
  End;
  If (CBProxy.ItemIndex = 0) or (CBProxy.ItemIndex = 2) Then Begin
    TBProxyUser.Visible := false;
    TBProxyPwd.Visible := false;
    CBProxyPwd.Visible := false;
    CBProxyPwd.Checked := false;
  End
  Else Begin
    TBProxyUser.Visible := CBProxyPwd.Checked;
    TBProxyPwd.Visible := CBProxyPwd.Checked;
    CBProxyPwd.Visible := true;
  End;
end;

procedure TAngaben.TBTelefonClick(Sender: TObject);
var i: Integer;
begin
  i := TBTelefon.SelStart;
  While (i > 0) and ((TBTelefon.Text[i] = ' ') or (TBTelefon.Text[i] = '')) Do Dec(i);
  TBTelefon.SelStart := i;
end;

procedure TAngaben.CBProxyPwdClick(Sender: TObject);
begin
  TBProxyUser.Visible := CBProxyPwd.Checked;
  TBProxyPwd.Visible := CBProxyPwd.Checked;
end;

procedure TAngaben.CBupdateClick(Sender: TObject);
begin
//  Angaben.Hide;        // Eingabe-Formular verstecken
  cdpupdate.Showmodal;   // Formular mit Fortschrittsanz. der Installation zeigen
  Hintergrund.Update;  // blauen Hintergrund neu zeichnen
  cdpupdate.Update; // Installieren-Formular neu auf Hintergrund zeichnen
//  Angaben.Show;        // Eingabe-Formular zeigen
end;

procedure TAngaben.CdpNodelistChange(Sender: TObject);
Var i: Integer;
    zeile: String;
begin
  i := CdpNodelist.ItemIndex;
  zeile := CdpNodelist.Items.Strings[i];

  if (zeile = s[0289]) Then chkIstSchonPoint.Enabled := false
                       Else chkIstSchonPoint.Enabled := true;
end;

end.

