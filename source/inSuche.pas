unit inSuche;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

procedure suchen(var forced: Boolean);

type
  TinternetSearch = class(TForm)
    info: TLabel;
    inForce: TButton;
    abbruch: TButton;
    procedure abbruchClick(Sender: TObject);
    procedure inForceClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  internetSearch : TinternetSearch;
  fertig         : Boolean;

implementation

uses Dateneingabe, fpd_language;

var forced_in: Boolean;

{$R *.DFM}

procedure suchen(var forced: Boolean);
var i: Integer;
begin
  fertig := false;
  forced_in := forced;

  For i := 1 To 1500 Do Begin
    Sleep(10);
    If i mod 100 = 0 Then
     internetSearch.info.Caption := internetSearch.info.Caption + '.';
    Application.ProcessMessages;
    If Angaben.isUserOnline or fertig Then break;
  End;

  forced := forced_in;
  internetSearch.Close;
end;

procedure TinternetSearch.abbruchClick(Sender: TObject);
begin
  fertig := true;
end;

procedure TinternetSearch.inForceClick(Sender: TObject);
begin
  forced_in := true;
  fertig := true;
end;

procedure TinternetSearch.FormShow(Sender: TObject);
begin
  If sprache <> 'deutsch' Then Begin // deutsche Beschriftungen sind
    info.Caption := s[0102];         // schon in der Form drin
    inForce.Caption := s[0103];
    abbruch.Caption := s[0090];
  End;
end;

end.
