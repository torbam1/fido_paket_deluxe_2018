unit Golded;

interface

procedure Golded_konfigurieren(Name: String);


implementation

uses SysUtils, Windows, Forms, Dateneingabe, Background, fpd_language;

procedure Golded_konfigurieren(Name: String);
var f, g          : Textfile;
    zeile, zeile2 : String;
    i             : Integer;
    zeilenAnzahl  : Integer;
    gefunden      : Boolean;
    browser       : String;
begin
  // rungold.bat
  Assignfile(f, InstDir + '\golded\rungold.bat');
  Assignfile(g, InstDir + '\golded\runbat.tmp');
  Reset(f);
  Rewrite(g);
  For i := 1 To 2 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f);
  Writeln(g, 'cd ' + InstDir + '\binkley\hpt');
  Readln(f, zeile);
  Writeln(g, zeile);
  Readln(f);
  Writeln(g, 'cd ' + InstDir + '\golded');
  For i := 1 To 13 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f); Readln(f);
  If OS = 1 Then Write(g, 'rem '); // Windows NT
  Writeln(g, 'geddjg.exe');
  Writeln(g);
  Readln(f, zeile);
  Writeln(g, zeile);
  Readln(f);
  If OS = 0 Then Write(g, 'rem '); // Windows 9x
  Writeln(g, 'gedcyg.exe');

  While Not EOF(f) Do
  Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Closefile(f);
  Closefile(g);
  Erase(f);
  Rename(g, InstDir+'\golded\rungold.bat');

  // scan.bat
  Assignfile(f, InstDir + '\golded\scan.bat');
  Rewrite(f);
  Writeln(f, '@echo off');
  Writeln(f, 'goto ende');
  Writeln(f, 'cd ' + InstDir + '\binkley\hpt');
  Writeln(f, 'hpt scan');
  Writeln(f, 'hpt pack');
  Writeln(f, ':ende');
  Closefile(f);

  // golded.cfg
  Assignfile(f, InstDir + '\golded\golded.cfg');
  Assignfile(g, InstDir + '\golded\goldcfg.tmp');
  Reset(f);
  Rewrite(g);
  For i := 1 To 17 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f);
  Writeln(g, 'USERNAME ' + Name);

  For i := 1 To 4 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f);
  Writeln(g, 'ADDRESS ' + NodeAKA + '.' + point_nr + '            ; FidoNet 4D');

  zeilenAnzahl := 25; // Default-Wert
  browser := GetDefaultBrowser;
  If browser = '' Then browser := 'c:\progra~1\intern~1\iexplore.exe';

  While Not EOF(f) Do
  Begin
    Readln(f, zeile);
    If zeile = 'TEARLINE @longpid @version' Then
     zeile := 'TEARLINE FPD ' + Background.version + '  @longpid @version';
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

    If Pos('URLHandler ', zeile) = 1
     Then zeile := 'URLHandler start ' + browser + ' @url';

    Writeln(g, zeile);
  End;

  If sprache = 'russisch' Then Begin
    Writeln(g, '; russsian H configuration...');
    Writeln(g, 'EditSoftCRXLat H');
    Writeln(g, 'DispSoftCR Yes');
    Writeln(g, '; end russion H configuration...');
    Writeln(g);
  End;

  Closefile(f);
  Closefile(g);
  Erase(f);
  Rename(g, InstDir+'\golded\golded.cfg');

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

  // adrmacro.cfg
  Assignfile(f, InstDir+'\golded\adrmacro.cfg');
  Rewrite(f);
  Writeln(f, 'ADDRESSMACRO   areamgr,AreaFix,' + NodeAKA + ',' + AreafixPassword);
  Writeln(f, 'ADDRESSMACRO   areafix,AreaFix,' + NodeAKA + ',' + AreafixPassword);
  Writeln(f, 'ADDRESSMACRO   filescan,FileScan,' + NodeAKA + ',' + FiletickerPassword);
//  Writeln(f, 'ADDRESSMACRO   hs,Henning Schroeer,2:2457/265');
  Writeln(f, 'ADDRESSMACRO   mh,Michael Haase,2:2432/280');
//  Writeln(f, 'ADDRESSMACRO   nm,Natanael Mignon,2:2457/667');
//  Writeln(f, 'ADDRESSMACRO   sb,Stefan Buschmann,2:2457/265.25');
  Closefile(f);

  // gedcolor.cfg
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
  If sprache = 'spanisch' Then Begin
  // spanisches Sprachfile benutzen
    CopyFile(PChar(InstDir+'\golded\goldlang.esp'), PChar(InstDir+'\golded\goldlang.cfg'), false);
    CopyFile(PChar(InstDir+'\golded\goldhelp.esp'), PChar(InstDir+'\golded\goldhelp.cfg'), false);
    CopyFile(PChar(InstDir+'\binkley\FidoInfo\fido_esp.htm'), PChar(InstDir+'\binkley\FidoInfo\fido.htm'), false);
  End;

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
      zeile := 'mode con lines=' + IntToStr(zeilenAnzahl) + ' cols=80';
    End;
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
  IOResult;

end;

end.
