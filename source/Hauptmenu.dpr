{**********************************************************************}
{ File archived using GP-Version                                       }
{ GP-Version is Copyright 1999 by Quality Software Components Ltd      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.qsc.co.uk                                                 }
{**********************************************************************}
{}
{ $Log:  C:\Programme\Borland\GP-Version lite\Archives\Fido-Paket Menü\Fido\Hauptmenu.dpV
{
{   Rev 1.1    25.05.2001 18:58:25  Michael
{ v1.4
}
{}
program Hauptmenu;

uses
  Forms,
  Windows,
  HMenue in 'HMenue.pas' {Hauptmenue},
  Echos in 'Echos.pas' {EchoVerwaltung},
  Config in 'Config.pas' {Konfiguration},
  Verbindung in 'Verbindung.pas',
  PollAnzeige in 'PollAnzeige.pas' {pollen},
  Logfile in 'Logfile.pas' {frmLogfile},
  FidoInfos in 'FidoInfos.pas' {fidoInfo},
  Ras in 'ras\Ras.pas',
  fpd_language in 'fpd_language.pas',
  Output in 'Output.pas' {DosOutput},
  AcrobatPDF in 'AcrobatPDF.pas',
  ExcMagicGUI,
  pdf in 'pdf.pas' {frmPdf};

{$R *.RES}
{$R WindowsXP.RES}

begin
  HPrevInst := FindWindow('THauptmenue', nil);
  // verhindern, dass mehrere Instanzen gestartet werden
  If (HPrevInst = 0)  or (ParamStr(1) = 'test') or (ParamStr(2) = 'test') Then Begin
    Application.Initialize;
    Application.Title := 'Fido-Paket Menü';
    Application.CreateForm(THauptmenue, Hauptmenue);
  Application.CreateForm(TEchoVerwaltung, EchoVerwaltung);
  Application.CreateForm(Tpollen, pollen);
  Application.CreateForm(TfrmLogfile, frmLogfile);
  Application.CreateForm(TfidoInfo, fidoInfo);
  Application.CreateForm(TDosOutput, DosOutput);
  Application.CreateForm(TKonfiguration, Konfiguration);
  Application.Run;
  End
  Else Begin
    // zur bereits aktiven Instanz wechseln
    Windows.SetFocus(HPrevInst);
    Windows.SetForegroundWindow(HPrevInst);
  End;
end.
