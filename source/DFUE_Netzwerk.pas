unit DFUE_Netzwerk;

interface

uses StdCtrls;

function  get_Anzahl_Verbindungen: Integer;
procedure Devices_auflisten(Var LDevices: TComboBox);
procedure wahrscheinliches_Device_suchen(lstEntries: TComboBox; Var LDevices: TComboBox);
function  neue_Verbindung_erstellen(LDevices: TComboBox): Boolean;

implementation

uses SysUtils, Dialogs, Forms, Windows, Ras, Dateneingabe, fpd_language;



function get_Anzahl_Verbindungen: Integer;
var
    bufsize: Longint;
    numEntries: Longint;
    entries: LPRasEntryName;
    res: Integer;
begin
  entries := AllocMem(SizeOf(TRasEntryName));
  entries^.dwSize := SizeOf(TRasEntryName);
  bufsize := SizeOf(TRasEntryName);
  res := RasEnumEntries(nil, nil, entries, bufsize, numEntries);
  if res = ERROR_BUFFER_TOO_SMALL then
    begin
    ReallocMem(entries, bufsize);
    FillChar(entries^, bufsize, 0);
    entries^.dwSize := SizeOf(TRasEntryName);
    res := RasEnumEntries(nil, nil, entries, bufsize, numEntries);
    end;
  if res = 0 then get_Anzahl_Verbindungen := numEntries
             else get_Anzahl_Verbindungen := -1; // DFÜ Netzwerk nicht initialisiert (?)
  FreeMem(entries);
end;


procedure Devices_auflisten(Var LDevices: TComboBox);
var
    buffer: Pointer;
    devices: LPRasDevInfo;
    devSize, ndevs: Integer;
    devType, devName: String;
    i: Integer;
    i_str: String;
begin
  If noRAS Then Begin
//      LDevices.Items.Add(s[0094]);
      LDevices.Items.Add(s[0093]);
      LDevices.ItemIndex := LDevices.Items.Count-1;
      Exit;
  End;

  devSize := 0;
  ndevs := 0;
  {$I-}
  if RasEnumDevices(nil, devSize, ndevs) <> ERROR_BUFFER_TOO_SMALL then begin
//    If netzwerk Then Begin
      LDevices.Items.Add(s[0093]);
      LDevices.ItemIndex := LDevices.Items.Count-1;
//    End;
    If internet Then Begin
      LDevices.Items.Add(s[0094]);
      LDevices.ItemIndex := LDevices.Items.Count-1;
    End;
    Exit;
  End;
  {$I+}
  i := IOResult;
  IF i <> 0 Then Begin // dürfte nicht mehr vorkommen, war zum Testen
    Str(i, i_str);
    Application.MessageBox(
         PChar(s[0095] + Format(s[0096], [i_str])), sprache_Fehler, MB_OK);
    Exit;
  End;

  {$I-} buffer := AllocMem(devSize); {$I+}
  i := IOResult;
  IF i <> 0 Then Begin // dürfte nicht mehr vorkommen, war zum Testen
    Str(i, i_str);
    Application.MessageBox(
         PChar(s[0097] + Format(s[0096], [i_str])), sprache_Fehler, MB_OK);
    If netzwerk Then LDevices.Items.Add(s[0093])
//    Else If internet Then LDevices.Items.Add('Internet-Verbindung')
    Else LDevices.Items.Add(s[0098]);
    LDevices.ItemIndex := LDevices.Items.Count-1;
    Exit;
  End;

  try
    devices := buffer;
    devices^.dwSize := SizeOf(TRasDevInfo);
    if RasEnumDevices(buffer, devSize, ndevs) = 0 then
      begin
        while ndevs > 0 do
          begin
          devType := devices^.szDeviceType;
          devName := devices^.szDeviceName;
          If ((devType = s[0099]) or (devType = s[0100]))
             and (Pos(s[0101], devName) = 0) Then
           LDevices.Items.Add(Format('%s=%s', [devName, devType]));
          Inc(devices);
          Dec(ndevs);
          end;
        LDevices.Items.Add(s[0094]);
      end
    else if not netzwerk then LDevices.Items.Add(s[0098]);
  finally
    FreeMem(buffer);
    end;

//  If netzwerk Then Begin
    LDevices.Items.Add(s[0093]);
    LDevices.ItemIndex := LDevices.Items.Count-1;
//  End;
end;


procedure wahrscheinliches_Device_suchen(lstEntries: TComboBox; Var LDevices: TComboBox);
var
    entry: LPRasEntry;
    entrySize, devinfoSize: Integer;
    entryName: string;
    i, j: Integer;
begin
  If netzwerk or internetOnly Then Exit;

  LDevices.ItemIndex := 0;

  // jede Verbindung durchgehen bis Wählverbindung gefunden
  For j := 1 To (lstEntries.Items.Count-1) Do
  Begin
  // Get required size for buffers:
  entrySize := 0;
  entryName := lstEntries.Items.Strings[j-1];
  devinfoSize := 0;
  if RasGetEntryProperties(nil, PChar(entryName),
      nil, entrySize, nil, devinfoSize) = ERROR_BUFFER_TOO_SMALL then
  begin
   entry := AllocMem(entrySize);
   try
    entry^.dwSize := SizeOf(TRasEntry);
    if RasGetEntryProperties(nil, PChar(entryName),
        entry, entrySize, nil, devinfoSize) = 0 then
      begin
      with entry^ do
        begin
         If ((dwfNetProtocols and RASNP_Ip) <> 0) // PPP Verbindung?
            and (Length(szLocalPhoneNumber) > 4) Then   // Telefonnummer (-> Wählverbindung) angegeben?
         begin
          for i := 0 to (LDevices.Items.Count-1) do
            if (LDevices.Items.Names[i] = szDeviceName) then
            begin
              LDevices.ItemIndex := i;
              Break;
            end;
         end;
        end;
      end
  finally
    FreeMem(entry);
   end;
  end;
  end;
end;


procedure set_entry_params(var entry: TRasEntry; LDevices: TComboBox);
var
    devicename: string;
begin
  with entry do
    begin
      dwfOptions := dwfOptions and (not RASEO_UseCountryAndAreaCodes);
      dwfOptions := dwfOptions and (not RASEO_SpecificIpAddr);
      dwfOptions := dwfOptions and (not RASEO_SpecificNameServers);
      dwfOptions := dwfOptions or RASEO_IpHeaderCompression;
      dwfOptions := dwfOptions or RASEO_RemoteDefaultGateway;
      dwfOptions := dwfOptions and (not RASEO_DisableLcpExtensions);
      dwfOptions := dwfOptions and (not RASEO_TerminalBeforeDial);
      dwfOptions := dwfOptions and (not RASEO_TerminalAfterDial);
      dwfOptions := dwfOptions or RASEO_ModemLights;
      dwfOptions := dwfOptions or RASEO_SwCompression;
      dwfOptions := dwfOptions and (not RASEO_RequireEncryptedPw);
      dwfOptions := dwfOptions and (not RASEO_RequireMsEncryptedPw);
      dwfOptions := dwfOptions and (not RASEO_RequireDataEncryption);
      dwfOptions := dwfOptions and (not RASEO_NetworkLogon);
      dwfOptions := dwfOptions and (not RASEO_UseLogonCredentials);
      dwfOptions := dwfOptions and (not RASEO_PromoteAlternates);
{      dwfOptions := dwfOptions and (not RASEO_SecureLocalFiles);}
//      dwCountryID := StrToInt(txtCountryID.Text);
//      dwCountryCode := StrToInt(txtCountryCode.Text);
    StrPCopy(szLocalPhoneNumber, telNummerNode);
      dwfNetProtocols := dwfNetProtocols and (not RASNP_Netbeui);
      dwfNetProtocols := dwfNetProtocols and (not RASNP_Ipx);
      dwfNetProtocols := dwfNetProtocols or RASNP_Ip;

    dwFramingProtocol := 1 shl 0; // (?)
    StrPCopy(szScript, '');

    devicename := LDevices.Items.Names[LDevices.ItemIndex];
    StrPCopy(szDeviceName, devicename);
    StrPCopy(szDeviceType, LDevices.Items.Values[devicename]);
    end;
end;


function create_connection(LDevices: TComboBox): Boolean;
var
    entry: LPRasEntry;
    entrySize, devinfoSize: Integer;
    entryName: string;
    dialparams: TRasDialParams;
begin
  create_connection := True;

  // Get required size for buffers:
  entryName := 'Fido-Paket deluxe';
  entrySize := 0;
  devinfoSize := 0;
  if RasGetEntryProperties(nil, PChar(entryName),
      nil, entrySize, nil, devinfoSize) <> ERROR_BUFFER_TOO_SMALL then
    begin
      create_connection := False;
      Exit;
    end;
  entry := AllocMem(entrySize);
  try
    entry^.dwSize := SizeOf(TRasEntry);
    if RasGetEntryProperties(nil, PChar(entryName),
        entry, entrySize, nil, devinfoSize) = 0 then
      begin
        set_entry_params(entry^, LDevices);
        if RasSetEntryProperties(nil, PChar(entryName), entry, entrySize, nil, 0) <> 0
         then create_connection := False
         else begin
           with dialparams do
           begin
             // Note: as stated in WIN32.HLP, the szPhoneNumber cannot be changed by
             // this function. The only way to change it (as far as I know) is to use
             // RasEditPhoneBookEntry and change it manually. Or it's possible to
             // specify szPhoneNumber for the RasDial function.
             dwSize := Sizeof(TRasDialParams);
             StrPCopy(szEntryName, 'Fido-Paket deluxe');
             StrPCopy(szUserName, Username);
             StrPCopy(szPassword, Passwort);
           end;
           if RasSetEntryDialParams(nil, dialparams, False) <> 0
             then create_connection := False;
         end;
      end
    else create_connection := False;
  finally
    FreeMem(entry);
  end;
end;

function neue_Verbindung_erstellen(LDevices: TComboBox): Boolean;
var
    entry: TRasEntry;
begin
  FillChar(entry, SizeOf(TRasEntry), 0);
  entry.dwSize := SizeOf(TRasEntry);
  set_entry_params(entry, LDevices);
  if RasSetEntryProperties(nil, PChar('Fido-Paket deluxe'),
      @entry, SizeOf(TRasEntry), nil, 0) = 0
    then neue_Verbindung_erstellen := create_connection(LDevices)
    else neue_Verbindung_erstellen := False;
end;

end.
