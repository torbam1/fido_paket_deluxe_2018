program Fido;

uses
  Forms,
  Windows,
  Install in 'Install.pas' {Form1},
  crc in 'crc.pas',
  Binkley in 'Binkley.pas',
  CDP in 'CDP.pas',
  Dateneingabe in 'Dateneingabe.pas' {Angaben},
  Golded in 'Golded.pas',
  Background in 'Background.pas' {Hintergrund},
  copydir in 'copydir.pas',
  kopieren in 'kopieren.pas' {Installieren},
  DFUE_Netzwerk in 'DFUE_Netzwerk.pas',
  PollAnzeige in 'PollAnzeige.pas' {pollen},
  Verbindung in 'Verbindung.pas',
  PBFolderDialog in 'PBFolderDialog.pas',
  inSuche in 'inSuche.pas' {internetSearch},
  fpd_language in 'fpd_language.pas',
  Ras in 'RAS\Ras.pas',
  Output in 'Output.pas' {DosOutput},
  ExcMagicGUI,
  updatecdp in 'updatecdp.pas' {cdpupdate},
  cdn_input in 'cdn_input.pas' {cdnInput};

{$R *.RES}
{$R WindowsXP.RES}

begin
  HPrevInst := FindWindow('THintergrund', nil);
  If (HPrevInst = 0) or (ParamStr(2) = 'test') Then Begin
    Application.Initialize;
    // hier nicht s[0001] benutzen, da Sprachdefinitionen noch nicht initialisiert!
    Application.Title := 'Fido-Paket deluxe';
    Application.CreateForm(THintergrund, Hintergrund);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TAngaben, Angaben);
  Application.CreateForm(TInstallieren, Installieren);
  Application.CreateForm(Tpollen, pollen);
  Application.CreateForm(TinternetSearch, internetSearch);
  Application.CreateForm(TDosOutput, DosOutput);
  Application.CreateForm(Tcdpupdate, cdpupdate);
  Application.CreateForm(TcdnInput, cdnInput);
  Application.Run;
  End
  Else Begin
    Windows.SetFocus(HPrevInst);
    Windows.SetForegroundWindow(HPrevInst);
  End;
end.
