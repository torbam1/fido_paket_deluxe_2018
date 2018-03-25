unit CDP;

interface

uses Windows, StdCtrls, Background;

function pointdaten_anfordern(Name, Ort, Telefon: String; AppHandle: HWND;
                              lstEntries: TComboBox;
                              isUserOnline: Boolean): Integer;
function Node_anpollen(lstEntries: TComboBox;
                       isUserOnline: Boolean): Boolean;
procedure normalPoll;
function cdn_auslesen(cdn: String): Integer;


implementation

uses SysUtils, ShellApi, Forms, WinTypes, WinProcs, Dialogs, Registry, Classes,
     crc, Dateneingabe, kopieren, PollAnzeige, Verbindung, Output,
     fpd_language;

var  cdp_version         : Integer;
     cdp_node_aka        : Word;
     angabenVollstaendig : Boolean;


function Node_anpollen(lstEntries: TComboBox;
                       isUserOnline: Boolean): Boolean;
var fehler       : LongBool;
    meldung      : String;
    UName, PWort : String;
    cmd          : Array[0..2*MAX_PATH] of Char;
//    r            : TRect;
begin
  Node_anpollen := true;
  otherProvider := true;

  Installieren.Hide;

  If netzwerk Then meldung := s[0010]
  Else If internet Then Begin
    If (lstEntries.ItemIndex = (lstEntries.Items.Count-1))
     Then meldung := s[0011]
     Else Begin
       meldung := s[0012];
       otherProvider := false;
     End;
  End
  Else meldung := s[0013];
  meldung := meldung + s[0014];
  already_connected := isUserOnline;
  If not (internet and already_connected) Then
   Application.MessageBox(PChar(meldung), sprache_Hinweis, MB_OK);

  PollAbbruch := false;
  Pollen.Show;

  // aktive Verbindung -> nicht wählen
//  already_connected := internet and aktiveVerbindungen(nameProvider);
  already_connected := isUserOnline;
  If forced Then already_connected := true;

  // bereits aktive Verbindung -> nachher nicht auflegen
  not_auflegen := already_connected;

  If internet and otherProvider and not already_connected Then Begin
    meldung := s[0015];
    Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);

    nichtFragen := true;
    Pollen.Close;
    Angaben.Visible := true;
    Node_anpollen := false;
    Application.ProcessMessages;
    Exit;
  End;

  If not netzwerk and not already_connected and not otherProvider Then Begin
    statusmeldung := '';
    If not internet Then waehlen('Fido-Paket deluxe', Username, Passwort)
                    Else Begin
                      getParams(lstEntries.Items.Strings[lstEntries.ItemIndex], UName, PWort);
                      Username := UName;
                      Passwort := PWort;
                      If Passwort = '' Then Begin
                        meldung := Format(s[0016], [lstEntries.Items.Strings[lstEntries.ItemIndex]]);
                        Passwort := InputBox(s[0017], meldung, '')
                      End;
                      waehlen(lstEntries.Items.Strings[lstEntries.ItemIndex], Username, Passwort);
                    End;
    Repeat Application.ProcessMessages; until (statusmeldung = 'Connected')
                 or (statusmeldung = 'Disconnected')
                 or (Pos(sprache_Fehler, statusmeldung) > 0)
                 or (Pos('geschlossen', statusmeldung) > 0)
                 or (Pos('antwortet nicht', statusmeldung) > 0)
                 or PollAbbruch;

    Application.ProcessMessages;
    If PollAbbruch Then Begin
      nichtFragen := true;
      Pollen.Close;
      Angaben.Visible := true;
      Node_anpollen := false;
      Application.ProcessMessages;
      If not not_auflegen Then auflegen(nameProvider);
      Exit;
    End;


    If statusmeldung <> 'Connected' Then Begin
      Pollen.CBAbbruch.Enabled := false;
      Application.ProcessMessages;
      meldung := Format(s[0018], [statusmeldung]);
      Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
      Pollen.CBAbbruch.Enabled := true;
      Pollen.Close;
      nichtFragen := true;
      Angaben.Visible := true;
      Node_anpollen := false;
      If not not_auflegen Then auflegen(nameProvider);
      Exit;
    End;
  End;

  If not netzwerk and not internet
   Then Pollen.Info.Caption := s[0019]
   Else Pollen.Info.Caption := '';

  Pollen.Info2.Caption := s[0020];
  Pollen.Info3.Text := s[0021];
  Pollen.Info3.Visible := True;
  Pollen.Left := Screen.Width - Pollen.Width - 20;
  Application.ProcessMessages;

  lstrcpy(cmd, comspec);
  lstrcat(cmd, PChar(InstDir+'\binkley\poll2.bat'));
  DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 0, True);

  lstrcpy(cmd, PChar(InstDir + '\binkley\binkd.exe -p binkd.cfg'));
  DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 1, True);

  lstrcpy(cmd, comspec);
  lstrcat(cmd, PChar(InstDir+'\binkley\poll3.bat'));
  DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 0, True);

//  GetWindowRect(prozessinfo.hprocess,r); // die Maße des Fensters in das rect
//  If (Pollen.Top > r.Top) and (Pollen.Top+Pollen.Height < r.Bottom) Then
//   Pollen.Top := r.Bottom + 10;
(*
  Repeat
    Application.ProcessMessages;
  Until (WaitforSingleObject(prozessinfo.hProcess,0)<>WAIT_TIMEOUT)
        or (Application.terminated) or PollAbbruch;

  If PollAbbruch Then TerminateProcess(prozessinfo.hProcess,1);
  CloseHandle(prozessinfo.hProcess);
*)

//  If not not_auflegen Then auflegen;

  If fehler Then Begin // Fehler
    Pollen.Close;
    Str(GetLastError, meldung);
    meldung := Format(s[0023], [meldung]);
    Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    Node_anpollen := false;
  End;
end;


function cdn_auslesen(cdn: String): Integer;
Var f              : Textfile;
    i              : Integer;
    noPointText    : String;
    zeile, zeile2  : String;
    meldung        : String;
    connected      : Boolean; // aus Binkd.log auslesen, ob Connect erfolgreich
begin
  cdn_auslesen := 0;
  Assignfile(f, cdn);
  {$I-} Reset(f); {$I+}
  IF IOResult <> 0 Then
  Begin
    Pollen.Close;
    cdn_auslesen := 1; // Fehler
    noPointText := '';
    If cdn_uebergeben Then Begin
      meldung := s[0105];
      Application.MessageBox(PChar(meldung), 'Fehler', MB_OK);
      Exit; // oder besser halt?
    End
    Else Begin
      Assignfile(f, InstDir + '\BINKLEY\FILES\NOPOINT.CDN');
      {$I-} Reset(f); {$I+}
      IF IOResult <> 0 Then Begin
        // kein Grund angegeben, vermutlich ein vorübergehender Fehler beim Node
        // oder Verbindung (Connect) hat nicht geklappt
        Assignfile(f, InstDir + '\BINKLEY\binkd.log');
        {$I-} Reset(f); {$I+}
        IF IOResult <> 0 Then Begin
        End; // nur IOResult löschen; dieser Fall dürfte normal nicht vorkommen

        connected := false;
        While not EOF(f) Do Begin
          Readln(f, zeile);
          If Pos('connected', zeile) > 0 Then Begin
            connected := true;
            Break;
          End;
        End;
        Closefile(f);
        If not connected Then noPointText := Format(s[0024], [InstDir]);
      End
      Else Begin
        // Node akzeptiert (zur Zeit) keine (CDP-)Points mehr
        Readln(f, zeile);
        If zeile <> '' Then noPointText := zeile;
        While not EOF(f) Do Begin
          Readln(f, zeile);
          If zeile <> '' Then noPointText := noPointText + Chr(13) + zeile;
        End;
        Closefile(f);
      End;

      Angaben.noPoint(noPointText);
      Exit;
    End;
  End;

  // Variablen initialisieren
  point_nr := '';           // Point-Nummer (nicht die gesamte AKA)
  SessionPassword := '';    // für Mailer/Nodelistcompiler
  AreafixPassword := '';    // für Tosser
  FiletickerPassword := ''; // für Fileticker
  PktPassword := '';        // für Tosser
  AreafixName := '';        // Name des Areafix (meist Areafix)
  FiletickerName := '';     // Name des Filetickers (meist Filefix)
  eMail := '';              // eMail Adresse des Nodes
  Voice := '';              // Telefonnummer (Voice) des Nodes
  cdp_version := 1;         // CDP Version, die der Node unterstützt
  cdp_node_aka := 0;        // ab CDP Version 2; zu benutzende Node AKA
  angabenVollstaendig := False;

  {$I-}
  While not EOF(f) Do Begin
    Readln(f, zeile);
    If (Length(zeile) > 1) and (zeile[1] <> ';') and (zeile[1] <> '#')
       and (Pos('=', zeile) > 0) Then Begin
      i := Pos('=', zeile);
      zeile2 := Copy(zeile,i+1,Length(zeile));
      zeile := UpperCase(zeile);

      If Pos('POINTNUMBER=', zeile) = 1 Then point_nr := zeile2
      Else If Pos('PASSWORD=', zeile) = 1 Then SessionPassword := zeile2
      Else If Pos('AREAFIXPW=', zeile) = 1 Then AreafixPassword := zeile2
      Else If Pos('TICKERPW=', zeile) = 1 Then FiletickerPassword := zeile2
      Else If Pos('PKTPW=', zeile) = 1 Then PktPassword := zeile2
      Else If Pos('AREAFIX_NAME=', zeile) = 1 Then AreafixName := zeile2
      Else If Pos('TICKER_NAME=', zeile) = 1 Then FiletickerName := zeile2
      Else If Pos('EMAIL_ADDR=', zeile) = 1 Then eMail := zeile2
      Else If Pos('VOICE=', zeile) = 1 Then Voice := zeile2
      Else If Pos('VERSION=', zeile) = 1 Then cdp_version := StrToInt(zeile2)
      Else If Pos('NODE_AKA=', zeile) = 1 Then cdp_node_aka := StrToInt(zeile2);
    End;
  End;

  Closefile(f);
  If not updaten Then Begin
    CopyFile(PChar(cdn), PChar(InstDir + '\point.cdn'), false);
    Erase(f);
  End;
  {$I+}

  i := IOResult; // wenn IOResult <> 0, dann angabenVollstaendig = False

  If i = 0 Then Begin
    angabenVollstaendig := (point_nr <> '') and
                           (SessionPassword <> '') and
                           (AreafixPassword <> '') and
                           (FiletickerPassword <> '') and
                           (PktPassword <> '') and
                           (AreafixName <> '') and
                           (FiletickerName <> '');
  End;


  If angabenVollstaendig and (cdp_version > 1) Then Begin
    If cdp_node_aka = 0 Then angabenVollstaendig := False
    Else Begin
      node_nr := cdp_node_aka;
      Angaben.node_aka_hex_bestimmen(node_nr, netz_nr);
    End;
  End;

  If not angabenVollstaendig Then Begin
    noPointText := Format(s[0025], [IntToStr(i)]);
    Angaben.noPoint(noPointText);
    Exit;
  End;
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

function pointdaten_anfordern(Name, Ort, Telefon: String; AppHandle: HWND;
                              lstEntries: TComboBox;
                              isUserOnline: Boolean): Integer;
Var f              : Textfile;
    temp_Aka_Hex   : String[4];  // temporäre Point-AKA in Hex für CDP-Poll
    tempNode       : String[25];
    i              : Integer;
    zone_str       : String[4];
    LWCount        : Byte;
    DriveList      : String;
    FidoCD         : Boolean; // Installation von Fido-CD?
    InstLfw        : String;
begin
  If cdn_uebergeben
  Then CopyFile(PChar(cdn), PChar(InstDir+'\Binkley\Files\ALTPOINT.CDN'), false)
  Else Begin { keine cdn übergeben }

  temp_Aka_Hex := crc_bilden_hex(Name + Ort + Telefon);

  // CDP-Datei für Node erstellen
  Str(zone_nr, zone_str);
  While Length(zone_str) < 4 Do zone_str := '0' + zone_str; // 4-stellig machen

  Assignfile(f, InstDir + '\BINKLEY\OUTECHO\' + temp_Aka_Hex + zone_str + '.CDP');
  Rewrite(f);

  Writeln(f, '; CDP-Projekt Datendatei');
  Writeln(f, '; Name des Points');
  Writeln(f, 'POINTNAME=' + Name);
  Writeln(f, '; Anschrift des Points');
  Writeln(f, 'RESIDENCE=' + Ort);
  Writeln(f, '; Wohnort des Points für die Pointliste');
  Writeln(f, 'PNTLST_RES=' + Ort);
  Writeln(f, '; Telefon-Nr. (Voice) des Points');
  Writeln(f, 'VOICEPHONE=' + Telefon);
  Writeln(f, '; Temporaere Adresse zur Einwahl beim Node');
  i := Pos('/', NodeAKA);
  tempNode := Copy(NodeAKA,1,i) + '9999.' + temp_Aka_Dez;
  Writeln(f, 'TEMPAKA=' + tempNode);
  Writeln(f, '; An den Point zu uebertragene Datei');
  Writeln(f, 'RESULT=' + temp_Aka_Hex + zone_str + '.CDN');
  Writeln(f, '; Wieviele verschiedene Passwoerter kann die Pointsoft');
  Writeln(f, 'PW_USABLE=4');
  Writeln(f, '; Welche CDP Version wurde implementiert?');
  Writeln(f, 'VERSION=3'); // CDP Spezifikation Version 3

  FidoCD := False;
  LWCount := GetDrives(DRIVE_CDROM, DriveList);
  InstLfw := Copy(ParamStr(0),1,1);
  For i := 1 to LWCount Do If (InstLfw = DriveList[i]) Then Begin
    FidoCD := True;
    break;
  End;

  Write(f, '; Fido-Paket deluxe ' + Background.version);
  If FidoCD Then Write(f, ' -CD-');
  Writeln(f, ', von Michael Haase (2:2432/280) - www.fido-deluxe.de.vu');
  Closefile(f);

  // CLO-File für Binkley erstellen zum Crash-Pollen der CDP-Datei
  Assignfile(f, InstDir + '\BINKLEY\OUTECHO\' + node_aka_hex + '.CLO');
  Rewrite(f);
  Writeln(f, '^' + InstDir + '\BINKLEY\OUTECHO\' + temp_Aka_Hex + zone_str + '.CDP');
  Closefile(f);

  End; { keine cdn übergeben }

  // REQ-File für Binkley erstellen zwecks Auslösen des Function-Requests
  // für CDP und Requesten von ECHOLIST und NODELIST
  Assignfile(f, InstDir + '\BINKLEY\OUTECHO\' + node_aka_hex + '.REQ');
  Rewrite(f);
  If not cdn_uebergeben Then Writeln(f, 'CDPOINT !CDP-PW');
  Writeln(f, 'ECHOLIST');
  Writeln(f, 'NODE0002');
  Writeln(f, 'BOXLIST');
  Writeln(f, 'NETZLIST');
  Writeln(f, 'NODETEXT');
  Writeln(f, 'PNT0002');
  If (NodeAKA = '2:240/2188') or (NodeAKA = '2:240/2189')
   Then Writeln(f, 'PNT2188.LST');
//  If (NodeAKA = '2:2457/265') or (NodeAKA = '2:2457/266') or (NodeAKA = '2:2457/267')
//   Then Writeln(f, 'POINT265.LST');
  Closefile(f);

  // Binkley starten, pollen lassen, Binkley beenden
  If not cdn_uebergeben Then If Node_anpollen(lstEntries, isUserOnline) = false
  Then Begin
    pointdaten_anfordern := 1; // Fehler
    Exit;
  End;

  // Pointdaten aus empfangener CDN-Datei auslesen
  If not cdn_uebergeben Then cdn := temp_Aka_Hex + zone_str + '.CDN'
                        Else cdn := 'ALTPOINT.CDN';
  pointdaten_anfordern := cdn_auslesen(InstDir + '\BINKLEY\FILES\' + cdn);

  // wenn von Henning eine point265.lst empfangen wird, dann diese
  // ins Nodelist-Verzeichnis verschieben (wird in Nodeliste eingebunden)
(*
  Assignfile(f, InstDir + '\BINKLEY\FILES\point265.lst');
  {$I-} Reset(f); {$I+}
  IF IOResult = 0 Then Begin
    Closefile(f);
    CopyFile(PChar(InstDir+'\binkley\files\point265.lst'),
             PChar(InstDir+'\binkley\nodelist\point265.lst'), false);
    DeleteFile(PChar(InstDir+'\binkley\files\point265.lst'));
  End;
*)
  // wenn von Christian eine 10251.UPD empfangen wird, dann diese
  // ins Nodelist-Verzeichnis verschieben (wird in Nodeliste eingebunden)
  Assignfile(f, InstDir + '\BINKLEY\FILES\10251.UPD');
  {$I-} Reset(f); {$I+}
  IF IOResult = 0 Then Begin
    Closefile(f);
    CopyFile(PChar(InstDir+'\binkley\files\10251.UPD'),
             PChar(InstDir+'\binkley\nodelist\10251.UPD'), false);
    DeleteFile(PChar(InstDir+'\binkley\files\10251.UPD'));
  End;
end;


procedure normalPoll;
var fehler      : LongBool;
    meldung     : String;
    cmd         : Array[0..2*MAX_PATH] of Char;
    f           : Textfile;
//    r           : TRect;
begin
  // REQ-File für Binkley erstellen zum Requesten der Pointliste bei Monika
  If (NodeAKA <> '2:249/3110') and (NodeAKA <> '2:249/3114') Then Begin
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

  Sleep(5000); // 5 Sekunden warten

  meldung := s[0026];
  Application.MessageBox(PChar(meldung), sprache_Info, MB_OK);

  Pollen.Left := Screen.Width - Pollen.Width - 20;

  lstrcpy(cmd, comspec);
  lstrcat(cmd, PChar(InstDir+'\binkley\poll.bat'));
  DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 0, True);

  lstrcpy(cmd, PChar(InstDir + '\binkley\binkd.exe -p binkd.cfg'));
  DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 1, True);

  // wenn eine Pointliste empfangen wurde, dann leere Dummy-Pointliste
  // löschen
  Assignfile(f, InstDir + '\BINKLEY\FILES\pnt0002.zip');
  {$I-} Reset(f); {$I+}
  IF IOResult = 0 Then Begin
    Closefile(f);
    DeleteFile(PChar(InstDir+'\binkley\nodelist\r24pnt.000'));
  End;

  lstrcpy(cmd, comspec);
  lstrcat(cmd, PChar(InstDir+'\binkley\hpt\toss.bat'));
  DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 2, True);

//  GetWindowRect(prozessinfo.hprocess,r); // die Maße des Fensters in das rect
//  If (Pollen.Top > r.Top) and (Pollen.Top+Pollen.Height < r.Bottom) Then
//   Pollen.Top := r.Bottom + 10;
(*
  Repeat
    Application.ProcessMessages;
  Until (WaitforSingleObject(prozessinfo.hProcess,0)<>WAIT_TIMEOUT)
        or (Application.terminated) or PollAbbruch;

  If PollAbbruch Then TerminateProcess(prozessinfo.hProcess,1);
  CloseHandle(prozessinfo.hProcess);
*)

  If not not_auflegen Then auflegen(nameProvider);

  If fehler Then Begin // Fehler
    Pollen.Close;
    Str(GetLastError, meldung);
    meldung := Format(s[0023], [meldung]);
    Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
  End;
end;


end.
