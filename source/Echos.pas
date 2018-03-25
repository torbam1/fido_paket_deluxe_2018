unit Echos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, InfoBtn, CheckLst;

type
  Str5 = String[5];
  TEchoVerwaltung = class(TForm)
    alleEchos: TListBox;
    aktiveEchos: TListBox;
    anzahlEchos: TLabel;
    anzahlEchosAktiv: TLabel;
    suchbegriff: TEdit;
    CBsuchen: TButton;
    CBweitersuchen: TInfoButton;
    LSuchbegriff: TLabel;
    CBok: TInfoButton;
    CBabbruch: TInfoButton;
    Erklaerung: TLabel;
    CBfidoEchos: TInfoButton;
    LEchos: TLabel;
    DiffListe: TListBox;
    CBfidoInternational: TInfoButton;
    CBlokaleEchos: TInfoButton;
    CBregionaleEchos: TInfoButton;
    CBalleBestellen: TButton;
    procedure Tastendruecke(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure alleEchosDblClick(Sender: TObject);
    procedure aktiveEchosDblClick(Sender: TObject);
    procedure CBsuchenClick(Sender: TObject);
    procedure suchbegriffKeyPress(Sender: TObject; var Key: Char);
    procedure CBweitersuchenClick(Sender: TObject);
    procedure CBabbruchClick(Sender: TObject);
    procedure CBokClick(Sender: TObject);
    procedure echoAnAbBestellen(Var Diffliste: TMemo);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CBfidoEchosClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Echos_lesen(name: String; var anzahl_str: Str5);
    procedure CBfidoInternationalClick(Sender: TObject);
    procedure CBlokaleEchosClick(Sender: TObject);
    procedure CBregionaleEchosClick(Sender: TObject);
    procedure CBalleBestellenClick(Sender: TObject);
  private
    { Private-Deklarationen}
  public
    { Public-Deklarationen}
  end;

var
  EchoVerwaltung      : TEchoVerwaltung;
  anzahlEchosBestellt : Integer;
  veraendert          : Boolean;

implementation

uses HMenue, Background, fpd_language, Output;

var altePosition     : Integer = -1;
    alterSuchbegriff : String;

{$R *.DFM}

procedure TEchoVerwaltung.alleEchosDblClick(Sender: TObject);
var i, j       : Integer;
    anzahl_str : String[5];
    EchoNeu    : String;
    EchoAlt    : String;
    fehler     : LongBool;
    cmd        : Array[0..2*MAX_PATH] of Char;
begin
  // nur Echotag ohne Beschreibung des neu anzubestellenden Echos
  j := Pos(' ', alleEchos.Items[alleEchos.ItemIndex]);
  EchoNeu := Copy(alleEchos.Items[alleEchos.ItemIndex], 1, j-1);

  For i := 0 to (aktiveEchos.Items.Count-1) Do Begin
    j := Pos(' ', aktiveEchos.Items[i]);
    EchoAlt := Copy(aktiveEchos.Items[i], 1, j-1); // nur Echotag ohne Beschreibung
    If EchoAlt = EchoNeu Then Exit;
  End;

  If (EchoNeu = 'HARDROCK.GER') Then Begin
    Application.MessageBox(PChar(s[0251]), sprache_Hinweis, MB_OK);

    // Rules der hardrock.ger als Netmail an den Point schreiben
    lstrcpy(cmd, PChar(InstDir+'\binkley\hpt\hpt post -nf "Michael Haase" '
            + '-nt "' + pointname + '" -af "2:2457/2" -at "' + point_aka
            + '" -s "Rules der HARDROCK.GER" -f "pvt" '
            + InstDir+'\hardro_g.rul'));
    DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 0, False);

    Exit;
  End;

  aktiveEchos.Items.Add(alleEchos.Items[alleEchos.ItemIndex]);
  Inc(anzahlEchosBestellt);
  Str(anzahlEchosBestellt, anzahl_str);
  anzahlEchosAktiv.Caption := Format(s[0128], [anzahl_str]);
  veraendert := true;
end;

procedure TEchoVerwaltung.aktiveEchosDblClick(Sender: TObject);
var anzahl_str: String[5];
begin
  aktiveEchos.Items.Delete(aktiveEchos.ItemIndex);
  Dec(anzahlEchosBestellt);
  Str(anzahlEchosBestellt, anzahl_str);
  anzahlEchosAktiv.Caption := Format(s[0128], [anzahl_str]);
  veraendert := true;
end;

procedure TEchoVerwaltung.CBsuchenClick(Sender: TObject);
var i: Integer;
begin
  If suchbegriff.Text = '' Then Exit; // kein Suchbegriff angegeben

  For i := 0 to (alleEchos.Items.Count-1) Do
    If Pos(UpperCase(suchbegriff.Text), UpperCase(alleEchos.Items.Strings[i])) > 0 Then Begin
      alleEchos.ItemIndex := i;
      altePosition := i;
      Exit;
    End;

  If (i >= alleEchos.Items.Count) Then
  Begin
    altePosition := -1;
    Application.MessageBox(PChar(s[0129]), PChar(s[0130]), MB_OK);
    Exit;
  End;
end;

procedure TEchoVerwaltung.suchbegriffKeyPress(Sender: TObject;
  var Key: Char);
begin
  If Key = Chr(13) Then CBsuchenClick(Sender);
end;

procedure TEchoVerwaltung.CBweitersuchenClick(Sender: TObject);
var i    : Integer;
    ende : Integer;
begin
  If suchbegriff.Text = '' Then Exit; // kein Suchbegriff angegeben

  If suchbegriff.Text <> alterSuchbegriff Then Begin
    altePosition := -2;
    alterSuchbegriff := suchbegriff.Text;
  End;

  For i := (alleEchos.ItemIndex+1) to (alleEchos.Items.Count-1) Do
    If Pos(UpperCase(suchbegriff.Text), UpperCase(alleEchos.Items.Strings[i])) > 0 Then Begin
      alleEchos.ItemIndex := i;
      If altePosition < 0 Then altePosition := i;
      Exit;
    End;

  If altePosition = -2 Then ende := alleEchos.Items.Count-1
                       Else ende := altePosition-1;
  For i := 0 to ende Do
    If Pos(UpperCase(suchbegriff.Text), UpperCase(alleEchos.Items.Strings[i])) > 0 Then Begin
      alleEchos.ItemIndex := i;
      If altePosition < 0 Then altePosition := i;
      Exit;
    End;

  If (altePosition < 0) Then
    Application.MessageBox(PChar(s[0129]), PChar(s[0130]), MB_OK)
  Else Application.MessageBox(PChar(s[0131]), PChar(s[0130]), MB_OK);
end;

procedure TEchoVerwaltung.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var meldung : String;
    info    : String;
begin
  If veraendert Then Begin
    meldung := s[0132];
    info := s[0050];

    If Application.MessageBox(PChar(meldung), PChar(info), MB_YesNo) = IDYes
     Then Begin
       veraendert := false;
       aktiveEchos.Items := DiffListe.Items;
     End
     Else Begin
       CanClose := False;
       Exit;
     End;
  End;

//  Hauptmenue.Visible := true;
  CanClose := True;
end;

procedure TEchoVerwaltung.CBabbruchClick(Sender: TObject);
begin
  EchoVerwaltung.Close;
end;

procedure TEchoVerwaltung.CBokClick(Sender: TObject);
var i, j, k      : Integer;
    echoname     : String[50];
    echoname2    : String[50];
    gefunden     : Boolean;
    AreafixListe : TMemo;
    fehler       : LongBool;
    cmd          : Array[0..2*MAX_PATH] of Char;
    f            : Textfile;
begin
  AreafixListe := TMemo.Create(Self);
  AreafixListe.Parent := EchoVerwaltung;
  AreafixListe.Visible := False;
  AreafixListe.Clear;

  If veraendert Then Begin
    // neue Liste mit alter abgleichen und dann ggf. Mail an Areafix schreiben
    // abbestellte Echos aus Husky (HPT) Config löschen
    // anschliessend Area-Config für Golded neu schreiben lassen
    For i := 0 To (aktiveEchos.Items.Count-1) Do Begin
      j := Pos(' ', aktiveEchos.Items.Strings[i]);
      If j > 0 Then echoname := Copy(aktiveEchos.Items.Strings[i],1,j-1)
               Else echoname := aktiveEchos.Items.Strings[i];
      gefunden := false;
      For j := 0 To (DiffListe.Items.Count-1) Do Begin
        k := Pos(' ', DiffListe.Items.Strings[j]);
        If k > 0 Then echoname2 := Copy(DiffListe.Items.Strings[j],1,k-1)
                 Else echoname2 := DiffListe.Items.Strings[j];
        If echoname2 = echoname Then Begin
          gefunden := true; // keine Änderung
          DiffListe.Items.Delete(j);
          break;
        End;
      End;
      // wenn nicht in bisheriger Liste gefunden, dann Echo anbestellen
      If not gefunden Then AreafixListe.Lines.Add('+' + echoname);
    End;

    // übrige Echos (nicht mehr in aktueller Liste) abbestellen
    For i := 0 To (DiffListe.Items.Count-1) Do Begin
      j := Pos(' ', DiffListe.Items.Strings[i]);
      If j > 0 Then echoname := Copy(DiffListe.Items.Strings[i],1,j-1)
               Else echoname := DiffListe.Items.Strings[i];
      AreafixListe.Lines.Add('-' + echoname);
    End;

    // neue Echos anbestellen, gelöschte Echos abbestellen
    echoAnAbBestellen(AreafixListe);
    AreafixListe.Free;

    // neue Echo-Liste für Golded erstellen und Mail für Areafix erstellen
    lstrcpy(cmd, comspec);
    lstrcat(cmd, PChar(InstDir+'\binkley\hpt\goldarea.bat'));
//    DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 0, True);
    // mal auf nicht warten gesetzt, weil es wohl manchmal hing, wobei ich
    // nicht weiss, ob es hieran liegt/lag
    DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 0, False);
  End;

  Assignfile(f, InstDir+'\aktiv.lst');
  Rewrite(f);
  For i := 0 to (aktiveEchos.Items.Count-1) Do
   Writeln(f, aktiveEchos.Items.Strings[i]);
  Closefile(f);

  veraendert := false;
  EchoVerwaltung.Close;
end;


procedure TEchoVerwaltung.echoAnAbBestellen(Var Diffliste: TMemo);
var f, g        : Textfile;
    zeile       : String;
    echoname    : String;
    i           : Integer;
begin
  If Diffliste.Lines.Count <= 0 Then Exit;

  // abbestellte Areas aus Husky (HPT) Config austragen
  Assignfile(f, InstDir+'\binkley\hpt\config');
  Reset(f);
  Assignfile(g, InstDir+'\binkley\hpt\config.tmp');
  Rewrite(g);
  While not EOF(f) Do Begin
    Readln(f, zeile);
    If Pos('EchoArea ', zeile) = 1 Then Begin
      i := -1;
      echoname := zeile;
      Delete(echoname,1,Length('EchoArea '));
      While (Length(echoname) > 1) and (echoname[1] = ' ') Do Delete(echoname,1,1);
      If Length(echoname) > 1 Then Delete(echoname,Pos(' ', echoname),Length(echoname));
      If Length(echoname) > 1 Then i := Diffliste.Lines.IndexOf('-' + echoname);
      If i = -1 Then Writeln(g, zeile)
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

  // Mail an Areafix mit Änderungen erstellen
  Assignfile(f, InstDir+'\binkley\hpt\areafix.chg');
  {$I-} Append(f); {$I+}
  If not (IOResult=0) Then Rewrite(f);
  For i := 0 To (Diffliste.Lines.Count-1) Do Begin
    echoname := Diffliste.Lines.Strings[i];
    Writeln(f, echoname);
    If echoname[1] = '+' Then Begin // für Rescan
      Delete(echoname,1,1); // '+' löschen
      If ( (netznummer = 2457) and ((nodenummer = '265') or (nodenummer = '267')) )
        or ( (netznummer = 2450) and ((nodenummer = '510') or (nodenummer = '513')) )
        or ( (netznummer = 240) and ((nodenummer = '2188') or (nodenummer = '2189')) )
       Then Writeln(f, '%rescan ' + echoname + ' 20') // Henning Schroeer, Ralph Bieler, Christian von Busse
       Else Writeln(f, echoname + ', R=20');
    End;
  End;
  Closefile(f);
end;


procedure TEchoVerwaltung.Tastendruecke(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  Case Key of
   VK_Escape: CBabbruchClick(Sender);
   VK_F3: CBweitersuchenClick(Sender);
   Ord('O'): If ssAlt in Shift Then CBokClick(Sender);
   Ord('S'): If ssAlt in Shift Then suchbegriff.SetFocus;
   Ord('1'): If ssAlt in Shift Then CBfidoEchosClick(Sender);
   Ord('2'): If ssAlt in Shift Then CBfidoInternationalClick(Sender);
   Ord('3'): If ssAlt in Shift Then CBlokaleEchosClick(Sender);
   Ord('4'): If ssAlt in Shift Then CBregionaleEchosClick(Sender);
  End;
end;

procedure TEchoVerwaltung.CBfidoEchosClick(Sender: TObject);
var anzahl: String[5];
begin
  // echolist.ger oder echo0002.lst auslesen
  If FileExists('echolist.ger') Then Echos_lesen('echolist.ger', anzahl)
                                Else Echos_lesen('echo0002.lst', anzahl);
  anzahlEchos.Caption := Format(s[0133], [anzahl]);

  CBfidoEchos.Enabled := false;
  CBfidoEchos.Refresh;
  CBfidoInternational.Enabled := true;
  CBfidoInternational.Refresh;
  CBlokaleEchos.Enabled := true;
  CBlokaleEchos.Refresh;
  CBregionaleEchos.Enabled := true;
  CBregionaleEchos.Refresh;
end;

procedure TEchoVerwaltung.FormShow(Sender: TObject);
var f          : Textfile;
    zeile      : String;
    anzahl_str : String[5];
begin
  EchoVerwaltung.Visible := True;
  
  veraendert := false;

  CBfidoEchosClick(Sender);

  aktiveEchos.Clear;
  DiffListe.Items.Clear;

  Assignfile(f, InstDir+'\aktiv.lst');
  {$I-} Reset(f); {$I+}
  IF (IOResult = 0) Then Begin
    While not EOF(f) Do Begin
      Readln(f, zeile);
      If (zeile <> '') Then Begin
        aktiveEchos.Items.Add(zeile);
        DiffListe.Items.Add(zeile);
      End;
    End;
    Closefile(f);
  End;

  anzahlEchosBestellt := aktiveEchos.Items.Count;
  Str(anzahlEchosBestellt, anzahl_str);
  anzahlEchosAktiv.Caption := Format(s[0128], [anzahl_str]);

  altePosition := -1;
end;

procedure TEchoVerwaltung.FormCreate(Sender: TObject);
var DC: hDc;
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
    LEchos.Left := LEchos.Left - 30;
    CBfidoEchos.Left := CBfidoEchos.Left - 30;
    CBfidoInternational.Left := CBfidoInternational.Left - 23;
    CBlokaleEchos.Left := CBlokaleEchos.Left - 15;
    CBregionaleEchos.Left := CBregionaleEchos.Left - 7;
    CBfidoEchos.Width := CBfidoEchos.Width + 7;
    CBfidoInternational.Width := CBfidoInternational.Width + 8;
    CBlokaleEchos.Width := CBlokaleEchos.Width + 8;
    CBregionaleEchos.Width := CBregionaleEchos.Width + 7;
  End;

  If EchoVerwaltung.Width <> (alleEchos.Width + 30) Then
    EchoVerwaltung.Width := alleEchos.Width + 30;
  If EchoVerwaltung.Height <> (LSuchbegriff.Top + LSuchbegriff.Height + 40) Then
    EchoVerwaltung.Height := LSuchbegriff.Top + LSuchbegriff.Height + 40;
//  While ((Erklaerung.Left + Erklaerung.Width + 30) > CBfidoEchos.Left) Do
//    Erklaerung.Width := Erklaerung.Width - 1;

  // Fenster zentrieren
  EchoVerwaltung.Top := (y - EchoVerwaltung.Height - 30) div 2;
  EchoVerwaltung.Left := (x - EchoVerwaltung.Width) div 2;

  If sprache <> 'deutsch' Then Begin
    EchoVerwaltung.Caption := s[0134];
    Erklaerung.Caption := s[0135];
    LEchos.Caption := s[0136];
    CBfidoEchos.Caption := s[0137];
    CBfidoInternational.Caption := s[0138];
    CBlokaleEchos.Caption := s[0139];
    CBregionaleEchos.Caption := s[0140];
    LSuchbegriff.Caption := s[0141];
    CBsuchen.Caption := s[0142];
    CBweitersuchen.Caption := s[0143];
    CBok.Caption := s[0144];
    CBabbruch.Caption := ' ' + s[0050];
    CBalleBestellen.Caption := s[0256];
  End
end;

procedure TEchoVerwaltung.Echos_lesen(name: String; var anzahl_str: Str5);
var f            : Textfile;
    zeile        : String[110];
    echotag      : String[40];
    beschreibung : String[80];
    i, anzahl    : Integer;
    abbruch      : Boolean;
    kindOfEchos  : Integer;
begin
  anzahl := 0;
  alleEchos.Clear;

  // Datei mit Echos auslesen
  Assignfile(f, InstDir + '\' + name);
  {$I-} Reset(f); {$I+}
  IF not (IOResult = 0) Then Begin
    anzahl_str := '0';
    Exit;
  End;

  If (Uppercase(name) = 'ECHOLIST.GER')
     or (Uppercase(name) = 'ECHO0002.LST') Then kindOfEchos := 1
  Else If (Uppercase(name) = 'BACKBONE.NA') Then kindOfEchos := 2
  Else kindOfEchos := 0;

  abbruch := False;
  If not EOF(f) Then Readln(f, zeile)
                Else abbruch := True;

  While not abbruch Do Begin
    If (zeile[1] <> ' ') and (zeile <> '') Then Begin

      i := Pos(' ', zeile);
      If (i = 0) Then Begin
        echotag := Uppercase(zeile);
        beschreibung := '';
        If not EOF(f) Then Readln(f, zeile)
                      Else abbruch := True;
      End
      Else Begin
        echotag := Uppercase(Copy(zeile,1,i-1));

        Delete(zeile,1,i);
        While (Length(zeile) > 1) and (zeile[1] = ' ') Do Delete(zeile,1,1);

        If (Length(zeile) > 1) and (zeile[1] = '[') Then Delete(zeile,1,4);
        beschreibung := zeile;

        If not EOF(f) Then Begin
          Readln(f, zeile);
          If zeile[1] = ' ' Then Begin
            beschreibung := beschreibung + zeile;
            If not EOF(f) Then Readln(f, zeile)
                          Else abbruch := True;
          End;
        End
        Else abbruch := True;
      End;

      If (kindOfEchos = 0) or
         (sprache = 'englisch') or  // dann auch amerikanische/englische Echos zulassen
         ((kindOfEchos = 1) and ((Pos('.GER', echotag) > 0) or  // ECHO0002.LST, ECHOLIST.GER
                                 (Pos('.024', echotag) > 0) or
                                 (Pos('.INFO', echotag) > 0) or
                                 (Pos('.DEUTSCH', echotag) > 0) or
                                 (Pos('.OS2', echotag) > 0) or
                                 (Pos('.TEX', echotag) > 0) or
                                 (Pos('.2000', echotag) > 0) or
                                 (Pos('HAMBURG', echotag) > 0) or
                                 (Pos('CFOS_HELP', echotag) > 0) or
                                 (Pos('.1996', echotag) > 0))) or
         ((kindOfEchos = 2) and (Pos('.GER', echotag) = 0) and // BACKBONE.NA
                                (Pos('.024', echotag) = 0) and
                                (Pos('.DEUTSCH', echotag) = 0) and
                                (Pos('.1996', echotag) = 0)) Then Begin
        alleEchos.Items.Add(Format('%-30s %-70s', [echotag, beschreibung]));
        Inc(anzahl);
      End;
    End Else Begin
      If not EOF(f) Then Readln(f, zeile)
                    Else abbruch := True;
    End;
  End;
  Closefile(f);

  Str(anzahl, anzahl_str);
end;

procedure TEchoVerwaltung.CBfidoInternationalClick(Sender: TObject);
var anzahl: String[5];
begin
  // backbone.na auslesen
  Echos_lesen('backbone.na', anzahl);
  anzahlEchos.Caption := Format(s[0145], [anzahl]);

  CBfidoEchos.Enabled := true;
  CBfidoEchos.Refresh;
  CBfidoInternational.Enabled := false;
  CBfidoInternational.Refresh;
  CBlokaleEchos.Enabled := true;
  CBlokaleEchos.Refresh;
  CBregionaleEchos.Enabled := true;
  CBregionaleEchos.Refresh;
end;

procedure TEchoVerwaltung.CBlokaleEchosClick(Sender: TObject);
var anzahl: String[5];
begin
  // box.lst auslesen
  Echos_lesen('box.lst', anzahl);
  anzahlEchos.Caption := Format(s[0146], [anzahl]);

  CBfidoEchos.Enabled := true;
  CBfidoEchos.Refresh;
  CBfidoInternational.Enabled := true;
  CBfidoInternational.Refresh;
  CBlokaleEchos.Enabled := false;
  CBlokaleEchos.Refresh;
  CBregionaleEchos.Enabled := true;
  CBregionaleEchos.Refresh;
end;

procedure TEchoVerwaltung.CBregionaleEchosClick(Sender: TObject);
var anzahl: String[5];
begin
  // netz.lst auslesen
  Echos_lesen('netz.lst', anzahl);
  anzahlEchos.Caption := Format(s[0147], [anzahl]);

  CBfidoEchos.Enabled := true;
  CBfidoEchos.Refresh;
  CBfidoInternational.Enabled := true;
  CBfidoInternational.Refresh;
  CBlokaleEchos.Enabled := true;
  CBlokaleEchos.Refresh;
  CBregionaleEchos.Enabled := false;
  CBregionaleEchos.Refresh;
end;

procedure TEchoVerwaltung.CBalleBestellenClick(Sender: TObject);
var i, j         : Integer;
    echoname     : String[50];
    AreafixListe : TMemo;
    fehler       : LongBool;
    cmd          : Array[0..2*MAX_PATH] of Char;
    f            : Textfile;
begin
  AreafixListe := TMemo.Create(Self);
  AreafixListe.Parent := EchoVerwaltung;
  AreafixListe.Visible := False;
  AreafixListe.Clear;

  For i := 0 To (aktiveEchos.Items.Count-1) Do Begin
    j := Pos(' ', aktiveEchos.Items.Strings[i]);
    If j > 0 Then echoname := Copy(aktiveEchos.Items.Strings[i],1,j-1)
             Else echoname := aktiveEchos.Items.Strings[i];

    AreafixListe.Lines.Add('+' + echoname);
  End;

  // Mail an Areafix mit Änderungen erstellen
  Assignfile(f, InstDir+'\binkley\hpt\areafix.chg');
  {$I-} Append(f); {$I+}
  If not (IOResult=0) Then Rewrite(f);
  For i := 0 To (AreafixListe.Lines.Count-1) Do Begin
    echoname := AreafixListe.Lines.Strings[i];
    Writeln(f, echoname);
  End;
  Closefile(f);

  AreafixListe.Free;

  // neue Echo-Liste für Golded erstellen und Mail für Areafix erstellen
  lstrcpy(cmd, comspec);
  lstrcat(cmd, PChar(InstDir+'\binkley\hpt\goldarea.bat'));
//  DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 0, True);
  // mal auf nicht warten gesetzt, weil es wohl manchmal hing, wobei ich
  // nicht weiss, ob es hieran liegt/lag
  DosOutput.starteProgrammRedirect(InstDir, cmd, fehler, 0, False);

  Application.MessageBox(PChar(s[0257]), sprache_Hinweis, MB_OK);

  EchoVerwaltung.Close;
end;

end.
