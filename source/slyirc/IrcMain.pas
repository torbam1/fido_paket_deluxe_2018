unit IrcMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SlyIrc, ComCtrls, WSocket, CoolTrayIcon, Menus,
  ImgList, WinInet, ExcMagicGUI;

type
  TfrmIrcMain = class(TForm)
    pnlButtons: TPanel;
    edtPort: TEdit;
    edtNick: TEdit;
    edtAltNick: TEdit;
    lblHost: TLabel;
    lblPort: TLabel;
    lblNicks: TLabel;
    btnConnect: TButton;
    btnQuit: TButton;
    sbrMain: TStatusBar;
    pnlStatus: TPanel;
    edtUsername: TEdit;
    lblUsername: TLabel;
    chkStdMsgs: TCheckBox;
    pnlCommand: TPanel;
    edtCommand: TEdit;
    chkInvisible: TCheckBox;
    chkServerNotices: TCheckBox;
    memStatus: TRichEdit;
    edtHost: TComboBox;
    chkWriteLog: TCheckBox;
    NamesListe: TListBox;
    LNicks: TLabel;
    chkRemind: TCheckBox;
    InactivityTimer: TTimer;
    LSchriftgroesse: TLabel;
    CBsize: TComboBox;
    IrcTray: TCoolTrayIcon;
    chkTray: TCheckBox;
    PopupMenu1: TPopupMenu;
    ShowWindow1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    IrcIcons: TImageList;
    autoConnectTimer: TTimer;
    TimerCheckConnection: TTimer;
    chkBeep: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure InitialisiereIrc;
    procedure FormDestroy(Sender: TObject);
    function  IsUserOnline: Boolean;
    procedure btnConnectClick(Sender: TObject);
    procedure btnQuitClick(Sender: TObject);
    procedure edtCommandKeyPress(Sender: TObject; var Key: Char);
    procedure chkInvisibleClick(Sender: TObject);
    procedure chkServerNoticesClick(Sender: TObject);
    procedure chkWriteLogClick(Sender: TObject);
    procedure InactivityTimerTimer(Sender: TObject);
    procedure pnlStatusResize(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure CBsizeChange(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure chkRemindClick(Sender: TObject);
    procedure chkStdMsgsClick(Sender: TObject);
    procedure chkTrayClick(Sender: TObject);
    procedure ShowWindow1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Minimize(Sender: TObject);
    procedure autoConnectTimerTimer(Sender: TObject);
    procedure TimerCheckConnectionTimer(Sender: TObject);
  private
    FSlyIrc: TSlyIrc;
    procedure SlyIrcReceive(Sender: TObject; msg: String);
    procedure SlyIrcAfterStateChange(Sender: TObject);
    procedure SlyIrcResponse(Sender: TObject; ATokens: TIrcToken;
      var Suppress: Boolean);
    procedure SlyIrcUserModeChanged(Sender: TObject);
    procedure AddText(msg: String; farbe: TColor = clWindowText);
    procedure LogfileOeffnen;
    procedure LogfileSchliessen;
  public
  end;

var
  frmIrcMain : TfrmIrcMain;
  minimiert  : Boolean = False;

implementation

uses fontheight, Bleeper, BleepInt, fpd_language;

{$R *.DFM}

const
  StateDesc: array [TSlyIrcState] of String = ('Not connected', 'Resolving host', 'Connecting', 'Connected',
    'Registering', 'Ready', 'Aborting', 'Disconnecting');
  ScreenWidthDev  = 1280;
  ScreenHeightDev = 1024;

var
  chatlog      : String;
  firstlog     : Boolean;
  log          : Textfile;
//  FensterAktiv : Boolean;
  LogfileOffen : Boolean = False;
  InstDir      : String;
  versionsnr   : String;
  meldung      : String;
  MausDown     : Boolean = False;
  NickPasswort : String;
  otherResolution   : Boolean = false;
  x,y               : Integer; // für Bildschirmauflösung
  bigFonts          : Boolean = false;
  abortingCounter   : Byte = 0;
  Verbindung        : Boolean = False;
  FormCreated       : Boolean = False;

procedure TfrmIrcMain.FormCreate(Sender: TObject);
var f      : Textfile;
    zeile  : String;
    i      : Integer;
    laenge : Integer;
    DC     : hDc;
begin
  autoConnectTimer.Enabled := False;

  If (ParamStr(2) = '-tray') or (ParamStr(3) = '-tray')
   Then Begin
     // wenn durch Verknüpfung minimiert gestartet wurde, dann diese
     // Minimierung aufheben (geht in Konflikt mit CoolTray), das Prog
     // wird durch CoolTray automatisch minimiert
     If CmdShow = SW_SHOWMINNOACTIVE Then CmdShow := SW_RESTORE;

     autoConnectTimer.Enabled := True;
   End;

  Scaled := true;
  x := Screen.Width;
  y := Screen.Height;
  if (x<>ScreenWidthDev) or (y<>ScreenHeightDev) then begin
    If not SmallFonts Then Begin
      bigFonts := true;
      DC := GetDC(0);
      ScaleBy(96,GetDeviceCaps(DC,LOGPIXELSX));
      ReleaseDC(0,DC);
      Refresh;
    End;
  end; // of if
  Font.OnChange(Self);

  InstDir := ParamStr(1);
  If InstDir = '' Then Begin
    Application.Messagebox('No parameter for Fido-Package deluxe installation directory is given.', 'Error', MB_ok);
    Halt(1);
  End;

  Assignfile(f, InstDir + '\mh-fido.cfg');
  {$I-} Reset(f); {$I+}
  IF IOResult <> 0 Then Begin
    autoConnectTimer.Enabled := False;
    meldung := 'Konfigurationsdatei (mh-fido.cfg) nicht gefunden.' + Chr(13)
               + 'Installation nicht vollständig oder beschädigt.' + Chr(13)
               + Chr(13)
               + 'Config file (mh-fido.cfg) not found.' + Chr(13)
               + 'Installation not completed or damaged.';
    Application.MessageBox(PChar(meldung), 'Fehler / Error', MB_OK);
    Halt(1); // Programm beenden
  End;
  For i := 1 To 8 Do Readln(f);
  Readln(f, sprache);
  For i := 1 To 2 Do Readln(f);
  Readln(f, versionsnr);
  Closefile(f);

  If versionsnr = '' Then Begin
    Application.Messagebox('No parameter for Fido-Package deluxe version number is given.', 'Error', MB_ok);
    Halt(1);
  End;

  sprachen_strings_initialisieren(sprache);

  NickPasswort := ParamStr(2);
  If NickPasswort = '-tray' Then NickPasswort := '';

  CBsize.ItemIndex := 0;

  laenge := Screen.Width - 15;
  If (frmIrcMain.Left + frmIrcMain.Width) > laenge Then
   While (frmIrcMain.Left > 5) and
         ((frmIrcMain.Left + frmIrcMain.Width) > laenge) Do
    frmIrcMain.Left := frmIrcMain.Left - 5;

  laenge := Screen.Height - 30;
  If (frmIrcMain.Top + frmIrcMain.Height) > laenge Then
   While (frmIrcMain.Top > 5) and
         ((frmIrcMain.Top + frmIrcMain.Height) > laenge) Do
    frmIrcMain.Top := frmIrcMain.Top - 5;

  Application.OnMinimize := Minimize;

  edtUsername.Text := '';
  Assignfile(f, InstDir + '\golded\golded.cfg');
  {$I-} Reset(f); {$I+}
  If IOResult = 0 Then Begin
    zeile := '';
    While not EOF(f) and (Pos('USERNAME', zeile) <> 1) Do Readln(f, zeile);
    If Pos('USERNAME', zeile) = 1 Then Begin
      Delete(zeile,1,9);
      While (Length(zeile) > 2) and (zeile[1] = ' ') Do Delete(zeile,1,1);
      While (Length(zeile) > 2) and (zeile[Length(zeile)] = ' ') Do
       Delete(zeile,Length(zeile),1); // Leerzeichen am Anfang und Ende löschen
      edtUsername.Text := zeile;
    End;
    While not EOF(f) and (Pos('ADDRESS', zeile) <> 1) Do Readln(f, zeile);
    If Pos('ADDRESS', zeile) = 1 Then Begin
      Delete(zeile,1,8);
      While (Length(zeile) > 2) and (zeile[1] = ' ') Do Delete(zeile,1,1);
      i := Pos(' ', zeile);
      If i > 1 Then zeile := Copy(zeile,1,i-1);
      edtUsername.Text := edtUsername.Text + ' (' + zeile + ')';
    End;
    Closefile(f);
  End;

  edtHost.Items.Clear;
//  edtHost.Items.Add('fs1-cccbbs');
  edtHost.Items.Add('irc.icq.com');
//  edtHost.Items.Add('irc.quakenet.eu.org');
//  edtHost.Items.Add('cccbbs.dyn.dhs.org');
  edtHost.ItemIndex := 0;

  If edtUsername.Text <> '' Then Begin
    edtUsername.Enabled := False;

    // Vorname als Nick
    edtNick.Text := edtUsername.Text;
    i := Pos(' ', edtNick.Text);
    If i > 0 Then edtNick.Text := Copy(edtNick.Text,1,i-1);
    If edtNick.Text = 'Michael' Then edtNick.Text := 'Micha';
    If Pos('Karl - Heinz', edtUsername.Text) = 1 Then edtNick.Text := 'Chopper';
    If Pos('Stefan Buschmann', edtUsername.Text) > 0 Then edtNick.Text := 'Buschi';
    If Pos('Gerhard Krueger', edtUsername.Text) > 0 Then edtNick.Text := 'Bilbo';

    // Unterstrich vor Nick setzen (weil einige Namen schon registiert sind)
    edtNick.Text := '_' + edtNick.Text;

    // alternativen Nick setzen
    edtAltNick.Text := edtNick.Text + '2';
  End;

  frmIrcMain.Caption := 'IRC - ' + s[0244];

  chatlog := InstDir + '\irc-chat.log';
  Assignfile(log, chatlog);
  firstlog := True;

//  SetWindowLong(Handle, GWL_EXSTYLE, WS_EX_APPWINDOW); // Fenster in Taskleiste
//  FensterAktiv := True;

  InitialisiereIrc;

  FormCreated := True;
end;

procedure TfrmIrcMain.InitialisiereIrc;
begin
  FSlyIrc := TSlyIrc.Create(nil);
  FSlyIrc.OnReceive := SlyIrcReceive;
  FSlyIrc.OnAfterStateChange := SlyIrcAfterStateChange;
  FSlyIrc.OnResponse := SlyIrcResponse;
  FSlyIrc.OnUserModeChanged := SlyIrcUserModeChanged;
end;

procedure TfrmIrcMain.FormDestroy(Sender: TObject);
begin
  FSlyIrc.Free;
end;

function TfrmIrcMain.IsUserOnline: Boolean;
var connect_status: dword;
begin
  connect_status := 2 {user uses a lan}    +
                    1 {user uses a modem.} +
                    4 {user uses a proxy}  ;
  result := InternetGetConnectedState(@connect_status,0);
end;

procedure TfrmIrcMain.btnConnectClick(Sender: TObject);
var s: String;
    i: Integer;
begin
  If FSlyIrc.State = isAborting Then Begin
    AddText('Initialisiere neu...');
    FSlyIrc.Destroy;
    InitialisiereIrc;
  End;

  // bis zu 1 Sekunde prüfen, ob Internet-Verbindung bereits besteht
  For i := 1 To 100 Do Begin
    Sleep(10);
    Application.ProcessMessages;
    If isUserOnline Then break;
  End;

  If not isUserOnline Then Begin
    AddText('Keine Internet-Verbindung festgestellt - Abbruch.');
    If not autoConnectTimer.Enabled
     Then Exit
     Else AddText('Versuche weiter...');
  End;

  FSlyIrc.Host := edtHost.Items.Strings[edtHost.ItemIndex];
  FSlyIrc.Port := edtPort.Text;
  FSlyIrc.Nick := edtNick.Text;
  FSlyIrc.AltNick := edtAltNick.Text;

  // falls Passwort für Nick übergeben, dann setzen (ansonsten ist es '')
  FSlyIrc.Password := NickPasswort;

  // wenn invisible, dann Nick und AltNick ändern
  if chkInvisible.Checked then begin
    FSlyIrc.Nick := '{' + FSlyIrc.Nick;
    FSlyIrc.AltNick := '{' + FSlyIrc.AltNick;
  end;

  // Userliste löschen
  NamesListe.Clear;

  s := edtUsername.Text;
  // nur Vorname (keine Leerzeichen erlaubt!)
  If Pos(' ', s) > 0 Then s := Copy(s,1,Pos(' ', s)-1);
  FSlyIrc.Username := s;
  FSlyIrc.Realname := edtUsername.Text + ' (' + versionsnr + ')';

  AddText('Connecting...');
  FSlyIrc.Connect;
  If FormCreated and frmIrcMain.Active Then edtCommand.SetFocus;
  If chkWriteLog.checked Then LogfileOeffnen;
  InactivityTimer.Enabled := True;

  TimerCheckConnection.Enabled := True;
  abortingCounter := 0;
end;

procedure TfrmIrcMain.btnQuitClick(Sender: TObject);
begin
  TimerCheckConnection.Enabled := False;
  FSlyIrc.Quit('Bye bye');
  If chkWriteLog.checked Then LogfileSchliessen;
  InactivityTimer.Enabled := False;
end;

procedure TfrmIrcMain.SlyIrcReceive(Sender: TObject; msg: String);
var i       : Integer;
    nick    : String;
    farbe   : TColor;
    s, msg2 : String;
begin
  If Pos('PING :', msg) = 1 Then Exit;

  farbe := clWindowText;

  If Pos(' PRIVMSG ', msg) > 0 Then Begin
    Delete(msg,1,1);
    i := Pos('!', msg);
    nick := Copy(msg,1,i-1);
    i := Pos(' PRIVMSG ', msg);
    Delete(msg,1,i+8);
    i := Pos(':', msg);
    If msg[1] <> '#' Then Begin // private Mail (flüstern)
      nick := ':' + nick;
      farbe := clTeal;
    End
    Else farbe := clBlue;
    nick := '<' + nick + '> ';
    Delete(msg,1,i);
    While Pos(#2, msg) > 0 Do Delete(msg, Pos(#2, msg), 1);
    msg := nick + msg;

    // ACTION Handlung abfangen..
    s := Chr(1) + 'ACTION ';
    If (Pos(s, msg) > 0) and (msg[Length(msg)] = Chr(1)) Then Begin
      Delete(msg,1,1);
      i := Pos('>', msg);
      Delete(msg,i,1);
      i := Pos(s, msg);
      Delete(msg,i,Length(s));
      Delete(msg,Length(msg),1);
    End
    Else If (not InactivityTimer.Enabled) and chkBeep.Checked
      Then Bleep(bInterrupt); // Beep if away

    If not frmIrcMain.Active and chkRemind.checked Then Begin
      If minimiert Then IrcTray.IconIndex := 1;
      FlashWindow(Application.Handle,true);
      Sleep(300);
      FlashWindow(Application.Handle,true);
    End;
  End
  Else If Pos(' JOIN :', msg) > 0 Then Begin
    Delete(msg,1,1);
    i := Pos('!', msg);
    nick := Copy(msg,1,i-1);
    i := Pos(':', msg);
    Delete(msg,1,i);
    msg := nick + ' joined ' + msg + '.';
    If msg[1] = '{' Then msg := '';
  End
  Else If Pos(' QUIT :', msg) > 0 Then Begin
    Delete(msg,1,1);
    i := Pos('!', msg);
    msg := Copy(msg,1,i-1) + ' has quit.';
  End
  Else If Pos(' PART #', msg) > 0 Then Begin
    Delete(msg,1,1);
    i := Pos('!', msg);
    nick := Copy(msg,1,i-1);
    i := Pos(' PART #', msg);
    Delete(msg,1,i+5);
    i := Pos(':', msg);
    msg := nick + ' left ' + Copy(msg,1,i-2) + '.';
  End
  Else If Pos(' NICK :', msg) > 0 Then Begin
    Delete(msg,1,1);
    i := Pos('!', msg);
    nick := Copy(msg,1,i-1);
    i := Pos(':', msg);
    Delete(msg,1,i);
    msg := nick + ' changed NICK into ' + msg + '.';
    If FSlyIrc.Nick = msg Then Caption := Format('%s on %s - IRC - ' + s[0244],
                                                 [FSlyIrc.Nick, FSlyIrc.Host]);
  End
  Else If Pos(' MODE ', msg) > 0 Then Begin
    msg2 := msg;
    i := Pos(' MODE ', msg);
    Delete(msg,1,i+5);
    If (msg[1] = '#') and (Pos(' +nt', msg) > 2)
     Then FSlyIrc.RenameNick(FSlyIrc.Nick, '@'+FSlyIrc.Nick)
     Else Begin
       i := Pos(' ', msg);
       nick := Copy(msg,1,i-1);
       Delete(msg,1,i);
       s := Copy(msg,1,2);
       Delete(msg,1,3);
       If Length(msg) > 0 Then nick := msg;
       If nick[Length(nick)] = ' ' Then Delete(nick,Length(nick),1);
       If nick[1] = '@' Then Delete(nick,1,1);
       If s = '+o' Then FSlyIrc.RenameNick(nick, '@'+nick)
       Else If s = '-o' Then FSlyIrc.RenameNick('@'+nick, nick)
       Else If s = '+v' Then msg := '';
     End;
     msg := msg2;
  End
  Else If Pos('ERROR :Closing Link:', msg) = 1 Then Delete(msg,1,7)
  Else msg := '>> ' + msg;

  If msg <> '' Then AddText(msg, farbe);
end;

procedure TfrmIrcMain.AddText(msg: String; farbe: TColor = clWindowText);
begin
  While MausDown Do Sleep(1); // wenn Mausbutton gedrückt, dann scrollen
                              // verhindern und warten

  // wenn Standardmeldungen (in schwarz) unterdrückt werden sollen,
  // dann rausgehen
  If (not chkStdMsgs.Checked) and (farbe = clWindowText) Then Exit;

  // Uhrzeit davor schreiben
  msg := Copy(TimeToStr(Time),1,5) + ' ' + msg;

  with memStatus do begin
    while Lines.Count>1000 do memStatus.Lines.Delete(0);

    Lines.Add(msg);

    If farbe <> clWindowText Then Begin
      SelStart := Length(memStatus.Text) - Length(msg) - 2;
      SelLength := Length(msg);
      SelAttributes.Color := farbe;
    End;

    SelStart:=length(memStatus.Text);
    SendMessage(handle,EM_SCROLLCARET,SelStart,0);
  end;

  If chkWriteLog.Checked Then Begin
    {$I-} Writeln(log, TimeToStr(Time) + ': ' + msg); {$I+}
    IOResult;
  End;
end;

procedure TfrmIrcMain.SlyIrcAfterStateChange(Sender: TObject);
begin
  sbrMain.SimpleText := StateDesc[FSlyIrc.State];
  case FSlyIrc.State of
    isNotConnected:
      begin
        AddText('Disconnected');
        Caption := 'IRC - ' + s[0244];
        InactivityTimer.Enabled := False;
      end;
    isResolvingHost:
      AddText('Resolving host');
    isConnecting:
      AddText('Connecting to host');
    isConnected:
      AddText('Connected to host');
    isRegistering:
      AddText('Registering');
    isReady:
      Caption := Format('%s on %s - IRC - ' + s[0244], [FSlyIrc.Nick, FSlyIrc.Host]);
    isAborting:
      AddText('Aborting connection');
    isDisconnecting:
      AddText('Disconnecting');
  end;
end;

procedure TfrmIrcMain.SlyIrcResponse(Sender: TObject; ATokens: TIrcToken;
  var Suppress: Boolean);
//var Line: String;
//    Index: Integer;
begin
{
  if chkShowTokens.Checked then
  begin
    Line := '"' + ATokens[0] + '"';
    for Index := 1 to ATokens.Count - 1 do
      Line := Line + ', "' + ATokens[Index] + '"';
    AddText(Line);
  end;
}
end;

procedure TfrmIrcMain.edtCommandKeyPress(Sender: TObject; var Key: Char);
var s    : String;
    i    : Integer;
    nick : String;
begin
  // Inactivity Timer zurücksetzen
  InactivityTimer.Enabled := False;
  InactivityTimer.Enabled := True;
  If Pos('|Away', FSlyIrc.Nick) > 1 Then Begin
    s := 'nick ' + Copy(FSlyIrc.Nick,1,Length(FSlyIrc.Nick)-Length('|Away'));
    FSlyIrc.Send(s);
  End;

  // wenn Return gedrückt, dann..
  if Key = #13 then begin
    { Suppress beep. }
    Key := #0;

    s:=edtCommand.Text;
    edtCommand.Text:='';

    If s = '' Then s := ' ';

    if s[1]='/' then begin
      If s = '/admin' Then Begin
        chkInvisible.Visible := True;
        chkServerNotices.Visible := True;
        edtHost.Items.Add('irc.quakenet.eu.org');
//        chkShowTokens.Visible := True;
        edtPort.Enabled := True;
      End
      Else If Pos('/add ', s) = 1 Then edtHost.Items.Add(Copy(s,6,Length(s)))
      Else If Pos('/msg ', s) = 1 Then Begin // flüstern
        Delete(s,1,5);
        i := Pos(' ', s);
        nick := Copy(s,1,i-1);
        Delete(s,1,i);
        AddText('<' + FSlyIrc.GetNick + ':' + nick + '> ' + s, clTeal);
        FSlyIrc.PrivMsg(nick, s);
      End
      Else Begin
        If Pos('/join ', s) = 1 Then FSlyIrc.channel := Copy(s,7,Length(s));
        AddText(s);
        FSlyIrc.Send(Copy(s,2,Length(s)-1));
      End;
    end
    else begin
      AddText('<' + FSlyIrc.GetNick + '> ' + s, clMaroon);
      FSlyIrc.PrivMsg(FSlyIrc.GetChannel, s);
    end;
  end;
end;

procedure TfrmIrcMain.SlyIrcUserModeChanged(Sender: TObject);
begin
  AddText('User mode changed');
end;

procedure TfrmIrcMain.chkInvisibleClick(Sender: TObject);
var nick: String;
begin
  nick := FSlyIrc.GetNick;
  if chkInvisible.Checked then begin
    FSlyIrc.UserModes := FSlyIrc.UserModes + [umInvisible];
    FSlyIrc.Send('nick ' + '{'+nick);
    InactivityTimer.Enabled := False;
  end
  else begin
    FSlyIrc.UserModes := FSlyIrc.UserModes - [umInvisible];
    Delete(nick,1,1);
    FSlyIrc.Send('nick ' + nick);
    InactivityTimer.Enabled := True;
  end;

  edtCommand.SetFocus;
end;

procedure TfrmIrcMain.chkServerNoticesClick(Sender: TObject);
begin
  if chkServerNotices.Checked then
    FSlyIrc.UserModes := FSlyIrc.UserModes + [umServerNotices]
  else
    FSlyIrc.UserModes := FSlyIrc.UserModes - [umServerNotices];

  edtCommand.SetFocus;
end;

procedure TfrmIrcMain.LogfileOeffnen;
begin
  If LogfileOffen Then Exit; // bereits geöffnet?

  If FileExists(chatlog) Then Append(log)
  Else Begin
    Rewrite(log);
    firstlog := True;
  End;

  LogfileOffen := True;
  Writeln(log, '>>>  ' + DateTimeToStr(Now) + '  >>>>>>>>>>>>>>>>>>');
  AddText('[Logfile opened]');
end;

procedure TfrmIrcMain.LogfileSchliessen;
begin
  If not LogfileOffen Then Exit; // bereits geschlossen?

  Writeln(log, '<<<  ' + DateTimeToStr(Now) + '  <<<<<<<<<<<<<<<<<<');
  Writeln(log);
  Closefile(log);
  LogfileOffen := False;
  AddText('[Logfile closed]');
end;

procedure TfrmIrcMain.chkWriteLogClick(Sender: TObject);
var i, j: Integer;
begin
  If chkWriteLog.Checked Then Begin
    LogfileOeffnen;
    j := 0;
    If not firstlog Then Begin
      For i := (memStatus.Lines.Count-1) DownTo 0 Do
       If memStatus.Lines.Strings[i] = '[Logfile closed]' Then Begin
         If i < (memStatus.Lines.Count-1) Then j := i+1
                                          Else j := i;
         break;
       End;
    End;
    For i := j To (memStatus.Lines.Count-1) Do
     Writeln(log, memStatus.Lines.Strings[i])
  End
  Else LogfileSchliessen;

  If FormCreated and frmIrcMain.Active Then edtCommand.SetFocus;

  firstlog := False;
end;

procedure TfrmIrcMain.InactivityTimerTimer(Sender: TObject);
var s: String;
begin
  If (FSlyIrc.Nick[1] <> '{') // not invisible
     and (Pos('|', FSlyIrc.Nick) = 0) Then Begin // and not away
//    s := 'AutoMessage: User is away..';
//    AddText(s, clMaroon);
//    FSlyIrc.PrivMsg(FSlyIrc.GetChannel, s);
    s := 'nick ' + FSlyIrc.Nick + '|Away';
    FSlyIrc.Send(s);
  End;
  InactivityTimer.Enabled := False;
end;

procedure TfrmIrcMain.pnlStatusResize(Sender: TObject);
begin
  memStatus.Height := sbrMain.Top - 103;
  NamesListe.Height := sbrMain.Top - 103;
end;

procedure TfrmIrcMain.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  Resize := (NewWidth > 646) and (NewHeight > 280);
//  NewWidth := 647;
end;

procedure TfrmIrcMain.CBsizeChange(Sender: TObject);
begin
  memStatus.Font.Size := StrToInt(CBsize.Items.Strings[CBsize.ItemIndex]);
end;

procedure TfrmIrcMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MausDown := True;
end;

procedure TfrmIrcMain.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MausDown := False;
end;

procedure TfrmIrcMain.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  If LogfileOffen Then LogfileSchliessen;
end;

procedure TfrmIrcMain.FormResize(Sender: TObject);
begin
  memStatus.Width := NamesListe.Left + 1;
  LNicks.Left := NamesListe.Left + 6;
end;

procedure TfrmIrcMain.chkRemindClick(Sender: TObject);
begin
  edtCommand.SetFocus;
end;

procedure TfrmIrcMain.chkStdMsgsClick(Sender: TObject);
begin
  edtCommand.SetFocus;
end;

procedure TfrmIrcMain.chkTrayClick(Sender: TObject);
begin
  IrcTray.MinimizeToTray := chkTray.State = cbChecked;
end;

procedure TfrmIrcMain.ShowWindow1Click(Sender: TObject);
begin
  minimiert := False;
  IrcTray.IconIndex := 0;
  IrcTray.ShowMainForm;
  IrcTray.IconVisible := false;
end;

procedure TfrmIrcMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmIrcMain.Minimize(Sender: TObject);
begin
  minimiert := True;
end;

procedure TfrmIrcMain.autoConnectTimerTimer(Sender: TObject);
begin
  autoConnectTimer.Enabled := False;

  If FSlyIrc.State = isNotConnected Then Begin
    chkTray.Checked := True;
    btnConnectClick(Sender);
    Minimize(Sender);
    IrcTray.HideMainForm;
    IrcTray.IconVisible := True;
    IrcTray.Refresh;
  End;
end;

procedure TfrmIrcMain.TimerCheckConnectionTimer(Sender: TObject);
begin
  If FSlyIrc.State = isNotConnected Then btnConnectClick(Sender);

  If FSlyIrc.State = isAborting Then Begin
    If abortingCounter = 3 Then Begin
      abortingCounter := 0;
      FSlyIrc.Reset;
      btnConnectClick(Sender);
    End
    Else Inc(abortingCounter);
  End;
end;

end.
