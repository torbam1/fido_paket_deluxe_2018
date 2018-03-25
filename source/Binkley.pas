unit Binkley;

interface

uses stdctrls;

Type Str5 = String[5];

procedure BinkD_temp_konfigurieren(Var temp_Aka_Dez: Str5;
           Name, Ort: String; Proxy: Integer; ProxyIP: String; ProxyPort: Str5;
           ProxyPwd: String);

procedure BinkD_fertig_konfigurieren;

procedure HPT_konfigurieren(Name, Ort: String);

procedure Fastlist_konfigurieren;


implementation

uses SysUtils, Windows, Dateneingabe, CDP, fpd_language;

var vorwahl_ohne_null: String[10];

procedure BinkD_temp_konfigurieren(Var temp_Aka_Dez: Str5;
           Name, Ort: String; Proxy: Integer; ProxyIP: String; ProxyPort: Str5;
           ProxyPwd: String);
var f, g     : Textfile;
    zeile    : String;
    i        : Integer;
    tempNode : String[25];
begin
  // binkd.cfg
  Assignfile(f, InstDir + '\binkley\binkd.cfg');
  Assignfile(g, InstDir + '\binkley\binkdcfg.tmp');
  Reset(f);
  Rewrite(g);
  For i := 1 To 18 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f);
  i := Pos('/', NodeAKA);
  tempNode := Copy(NodeAKA,1,i) + '9999.' + temp_Aka_Dez;
  Writeln(g, 'address ' + tempNode + '@fidonet');

  For i := 1 To 4 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f); Readln(f); Readln(f);
  i := Pos(' ', Name);
  Writeln(g, 'sysname "' + Copy(Name,1,i-1) + '"');
  Writeln(g, 'location "' + Ort + '"');
  Writeln(g, 'sysop "' + Name + '"');

  For i := 1 To 23 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;

  If (ProxyPwd <> '') and (proxy <> 3) Then ProxyPwd := '/' + ProxyPwd;
  Case Proxy of
       1: Writeln(g, 'proxy ' + ProxyIP + ':' + ProxyPort + ProxyPwd);
       2: Writeln(g, 'socks ' + ProxyIP + ':' + ProxyPort + ProxyPwd);
       3: Writeln(g, 'proxy ' + ProxyIP + ':' + ProxyPort + '/' + ProxyPwd);
  End;


  While not EOF(f) Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
//  If (ParamStr(2) <> '-aka') Then Writeln(g, 'node ' + NodeAKA + ' -crc ' + Node_IP + ' -')
//                             Else Writeln(g, 'node 2:2457/266 -crc 192.168.155.99:24554 -');
  If (ParamStr(2) <> '-aka') Then Writeln(g, 'node ' + NodeAKA + ' ' + Node_IP + ' -')
                             Else Writeln(g, 'node 2:2457/266 192.168.155.99:24554 -');

  If (NodeAKA <> '2:249/3110') and (NodeAKA <> '2:249/3114') Then Begin
    Writeln(g);
    Writeln(g, 'node 2:249/3110 monisbox.dyndns.org;bbsdd.de;monis.yi.org -');
  End;

  Closefile(f);
  Closefile(g);
  Erase(f);
  Rename(g, InstDir+'\binkley\binkd.cfg');

  // binkd.inc (leer) erstellen, damit keine Fehlermeldung kommt
  Assignfile(f, InstDir+'\binkley\binkd.inc');
  Rewrite(f);
  Writeln(f);
  Closefile(f);

  // poll2.bat
  Assignfile(f, InstDir + '\binkley\poll2.bat');
  Rewrite(f);
  Writeln(f, '@echo off');
  Writeln(f, 'cd ' + InstDir + '\binkley');
  Writeln(f, 'if exist outecho\*.try del outecho\*.try');
  Writeln(f, 'if exist outecho\*.csy del outecho\*.csy');
  Writeln(f, 'rem>>outecho\' + node_aka_hex + '.clo');
  Writeln(f, 'if not exist outecho\' + node_aka_hex + '.clo makepoll.exe outecho\' + node_aka_hex + '.clo');
  Closefile(f);

  // poll3.bat
  Assignfile(f, InstDir + '\binkley\poll3.bat');
  Rewrite(f);
  Writeln(f, '@echo off');
  Writeln(f, 'cd ' + InstDir + '\binkley\files\sec');
  Writeln(f, 'if exist box.lst copy box.lst ..\..\..\menu\box.lst');
  Writeln(f, 'if exist box.lst del box.lst');
  Writeln(f, 'if exist netz.lst copy netz.lst ..\..\..\menu\netz.lst');
  Writeln(f, 'if exist netz.lst del netz.lst');
  Closefile(f);
end;

procedure BinkD_fertig_konfigurieren;
var f, g  : Textfile;
    zeile : String;
    i     : Integer;
begin
  // binkd.cfg
  Assignfile(f, InstDir + '\binkley\binkd.cfg');
  Assignfile(g, InstDir + '\binkley\binkdcfg.tmp');
  Reset(f);
  Rewrite(g);
  For i := 1 To 18 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f);
  Writeln(g, 'address ' + NodeAKA + '.' + point_nr + '@fidonet');

  While not EOF(f) Do Begin
    Readln(f, zeile);
    If Pos('node ', zeile) = 1 Then break;
    Writeln(g, zeile);
  End;
  If (ParamStr(2) <> '-aka')
   Then Writeln(g, 'node ' + NodeAKA + ' ' + Node_IP + ' ' + SessionPassword)
   Else  Writeln(g, 'node 2:2457/266 192.168.155.99:24554 ' + SessionPassword);
  If NodeAKA = '2:2457/265'
   Then Writeln(g, 'node 2:2457/267 ' + Node_IP + ' ' + SessionPassword);

  While Not EOF(f) Do
  Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Closefile(f);
  Closefile(g);
  Erase(f);
  Rename(g, InstDir+'\binkley\binkd.cfg');

  // poll.bat
  Assignfile(f, InstDir + '\binkley\poll.bat');
  Assignfile(g, InstDir + '\binkley\pollbat.tmp');
  Reset(f);
  Rewrite(g);
  Readln(f, zeile);
  Writeln(g, zeile);
  Readln(f);
  Writeln(g, 'cd ' + InstDir + '\binkley\flags');
  For i := 1 To 3 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f);
  Writeln(g, 'cd ' + InstDir + '\binkley\files');
  For i := 1 To 4 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f);
  Writeln(g, 'cd ' + InstDir + '\binkley\files\sec');

  For i := 1 To 23 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f);
  Writeln(g, 'cd ' + InstDir + '\binkley\fidoinfo\node');

  For i := 1 To 14 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f);
  Writeln(g, 'cd ' + InstDir);

  For i := 1 To 10 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f);
  Writeln(g, 'cd ' + InstDir + '\binkley\nodelist');

  For i := 1 To 5 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f);
  Writeln(g, 'cd ' + InstDir + '\binkley');

  For i := 1 To 5 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f);
  Writeln(g, 'cd ' + InstDir + '\binkley\hpt');

  For i := 1 To 5 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f);
  Writeln(g, 'cd ' + InstDir + '\binkley\outecho');

  For i := 1 To 3 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f);
//  Writeln(g, 'if not exist ' + node_aka_hex + '.clo echo.>'
  Writeln(g, 'if not exist ' + node_aka_hex + '.clo ..\makepoll.exe '
             + node_aka_hex +'.clo');

  Writeln(g, 'cd ..');
  Closefile(f);
  Closefile(g);
  Erase(f);
  Rename(g, InstDir+'\binkley\poll.bat');

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

  // inst.bat
  Assignfile(f, InstDir + '\binkley\inst.bat');
  Assignfile(g, InstDir + '\binkley\instbat.tmp');
  Reset(f);
  Rewrite(g);
  Readln(f, zeile);
  Writeln(g, zeile);
  Readln(f);
  Writeln(g, 'cd ' + InstDir + '\binkley\files');

  While (zeile <> '') Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f);
  Writeln(g, 'cd ' + InstDir + '\binkley\fidoinfo\node');

  While (zeile <> ':echos') Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f);
  Writeln(g, 'cd ' + InstDir);

  While (zeile <> ':golded') Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f);
  Writeln(g, 'cd ' + InstDir + '\binkley\hpt');

  While (zeile <> ':update') Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f);
  Writeln(g, 'cd ' + InstDir + '\binkley');

  While not EOF(f) Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Closefile(f);
  Closefile(g);
  Erase(f);
  Rename(g, InstDir+'\binkley\inst.bat');

  // poll2.bat und poll3.bat (Pollen ohne Tossen) löschen, wurden nur für
  // ersten Poll benötigt
  SysUtils.DeleteFile(InstDir+'\binkley\poll2.bat');
  SysUtils.DeleteFile(InstDir+'\binkley\poll3.bat');

  // nodecomp.bat
  Assignfile(f, InstDir + '\binkley\nodecomp.bat');
  Rewrite(f);
  Writeln(f, '@echo off');
  Writeln(f, 'cd ' + InstDir + '\binkley\files\sec');
  Writeln(f, 'if exist node0002.zip copy node0002.zip ' + InstDir + '\binkley\nodelist\node0002.zip');
  Writeln(f, 'if exist node0002.zip del node0002.zip');
  Writeln(f, 'if exist pnt0002.zip copy pnt0002.zip ' + InstDir + '\binkley\nodelist\pnt0002.zip');
  Writeln(f, 'if exist pnt0002.zip del pnt0002.zip');
  Writeln(f);
  Writeln(f, 'cd ' + InstDir + '\binkley\nodelist');
  Writeln(f, 'if exist node0002.zip unzip -o -q -j node0002.zip');
  Writeln(f, 'if exist node0002.zip del node0002.zip');
  Writeln(f, 'if exist pnt0002.zip unzip -o -q -j pnt0002.zip');
  Writeln(f, 'if exist pnt0002.zip del pnt0002.zip');
  Writeln(f);
  Writeln(f, 'if not exist *.a?? goto weiter');
  Writeln(f, 'for %%i in (*.a??) do xarc %%i /o /q');
  Writeln(f, 'del *.a??>nul');
  Writeln(f);
  Writeln(f, ':weiter');
  Writeln(f, 'if not exist nodediff.z?? goto compilieren');
  Writeln(f, 'unzip -o -q -j nodediff.z??');
  Writeln(f, 'if exist pr24diff.z?? unzip -o -q -j pr24diff.z??');
  Writeln(f, 'if exist r24pnt_d.z?? unzip -o -q -j r24pnt_d.z??');
  Writeln(f, 'del nodediff.z??>nul');
  Writeln(f, 'if exist pr24diff.z?? del pr24diff.z??');
  Writeln(f, 'if exist r24pnt_d.z?? del r24pnt_d.z??');
  Writeln(f);
  Writeln(f, ':compilieren');
  Writeln(f, 'fastlst.exe');
  Writeln(f, 'iprouted.exe');
  Writeln(f, 'cd ' + InstDir + '\binkley');
  Closefile(f);

  // iproute.cfg
  Assignfile(f, InstDir + '\binkley\nodelist\iproute.cfg');
  Rewrite(f);
  Writeln(f, '#       global stuff');
  Writeln(f, 'nodelist: ' + InstDir + '\binkley\nodelist');
  Writeln(f, 'flags:    ibn');
  Writeln(f, 'nopack:    ' + NodeAKA);
  If NodeAKA = '2:2457/265' Then Writeln(f, 'nopack:    2:2457/267');
  Writeln(f, '#       binkd stuff');
  Writeln(f, 'binkd:    ' + InstDir + '\binkley\binkd.inc');
  Writeln(f, 'binkdcfg: ' + InstDir + '\binkley\binkd.cfg');
  Writeln(f, 'linux:    no');
  Writeln(f, 'biflavor: -');
  Closefile(f);

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
  Writeln(f, 'if exist lock.hpt del lock.hpt>nul');
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
end;


procedure HPT_konfigurieren(Name, Ort: String);
var f, g  : Textfile;
    zeile : String;
    i     : Integer;
begin
  // config
  Assignfile(f, InstDir + '\binkley\hpt\config');
  Assignfile(g, InstDir + '\binkley\hpt\config.tmp');
  Reset(f);
  Rewrite(g);
  For i := 1 To 4 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  For i := 1 To 5 Do Readln(f);
  i := Pos(' ', Name);
  Writeln(g, 'Name ' + Copy(Name,1,i-1));
  Writeln(g, 'Location ' + Ort);
  Writeln(g, 'Sysop ' + Name);
  Writeln(g);
  Writeln(g, 'Address ' + NodeAKA + '.' + point_nr);

  For i := 1 To 47 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  For i := 1 To 9 Do Readln(f);

  zeile := Node_Name;
  While Pos('_', zeile) > 0 Do zeile[Pos('_', zeile)] := ' ';
  Writeln(g, 'Link ' + zeile);
  
  Writeln(g, 'level 40');
  Writeln(g, 'Aka ' + NodeAKA);
  Writeln(g, 'ourAka ' + NodeAKA + '.' + point_nr);
  Writeln(g, 'Password ' + PktPassword);
  Writeln(g, 'pktpwd ' + PktPassword);
  Writeln(g, 'areafixpwd ' + AreafixPassword);
  Writeln(g, 'filefixpwd ' + FiletickerPassword);
  Writeln(g, 'ticpwd ' + FiletickerPassword);

  For i := 1 To 18 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f);
  Readln(f);
  Writeln(g, 'route normal ' + NodeAKA + ' *');
  Writeln(g, 'routeFile normal ' + NodeAKA + ' *');

  For i := 1 To 4 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f);
  Writeln(g, 'Outbound        ' + InstDir + '\binkley\outecho\');

  For i := 1 To 2 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f);
  Writeln(g, 'tempDir      ' + InstDir + '\binkley\hpt\temp\');
  Readln(f, zeile);
  Writeln(g, zeile);
  Readln(f);
  Writeln(g, 'MsgBaseDir      ' + InstDir + '\binkley\msgbase\');

  For i := 1 To 21 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f);
  Writeln(g, 'NetmailArea Netmail ' + InstDir + '\binkley\netmail\ -b msg');

  For i := 1 To 3 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  For i := 1 To 5 Do Readln(f);
  Writeln(g, 'BadArea     BadArea     ' + InstDir + '\binkley\msgbase\bad -b squish -d "Bad Mail Board" -p 10 -g Z');
  Writeln(g, 'DupeArea    DupeArea    ' + InstDir + '\binkley\msgbase\dupe -b squish -d "Dupe Board" -p 3 -g Z');
  Writeln(g);
  Writeln(g, 'LocalArea carbonArea       ' + InstDir + '\binkley\msgbase\carbon  -b squish -d "Carbon Area" -keepsb -g Z');
  Writeln(g, 'CarbonTo ' + Name);

  For i := 1 To 12 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  For i := 1 To 6 Do Readln(f);
  Writeln(g, 'NetmailArea NetmailArchiv ' + InstDir + '\binkley\netmail\archiv\ -b msg');
  If (NodeAKA = '2:240/2188') or (NodeAKA = '2:240/2189') Then Begin
    Writeln(g, 'EchoArea KRUEMEL.NEWS ' + InstDir + '\binkley\msgbase\kruemel.news -a 2:240/2188.' + point_nr + ' -b Squish -$m 500 -lw 10 -keepUnread -dupecheck move -g A -p 30 ' + NodeAKA);
    Writeln(g, 'EchoArea KRUEMEL.USER ' + InstDir + '\binkley\msgbase\kruemel.user -a 2:240/2188.' + point_nr + ' -b Squish -$m 500 -lw 10 -keepUnread -dupecheck move -g A -p 30 ' + NodeAKA);
  End;
  If (NodeAKA = '2:2457/265') or (NodeAKA = '2:2457/266') Then Begin
    Writeln(g, 'EchoArea CCC.CHAT ' + InstDir + '\binkley\msgbase\ccc.chat -a 2:2457/265.' + point_nr + ' -b Squish -$m 500 -lw 10 -keepUnread -dupecheck move -g A -p 30 ' + NodeAKA);
    Writeln(g, 'EchoArea CCC.POSTINGS ' + InstDir + '\binkley\msgbase\ccc.postings -a 2:2457/265.' + point_nr + ' -b Squish -$m 500 -lw 10 -keepUnread -dupecheck move -g A -p 30 ' + NodeAKA);
    Writeln(g, 'EchoArea CCC.LINKING ' + InstDir + '\binkley\msgbase\ccc.linking -a 2:2457/265.' + point_nr + ' -b Squish -$m 500 -lw 10 -keepUnread -dupecheck move -g A -p 30 ' + NodeAKA);
    If sprache <> 'deutsch' Then Writeln(g, 'EchoArea CCC.ENGLISH ' + InstDir + '\binkley\msgbase\ccc.english -a 2:2457/265.' + point_nr + ' -b Squish -$m 500 -lw 10 -keepUnread -dupecheck move -g A -p 30 ' + NodeAKA);
    Writeln(g, 'EchoArea 2457.NET ' + InstDir + '\binkley\msgbase\2457.net -a 2:2457/265.' + point_nr + ' -b Squish -$m 500 -lw 10 -keepUnread -dupecheck move -g A -p 30 ' + NodeAKA);
  End;

  While Not EOF(f) Do
  Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Closefile(f);
  Closefile(g);
  Erase(f);
  Rename(g, InstDir+'\binkley\hpt\config');

  // goldarea.bat
  Assignfile(f, InstDir + '\binkley\hpt\goldarea.bat');
  Rewrite(f);
  Writeln(f, '@echo off');
  Writeln(f, 'cd ' + InstDir + '\binkley\hpt');
  Writeln(f, 'fconf2golded ' + InstDir + '\golded\goldarea.inc');
  Writeln(f, 'if not exist *.chg goto ende');
  Writeln(f);
  Write(f, 'if exist areafix.chg hpt post -nt "' + AreafixName + '" -at "' + NodeAKA + '" -s "');
  Writeln(f, AreafixPassword + '" -f "k/s pvt loc" -d areafix.chg');
  Write(f, 'if exist filefix.chg hpt post -nt "' + FiletickerName + '" -at "' + NodeAKA + '" -s "');
  Writeln(f, FiletickerPassword + '" -f "k/s pvt loc" -d filefix.chg');
  Writeln(f, 'echo netmail>>echotoss.log');
  Writeln(f, 'hpt pack');
  Writeln(f);
  Writeln(f, ':ende');
  Closefile(f);

  // Areas anbestellen
  If (NodeAKA = '2:240/2188') or (NodeAKA = '2:240/2189') Then Begin
    Assignfile(f, InstDir + '\binkley\hpt\areafix.chg');
    Rewrite(f);
//    Writeln(f, '+KRUEMEL.NEWS');
    Writeln(f, '%Rescan kruemel.news 1');
    Writeln(f, '+KRUEMEL.USER');
    Writeln(f, '%Rescan kruemel.user 15');
    Closefile(f);

    Assignfile(f, InstDir + '\aktiv.lst');
    Rewrite(f);
    Writeln(f, 'KRUEMEL.NEWS                  Bekanntmachungen des Sysops');
    Writeln(f, 'KRUEMEL.USER                  Hier unterhalten sich die User der Kruemel Boks!');
    Closefile(f);
  End;

  If (NodeAKA = '2:2457/265') or (NodeAKA = '2:2457/266') Then Begin
    Assignfile(f, InstDir + '\binkley\hpt\areafix.chg');
    Rewrite(f);
    Writeln(f, '+CCC.CHAT');
    Writeln(f, '%Rescan ccc.chat 15');
    Writeln(f, '+CCC.POSTINGS');
    Writeln(f, '%Rescan ccc.postings 5');
    Writeln(f, '+CCC.LINKING');
    Writeln(f, '%Rescan ccc.linking 1');
    If sprache <> 'deutsch' Then Begin
      Writeln(f, '+CCC.ENGLISH');
      Writeln(f, '%Rescan ccc.english 5');
    End;
    Writeln(f, '+2457.NET');
    Writeln(f, '%Rescan 2457.net 10');
    Closefile(f);

    Assignfile(f, InstDir + '\aktiv.lst');
    Rewrite(f);
    Writeln(f, '2457.NET                       Das Netz-Echo des Suedwestfalen-Netzes');
    Writeln(f, 'CCC.CHAT                       DAS CHATecho schlechthin.');
    Writeln(f, 'CCC.LINKING                    In diesem Echo werden wichtige Sachen gepostet. Mandatory.');
    Writeln(f, 'CCC.POSTINGS                   Hier kommen alle interessanten Mails hin.');
    If sprache <> 'deutsch' Then Writeln(f, 'CCC.ENGLISH                    English speaking area for chats and questions');
    Closefile(f);
  End;

  Assignfile(f, InstDir + '\binkley\hpt\filefix.chg');
  Rewrite(f);
  Writeln(f, '+NODEDIFF');
  Writeln(f, '+NODEDIFZ');
  Writeln(f, '+R24PNT_D');
  Closefile(f);

  // pktdate.bat
  Assignfile(f, InstDir + '\binkley\hpt\pktdate.bat');
  Rewrite(f);
  Writeln(f, '@echo off');
  Writeln(f, 'rem %1 wird von HPT als Path uebergeben');
  Write(f, 'for %%i in (%1) do ' + InstDir + '\binkley\hpt\pktdate.exe -md -k -L ');
  Writeln(f, InstDir + '\binkley\outecho\pktdate.log -l 2 -c %%i');
  Closefile(f);

  // toss.bat
  Assignfile(f, InstDir + '\binkley\hpt\toss.bat');
  Rewrite(f);
  Writeln(f, '@echo off');
  Writeln(f, 'set FIDOCONFIG=' + InstDir + '\binkley\hpt\config');
  Writeln(f);
  Writeln(f, 'cd ' + InstDir + '\binkley\files');
  Writeln(f, 'if exist *.pkt move *.pkt sec>nul');
  Writeln(f);
  Writeln(f, 'cd sec');
  Write(f, 'rem for %%i in (*.pkt) do ' + InstDir + '\binkley\hpt\pktdate.exe ');
  Writeln(f, '-md -k -L ' + InstDir + '\binkley\outecho\pktdate.log -l 2 -c %%i');
  Writeln(f);
(*
  // Suchergebnis vom FLS in Netmail(s) wandeln
  Write(f, 'for %%i in (' + node_aka_hex + '.da?) do ' + InstDir);
  Write(f, '\binkley\hpt\hpt.exe post -nt "' + name + '" -at "' + NodeAKA);
  Write(f, '.' + point_nr + '" -s "Suchergebnis vom FLS" -f "pvt" -d %%i');
  Writeln(f);
*)
  Writeln(f, 'rem copy *.* backup\*.*');
  Writeln(f);
  Writeln(f, 'cd ' + InstDir + '\binkley\flags');
  Writeln(f, 'if exist toss.no goto ende');
  Writeln(f, 'if exist toss.now goto weiter');
  Writeln(f, 'goto ende');
  Writeln(f);
  Writeln(f, ':weiter');
  Writeln(f, 'del toss.now');
  Writeln(f, 'cd ..\files\sec');
  Writeln(f, 'if exist sic\*.* for %%i in (sic\*.*) do del %%i>nul');
  Writeln(f, 'copy *.* sic\*.*>nul');
  Writeln(f);
  Writeln(f, 'call ..\..\hpt\impexp.bat');
  Writeln(f);
  Writeln(f, ':ende');
  Closefile(f);

  // impexp.bat
  Assignfile(f, InstDir + '\binkley\hpt\impexp.bat');
  Assignfile(g, InstDir + '\binkley\hpt\impexp.tmp');
  Reset(f);
  Rewrite(g);
  Readln(f, zeile);
  Writeln(g, zeile);
  Readln(f);
  Writeln(g, 'cd ' + InstDir + '\binkley\flags');
  Readln(f);
  Writeln(g);

  While Not EOF(f) Do
  Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Writeln(g, 'cd ' + InstDir + '\binkley');
  Closefile(f);
  Closefile(g);
  Erase(f);
  Rename(g, InstDir+'\binkley\hpt\impexp.bat');
end;


procedure Fastlist_konfigurieren;
var f, g  : Textfile;
    zeile : String;
    i     : Integer;
begin
  // fastlst.cfg
  Assignfile(f, InstDir + '\binkley\nodelist\fastlst.cfg');
  Assignfile(g, InstDir + '\binkley\nodelist\flstcfg.tmp');
  Reset(f);
  Rewrite(g);
  For i := 1 To 298 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f); Readln(f); Readln(f);

  // wenn jemand einen anderen Anbieter als die Telekom Preselected hat und
  // über diesen auch Ortsgespräche führen kann, dies aber nicht möchte, dann
  // kann er die folgende Zeile benutzen, um wieder über die Telekom zu
  // telefonieren; Standard: auskommentiert
  Writeln(g, ';  ' + iv + vorwahl_ohne_null + '- 010900' + vorwahl_ohne_null);

  Writeln(g, '  ' + iv + vorwahl_ohne_null + '-');
  Writeln(g, '  ' + iv + ' ' + '0');

  For i := 1 To 47 Do Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;
  Readln(f);
  Writeln(g, ';NodeFlags ' + NodeAKA + '.' + point_nr + ' 300,CM,XA,U,ISDNC');

  While Not EOF(f) Do
  Begin
    Readln(f, zeile);
    Writeln(g, zeile);
  End;

//  If (NodeAKA = '2:2457/265') or (NodeAKA = '2:2457/266') Then Begin
//    Writeln(g);
//    Writeln(g, '  NodeList point265.lst   ; Points in "Boss," format');
//    Writeln(g, '    GermanPointList');
//  End;

  If (NodeAKA = '2:240/2188') or (NodeAKA = '2:240/2189') Then Begin
    Writeln(g);
    Writeln(g, '  NodeList 10251.UPD     ; Points in "Boss," format');
    Writeln(g, '    GermanPointList');
  End;

  Closefile(f);
  Closefile(g);
  Erase(f);
  Rename(g, InstDir+'\binkley\nodelist\fastlst.cfg');

  // password.lst
  Assignfile(f, InstDir + '\binkley\nodelist\password.lst');
  Rewrite(f);
  Writeln(f, 'Password  ' + NodeAKA + '  ' + SessionPassword);
  If (NodeAKA = '2:2457/265') or (NodeAKA = '2:2457/266') Then
   Writeln(f, 'Password  2:2457/266  ' + SessionPassword);
  Closefile(f);
end;


end.
