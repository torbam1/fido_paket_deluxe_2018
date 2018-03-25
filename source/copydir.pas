unit copydir; { Verzeichnis kopieren}

interface

uses comctrls; // hinzugefügt für Progress-Bar

function CopyDirectory(sourcedir,destdir:string; withsubdirs: boolean; Var first:byte; updaten: Boolean): boolean;
function ExistDir(name:string):boolean;
function CreateDirFull(name:string):boolean;
procedure MaxoutFortschrittsanzeige;

{---------------------------------------------------------------------}
implementation

uses SysUtils, Windows, StdCtrls, Forms, kopieren;

var Fortschrittsanzeige : TProgressBar; // hinzugefügt für Progress-Bar

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
function CopyDirectory(sourcedir,destdir:string; withsubdirs: boolean; Var first:byte; updaten: Boolean): boolean;
var sourcemask      : string[12];
    sr              : TSearchRec;
    found           : integer;
    fail            : boolean;
    kopierenErlaubt : boolean;
    dname, dpfad    : string;

 procedure FormPath(var s:string);
 begin
   s := extractfilepath(s); {nur path-angabe verwenden}
   if s = '' then s := ExpandFileName(''); {ins aktuelle dir}
   if s[length(s)] <> '\' then s := s + '\';
 end;

begin
  If first = 1 Then // hinzugefügt für Progress-Bar
  Begin
    Fortschrittsanzeige := TProgressBar.Create(Installieren);
    Fortschrittsanzeige.Top := 92;
    Fortschrittsanzeige.Width := 369;
    Fortschrittsanzeige.Height := 26;
    Fortschrittsanzeige.Left := 48;
    Fortschrittsanzeige.Parent := Installieren;
    Fortschrittsanzeige.Step := 1;
    Fortschrittsanzeige.Max := 131;
//    If updaten Then Fortschrittsanzeige.Max := 94 // Anzahl zu kopierender Dateien
//               Else Fortschrittsanzeige.Max := 127;

    first := 2;
  End;

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
      Fortschrittsanzeige.StepIt;
      Application.ProcessMessages;

      kopierenErlaubt := True;

      if updaten Then Begin
        dname := UpperCase(sr.name);
        dpfad := UpperCase(sourcedir);
        if (Pos('.BAT', dname) > 0) or (Pos('.CFG', dname) > 0)
           or (Pos('.TPL', dname) > 0) or (Pos('CONFIG', dname) > 0)
          Then kopierenErlaubt := False;
        if (Pos('FIDOINFO\NODE', dpfad) > 0)
           and (Pos('FILECMP.EXE', dname) = 0)
          Then kopierenErlaubt := False;
        if (Pos('BINKLEY\MSGBASE', dpfad) > 0)
          Then kopierenErlaubt := False;
      End;

      if kopierenErlaubt Then Begin
        if not copyfile(PChar(sourcedir+sr.name),
               PChar(destdir+sr.name), false) {Overwrite existing}
         then fail:=true
         else FileSetAttr(destdir+sr.name, 0); // alle Attribute löschen
      end;
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
        destdir + sr.name + '\',withsubdirs, first, updaten)
         then fail := true;
      end;
      found := findnext(sr);
    end;
    sysutils.FindClose(sr);
  end;

  Result := not fail;
end;

procedure MaxoutFortschrittsanzeige;
begin
  Fortschrittsanzeige.Position := Fortschrittsanzeige.Max;
end;


end.
