unit PollAnzeige;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  Tpollen = class(TForm)
    Info: TLabel;
    Info2: TLabel;
    CBAbbruch: TButton;
    Info3: TEdit;
    procedure CBAbbruchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private-Deklarationen}
  public
    { Public-Deklarationen}
  end;

var
  pollen      : Tpollen;
  PollAbbruch : Boolean = false;

implementation

{$R *.DFM}

uses fpd_language, HMenue, Output;

procedure Tpollen.CBAbbruchClick(Sender: TObject);
begin
  PollAbbruch := true;
  DosOutput.RunProcess1.AbortWait := TRUE;
  Application.ProcessMessages;
end;

procedure Tpollen.FormCreate(Sender: TObject);
begin
  If pollen.Width < (Info3.Width + 40) Then
    pollen.Width := Info3.Width + 40;
  pollen.Caption := ' ' + s[0234];
end;

procedure Tpollen.FormShow(Sender: TObject);
begin
  PollAbbruch := false;
end;

procedure Tpollen.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  PollAbbruch := true;
end;

end.
