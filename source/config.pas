unit config;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, InfoBtn, Tabnotbk, ExtCtrls, Grids, Mask, Spin,
  Buttons;

type
  TKonfiguration = class(TForm)
    CBabbruch: TInfoButton;
    CBok: TInfoButton;
    Reiter: TPageControl;
    Sheet_AutoPoll: TTabSheet;
    Sheet_Farben: TTabSheet;
    Sheet_Gruppen: TTabSheet;
    Sheet_Adressmakros: TTabSheet;
    Sheet_Daten: TTabSheet;
    Sheet_History: TTabSheet;
    Sheet_Updates: TTabSheet;
    lstProvider: TComboBox;
    InfoProvider: TLabel;
    Label1: TLabel;
    MinutenAutoPoll: TTrackBar;
    InfoAutoPoll: TLabel;
    autoPollen: TCheckBox;
    LText: TLabel;
    CBText: TComboBox;
    LQuote1: TLabel;
    CBQuote1: TComboBox;
    CBQuote2: TComboBox;
    LQuote2: TLabel;
    LHintergrund: TLabel;
    CBHintergrund: TComboBox;
    AdrMakros: TStringGrid;
    LAdrMakroErklaerung: TLabel;
    LBHistory: TListBox;
    LItalic: TLabel;
    CBItalic: TComboBox;
    CBBoldItalic: TComboBox;
    LBoldItalic: TLabel;
    LUnderline: TLabel;
    LBoldUnderline: TLabel;
    LItalicUnderline: TLabel;
    LBoldItalicUnderline: TLabel;
    CBUnderline: TComboBox;
    CBBoldUnderline: TComboBox;
    CBItalicUnderline: TComboBox;
    CBBoldItalicUnderline: TComboBox;
    LBold: TLabel;
    CBBold: TComboBox;
    MUpdates: TMemo;
    Laka: TLabel;
    LWarnung: TLabel;
    LSessionPwd: TLabel;
    TBSessionPwd: TEdit;
    LAreafixPwd: TLabel;
    TBAreafixPwd: TEdit;
    LFilemgrPwd: TLabel;
    TBFilemgrPwd: TEdit;
    LPktPwd: TLabel;
    TBPktPwd: TEdit;
    LAdrWarnung: TLabel;
    LFooter: TLabel;
    MFooter: TMemo;
    LGruppen: TLabel;
    LBGruppen: TListBox;
    UpDownButton: TSpinButton;
    CBneu: TButton;
    CBdel: TButton;
    CBchange: TButton;
    LAreasGrp: TLabel;
    LBAreasGrp: TListBox;
    CBAreaGruppe: TComboBox;
    LGrpArea: TLabel;
    LBAreasGrp2: TListBox;
    Sheet_Sonstiges: TTabSheet;
    CBLogfile: TInfoBitBtn;
    Lurl: TLabel;
    CBurl: TComboBox;
    LGoldedZeilen: TLabel;
    TBzeilenGolded: TEdit;
    LZeilenInfo: TLabel;
    TBaka: TEdit;
    TBnodename: TEdit;
    Lnodename: TLabel;
    TBip: TEdit;
    Lip: TLabel;
    procedure CBabbruchClick(Sender: TObject);
    procedure Tastendruecke(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure node_aka_hex_bestimmen(node_nr, netz_nr: Word);
    procedure CBokClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GetEntries(anzahl: Integer);
    procedure Adressmakros_schreiben;
    procedure Adressmakros_lesen;
    procedure GoldedFarben_schreiben;
    procedure GoldedFarben_lesen;
    procedure Gruppen_lesen;
    procedure Gruppen_schreiben;
    procedure Anzahl_Zeilen_lesen;
    procedure Anzahl_Zeilen_schreiben;
    procedure Footer_schreiben(fname: String);
    procedure passwoerter_und_link_aendern;
    procedure Daten_lesen;
    procedure FormCreate(Sender: TObject);
    procedure MinutenAutoPollChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure HistoryOeffnen;
    procedure TBSessionPwdKeyPress(Sender: TObject; var Key: Char);
    procedure TBAreafixPwdKeyPress(Sender: TObject; var Key: Char);
    procedure TBPktPwdKeyPress(Sender: TObject; var Key: Char);
    procedure TBFilemgrPwdKeyPress(Sender: TObject; var Key: Char);
    procedure LBAreasGrpClick(Sender: TObject);
    procedure LBAreasGrpKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CBAreaGruppeChange(Sender: TObject);
    procedure CBchangeClick(Sender: TObject);
    procedure CBdelClick(Sender: TObject);
    procedure CBneuClick(Sender: TObject);
    procedure UpDownButtonDownClick(Sender: TObject);
    procedure UpDownButtonUpClick(Sender: TObject);
    procedure CBLogfileClick(Sender: TObject);
    procedure lstProviderChange(Sender: TObject);
  private
    { Private-Deklarationen }
    function Farbe_zuweisen(farbe: String): Integer; overload;
    function Farbe_zuweisen(index: Integer): String; overload;
  public
    { Public-Deklarationen }
  end;

var
  Konfiguration: TKonfiguration;

implementation

uses FidoInfos, HMenue, fontheight, Background, ras, fpd_language, Logfile,
  Echos, Output, crc;

type
   AkaRecord = record
                     aka: String[21];
                     netz: String[4];
                     nodenr: String[4];
                     pointnr: String[5];
                     nodename: String;
                     ip: String[55];
                     nodehex: String[8];
               end;

var
   alt_Aka, neu_Aka : AkaRecord;
   alt_SessionPwd,
   alt_PktPwd,
   alt_AreafixPwd,
   alt_FilemgrPwd   : String[8];
   noChange         : Boolean; // AKA+Passwörter können nicht geändert werden
   dnsError         : Boolean; // kein (oder fehlerhafter) dyn. DNS-Eintrag

{$R *.DFM}

procedure TKonfiguration.CBabbruchClick(Sender: TObject);
begin
  Konfiguration.Close;
end;

procedure TKonfiguration.Tastendruecke(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  Case Key of
   VK_Escape: CBabbruchClick(Sender);
   Ord('O'): If ssAlt in Shift Then CBokClick(Sender);
  End;
end;

procedure TKonfiguration.node_aka_hex_bestimmen(node_nr, netz_nr: Word);
begin
  { CLO Name aus AKA des Nodes ohne Zone generieren }
  node_aka_hex := Numb2Hex(node_nr); // Nodenummer
  While Length(node_aka_hex) < 4 Do node_aka_hex := '0' + node_aka_hex; // 4-stellig machen
  node_aka_hex := Numb2Hex(netz_nr) + node_aka_hex; // Netznummer davor
  While Length(node_aka_hex) < 8 Do node_aka_hex := '0' + node_aka_hex; // 8-stellig machen
end;

procedure TKonfiguration.CBokClick(Sender: TObject);
Var f, g              : Textfile;
    i                 : Integer;
    zeile             : String;
    Diffliste         : TMemo;
    cmd               : Array[0..2*MAX_PATH] of Char;
    fehler            : LongBool;
    fehlerAka         : Boolean;
    temp              : String;
    boxlistGefunden,
    netzlistGefunden,
    echolistGefunden  : Boolean;
begin
  If autoPollen.Checked
   Then autoPoll := MinutenAutoPoll.Position
   Else autoPoll := -MinutenAutoPoll.Position; // deaktiviert, Slider auf x Min.

  If internet OR lokal_netz Then Begin
    If (lstProvider.ItemIndex = (lstProvider.Items.Count-2))
     Then Begin
       otherProvider := true;
       Verbindung_Name := 'otherProvider';
     End
     Else Begin
       otherProvider := false;
       Verbindung_Name := lstProvider.Items.Strings[lstProvider.ItemIndex];
     End;
  End;

  If (not noChange) Then Begin
    // Node Name
    neu_Aka.nodename := TBnodename.Text;

    // IP / Dyn. DNS
    neu_Aka.ip := TBip.Text;

    // AKA
    fehlerAka := False;
    temp := TBaka.Text;
    neu_Aka.aka := TBaka.Text;
    If (temp[2] = ':') Then Begin
      Delete(temp,1,2); // Zone löschen
      i := Pos('/', temp);
      If i > 0 Then Begin
        neu_Aka.netz := Copy(temp,1,i-1);
        Delete(temp,1,i); // Netz löschen
        i := Pos('.', temp);
        If i > 0 Then Begin
          neu_Aka.nodenr := Copy(temp,1,i-1);
          Delete(temp,1,i);
          If (Length(temp) > 0)
           Then neu_Aka.pointnr := temp
           Else neu_Aka.pointnr := '0';
        End
        Else fehlerAka := True;
      End
      Else fehlerAka := True;
    End
    Else fehlerAka := True;

    // AKA prüfen
    If fehlerAka Then Begin
      Application.MessageBox(PChar(s[0261]), PChar(sprache_Fehler), MB_OK);
      Exit;
    End;

    // leere Passwörter nicht erlauben
    If (TBSessionPwd.Text = '') or (TBPktPwd.Text = '')
       or (TBAreafixPwd.Text = '') or (TBFilemgrPwd.Text = '') Then Begin
      Application.Messagebox(PChar(s[0247]), sprache_Info, MB_Ok);
      Exit;
    End;

    // Nodenummer in hex
    alt_Aka.nodehex := node_aka_hex;
    node_aka_hex_bestimmen(StrToInt(neu_Aka.nodenr), StrToInt(neu_Aka.netz));
    neu_Aka.nodehex := node_aka_hex;
    node_aka_hex := alt_Aka.nodehex; // wird noch zum Pollen/Abmelden benötigt
  End; // not noChange

  Assignfile(f, InstDir + '\mh-fido.cfg');
  Assignfile(g, InstDir + '\mhfidcfg.tmp');
  {$I-} Reset(f); {$I+}
  IOResult;
  {$I-} Rewrite(g); {$I+}
  IOResult;

  If (noChange) Then Begin
    For i := 1 To 3 Do Begin
      Readln(f, zeile);
      Writeln(g, zeile);
    End;
  End
  Else Begin
    For i := 1 To 3 Do Readln(f);
    Writeln(g, neu_Aka.netz);
    Writeln(g, neu_Aka.nodenr);
    Writeln(g, neu_Aka.nodehex);
  End;

  For i := 1 To 4 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;

  Readln(f);
  If (Verbindung_Name = s[0254]) or forced Then Begin
    Writeln(g, '-l');
    lokal_netz := True;
    internet := False;
    forced := True;
  End
  Else Begin
    Writeln(g, Verbindung_Name);
    lokal_netz := False;
    internet := True;
    forced := False;
  End;

  Readln(f, zeile);
  Writeln(g, zeile);

  Readln(f, zeile);
  If (noChange) Then Writeln(g, zeile)
  Else Writeln(g, neu_Aka.aka[1] + ':' + neu_Aka.netz + '/' + neu_Aka.nodenr);

  Readln(f);
  Writeln(g, autoPoll);

  While not EOF(f) Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;

  Closefile(f);
  Closefile(g);
  Erase(f);
  Rename(g, InstDir+'\mh-fido.cfg');

  // Golded Farben
  GoldedFarben_schreiben;

  // Gruppen in Golded und Husky Config schreiben
  Gruppen_schreiben;

  // Golded Adressmakros schreiben
  Adressmakros_schreiben;

  // Golded Footer schreiben
  Footer_schreiben('golded.tpl');
  Footer_schreiben('netmail.tpl');

  // Golded Anzahl Zeilen schreiben
  Anzahl_Zeilen_schreiben;

  If (not noChange) Then Begin
    // Pointnummer ändern
    If alt_Aka.aka <> neu_Aka.aka Then Begin
      If (ParamStr(1) <> '-nichtabmelden') and (ParamStr(1) <> 'test') Then Begin
        Application.MessageBox(PChar(s[0214]), PChar(s[0127]), MB_OK);

        Hauptmenue.point_abmelden(Sender);
      End;
    End;

    // Daten ändern
    passwoerter_und_link_aendern;

    // globale Variablen aktualisieren
    netznummer := StrToInt(neu_Aka.netz);
    nodenummer := neu_Aka.nodenr;
    node_aka_dez := node_aka_dez[1] + ':' + neu_Aka.netz + '/' + neu_Aka.nodenr;
    node_aka_hex := neu_Aka.nodehex;
    point_aka := neu_Aka.aka;

    // wenn Pointnummer geändert wurde, dann alte Areas neu anbestellen
    // (erst nach passwoerter_aendern, weil neue Areafix und Filefix Passwörter)
    Diffliste := TMemo.Create(Self);
    Diffliste.Parent := Konfiguration;
    Diffliste.Visible := False;
    Diffliste.Clear;
    If alt_Aka.aka <> neu_Aka.aka Then Begin
      // alle vorher bestellten Mail-Areas anbestellen
      Assignfile(f, InstDir+'\aktiv.lst');
      {$I-} Reset(f); {$I+}
      IF (IOResult = 0) Then Begin
        While not EOF(f) Do Begin
          Readln(f, zeile);
          If (zeile <> '') Then Begin
            i := Pos(' ', zeile);
            Delete(zeile,i,Length(zeile));
            If (zeile <> '') Then Diffliste.Lines.Add('+' + zeile);
          End;
        End;
        Closefile(f);
      End;
      Echoverwaltung.echoAnAbBestellen(Diffliste);
      Diffliste.Free;

      // Fileareas anbestellen
      Assignfile(f, InstDir+'\binkley\hpt\filefix.chg');
      Rewrite(f);
      Writeln(f, '+NODEDIFF');
      Writeln(f, '+NODEDIFZ');
      Closefile(f);

      // Mail für Areafix und Filefix erstellen
      lstrcpy(cmd, comspec);
      lstrcat(cmd, PChar(InstDir+'\binkley\hpt\goldarea.bat'));
      DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 0, True);
    End;

    If (alt_Aka.nodehex <> neu_Aka.nodehex) Then Begin
      // wenn zu anderem Node gewechselt, dann neue Echolisten requesten
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
    End;
  End; // not noChange

  Konfiguration.Close;
end;

function get_Anzahl_Verbindungen: Integer;
var
    bufsize: Longint;
    numEntries: Longint;
    entries: LPRasEntryName;
    res: Integer;
begin
  If noRAS Then Begin
    get_Anzahl_Verbindungen := -1; // kein DFÜ Netzwerk
    Exit;
  End;

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
  if res = 0 then get_Anzahl_Verbindungen := numEntries
             else get_Anzahl_Verbindungen := -1; // DFÜ Netzwerk nicht initialisiert (?)
  FreeMem(entries);
end;

function TKonfiguration.Farbe_zuweisen(farbe: String): Integer;
var erg: Integer;
begin
  If farbe = 'Black' Then erg := 0
  Else If farbe = 'Blue' Then erg := 1
  Else If farbe = 'Green' Then erg := 2
  Else If farbe = 'Cyan' Then erg := 3
  Else If farbe = 'Red' Then erg := 4
  Else If farbe = 'Magenta' Then erg := 5
  Else If farbe = 'Brown' Then erg := 6
  Else If farbe = 'LGrey' Then erg := 8
  Else If farbe = 'DGrey' Then erg := 7
  Else If farbe = 'LBlue' Then erg := 9
  Else If farbe = 'LGreen' Then erg := 10
  Else If farbe = 'LCyan' Then erg := 11
  Else If farbe = 'LRed' Then erg := 12
  Else If farbe = 'LMagenta' Then erg := 13
  Else If farbe = 'Yellow' Then erg := 14
  Else If farbe = 'White' Then erg := 15
  Else erg := -1;
  Farbe_zuweisen := erg;
end;

function TKonfiguration.Farbe_zuweisen(index: Integer): String;
var farbe: String;
begin
  Case index of
        0: farbe := 'Black';
        1: farbe := 'Blue';
        2: farbe := 'Green';
        3: farbe := 'Cyan';
        4: farbe := 'Red';
        5: farbe := 'Magenta';
        6: farbe := 'Brown';
        8: farbe := 'LGrey';
        7: farbe := 'DGrey';
        9: farbe := 'LBlue';
       10: farbe := 'LGreen';
       11: farbe := 'LCyan';
       12: farbe := 'LRed';
       13: farbe := 'LMagenta';
       14: farbe := 'Yellow';
       15: farbe := 'White';
  End;
  Farbe_zuweisen := farbe;
end;

procedure TKonfiguration.Adressmakros_lesen;
Var i, z   : Integer;
    f      : Textfile;
    zeile  : String;
begin
  AdrMakros.Cells[0,0] := 'Makro';
  AdrMakros.Cells[1,0] := 'Adressat';
  AdrMakros.Cells[2,0] := 'Adresse (AKA)';
  AdrMakros.Cells[3,0] := 'Subject';
  z := 1;

  Assignfile(f, InstDir + '\golded\adrmacro.cfg');
  {$I-}
  Reset(f);
  While not EOF(f) and (z < 21) Do Begin
    Readln(f, zeile);
    Delete(zeile,1,14);
    i := Pos(',', zeile);
    AdrMakros.Cells[0,z] := Copy(zeile,1,i-1);
    Delete(zeile,1,i);

    i := Pos(',', zeile);
    If i = 0 Then i := Length(zeile) + 1;
    AdrMakros.Cells[1,z] := Copy(zeile,1,i-1);
    If i > Length(zeile) Then zeile := ''
                         Else Delete(zeile,1,i);

    If Length(zeile) > 0 Then Begin
      i := Pos(',', zeile);
      If i = 0 Then i := Length(zeile) + 1;
      AdrMakros.Cells[2,z] := Copy(zeile,1,i-1);
      If i > Length(zeile) Then zeile := ''
                           Else Delete(zeile,1,i);
    End;

    If Length(zeile) > 0 Then Begin
      i := Pos(',', zeile);
      If i = 0 Then i := Length(zeile) + 1;
      AdrMakros.Cells[3,z] := Copy(zeile,1,i-1);
      If i > Length(zeile) Then zeile := ''
                           Else Delete(zeile,1,i);
    End;

    Inc(z);
  End;
  Closefile(f);
  {$I+}
  If not IOResult = 0 Then Begin
    Assignfile(f, InstDir+'\golded\adrmacro.cfg');
    Rewrite(f);
    Writeln(f, 'ADDRESSMACRO   areamgr,AreaMgr,' + node_aka_dez + ',' {+ AreafixPassword});
    Writeln(f, 'ADDRESSMACRO   areafix,AreaMgr,' + node_aka_dez + ',' {+ AreafixPassword});
    Writeln(f, 'ADDRESSMACRO   filescan,FileScan,' + node_aka_dez + ',' {+ FiletickerPassword});
    Writeln(f, 'ADDRESSMACRO   mh,Michael Haase,2:2432/280');
//    Writeln(f, 'ADDRESSMACRO   nm,Natanael Mignon,2:2457/667');
    Closefile(f);
    Adressmakros_lesen; // zum Einlesen des gerade erstellten Files
  End;
end;

procedure TKonfiguration.Adressmakros_schreiben;
Var z     : Integer;
    f     : Textfile;
    zeile : String;
begin
  Assignfile(f, InstDir + '\golded\adrmacro.cfg');
  Rewrite(f);

  For z := 1 to AdrMakros.RowCount-1 Do Begin
    If (AdrMakros.Cells[0,z] <> '') and (AdrMakros.Cells[1,z] <> '') Then Begin
      zeile := 'ADDRESSMACRO   ' + AdrMakros.Cells[0,z] + ','
               + AdrMakros.Cells[1,z];
      If AdrMakros.Cells[2,z] <> '' Then Begin
        zeile := zeile + ',' + AdrMakros.Cells[2,z];
        If AdrMakros.Cells[3,z] <> '' Then
         zeile := zeile + ',' + AdrMakros.Cells[3,z];
      End;
      Writeln(f, zeile);
    End;
  End;

  Closefile(f);
end;

procedure TKonfiguration.GoldedFarben_schreiben;
Var f           : Textfile;
    farbe       : String;
    hintergrund : String;
begin
  Assignfile(f, InstDir + '\golded\gedcolor.cfg');
  Rewrite(f);
  farbe := Farbe_zuweisen(CBText.ItemIndex);
  hintergrund := Farbe_zuweisen(CBHintergrund.ItemIndex);
  Writeln(f, 'Color Reader Window ' + farbe + ' on ' + hintergrund);
  farbe := Farbe_zuweisen(CBQuote1.ItemIndex);
  Writeln(f, 'Color Reader Quote ' + farbe + ' on ' + hintergrund);
  farbe := Farbe_zuweisen(CBQuote2.ItemIndex);
  Writeln(f, 'Color Reader Quote2 ' + farbe + ' on ' + hintergrund);
  farbe := Farbe_zuweisen(CBurl.ItemIndex);
  Writeln(f, 'Color Reader URL    ' + farbe + ' on ' + hintergrund);
  farbe := Farbe_zuweisen(CBBold.ItemIndex);
  Writeln(f, 'Color Stylecode B   ' + farbe + ' on ' + hintergrund);
  farbe := Farbe_zuweisen(CBItalic.ItemIndex);
  Writeln(f, 'Color Stylecode I   ' + farbe + ' on ' + hintergrund);
  farbe := Farbe_zuweisen(CBBoldItalic.ItemIndex);
  Writeln(f, 'Color Stylecode BI  ' + farbe + ' on ' + hintergrund);
  farbe := Farbe_zuweisen(CBUnderline.ItemIndex);
  Writeln(f, 'Color Stylecode U   ' + farbe + ' on ' + hintergrund);
  farbe := Farbe_zuweisen(CBBoldUnderline.ItemIndex);
  Writeln(f, 'Color Stylecode BU  ' + farbe + ' on ' + hintergrund);
  farbe := Farbe_zuweisen(CBItalicUnderline.ItemIndex);
  Writeln(f, 'Color Stylecode IU  ' + farbe + ' on ' + hintergrund);
  farbe := Farbe_zuweisen(CBBoldItalicUnderline.ItemIndex);
  Writeln(f, 'Color Stylecode BIU ' + farbe + ' on ' + hintergrund);
  Closefile(f);
end;

procedure TKonfiguration.GoldedFarben_lesen;
Var i, j   : Integer;
    f      : Textfile;
    zeile  : String;
    fehler : Boolean;
begin
  fehler := false;
  Assignfile(f, InstDir + '\golded\gedcolor.cfg');
  {$I-}
  Reset(f);
  Readln(f, zeile);
  Delete(zeile,1,20);
  i := Pos(' ', zeile);
  j := Farbe_zuweisen(Copy(zeile,1,i-1));
  If j = -1 Then fehler := true
            Else CBText.ItemIndex := j;

  Delete(zeile,1,i+3);
  j := Farbe_zuweisen(zeile);
  If j = -1 Then fehler := true
            Else CBHintergrund.ItemIndex := j;

  Readln(f, zeile);
  Delete(zeile,1,19);
  i := Pos(' ', zeile);
  zeile := Copy(zeile,1,i-1);
  j := Farbe_zuweisen(zeile);
  If j = -1 Then fehler := true
            Else CBQuote1.ItemIndex := j;

  Readln(f, zeile);
  Delete(zeile,1,20);
  i := Pos(' ', zeile);
  zeile := Copy(zeile,1,i-1);
  j := Farbe_zuweisen(zeile);
  If j = -1 Then fehler := true
            Else CBQuote2.ItemIndex := j;

  Readln(f, zeile);
  Delete(zeile,1,20);
  i := Pos(' ', zeile);
  zeile := Copy(zeile,1,i-1);
  j := Farbe_zuweisen(zeile);
  If j = -1 Then fehler := true
            Else CBurl.ItemIndex := j;

  Readln(f, zeile);
  Delete(zeile,1,20);
  i := Pos(' ', zeile);
  zeile := Copy(zeile,1,i-1);
  j := Farbe_zuweisen(zeile);
  If j = -1 Then fehler := true
            Else CBBold.ItemIndex := j;

  Readln(f, zeile);
  Delete(zeile,1,20);
  i := Pos(' ', zeile);
  zeile := Copy(zeile,1,i-1);
  j := Farbe_zuweisen(zeile);
  If j = -1 Then fehler := true
            Else CBItalic.ItemIndex := j;

  Readln(f, zeile);
  Delete(zeile,1,20);
  i := Pos(' ', zeile);
  zeile := Copy(zeile,1,i-1);
  j := Farbe_zuweisen(zeile);
  If j = -1 Then fehler := true
            Else CBBoldItalic.ItemIndex := j;

  Readln(f, zeile);
  Delete(zeile,1,20);
  i := Pos(' ', zeile);
  zeile := Copy(zeile,1,i-1);
  j := Farbe_zuweisen(zeile);
  If j = -1 Then fehler := true
            Else CBUnderline.ItemIndex := j;

  Readln(f, zeile);
  Delete(zeile,1,20);
  i := Pos(' ', zeile);
  zeile := Copy(zeile,1,i-1);
  j := Farbe_zuweisen(zeile);
  If j = -1 Then fehler := true
            Else CBBoldUnderline.ItemIndex := j;

  Readln(f, zeile);
  Delete(zeile,1,20);
  i := Pos(' ', zeile);
  zeile := Copy(zeile,1,i-1);
  j := Farbe_zuweisen(zeile);
  If j = -1 Then fehler := true
            Else CBItalicUnderline.ItemIndex := j;

  Readln(f, zeile);
  Delete(zeile,1,20);
  i := Pos(' ', zeile);
  zeile := Copy(zeile,1,i-1);
  j := Farbe_zuweisen(zeile);
  If j = -1 Then fehler := true
            Else CBBoldItalicUnderline.ItemIndex := j;

  Closefile(f);
  {$I+}
  IF (IOResult <> 0) or fehler Then Begin
    Assignfile(f, InstDir + '\golded\gedcolor.cfg');
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

    CBText.ItemIndex := Farbe_zuweisen('LGrey');
    CBHintergrund.ItemIndex := Farbe_zuweisen('Black');
    CBQuote1.ItemIndex := Farbe_zuweisen('LGreen');
    CBQuote2.ItemIndex := Farbe_zuweisen('Green');
    CBBold.ItemIndex := Farbe_zuweisen('White');
    CBItalic.ItemIndex := Farbe_zuweisen('White');
    CBBoldItalic.ItemIndex := Farbe_zuweisen('White');
    CBUnderline.ItemIndex := Farbe_zuweisen('White');
    CBBoldUnderline.ItemIndex := Farbe_zuweisen('White');
    CBItalicUnderline.ItemIndex := Farbe_zuweisen('White');
    CBBoldItalicUnderline.ItemIndex := Farbe_zuweisen('White');
  End;
end;

procedure TKonfiguration.Gruppen_lesen;
Var i, j   : Integer;
    f      : Textfile;
    zeile  : String;
    bstb   : Char;
//    fehler : LongBool;
//    cmd    : Array[0..2*MAX_PATH] of Char;
begin
  j := 1;
  LBGruppen.Items.Clear;
  LBAreasGrp.Items.Clear;
  LBAreasGrp2.Items.Clear;
  CBAreaGruppe.Items.Clear;

  // Golded Gruppen lesen
  Assignfile(f, InstDir + '\golded\goldgrp.cfg');
  {$I-}
  Reset(f);
  While not EOF(f) and (j < 26) Do Begin
    Readln(f, zeile);
    If Pos('AREASEP ', zeile) = 1 Then Begin
      i := Pos('"', zeile);
      Delete(zeile,1,i);
      i := Pos('"', zeile);
      zeile := Copy(zeile,1,i-1);
      If Pos('!Z "Archivareas', zeile) = 0 Then Begin
        LBGruppen.Items.Add(zeile);
        CBAreaGruppe.Items.Add(zeile);
        Inc(j); // max. 25 Gruppen
      End;
    End;
  End;

  Closefile(f);
  {$I+}
  IF IOResult <> 0 Then Begin
    Assignfile(f, InstDir + '\golded\goldgrp.cfg');
    Rewrite(f);
    Writeln(f, 'AREASEP !A "Fido Echo" A Echo');
    Writeln(f, 'AREASEP !Z "Archivareas" Z Echo');
    Closefile(f);
    LBGruppen.Items.Add('Fido Echo');
//    LBGruppen.Items.Add('Archivareas');  Archivareas fest drin lassen, nicht anzeigen
  End;

  // EolChg ausfuehren, um evtl. korrupte Husky Config zu reparieren
  // am 11.01.2003 auskommentiert, bug in hpt gefixed, nicht mehr nötig
//  lstrcpy(cmd, comspec);
//  lstrcat(cmd, PChar(InstDir+'\binkley\hpt\confrep.bat'));
//  DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 0, True);

  // Areas aus Husky Config lesen
  Assignfile(f, InstDir + '\binkley\hpt\config');
  {$I-}
  Reset(f);
  While not EOF(f) Do Begin
    Readln(f, zeile);
    If Pos('EchoArea ', zeile) = 1 Then Begin
      Delete(zeile,1,9);
      While zeile[1] = ' ' Do Delete(zeile,1,1); // falls noch mehr Leerzeichen da sind
      i := Pos(' ', zeile);
      LBAreasGrp.Items.Add(Copy(zeile,1,i-1));
      i := Pos(' -g ', zeile);
      Delete(zeile,1,i+3);
      bstb := zeile[1];
      i := Ord(bstb)-65;
      If (i < 0) or (i > (LBGruppen.Items.Count-1)) Then i := 0;
      LBAreasGrp2.Items.Add(LBGruppen.Items.Strings[i]);
    End;
  End;
  Closefile(f);
  {$I+}
  IOResult;

  LBGruppen.ItemIndex := 0;
  LBAreasGrp.ItemIndex := 0;
end;

procedure TKonfiguration.Gruppen_schreiben;
Var i, j, k : Integer;
    f, g    : Textfile;
    zeile   : String;
    zeile2  : String;
    bstb    : Char;
begin
  bstb := 'A';

  // Golded Gruppen schreiben
  Assignfile(f, InstDir + '\golded\goldgrp.cfg');
  {$I-}
  Rewrite(f);
  For i := 0 To (LBGruppen.Items.Count-1) Do Begin
    If i > 25 Then break; // max. 25 Gruppen (26. Gruppe ist Archivareas)
    If (LBGruppen.Items.Strings[i] <> 'Archivareas') Then Begin
      Write(f, 'AREASEP !' + bstb + ' "' + LBGruppen.Items.Strings[i]);
      Writeln(f, '" ' + bstb + ' Echo');
      Inc(bstb);
    End;
  End;
  Writeln(f, 'AREASEP !Z "Archivareas" Z Echo');
  Closefile(f);
  {$I+}
  IOResult;

  // Areas in Husky Config schreiben
  j := 0;
  Assignfile(f, InstDir + '\binkley\hpt\config');
  Assignfile(g, InstDir + '\binkley\hpt\config.tmp');
  {$I-}
  Reset(f);
  Rewrite(g);
  While not EOF(f) Do Begin
    Readln(f, zeile);
    If Pos('EchoArea ', zeile) = 1 Then Begin
      // Gruppe suchen
      For k := 0 To (LBGruppen.Items.Count-1) Do
        If LBGruppen.Items.Strings[k] = LBAreasGrp2.Items.Strings[j] Then break;

      // Gruppe schreiben
      i := Pos(' -g ', zeile);
      zeile2 := Copy(zeile,1,i+3) + Chr(k+65) + ' ';
      Delete(zeile,1,i+4);
      While (zeile[1] <> ' ') and (Length(zeile) > 1) Do Delete(zeile,1,1);
      While (zeile[1] = ' ') and (Length(zeile) > 1) Do Delete(zeile,1,1);
      zeile := zeile2 + zeile;
      Inc(j);
    End;
    Writeln(g, zeile);
  End;
  Closefile(f);
  Closefile(g);
  Erase(f);
  Rename(g, InstDir + '\binkley\hpt\config');
  {$I+}
  IOResult;
end;

procedure TKonfiguration.Footer_schreiben(fname: String);
Var f, g  : Textfile;
    zeile : String;
    i     : Integer;
begin
  Assignfile(f, InstDir + '\golded\' + fname);
  Assignfile(g, InstDir + '\golded\goldtpl.tmp');
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

  For i := 0 To (MFooter.Lines.Count-1) Do Writeln(g, MFooter.Lines.Strings[i]);

  If fname = 'netmail.tpl' Then Begin
    Writeln(g);
    Writeln(g, '--- @longpid @version');
  End;

  Writeln(g);
  Writeln(g, ';');
  Writeln(g, ';   End of template. Confused? Me too! :-)');
  Writeln(g, ';   ----------------------------------------------------------------------');

  Closefile(f);
  Closefile(g);
  Erase(f);
  Rename(g, InstDir + '\golded\' + fname);
  {$I+}
  IOResult;
end;

procedure TKonfiguration.passwoerter_und_link_aendern;
Var f, g        : Textfile;
    zeile       : String;
    i, j, k     : Integer;
    alt_NodeAka,
    neu_NodeAka : String[20];
    cmd         : Array[0..2*MAX_PATH] of Char;
    fehler      : LongBool;
begin
  alt_NodeAka := node_aka_dez[1] + ':' + alt_Aka.netz + '/' + alt_Aka.nodenr;
  neu_NodeAka := neu_Aka.aka;
  i := Pos('.', neu_NodeAka);
  If (i > 0) Then Delete(neu_NodeAka, i, Length(neu_NodeAka));

  // point.cdn
  If (alt_SessionPwd <> TBSessionPwd.Text)
   or (alt_PktPwd <> TBPktPwd.Text)
   or (alt_AreafixPwd <> TBAreafixPwd.Text)
   or (alt_FilemgrPwd <> TBFilemgrPwd.Text)
   or (alt_Aka.ip <> neu_Aka.ip)
   or (alt_Aka.aka <> neu_Aka.aka) Then Begin
    // Daten ändern
    Assignfile(f, InstDir + '\point.cdn');
    Assignfile(g, InstDir + '\pointcdn.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('PASSWORD=', zeile) = 1 Then
       zeile := 'PASSWORD=' + TBSessionPwd.Text;
      If Pos('PKTPW=', zeile) = 1 Then
       zeile := 'PKTPW=' + TBPktPwd.Text;
      If Pos('AREAFIXPW=', zeile) = 1 Then
       zeile := 'AREAFIXPW=' + TBAreafixPwd.Text;
      If Pos('TICKERPW=', zeile) = 1 Then
       zeile := 'TICKERPW=' + TBFilemgrPwd.Text;
      If Pos('POINTNUMBER=', zeile) = 1 Then
       zeile := 'POINTNUMBER=' + neu_Aka.pointnr;
      If Pos('NODE_AKA=', zeile) = 1 Then
       zeile := 'NODE_AKA=' + neu_Aka.nodenr;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\point.cdn');
    {$I+}
    IOResult;
  End;

  // golded.cfg
  Assignfile(f, InstDir + '\golded\golded.cfg');
  Assignfile(g, InstDir + '\golded\goldcfg.tmp');
  {$I-}
  Reset(f);
  Rewrite(g);
  While not EOF(f) Do Begin
    Readln(f, zeile);
    i := Pos(alt_Aka.aka, zeile);
    If i > 0 Then zeile := Copy(zeile,1,i-1) + neu_Aka.aka
                           + Copy(zeile,i+Length(alt_Aka.aka),Length(zeile));
    Writeln(g, zeile);
  End;
  Closefile(f);
  Closefile(g);
  Erase(f);
  Rename(g, InstDir + '\golded\golded.cfg');
  {$I+}
  IOResult;

  // password.lst
  If (alt_SessionPwd <> TBSessionPwd.Text)  or (alt_Aka.ip <> neu_Aka.ip) Then Begin
    Assignfile(f, InstDir + '\binkley\nodelist\password.lst');
    Assignfile(g, InstDir + '\binkley\nodelist\pwdlst.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    j := Length(alt_SessionPwd);
    k := Length(':'+alt_Aka.netz+'/'+alt_Aka.nodenr);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      i := Pos(alt_SessionPwd, zeile);
      If i > 0
       Then zeile := Copy(zeile,1,i-1) + TBSessionPwd.Text
                     + Copy(zeile,i+j,Length(zeile));
      i := Pos(':'+alt_Aka.netz+'/'+alt_Aka.nodenr, zeile);
      If i > 0 Then Begin
        zeile := Copy(zeile,1,i-1) + neu_Aka.netz + '/' + neu_Aka.nodenr
                 + Copy(zeile,i+k,Length(zeile));
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\nodelist\password.lst');
    {$I+}
    IOResult;
  End;

  // binkd.cfg
  If (alt_SessionPwd <> TBSessionPwd.Text) or (alt_Aka.ip <> neu_Aka.ip)
     or (alt_Aka.aka <> neu_Aka.aka) or dnsError Then Begin
    Assignfile(f, InstDir + '\binkley\binkd.cfg');
    Assignfile(g, InstDir + '\binkley\binkdcfg.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    j := Length(alt_SessionPwd);

    While not EOF(f) Do Begin
      Readln(f, zeile);

      If (neu_NodeAka <> alt_NodeAka) Then Begin
        // Monikas Zusatz-Eintrag ggf. löschen
        If (neu_NodeAka = '2:249/3110') Then Begin
          // Zusatz-Eintrag löschen
          If (Pos('node 2:249/3110 ', zeile) = 1) Then zeile := '[loeschen]';
        End;
      End;

      i := Pos(alt_NodeAka, zeile);
      If i > 0 Then Begin
        zeile := Copy(zeile,1,i-1) + neu_NodeAka
                 + Copy(zeile,i+Length(alt_NodeAka),Length(zeile));
        If dnsError and (Pos('node ', zeile) = 1) Then Begin
          If (Pos('.', neu_Aka.ip) = 0) Then neu_Aka.ip := 'incorrect.ip';
          i := i + Length(neu_NodeAka) - 1;
          zeile := Copy(zeile,1,i) + ' ' + neu_Aka.ip + ' ' + TBSessionPwd.Text;
        End;
      End;

      i := Pos(alt_SessionPwd, zeile);
      If i > 0 Then zeile := Copy(zeile,1,i-1) + TBSessionPwd.Text
                             + Copy(zeile,i+j,Length(zeile));

      i := Pos(alt_Aka.ip, zeile);
      If i > 0 Then zeile := Copy(zeile,1,i-1) + neu_Aka.ip
                             + Copy(zeile,i+Length(alt_Aka.ip),Length(zeile));
      If (zeile <> '[loeschen]') Then Writeln(g, zeile);
    End;

    If ((neu_NodeAka <> alt_NodeAka) and (alt_NodeAka = '2:249/3110')) Then Begin
      // Monikas Zusatz-Eintrag hinzufügen, wenn von Monika zu anderem Node
      // gewechselt wird
      If (neu_NodeAka <> '2:249/3110') Then Begin
        Writeln(g, 'node 2:249/3110 monisbox.dyndns.org;bbsdd.de;monis.yi.org -');
      End;
    End;

    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\binkd.cfg');
    {$I+}
    IOResult;
  End;

  // iproute.cfg
  If (neu_NodeAka <> alt_NodeAka) Then Begin
    Assignfile(f, InstDir + '\binkley\nodelist\iproute.cfg');
    Assignfile(g, InstDir + '\binkley\nodelist\iproute.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);

    While not EOF(f) Do Begin
      Readln(f, zeile);

      i := Pos(alt_NodeAka, zeile);
      If i > 0 Then zeile := Copy(zeile,1,i-1) + neu_NodeAka
                             + Copy(zeile,i+Length(alt_NodeAka),Length(zeile));
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\nodelist\iproute.cfg');
    {$I+}
    IOResult;

    // iprouted.exe aufrufen
    lstrcpy(cmd, PChar(InstDir+'\binkley\nodelist\iprouted.exe'));
    DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 1, True);
  End;

  // adrmacro.cfg
  If (alt_AreafixPwd <> TBAreafixPwd.Text)
   or (alt_FilemgrPwd <> TBFilemgrPwd.Text)
   or (alt_Aka.aka <> neu_Aka.aka) Then Begin
    Assignfile(f, InstDir + '\golded\adrmacro.cfg');
    Assignfile(g, InstDir + '\golded\adrmtmp.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    j := Length(alt_SessionPwd);
    k := Length(':'+alt_Aka.netz+'/'+alt_Aka.nodenr);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      i := Pos(alt_AreafixPwd, zeile);
      If i > 0 Then Begin
        zeile := Copy(zeile,1,i-1) + TBAreafixPwd.Text
                 + Copy(zeile,i+j,Length(zeile));
        i := Pos(':'+alt_Aka.netz+'/'+alt_Aka.nodenr, zeile);
        If i > 0 Then Begin
          zeile := Copy(zeile,1,i) + neu_Aka.netz + '/' + neu_Aka.nodenr
                   + Copy(zeile,i+k,Length(zeile));
        End;
      End;
      i := Pos(alt_FilemgrPwd, zeile);
      If i > 0 Then Begin
        zeile := Copy(zeile,1,i-1) + TBFilemgrPwd.Text
                 + Copy(zeile,i+j,Length(zeile));
        i := Pos(':'+alt_Aka.netz+'/'+alt_Aka.nodenr, zeile);
        If i > 0 Then Begin
          zeile := Copy(zeile,1,i) + neu_Aka.netz + '/' + neu_Aka.nodenr
                   + Copy(zeile,i+k,Length(zeile));
        End;
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\golded\adrmacro.cfg');
    {$I+}
    IOResult;
  End;

  // Husky config
  If (alt_PktPwd <> TBPktPwd.Text)
   or (alt_AreafixPwd <> TBAreafixPwd.Text)
   or (alt_FilemgrPwd <> TBFilemgrPwd.Text)
   or (alt_Aka.nodename <> neu_Aka.nodename)
   or ((':'+alt_Aka.netz+'/'+alt_Aka.nodenr) <> (':'+neu_Aka.netz+'/'+neu_Aka.nodenr))
   or (alt_Aka.aka <> neu_Aka.aka) Then Begin
    Assignfile(f, InstDir + '\binkley\hpt\config');
    Assignfile(g, InstDir + '\binkley\hpt\config.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    j := Length(alt_Aka.aka);
    k := Length(':'+alt_Aka.netz+'/'+alt_Aka.nodenr);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('Link '+alt_Aka.nodename, zeile) > 0 Then zeile := 'Link ' + neu_Aka.nodename;

      i := Pos(alt_Aka.aka, zeile);
      If i > 0 Then zeile := Copy(zeile,1,i-1) + neu_Aka.aka
                             + Copy(zeile,i+j,Length(zeile));
      i := Pos(':'+alt_Aka.netz+'/'+alt_Aka.nodenr, zeile);
      If i > 0 Then zeile := Copy(zeile,1,i) + neu_Aka.netz + '/' + neu_Aka.nodenr
                             + Copy(zeile,i+k,Length(zeile));

      If Pos('Password ', zeile) > 0 Then zeile := 'Password ' + TBPktPwd.Text;
      If Pos('pktpwd ', zeile) > 0 Then zeile := 'pktpwd ' + TBPktPwd.Text;
      If Pos('areafixpwd ', zeile) > 0 Then zeile := 'areafixpwd ' + TBAreafixPwd.Text;
      If Pos('filefixpwd ', zeile) > 0 Then zeile := 'filefixpwd ' + TBFilemgrPwd.Text;
      If Pos('ticpwd ', zeile) > 0 Then zeile := 'ticpwd ' + TBFilemgrPwd.Text;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\hpt\config');
    {$I+}
    IOResult;
  End;

  // goldarea.bat
  If (alt_AreafixPwd <> TBAreafixPwd.Text)
   or (alt_FilemgrPwd <> TBFilemgrPwd.Text)
   or (alt_Aka.aka <> neu_Aka.aka) Then Begin
    Assignfile(f, InstDir + '\binkley\hpt\goldarea.bat');
    Assignfile(g, InstDir + '\binkley\hpt\gareabat.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    j := Length(alt_SessionPwd);
    k := Length(':'+alt_Aka.netz+'/'+alt_Aka.nodenr);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If Pos('areafix.chg', zeile) > 0 Then Begin
        i := Pos(alt_AreafixPwd, zeile);
        If i > 0 Then zeile := Copy(zeile,1,i-1) + TBAreafixPwd.Text
                               + Copy(zeile,i+j,Length(zeile));
        i := Pos(':'+alt_Aka.netz+'/'+alt_Aka.nodenr, zeile);
        If i > 0 Then zeile := Copy(zeile,1,i) + neu_Aka.netz+'/'+neu_Aka.nodenr
                               + Copy(zeile,i+k,Length(zeile));
      End;
      If Pos('filefix.chg', zeile) > 0 Then Begin
        i := Pos(alt_FilemgrPwd, zeile);
        If i > 0 Then zeile := Copy(zeile,1,i-1) + TBFilemgrPwd.Text
                               + Copy(zeile,i+j,Length(zeile));
        i := Pos(':'+alt_Aka.netz+'/'+alt_Aka.nodenr, zeile);
        If i > 0 Then zeile := Copy(zeile,1,i) + neu_Aka.netz+'/'+neu_Aka.nodenr
                               + Copy(zeile,i+k,Length(zeile));
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\hpt\goldarea.bat');
    {$I+}
    IOResult;
  End;

  // poll.bat
  If (alt_Aka.nodehex <> neu_Aka.nodehex) Then Begin
    Assignfile(f, InstDir + '\binkley\poll.bat');
    Assignfile(g, InstDir + '\binkley\poll.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      While (Pos(alt_Aka.nodehex, zeile) > 0) Do Begin
        i := Pos(alt_Aka.nodehex, zeile);
        zeile := Copy(zeile,1,i-1) + neu_Aka.nodehex
                 + Copy(zeile,i+Length(alt_Aka.nodehex),Length(zeile));
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\poll.bat');
    {$I+}
    IOResult;
  End;

  // pollman.bat
  If (alt_Aka.nodehex <> neu_Aka.nodehex) Then Begin
    Assignfile(f, InstDir + '\binkley\pollman.bat');
    Assignfile(g, InstDir + '\binkley\pollman.tmp');
    {$I-}
    Reset(f);
    Rewrite(g);
    While not EOF(f) Do Begin
      Readln(f, zeile);
      While (Pos(alt_Aka.nodehex, zeile) > 0) Do Begin
        i := Pos(alt_Aka.nodehex, zeile);
        zeile := Copy(zeile,1,i-1) + neu_Aka.nodehex
                 + Copy(zeile,i+Length(alt_Aka.nodehex),Length(zeile));
      End;
      Writeln(g, zeile);
    End;
    Closefile(f);
    Closefile(g);
    Erase(f);
    Rename(g, InstDir + '\binkley\pollman.bat');
    {$I+}
    IOResult;
  End;
end;

procedure TKonfiguration.Daten_lesen;
Var f       : Textfile;
    zeile   : String;
    i       : Integer;
    meldung : String;
begin
  alt_Aka.pointnr := '';
  alt_SessionPwd := '';
  alt_PktPwd := '';
  alt_AreafixPwd := '';
  alt_FilemgrPwd := '';

  Assignfile(f, InstDir + '\point.cdn');
  {$I-}
  Reset(f);
  While not EOF(f) Do Begin
    Readln(f, zeile);
    zeile := UpperCase(zeile);
    If Pos('POINTNUMBER=', zeile) = 1 Then alt_Aka.pointnr := Copy(zeile,13,5);
    If Pos('PASSWORD=', zeile) = 1 Then alt_SessionPwd := Copy(zeile,10,8);
    If Pos('AREAFIXPW=', zeile) = 1 Then alt_AreafixPwd := Copy(zeile,11,8);
    If Pos('TICKERPW=', zeile) = 1 Then alt_FilemgrPwd := Copy(zeile,10,8);
    If Pos('PKTPW=', zeile) = 1 Then alt_PktPwd := Copy(zeile,7,8);
  End;
  Closefile(f);
  {$I+}
  noChange := IOResult <> 0; // true, wenn Fehler -> keine Änderung der Daten
                             // möglich!
  If (alt_Aka.pointnr = '') or (alt_SessionPwd = '') or (alt_PktPwd = '')
     or (alt_AreafixPwd = '') or (alt_FilemgrPwd = '') Then noChange := True;

  If not noChange Then Begin
    alt_Aka.netz := IntToStr(netznummer);
    alt_Aka.nodenr := nodenummer;
    alt_Aka.aka := node_aka_dez[1] + ':' + alt_Aka.netz + '/' + alt_Aka.nodenr
                   + '.' + alt_Aka.pointnr;
  End;

  If noChange Then Application.MessageBox(
   PChar(Format(s[0210], [InstDir+'\point.cdn'])), sprache_Fehler, MB_Ok);

  TBaka.Text := alt_Aka.aka;
  TBSessionPwd.Text := alt_SessionPwd;
  TBPktPwd.Text := alt_PktPwd;
  TBAreafixPwd.Text := alt_AreafixPwd;
  TBFilemgrPwd.Text := alt_FilemgrPwd;

  // IP / Dyn. DNS lesen
  Assignfile(f, InstDir + '\binkley\binkd.cfg');
  {$I-}
  Reset(f);
  i := 0;
  While not EOF(f) Do Begin
    Readln(f, zeile);
    i := Pos(':'+alt_Aka.netz+'/'+alt_Aka.nodenr+' ', zeile);
    If (i > 0) Then break;
  End;
  Delete(zeile,1,i+Length(':'+alt_Aka.netz+'/'+alt_Aka.nodenr+' ')-1);
  While (Length(zeile) > 1) and (zeile[1] = ' ') Do Delete(zeile,1,1);
  i := Pos(' ', zeile);
  alt_Aka.ip := Copy(zeile,1,i-1);
  If (i = 0) or (alt_Aka.ip = 'incorrect.ip') Then Begin
    If (alt_Aka.ip <> 'incorrect.ip') Then dnsError := true;
    meldung := s[0293];
    Application.MessageBox(PChar(meldung), sprache_Fehler, MB_OK);
    Reiter.ActivePage := Sheet_Daten;
  End;
  TBip.Text := alt_Aka.ip;
  Closefile(f);
  {$I+}
  IOResult;

  // Node Name lesen
  Assignfile(f, InstDir + '\binkley\hpt\config');
  {$I-}
  Reset(f);
  While not EOF(f) Do Begin
    Readln(f, zeile);
    If (Pos('Link ', zeile) = 1) Then Begin
      Delete(zeile,1,Length('Link '));
      While (Length(zeile) > 1) and (zeile[1] = ' ') Do Delete(zeile,1,1);
      While (Length(zeile) > 1) and (zeile[Length(zeile)] = ' ') Do
       Delete(zeile,Length(zeile),1);
      alt_Aka.nodename := zeile;
    End;
    If (Pos('ourAka ', zeile) = 1) and (Pos(alt_Aka.aka, zeile) > 0) Then break;
  End;
  TBnodename.Text := alt_Aka.nodename;
  Closefile(f);
  {$I+}
  IOResult;

  // Footer lesen
  MFooter.Lines.Clear;
  Assignfile(f, InstDir + '\golded\golded.tpl');
  {$I-}
  Reset(f);
  While not EOF(f) Do Begin
    Readln(f, zeile);
    If (Pos('@Quote ', zeile) = 1) or (zeile = '@Quote') Then break;
  End;
  If Pos('@Quote', zeile) = 0 Then Exit;
  While not EOF(f) Do Begin
    Readln(f, zeile);
    If (zeile <> '') and (zeile[1] <> ';') Then MFooter.Lines.Add(zeile);
  End;
  Closefile(f);
  {$I+}
  IOResult;

  If MFooter.Lines.Count = 0 Then Begin
    MFooter.Lines.Add('Gruss,');
    MFooter.Lines.Add('@CFName');
  End;
end;

procedure TKonfiguration.FormShow(Sender: TObject);
Var i: Integer;
begin
  autoPollen.Checked := (autoPoll > 0); // < 0 bedeutet deaktiviert
  If autoPoll > 0 Then MinutenAutoPoll.Position := autoPoll
                  Else MinutenAutoPoll.Position := -autoPoll;

  infoProvider.Visible := internet OR lokal_netz; // nur Auswahl möglich, wenn
  lstProvider.Visible := internet OR lokal_netz;  // Fido-over-Internet

  dnsError := false; // erstmal auf false initialisieren

  If internet OR lokal_netz Then Begin
    i := get_Anzahl_Verbindungen;
    GetEntries(i);
    lstProvider.ItemIndex := 0;
    If otherProvider Then lstProvider.ItemIndex := (lstProvider.Items.Count-2)
    Else If lokal_netz Then lstProvider.ItemIndex := (lstProvider.Items.Count-1)
    Else If i > 0 Then Begin // wenn Provider gefunden
      For i := 1 to lstProvider.Items.Count Do
        If lstProvider.Items.Strings[i-1] = Verbindung_Name Then Begin
          lstProvider.ItemIndex := (i-1); // den akt. gewählten selektieren
          break;
        End;
    End;
  End;

  // Golded Farbkonfiguration lesen
  GoldedFarben_lesen;

  // Gruppen lesen
  Gruppen_lesen;
  LBAreasGrpClick(Sender);
  CBdel.Enabled := LBGruppen.Items.Count > 1;

  // Golded Adressmakros lesen
  Adressmakros_lesen;

  // Daten lesen (AKA, Passwörter, Footer)
  Daten_lesen;

  // Golded Anzahl Zeilen lesen
  Anzahl_Zeilen_lesen;
end;

procedure TKonfiguration.GetEntries(anzahl: Integer);
var
  bufsize: Longint;
  numEntries: Longint;
  entries, p: LPRasEntryName;
  x: Integer;
  res: Integer;
begin
  lstProvider.Items.Clear;

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
          lstProvider.Items.Add(p^.szEntryName);
          Inc(p);
          end;
        end;
      end;
//    else
//      ShowMessage('RasEnumEntries failed.');
    FreeMem(entries);
  End;

  lstProvider.Items.Add(s[0085]);
  lstProvider.Items.Add(s[0254]);
  lstProvider.ItemIndex := 0;
end;


procedure TKonfiguration.FormCreate(Sender: TObject);
Var min, i : Integer;
    DC     : hDc;
begin
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

  min := autoPoll;
  If min < 0 Then min := -min;

  autoPollen.Caption := Format(s[0167], [IntToStr(min)]);
  If sprache <> 'deutsch' Then Begin
    Sheet_AutoPoll.Caption := s[0171];
    Sheet_Farben.Caption := s[0172];
    Sheet_Gruppen.Caption := s[0173];
    Sheet_Adressmakros.Caption := s[0174];
    Sheet_Daten.Caption := s[0175];
    Sheet_Sonstiges.Caption := s[0241];
    Sheet_History.Caption := s[0176];
    Sheet_Updates.Caption := s[0177];
    InfoAutoPoll.Caption := s[0168];
    InfoProvider.Caption := s[0169];
    LText.Caption := s[0178];
    LQuote1.Caption := s[0179] + ' 1';
    LQuote2.Caption := s[0179] + ' 2';
//    Lurl.Caption := s[];
    LHintergrund.Caption := s[0180];
    LBold.Caption := s[0198];
    LItalic.Caption := s[0199];
    LBoldItalic.Caption := s[0198] + ' ' + s[0199];
    LUnderline.Caption := s[0200];
    LBoldUnderline.Caption := s[0198]+ ' ' + s[0200];
    LItalicUnderline.Caption := s[0199]+ ' ' + s[0200];
    LBoldItalicUnderline.Caption := s[0198] + ' ' + s[0199]+ ' ' + s[0200];

    For i := 0 To 15 Do CBText.Items.Strings[i] := s[0181+i];
    For i := 0 To 15 Do CBQuote1.Items.Strings[i] := s[0181+i];
    For i := 0 To 15 Do CBQuote2.Items.Strings[i] := s[0181+i];
    For i := 0 To 15 Do CBurl.Items.Strings[i] := s[0181+i];
    For i := 0 To 6 Do CBHintergrund.Items.Strings[i] := s[0181+i];
    CBHintergrund.Items.Strings[7] := s[0189];

    For i := 0 To 15 Do CBBold.Items.Strings[i] := s[0181+i];
    For i := 0 To 15 Do CBItalic.Items.Strings[i] := s[0181+i];
    For i := 0 To 15 Do CBBoldItalic.Items.Strings[i] := s[0181+i];
    For i := 0 To 15 Do CBUnderline.Items.Strings[i] := s[0181+i];
    For i := 0 To 15 Do CBBoldUnderline.Items.Strings[i] := s[0181+i];
    For i := 0 To 15 Do CBItalicUnderline.Items.Strings[i] := s[0181+i];
    For i := 0 To 15 Do CBBoldItalicUnderline.Items.Strings[i] := s[0181+i];

    LAdrMakroErklaerung.Caption := s[0201];

    CBabbruch.Caption := s[0090];

    LWarnung.Caption := s[0202];
    Laka.Caption := s[0203] + ' (AKA)';
    LAdrWarnung.Caption := s[0204];
    LSessionPwd.Caption := s[0205] + '-' + s[0206];
    LPktPwd.Caption := 'Pkt-' + s[0206];
    LAreafixPwd.Caption := s[0207] + '-' + s[0206];
    LFilemgrPwd.Caption := s[0208] + '-' + s[0206];
    LFooter.Caption := s[0209];
    Lnodename.Caption := s[0259];
    Lip.Caption := s[0260];

    LGruppen.Caption := s[0216];
    CBneu.Caption := s[0217];
    CBdel.Caption := s[0218];
    CBchange.Caption := s[0219];
    LAreasGrp.Caption := s[0220];
    LGrpArea.Caption := s[0221];

    CBLogfile.Caption := s[0117];
    LgoldedZeilen.Caption := s[0252];
    LZeilenInfo.Caption := s[0258];

    Konfiguration.Caption := ' ' + s[0233];
  End;

  InfoAutoPoll.Left := ((MinutenAutoPoll.Width - InfoAutoPoll.Width) DIV 2);

  HistoryOeffnen;

  MUpdates.Lines.Text := s[0197] + Chr(13) + Chr(13)
                         + 'www.fido-deluxe.de.vu' + Chr(13)
                         + 'www.fidodeluxe.de.vu' + Chr(13) + Chr(13)
                         + 'eMail: m.haase@gmx.net';

end;

procedure TKonfiguration.MinutenAutoPollChange(Sender: TObject);
begin
  autoPollen.Caption := Format(s[0167], [IntToStr(MinutenAutoPoll.Position)]);
end;

procedure TKonfiguration.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//  Hauptmenue.Enabled := true;
  Hauptmenue.SetFocus;
end;

procedure TKonfiguration.HistoryOeffnen;
var f           : Textfile;
    Buf         : Array[1..31744] of Char; // 31K buffer
    zeile       : String;
begin
  LBHistory.Items.Clear;

  Assignfile(f, InstDir + '\whatsnew.txt');
  System.SetTextBuf(f, Buf); // dem Logfile einen Buffer zuweisen
  {$I-} Reset(f); {$I+}
  IF IOResult <> 0 Then Exit;

  While not EOF(f) Do Begin
    Readln(f, zeile);
    LBHistory.Items.Add(zeile);
  End;
  Closefile(f);

  Application.ProcessMessages;
  LBHistory.ItemIndex := 0;
end;

procedure TKonfiguration.TBSessionPwdKeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := UpCase(Key);
end;

procedure TKonfiguration.TBAreafixPwdKeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := UpCase(Key);
end;

procedure TKonfiguration.TBPktPwdKeyPress(Sender: TObject; var Key: Char);
begin
  Key := UpCase(Key);
end;

procedure TKonfiguration.TBFilemgrPwdKeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := UpCase(Key);
end;

procedure TKonfiguration.LBAreasGrpClick(Sender: TObject);
var i, j: Integer;
begin
  i := LBAreasGrp.ItemIndex;
  If i < 0 Then Exit; // keine Areas in der config definiert
  For j := 0 To (CBAreaGruppe.Items.Count-1) Do
   If CBAreaGruppe.Items.Strings[j] = LBAreasGrp2.Items.Strings[i] Then break;
  If j <= (CBAreaGruppe.Items.Count-1) Then CBAreaGruppe.ItemIndex := j;
end;

procedure TKonfiguration.LBAreasGrpKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  LBAreasGrpClick(Sender);
end;

procedure TKonfiguration.CBAreaGruppeChange(Sender: TObject);
var i: Integer;
begin
  i := LBAreasGrp.ItemIndex;
  LBAreasGrp2.Items.Strings[i] := CBAreaGruppe.Items.Strings[CBAreaGruppe.ItemIndex];
end;

procedure TKonfiguration.CBchangeClick(Sender: TObject);
Var i       : Integer;
    name    : String;
    eingabe : String;
begin
  i := LBGruppen.ItemIndex;
  name := LBGruppen.Items.Strings[i];
  eingabe := InputBox(s[0222], s[0223], name);
  If eingabe <> '' Then LBGruppen.Items.Strings[i] := eingabe;

  // Areas neuen Gruppennamen zuordnen
  For i := 0 To (LBAreasGrp2.Items.Count-1) Do
    If LBAreasGrp2.Items.Strings[i] = name Then
      LBAreasGrp2.Items.Strings[i] := eingabe;

  LBAreasGrpClick(Sender);
end;

procedure TKonfiguration.CBdelClick(Sender: TObject);
Var i    : Integer;
    name : String;
begin
  If LBGruppen.Items.Count <= 1 Then Exit;

  i := LBGruppen.ItemIndex;
  name := LBGruppen.Items.Strings[i];
  LBGruppen.Items.Delete(i);
  CBAreaGruppe.Items.Delete(i);

  // Areas in der gelöschten Gruppe nun der ersten vorhandenen Gruppe zuordnen
  For i := 0 To (LBAreasGrp2.Items.Count-1) Do
    If LBAreasGrp2.Items.Strings[i] = name Then
      LBAreasGrp2.Items.Strings[i] := LBGruppen.Items.Strings[0];

  CBdel.Enabled := LBGruppen.Items.Count > 1;
  LBAreasGrpClick(Sender);
end;

procedure TKonfiguration.CBneuClick(Sender: TObject);
Var eingabe: String;
begin
  eingabe := InputBox(s[0222], s[0223], '');
  If eingabe = '' Then Exit;
  LBGruppen.Items.Add(eingabe);
  CBAreaGruppe.Items.Add(eingabe);

  CBdel.Enabled := LBGruppen.Items.Count > 1;
  LBAreasGrpClick(Sender);
end;

procedure TKonfiguration.UpDownButtonDownClick(Sender: TObject);
var i    : Integer;
    temp : String;
begin
  i := LBGruppen.ItemIndex;
  If i >= (LBGruppen.Items.Count-1) Then Exit; // tiefer gehts nicht

  temp := LBGruppen.Items.Strings[i];
  LBGruppen.Items.Strings[i] := LBGruppen.Items.Strings[i+1];
  LBGruppen.Items.Strings[i+1] := temp;
  LBGruppen.ItemIndex := i+1; // damit die gleiche Area weiter selektiert ist
end;

procedure TKonfiguration.UpDownButtonUpClick(Sender: TObject);
var i    : Integer;
    temp : String;
begin
  i := LBGruppen.ItemIndex;
  If i < 1 Then Exit; // höher gehts nicht

  temp := LBGruppen.Items.Strings[i];
  LBGruppen.Items.Strings[i] := LBGruppen.Items.Strings[i-1];
  LBGruppen.Items.Strings[i-1] := temp;
  LBGruppen.ItemIndex := i-1; // damit die gleiche Area weiter selektiert ist
end;

procedure TKonfiguration.CBLogfileClick(Sender: TObject);
begin
//  Konfiguration.Hide;
  frmLogfile.ShowModal;
end;

procedure TKonfiguration.Anzahl_Zeilen_lesen;
Var anzahlZeilen : Integer;
    gefunden     : Boolean;
    f            : Textfile;
    zeile        : String;
begin
  anzahlZeilen := 0;
  gefunden := False;

  Assignfile(f, InstDir + '\golded\golded.cfg');
  {$I-}
  Reset(f);
  While not EOF(f) and not gefunden Do Begin
    Readln(f, zeile);
    If (Pos('SCREENMAXROW ', zeile) = 1) Then Begin
      gefunden := True;
      Delete(zeile,1,Length('SCREENMAXROW '));
      While (Length(zeile) > 1) and (zeile[1] = ' ') Do Delete(zeile,1,1);
      While (Length(zeile) > 1) and (zeile[Length(zeile)] = ' ') Do
       Delete(zeile,Length(zeile),1);
      anzahlZeilen := StrToInt(zeile);
    End;
  End;
  Closefile(f);

  If (anzahlZeilen < 25) or (anzahlZeilen > 100) Then anzahlZeilen := 25;

  TBzeilenGolded.Text := IntToStr(anzahlZeilen);
end;

procedure TKonfiguration.Anzahl_Zeilen_schreiben;
Var anzahlZeilen : Integer;
    f, g         : Textfile;
    zeile        : String;
    gefunden     : Boolean;
begin
  anzahlZeilen := StrToInt(TBzeilenGolded.Text);
  If (anzahlZeilen < 25) or (anzahlZeilen > 100) Then Exit;

  Assignfile(f, InstDir + '\golded\golded.cfg');
  Assignfile(g, InstDir + '\golded\golded.tmp');
  {$I-}
  Reset(f);
  Rewrite(g);
  While not EOF(f) Do Begin
    Readln(f, zeile);
    If (Pos('SCREENMAXROW ', zeile) = 1) Then
     zeile := 'SCREENMAXROW ' + IntToStr(anzahlZeilen);
    Writeln(g, zeile);
  End;

  Closefile(f);
  Closefile(g);
  Erase(f);
  Rename(g, InstDir + '\golded\golded.cfg');
  {$I+}
  IOResult;

  // in rungold.bat mode con aktualisieren zum Anpassen der Fenstergroesse
  // an die eingestellte Zeilenanzahl
  Assignfile(f, InstDir + '\golded\rungold.bat');
  Assignfile(g, InstDir + '\golded\rungold.tmp');
  {$I-}
  Reset(f);
  Rewrite(g);
  gefunden := False;
  While not EOF(f) Do Begin
    Readln(f, zeile);
    If Pos('mode con ', zeile) = 1 Then Begin
      gefunden := True; // nur einmal einfuegen!
      zeile := 'mode con lines=' + IntToStr(anzahlZeilen) + ' cols=80';
    End;
    If (Pos('geddjg.exe', zeile) > 0) and not gefunden Then Begin
      gefunden := True; // nur einmal einfuegen!
      Writeln(g, 'mode con lines=' + IntToStr(anzahlZeilen) + ' cols=80');
    End;
    Writeln(g, zeile);
  End;
  Closefile(f);
  Closefile(g);
  Erase(f);
  Rename(g, InstDir + '\golded\rungold.bat');
  {$I+}
  IOResult;
end;

procedure TKonfiguration.lstProviderChange(Sender: TObject);
begin
  forced := (Verbindung_Name = s[0254]);
end;

end.
