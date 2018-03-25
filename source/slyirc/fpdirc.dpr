program fpdirc;

uses
  Forms,
  IrcMain in 'IrcMain.pas' {frmIrcMain},
  fpd_language in '..\fpd_language.pas';

{$R *.RES}
{$R WindowsXP.RES}

begin
  Application.Initialize;
  Application.Title := 'IRC - Chatten mit anderen Fidoleuten..';
  Application.CreateForm(TfrmIrcMain, frmIrcMain);
  Application.Run;
end.
