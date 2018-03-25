unit Install;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, jpeg, Buttons;

type
  TForm1 = class(TForm)
    Shape1: TShape;
    imgWelcome: TImage;
    Ueberschrift: TStaticText;
    Begruessung: TStaticText;
    cmdOK: TButton;
    cmdExit: TButton;
    Frage: TStaticText;
    englisch: TBitBtn;
    deutsch: TBitBtn;
    belgien: TBitBtn;
    russisch: TBitBtn;
    cmdUpdate: TButton;
    spanisch: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure cmdExitClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure deutschClick(Sender: TObject);
    procedure englischClick(Sender: TObject);
    procedure belgienClick(Sender: TObject);
    procedure Titel_updaten(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure russischClick(Sender: TObject);
    procedure cmdUpdateClick(Sender: TObject);
    procedure spanischClick(Sender: TObject);
  private
    { Private-Deklarationen}
  public
    { Public-Deklarationen}
  end;

var
  Form1: TForm1;

implementation

uses Registry, Dateneingabe, Background, kopieren, fpd_language;

type Str5 = String[5];

{$R *.DFM}

function laendercode_auslesen: Str5;
var FReg    : TRegistry;
    FLocale : String;
begin
  FReg := TRegistry.Create;
  with FReg do begin
    if OpenKey('\Control Panel\Desktop\ResourceLocale', False) then
    begin {Windows 9x installation language}
    	FLocale := ReadString('');
    	FLocale := LowerCase(Copy(FLocale, length(FLocale) - 3, 4));
    end
    else
    begin {Windows NT installation language}
    	RootKey := HKEY_CURRENT_USER;
    	if OpenKey('\Control Panel\International', False) then
    	begin
    		FLocale := ReadString('Locale');
    		FLocale := LowerCase(Copy(FLocale, length(FLocale) - 3, 4));
    	end;
    end;
  end;
  FReg.Free;

  // Language-IDs von: http://msdn.microsoft.com/library/psdk/winbase/nls_8xo3.htm
  // und: http://www.microsoft.com/globaldev/win2k/setup/lcid.asp
  // internationale Vorwahlen von: http://home.t-online.de/home/ludwig.fw/world3.htm
  sprache := 'deutsch';
  If FLocale = '0407' Then laendercode_auslesen := '49-'        // German (Standard)
  Else If FLocale = '0807' Then laendercode_auslesen := '41-'   // German (Switzerland)
  Else If FLocale = '0c07' Then laendercode_auslesen := '43-'   // German (Austria)
  Else If FLocale = '1007' Then laendercode_auslesen := '352-'  // German (Luxembourg)
//  Else If FLocale = '1407' Then laendercode_auslesen := '41-'   // German (Liechtenstein)
  Else Begin
    sprache := 'flaemisch';
    If FLocale = '0413' Then laendercode_auslesen := '31-'        // Dutch (Netherlands)
    Else If FLocale = '0813' Then laendercode_auslesen := '32-'   // Dutch (Belgium)
    Else Begin
      sprache := 'russisch';
      If FLocale = '0419' Then laendercode_auslesen := '7-'    // Russian
      Else Begin
        sprache := 'spanisch';
        If FLocale = '040a' Then laendercode_auslesen := '34-'        // Spanish (Traditional Sort)
        Else If FLocale = '080a' Then laendercode_auslesen := '52-'   // Spanish (Mexican)
        Else If FLocale = '0c0a' Then laendercode_auslesen := '34-'   // Spanish (Modern Sort)
        Else If FLocale = '100a' Then laendercode_auslesen := '502-'  // Spanish (Guatemala)
        Else If FLocale = '140a' Then laendercode_auslesen := '506-'  // Spanish (Costa Rica)
        Else If FLocale = '180a' Then laendercode_auslesen := '507-'  // Spanish (Panama)
        Else If FLocale = '1c0a' Then laendercode_auslesen := '1809-' // Spanish (Dominican Republic)
        Else If FLocale = '200a' Then laendercode_auslesen := '58-'   // Spanish (Venezuela)
        Else If FLocale = '240a' Then laendercode_auslesen := '57-'   // Spanish (Colombia)
        Else If FLocale = '280a' Then laendercode_auslesen := '51-'   // Spanish (Peru)
        Else If FLocale = '2c0a' Then laendercode_auslesen := '54-'   // Spanish (Argentina)
        Else If FLocale = '300a' Then laendercode_auslesen := '593-'  // Spanish (Ecuador)
        Else If FLocale = '340a' Then laendercode_auslesen := '56-'   // Spanish (Chile)
        Else If FLocale = '380a' Then laendercode_auslesen := '598-'  // Spanish (Uruguay)
        Else If FLocale = '3c0a' Then laendercode_auslesen := '595-'  // Spanish (Paraguay)
        Else If FLocale = '400a' Then laendercode_auslesen := '591-'  // Spanish (Bolivia)
        Else If FLocale = '440a' Then laendercode_auslesen := '503-'  // Spanish (El Salvador)
        Else If FLocale = '480a' Then laendercode_auslesen := '504-'  // Spanish (Honduras)
        Else If FLocale = '4c0a' Then laendercode_auslesen := '505-'  // Spanish (Nicaragua)
        Else If FLocale = '500a' Then laendercode_auslesen := '1787-' // Spanish (Puerto Rico)
        Else Begin
          sprache := 'englisch';
          If FLocale = '0409' Then laendercode_auslesen := '1-'         // English (United States)
          Else If FLocale = '0809' Then laendercode_auslesen := '44-'   // English (United Kingdom)
          Else If FLocale = '0c09' Then laendercode_auslesen := '61-'   // English (Australian)
          Else If FLocale = '1009' Then laendercode_auslesen := '1-'    // English (Canadian)
          Else If FLocale = '1409' Then laendercode_auslesen := '64-'   // English (New Zealand)
          Else If FLocale = '1809' Then laendercode_auslesen := '353-'  // English (Ireland)
          Else If FLocale = '1c09' Then laendercode_auslesen := '27-'   // English (South Africa)
          Else If FLocale = '2009' Then laendercode_auslesen := '1876-' // English (Jamaica)
//          Else If FLocale = '2409' Then laendercode_auslesen := '-' // English (Caribbean)
          Else If FLocale = '2809' Then laendercode_auslesen := '501-'  // English (Belize)
          Else If FLocale = '2c09' Then laendercode_auslesen := '1868-' // English (Trinidad)
          Else If FLocale = '3009' Then laendercode_auslesen := '263-'  // English (Zimbabwe)
          Else If FLocale = '3409' Then laendercode_auslesen := '63-'   // English (Philippines)

          Else If FLocale = '0436' Then laendercode_auslesen := '236-'  // Afrikaans
          Else If FLocale = '041c' Then laendercode_auslesen := '355-'  // Albanian
          Else If FLocale = '0423' Then laendercode_auslesen := '375-'  // Belarussian
          Else If FLocale = '0402' Then laendercode_auslesen := '359-'  // Bulgarian
          Else If FLocale = '041a' Then laendercode_auslesen := '385-'  // Croatian
          Else If FLocale = '0405' Then laendercode_auslesen := '420-'  // Czech
          Else If FLocale = '0406' Then laendercode_auslesen := '45-'   // Danish
          Else If FLocale = '0425' Then laendercode_auslesen := '372-'  // Estonian
          Else If FLocale = '0438' Then laendercode_auslesen := '298-'  // Faeroese
          Else If FLocale = '040b' Then laendercode_auslesen := '358-'  // Finnish
          Else If FLocale = '040c' Then laendercode_auslesen := '33-'   // French (Standard)
          Else If FLocale = '080c' Then laendercode_auslesen := '32-'   // French (Belgian)
          Else If FLocale = '0c0c' Then laendercode_auslesen := '1-'    // French (Canadian)
          Else If FLocale = '100c' Then laendercode_auslesen := '41-'   // French (Switzerland)
          Else If FLocale = '140c' Then laendercode_auslesen := '352-'  // French (Luxembourg)
          Else If FLocale = '180c' Then laendercode_auslesen := '377-'  // French (Monaco)
          Else If FLocale = '0437' Then laendercode_auslesen := '995-'  // Windows 2000: Georgian. This is Unicode only.
          Else If FLocale = '0408' Then laendercode_auslesen := '30-'   // Greek
          Else If FLocale = '040e' Then laendercode_auslesen := '36-'   // Hungarian
          Else If FLocale = '040f' Then laendercode_auslesen := '354-'  // Icelandic
          Else If FLocale = '0421' Then laendercode_auslesen := '62-'   // Indonesian
          Else If FLocale = '0410' Then laendercode_auslesen := '39-'   // Italian (Standard)
          Else If FLocale = '0810' Then laendercode_auslesen := '41-'   // Italian (Switzerland)
          Else If FLocale = '042f' Then laendercode_auslesen := '389-'  // Macedonian
          Else If FLocale = '0414' Then laendercode_auslesen := '47-'   // Norwegian (Bokmal)
          Else If FLocale = '0814' Then laendercode_auslesen := '47-'   // Norwegian (Nynorsk)
          Else If FLocale = '0415' Then laendercode_auslesen := '48-'   // Polish
          Else If FLocale = '0416' Then laendercode_auslesen := '55-'   // Portuguese (Brazil)
          Else If FLocale = '0816' Then laendercode_auslesen := '351-'  // Portuguese (Standard)
          Else If FLocale = '0418' Then laendercode_auslesen := '40-'   // Romanian
          Else If FLocale = '0c1a' Then laendercode_auslesen := '381-'  // Serbian (Cyrillic)
          Else If FLocale = '081a' Then laendercode_auslesen := '381-'  // Serbian (Latin)
          Else If FLocale = '041b' Then laendercode_auslesen := '421-'  // Slovak
          Else If FLocale = '0424' Then laendercode_auslesen := '386-'  // Slovenian
          Else If FLocale = '041d' Then laendercode_auslesen := '46-'   // Swedish
          Else If FLocale = '081d' Then laendercode_auslesen := '358-'  // Swedish (Finland)
          Else If FLocale = '041f' Then laendercode_auslesen := '90-'   // Turkish
          Else If FLocale = '0422' Then laendercode_auslesen := '380-'  // Ukrainian
          Else laendercode_auslesen := '-';
        End;
      End;
    End;
  End;
end;


procedure TForm1.FormCreate(Sender: TObject);
var Fensterbreite: Integer;
    x,y: Integer; // für Bildschirmauflösung
begin
  Scaled := true;
  x := Screen.Width;
  y := Screen.Height;
  if (x<>ScreenWidthDev) or (y<>ScreenHeightDev) then begin
    Hintergrund.Height := (Hintergrund.ClientHeight*y div ScreenHeightDev) +
                           Hintergrund.Height - Hintergrund.ClientHeight;
    Hintergrund.Width := (Hintergrund.ClientWidth*x div ScreenWidthDev) +
                          Hintergrund.Width - Hintergrund.ClientWidth;
//    ScaleBy(x,ScreenWidthDev);
  end; // of if

  sprache := 'deutsch';

  // hier nicht s[0004] benutzen, da Sprachdefinitionen noch nicht initialisiert!
  Ueberschrift.Caption := 'Willkommen zum Fido-Paket deluxe - Installationsprogramm' + Chr(13)
                          + version + ', von Michael Haase (m.haase@gmx.net)';

  If Begruessung.Width > Shape1.Width - Begruessung.Left
   Then Shape1.Width := Begruessung.Width + Begruessung.Left;
  Fensterbreite := Shape1.Width + 40;
  If Fensterbreite > Form1.Width Then
   Form1.Width := Fensterbreite;
  Shape1.Left := (Fensterbreite - Shape1.Width) DIV 2;
  cmdOK.Left := (Trunc(Fensterbreite - cmdOK.Width * 3 - cmdExit.Width) DIV 3) + 5;
  cmdUpdate.Left := cmdOK.Left + cmdOK.Width + 17;
  cmdExit.Left := cmdUpdate.Left + cmdUpdate.Width + 17;
  If Form1.Height < (cmdOK.Top + cmdOK.Height + 40) Then
    Form1.Height := cmdOK.Top + cmdOK.Height + 40;

  If Uppercase(ParamStr(1)) = 'UPDATE' Then Begin
    updaten := True;

    // hier nicht s[0007] benutzen, da Sprachdefinitionen noch nicht initialisiert!
    cmdOK.Caption := '&Update';
  End
  Else updaten := False;

(*
  If Now > StrToDate('30.07.2000') Then Begin
    Application.MessageBox(
        'Diese Version ist veraltet, bitte eine neue Version besorgen.',
        'Hinweis', MB_OK);
    Halt;
  End;
*)

  iv := laendercode_auslesen; // internationale Vorwahl
  sprachen_strings_initialisieren(sprache);
end;

procedure TForm1.cmdExitClick(Sender: TObject);
begin
  Halt(1);
end;

procedure TForm1.cmdOKClick(Sender: TObject);
begin
  Form1.Close;
  If not updaten Then Angaben.Show
                 Else Angaben.Update_durchfuehren(Sender);
  firsttime := false;
end;


procedure TForm1.deutschClick(Sender: TObject);
begin
  cmdOK.SetFocus;
  sprache := 'deutsch';
  sprachen_strings_initialisieren(sprache);
  Font.Charset := DEFAULT_CHARSET;
  Titel_updaten(Sender);
end;

procedure TForm1.englischClick(Sender: TObject);
begin
  cmdOK.SetFocus;
  sprache := 'englisch';
  sprachen_strings_initialisieren(sprache);
  Font.Charset := DEFAULT_CHARSET;
  Titel_updaten(Sender);
end;

procedure TForm1.belgienClick(Sender: TObject);
begin
  cmdOK.SetFocus;
  sprache := 'flaemisch';
  sprachen_strings_initialisieren(sprache);
  Font.Charset := DEFAULT_CHARSET;
  Titel_updaten(Sender);
end;

procedure TForm1.russischClick(Sender: TObject);
begin
  cmdOK.SetFocus;
  sprache := 'russisch';
  sprachen_strings_initialisieren(sprache);
  Font.Charset := RUSSIAN_CHARSET;
  Titel_updaten(Sender);
end;

procedure TForm1.spanischClick(Sender: TObject);
begin
  cmdOK.SetFocus;
  sprache := 'spanisch';
  sprachen_strings_initialisieren(sprache);
  Font.Charset := DEFAULT_CHARSET;
  Titel_updaten(Sender);
end;

procedure TForm1.Titel_updaten(Sender: TObject);
begin
  Application.Title := s[0001];
  Hintergrund.Caption := s[0001];
  Hintergrund.Ueberschrift.Caption := s[0002];
  Form1.Caption := s[0003];
  Ueberschrift.Caption := Format(s[0004], [version]);
  Begruessung.Caption := s[0005];
  Frage.Caption := s[0006];
  If updaten Then cmdOK.Caption := s[0007]
             Else cmdOK.Caption := s[0008];
  cmdExit.Caption := s[0009];
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  If sprache = 'englisch' Then englischClick(Sender)
  Else If sprache = 'flaemisch' Then belgienClick(Sender)
  Else If sprache = 'russisch' Then russischClick(Sender)
  Else If sprache = 'spanisch' Then spanischClick(Sender);
end;

procedure TForm1.cmdUpdateClick(Sender: TObject);
begin
  updaten := True;
  cmdOKClick(Sender);
end;

end.
