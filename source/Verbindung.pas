unit Verbindung;

interface

function aktiveVerbindungen(nameProvider: String): boolean;
procedure waehlen(verb_name, Username, Passwort: String);
procedure auflegen(nameProvider: String);
procedure getParams(verb_name: String; var Username, Passwort: String);

var statusmeldung: String;

implementation

uses SysUtils, Dialogs, StdCtrls, Graphics, Forms, PollAnzeige, ras,
     ComCtrls, fpd_language;

var dialparams : TRasDialParams;
    Data       : Pointer;
    Pollstatus : TEdit;


function StatusString(state: TRasConnState; error: Longint): String;
  var
    c: Array[0..100] of Char;
    s: String;
  begin
  if error <> 0 then
    begin
    RasGetErrorString(error, c, 100);
    s := '# ' + c;
    Result := s;
    end
  else
    begin
    s := '';
    case State of
      RASCS_OpenPort:
        s := 'Öffne Port';
      RASCS_PortOpened:
        s := 'Port geöffnet';
      RASCS_ConnectDevice:
        s := 'Stelle Verbindung her..';
      RASCS_DeviceConnected:
        s := 'Device connected';
      RASCS_AllDevicesConnected:
        s := 'All devices connected';
      RASCS_Authenticate:
        s := 'Starte Authentifizierung';
      RASCS_AuthNotify:
        s := 'Authentifikation: anmelden';
      RASCS_AuthRetry:
        s := 'Authentifikation: neuer Versuch';
      RASCS_AuthCallback:
        s := 'Authentifikation: callback';
      RASCS_AuthChangePassword:
        s := 'Authentifikation: Passwort ändern';
      RASCS_AuthProject:
        s := 'Name und Passwort werden überprüft';
      RASCS_AuthLinkSpeed:
        s := 'Authentifikation: Verbindungsgeschwindigkeit';
      RASCS_AuthAck:
        s := 'Authentifikation: bestätigen';
      RASCS_ReAuthenticate:
        s := 'Authentifikation: neu authentifizieren';
      RASCS_Authenticated:
        s := 'Authentifiziert';
      RASCS_PrepareForCallback:
        s := 'Preparing for callback';
      RASCS_WaitForModemReset:
        s := 'Warte auf Modem-Reset';
      RASCS_WaitForCallback:
        s := 'Waiting for callback';
      RASCS_Projected:
        s := 'Projected';
      RASCS_StartAuthentication:
        s := 'Starte Authentifizierung';
      RASCS_CallbackComplete:
        s := 'Callback complete';
      RASCS_LogonNetwork:
        s := 'im Netzwerk einloggen';

      RASCS_Interactive:
        s := 'Interaktiv';
      RASCS_RetryAuthentication:
        s := 'Wiederhole Authentifizierung';
      RASCS_CallbackSetByCaller:
        s := 'Callback set by caller';
      RASCS_PasswordExpired:
        s := 'Passwort abgelaufen';

      RASCS_Connected:
        s := 'Connected';
      RASCS_Disconnected:
        s := 'Disconnected';
      end;
    Result := s;
    end;
  end;

function aktiveVerbindungen(nameProvider: String): boolean;
  var
    bufsize: Longint;
    numEntries: Longint;
    x: Integer;
    entries: Array[1..100] of TRasConn;
    stat: TRasConnStatus;
  begin
  aktiveVerbindungen := false;
  entries[1].dwSize := SizeOf(TRasConn);
  bufsize := SizeOf(TRasConn) * 100;
  FillChar(stat, Sizeof(TRasConnStatus), 0);
  stat.dwSize := Sizeof(TRasConnStatus);
  if RasEnumConnections(@entries[1], bufsize, numEntries) = 0 then
    begin
     if numEntries > 0 then
      begin
        aktiveVerbindungen := true;
        for x := 1 to numEntries do
          If entries[x].szEntryName = nameProvider Then
          Begin
            Data := Pointer(entries[x].hrasconn);
            RasGetConnectStatus(entries[x].hrasconn, stat);
(*    dwSize: Longint;
    rasconnstate: TRasConnState;
    dwError: LongInt;*)
//            SubItems.Add(StatusString(stat.rasconnstate, stat.dwError));
          End;
      end;
     end
  else
    ShowMessage('RasEnumConnections failed.');
  end;

// Callback RAS function
procedure RasCallback(msg: Integer; state: TRasConnState;
    error: Longint); stdcall
//    error: Longint; nameProvider: String); stdcall
begin
//  aktiveVerbindungen(nameProvider);
  if error = 0 then
    Pollstatus.Font.Color := clBlue
  else
    Pollstatus.Font.Color := clRed;
  statusmeldung := StatusString(state, error);
  Pollstatus.Text := statusmeldung;
  Application.ProcessMessages;
end;

procedure waehlen(verb_name, Username, Passwort: String);
var
    r: integer;
    c: Array[0..100] of Char;
    hRas: THRasConn;
begin
  Pollstatus := TEdit.Create(Pollen);
  Pollstatus.Top := 72;
  Pollstatus.Left := 16;
  Pollstatus.Width := 321;
  Pollstatus.Height := 21;
  Pollstatus.Readonly := true;
  Pollstatus.Parent := Pollen;

  FillChar(dialparams, SizeOf(TRasDialParams), 0);
  with dialparams do
    begin
    dwSize := Sizeof(TRasDialParams);
    StrPCopy(szEntryName, verb_name);
    StrPCopy(szUserName, Username);
    StrPCopy(szPassword, Passwort);
    // You can override phone number here...
    // StrPCopy(szPhoneNumber, 'xxxxxx');
    end;
  hRas := 0;

  // Async dial
  r := RasDial(nil,   // This field is ignored in Windows95
      nil,  // Phonebook: use default (not used on Win95)
      dialparams,
      0, // use callback function of type RASDIALFUNC
      @RasCallback,   // callback function
      hRas);
  if r = 0 then aktiveVerbindungen(verb_name)
  else begin
    RasGetErrorString(r, c, 100);
    If Pos('already open', c) > 0 Then statusmeldung := 'Connected'
                                  Else statusmeldung := sprache_Fehler+': ' + c;
//    ShowMessage('RasDial failed: ' + c);
    If hRas <> 0 Then RasHangUp(hRas);
  end;
end;

procedure auflegen(nameProvider: String);
  var
    hRas: THRasConn;
  begin
    aktiveVerbindungen(nameProvider);
//  hRas := Longint(lvConnections.ItemFocused.Data);
  hRas := Longint(Data);
  if RasHangUp(hRas) = 0 then
    begin
//      Sleep(1000);  // wait 1 second
      aktiveVerbindungen(nameProvider);
    end
  else
//    ShowMessage('RasHangUp failed.');
  end;


procedure getParams(verb_name: String; var Username, Passwort: String);
var
    fp: LongBool;
    r: Longint;
begin
  FillChar(dialparams, SizeOf(TRasDialParams), 0);
  with dialparams do
    begin
    dwSize := Sizeof(TRasDialParams);
    StrPCopy(szEntryName, verb_name);
    end;
  r := RasGetEntryDialParams(nil, dialparams, fp);
  if r = 0 then
    with dialparams do
      begin
        Username := szUserName;
        if fp then Passwort := szPassword
              else Passwort := '';
      end
  else
    begin
//    RasGetErrorString(r, c, 100);
//    ShowMessage('RasGetEntryDialParams failed: ' + c);
    end;
end;


end.
