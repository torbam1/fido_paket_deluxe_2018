Program Uninst;

uses
  Windows, SysUtils, ShellApi, Registry, fpd_language2;

var
  InstDir         : String;
  WinDir          : String;
  Verbindung_Name : String;
  Verb_loeschen   : Boolean;
  sprache         : String[20]; // Sprache (deutsch, englisch, flaemisch, russisch)


function starteProgramm(proggy: string; var fehler: LongBool): TProcessinformation;
var start    : TStartupInfo;
    proginfo : TProcessInformation;
begin
  // die Startup-Informationen des aufrufenden Programmes besorgen
  GetStartupInfo(start);

  // Programm aufrufen, mit normaler Priorität
  fehler := not createprocess(nil, PChar(proggy), nil, nil, true,
       (Normal_PRIORITY_CLASS and CREATE_DEFAULT_ERROR_MODE),
       nil, nil, start, proginfo);

  result := proginfo;
end;

Procedure DelTree(DirName: string);
var f           : Textfile;
    prozessinfo : TProcessInformation;
    fehler      : LongBool;
Begin
  Assignfile(f, DirName[1]+':\fido_del.bat');
  Rewrite(f);
  Writeln(f, '@echo off');
  Writeln(f, DirName[1] + ':\sleep.exe'); // 0,6 Sekunden warten (damit Uninst.exe sich beenden kann)
  Writeln(f, 'del ' + DirName[1] + ':\sleep.exe');
  Writeln(f, 'deltree /y "' + DirName + '"');
  Writeln(f, 'rd "' + DirName + '" /s /q');
  Writeln(f, 'del ' + DirName[1] + ':\fido_del.bat');
  Closefile(f);

  prozessinfo := starteProgramm(DirName[1]+':\fido_del.bat', fehler);
  CloseHandle(prozessinfo.hProcess);
End;

Function DelTree2(DirName : string): Boolean;
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
//   fFlags := FOF_ALLOWUNDO;
//   fFlags := fFlags or FOF_NOCONFIRMATION;
   fFlags := FOF_NOCONFIRMATION;
   fFlags := fFlags or FOF_SILENT;
  end;
   Result := (SHFileOperation(SHFileOpStruct) = 0);
  except
   Result := False;
 end;
end;


procedure Dateien_loeschen;
begin
  {$I-}
  DeleteFile(WinDir + 'unrar.exe');
  DeleteFile(WinDir + 'xarc.exe');
  DeleteFile(WinDir + 'unzip.exe');
  DeleteFile(WinDir + 'zip.exe');
  {$I+}

  CopyFile(PChar(InstDir+'\sleep.exe'), PChar(InstDir[1]+':\'), true);
  DelTree2(InstDir);
  DelTree(InstDir);
end;


procedure Verknuepfungen_auf_Desktop_und_Startmenue_entfernen;
var
//  MyObject  : IUnknown;
//  MySLink   : IShellLink;
//  MyPFile   : IPersistFile;
//  FileName  : String;
  Directory : String;
  WFileName : WideString;
  MyReg     : TRegIniFile;
begin
(*  MyObject := CreateComObject(CLSID_ShellLink);
  MySLink := MyObject as IShellLink;
  MyPFile := MyObject as IPersistFile;
  FileName := InstDir + '\Fido.exe';
  with MySLink do begin
    SetArguments(''); // optionale Parameter
    SetPath(PChar(FileName));
    SetWorkingDirectory(PChar(ExtractFilePath(FileName)));
  end;*)
  MyReg := TRegIniFile.Create(
    'Software\MicroSoft\Windows\CurrentVersion\Explorer');

  // Use the next line of code to put the shortcut on your desktop
  Directory := MyReg.ReadString('Shell Folders','Desktop','');

// Use the next three lines to put the shortcut on your start menu
//  Directory := MyReg.ReadString('Shell Folders','Start Menu','')+'\Fido'; // in den Unterordner Fido im Startmenü
//  Directory := MyReg.ReadString('Shell Folders','Start Menu',''); // direkt im Startmenü
//  CreateDir(Directory);

  WFileName := Directory+'\'+s[0072]+'.lnk'; // auf Desktop
  DeleteFile(WFileName);

  Directory := MyReg.ReadString('Shell Folders','Programs',''); // direkt im Startmenü unerhalb von Programme
  WFileName := Directory+'\Fido'; // im Startmenü
  DelTree2(WFileName);

  MyReg.Free;
end;

procedure Installpfad_auslesen;
var f       : Textfile;
    meldung : String;
begin
  Assignfile(f, 'mh-fido.cfg');
  {$I-} Reset(f); {$I+}
  IF IOResult <> 0 Then Begin
    meldung := 'Konfigurationsdatei (mh-fido.cfg) nicht gefunden.' + Chr(13)
               + 'Installation nicht vollständig oder beschädigt.' + Chr(13)
               + Chr(13)
               + 'Config file (mh-fido.cfg) not found.' + Chr(13)
               + 'Installation not completed or damaged.';
    MessageBoxA(0, PChar(meldung), 'Fehler / Error', MB_OK);
    Halt;
  End;
  Readln(f);
  Readln(f);
  Readln(f);
  Readln(f, WinDir);
  Readln(f, InstDir);
  Readln(f);
  Readln(f);
  Readln(f, Verbindung_Name);
  Verb_loeschen := (Verbindung_Name = 'Fido-Paket deluxe');
  Readln(f, sprache);
  Closefile(f);
  ChDir('\');
end;


begin
  Installpfad_auslesen;
  sprachen_strings_initialisieren(sprache);

  If ParamStr(1) <> 'noask' Then Begin
    If MessageBoxA(0, PChar(s[0108]), PChar(s[0107]),
                   MB_YesNo+MB_DefButton2) = IDno Then Halt;
  End;

  Verknuepfungen_auf_Desktop_und_Startmenue_entfernen;

  Dateien_loeschen;

// Programm muss (schnell) beendet werden, damit Uninst.exe selbst
// auch geloescht werden kann, daher keine MessageBox mehr am Ende
//  MessageBoxA(0, PChar(s[0106]), PChar(' '+s[0107]), MB_Ok+MB_Systemmodal);
end.
