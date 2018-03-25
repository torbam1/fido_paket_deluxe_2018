{
  Unit        SlyIrc.pas

  Components  TSlyIrc
              A basic IRC component that simply encapsulates the protocol as
              defined by RFC1459, plus a few additions to the protocol as have
              been observed to be in present use.

  Author      Steve Williams

  Copyright   (C) Copyright 1999 Steve Williams

  Objects     TIrcObject
              Base object for all classes except TSlyIrc.  Implements common
              functionality.

              TIrcToken
              Tokenizes a response string.

              TIrcResponseHandlers
              Manages the repsonse handler functions.

  History     Sometime back in 1997, my first IRC client component was released
              upon the masses.  It was actually the third version, but the first
              to be released.  TIRCClient was (and still is) used by many people
              around the world.  Since that initial release, I learnt a whole
              lot more about object-oriented programming in Delphi, and thus
              TSlyIrc was born.

  1.0   24/11/99
              - Started work.
        12/12/99
              - Added get methods to the Host and Nick properties to return the
                actual nick and host if connected.
              - Added chaining to the response handlers.
        20/12/99
              - Added BreakChain parameter to response handlers.  Allows any
                handler in the stop further processing in the chain by setting
                the BreakChain parameter to True.

        23/12/99
              - This source file split.  Response.pas and SlyIrcEx.pas were
                created.

  Hints and Tips

              TIrcToken
              To use TIrcToken to tokenize message content, create a new
              TIrcToken object, set the Syntax property to tsMessage and then
              set the TokenString property to the message content to be
              tokenized.  This prevents the special tokenizing that is normally
              performed when Syntax = tsResponse (the default syntax).

              Replacing a response handler
              To replace a response handler instead of adding another link in
              the chain, set BreakChain to True in the response handler.  This
              prevents any further handlers lower in the chain from being
              executed, effectively replacing them.
}

unit SlyIrc;

interface

uses
  Classes, WSocket;

const
  DEFAULT_HOST = '';
  DEFAULT_PORT = '6667';
  DEFAULT_NICK = 'MyNick';
  DEFAULT_ALTNICK = 'OtherNick';
  DEFAULT_REALNAME = 'My real name';
  DEFAULT_USERNAME = 'username';
  DEFAULT_PASSWORD = '';

  MAX_TOKEN_LENGTH = 512;   { Defined in RFC1459 as the maximum length of a
                              single token. }
  TOKEN_SEPARATOR = ' ';    { Separates tokens, except for the following case. }
  TOKEN_ENDOFTOKENS = ':';  { If the second or higher token starts with this
                              character, it indicates that this token is all
                              characters to the end of the string. }

type
  TSlyIrc = class;

  TIrcObject = class(TObject)
  private
    FTag: Integer;
    FData: TObject;
    FSlyIrc: TSlyIrc;
    FOwner: TIrcObject;
    procedure SetData(const Value: TObject);
    procedure SetSlyIrc(const Value: TSlyIrc);
    procedure SetTag(const Value: Integer);
    procedure SetOwner(const Value: TIrcObject);
  public
    constructor Create(AOwner: TIrcObject);
    destructor Destroy; override;
    procedure Notification(AIrcObject: TIrcObject; Operation: TOperation); virtual;
    procedure PrivMsg(Text: String); virtual;
    procedure Notice(Text: String); virtual;
    property SlyIrc: TSlyIrc read FSlyIrc write SetSlyIrc;
    property Owner: TIrcObject read FOwner write SetOwner;
    property Data: TObject read FData write SetData;
    property Tag: Integer read FTag write SetTag;
  end;

  TTokenSyntax = (tsResponse, tsMessage, tsCTCP);

  TIrcToken = class(TObject)
  private
    FTokenString: String;
    FCount: Integer;
    FTokens: TList;
    FSyntax: TTokenSyntax;
    FBuffer: array [0..MAX_TOKEN_LENGTH] of Char;
    procedure SetTokenString(const Value: String);
    function GetTokens(Index: Integer): String;
    function GetTokensFrom(Index: Integer): String;
    procedure SetSyntax(const Value: TTokenSyntax);
  protected
    procedure Tokenize; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    property TokenString: String read FTokenString write SetTokenString;
    property Tokens[Index: Integer]: String read GetTokens; default;
    property TokensFrom[Index: Integer]: String read GetTokensFrom;
    property Count: Integer read FCount;
    property Syntax: TTokenSyntax read FSyntax write SetSyntax;
  end;

  THandlerFunc = procedure (SlyIrc: TSlyIrc; AResponse: String; ATokens: TIrcToken;
    var BreakChain: Boolean) of object;

  PResponseHandler = ^TResponseHandler;
  TResponseHandler = record
    Response: String;
    HandlerFunc: THandlerFunc;
    PrevHandler: PResponseHandler;
  end;

  TIrcResponseHandlers = class(TObject)
  private
    FHandlers: TStringList;
    FSlyIrc: TSlyIrc;
  public
    constructor Create(ASlyIrc: TSlyIrc);
    destructor Destroy; override;
    function AddHandler(Response: String; HandlerFunc: THandlerFunc): Integer;
    procedure DeleteHandler(Index: Integer);
    procedure RemoveHandler(Response: String);
    function IndexOfHandler(Response: String): Integer;
    procedure Handle(Tokens: TIrcToken);
  end;

  TSlyIrcState = (isNotConnected, isResolvingHost, isConnecting, isConnected,
    isRegistering, isReady, isAborting, isDisconnecting);

  TUserMode = (umInvisible, umOperator, umServerNotices, umWallops);
  TUserModes = set of TUserMode;

  TOnResponse = procedure (Sender: TObject; ATokens: TIrcToken; var Suppress: Boolean) of object;
  TOnReceive = procedure (Sender: TObject; AResponse: String) of object;
  TOnSend = procedure (Sender: TObject; AResponse: String) of object;

  TSlyIrc = class(TComponent)
  private
    FRealName: String;
    FPort: String;
    FPassword: String;
    FAltNick: String;
    FHost: String;
    FNick: String;
    FChannel: String;
    FChangeNickTo: String;
    FWSocket: TWSocket;
    FState: TSlyIrcState;
    FTokens: TIrcToken;
    FOnBeforeStateChange: TNotifyEvent;
    FOnAfterStateChange: TNotifyEvent;
    FOnResponse: TOnResponse;
    FOnReceive: TOnReceive;
    FOnSend: TOnSend;
    FHandlers: TIrcResponseHandlers;
    FUsername: String;
    FActualNick: String;
    FActualHost: String;
    FUserModes: TUserModes;
    FActualUserModes: TUserModes;
    FOnUserModeChanged: TNotifyEvent;
    procedure SetAltNick(const Value: String);
    procedure SetNick(const Value: String);
    procedure SetChannel(const Value: String);
    procedure SetPassword(const Value: String);
    procedure SetPort(const Value: String);
    procedure SetRealName(const Value: String);
    procedure SetHost(const Value: String);
    function GetHost: String;
    procedure SessionConnected(Sender: TObject; Error: Word);
    procedure SessionClosed(Sender: TObject; Error: Word);
    procedure DnsLookupDone(Sender: TObject; Error: Word);
    procedure DataAvailable(Sender: TObject; Error: Word);
    procedure SetState(const Value: TSlyIrcState);
    procedure SetUsername(const Value: String);
    function GetUserModes: TUserModes;
    procedure SetUserModes(const Value: TUserModes);
    function CreateUserModeCommand(NewModes: TUserModes): String;
    procedure LoescheNick(name: String);
    procedure AddNick(name: String);
  protected
    procedure ProcessResponse(AResponse: String; var Suppress: Boolean); virtual;
    procedure Receive(AResponse: String); virtual;
    procedure Response(ATokens: TIrcToken; var Suppress: Boolean); virtual;
    procedure UserModeChanged;
    procedure AddHandlers;
    procedure RplPing(SlyIrc: TSlyIrc; AResponse: String; ATokens: TIrcToken;
      var BreakChain: Boolean);
    procedure RplNick(SlyIrc: TSlyIrc; AResponse: String; ATokens: TIrcToken;
      var BreakChain: Boolean);
    procedure UpdateNamesList(SlyIrc: TSlyIrc; AResponse: String; ATokens: TIrcToken;
      var BreakChain: Boolean);
    procedure RplWelcome1(SlyIrc: TSlyIrc; AResponse: String; ATokens: TIrcToken;
      var BreakChain: Boolean);
    procedure RplUsers(SlyIrc: TSlyIrc; AResponse: String; ATokens: TIrcToken;
      var BreakChain: Boolean);
    procedure ErrNicknameInUse(SlyIrc: TSlyIrc; AResponse: String; ATokens: TIrcToken;
      var BreakChain: Boolean);
    procedure RplMode(SlyIrc: TSlyIrc; AResponse: String; ATokens: TIrcToken;
      var BreakChain: Boolean);
    procedure RetrieveChannel(SlyIrc: TSlyIrc; AResponse: String; ATokens: TIrcToken;
      var BreakChain: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Connect;
    procedure Close;
    procedure Reset;
    procedure Send(Command: String);
    procedure PrivMsg(Destination, Text: String);
    procedure Notice(Destination, Text: String);
    procedure Quit(Reason: String);
    procedure RenameNick(nameAlt, nameNeu: String);
    function GetNick: String;
    function GetChannel: String;
    function ExtractNickFromAddress(Address: String): String;
    property State: TSlyIrcState read FState;
    property Socket: TWSocket read FWSocket;
    property Handlers: TIrcResponseHandlers read FHandlers;
  published
    property Host: String read GetHost write SetHost;
    property Port: String read FPort write SetPort;
    property Nick: String read GetNick write SetNick;
    property AltNick: String read FAltNick write SetAltNick;
    property Channel: String read GetChannel write SetChannel;
    property RealName: String read FRealName write SetRealName;
    property Password: String read FPassword write SetPassword;
    property Username: String read FUsername write SetUsername;
    property UserModes: TUserModes read GetUserModes write SetUserModes;
    { Event properties. }
    property OnBeforeStateChange: TNotifyEvent read FOnBeforeStateChange write FOnBeforeStateChange;
    property OnAfterStateChange: TNotifyEvent read FOnAfterStateChange write FOnAfterStateChange;
    property OnResponse: TOnResponse read FOnResponse write FOnResponse;
    property OnReceive: TOnReceive read FOnReceive write FOnReceive;
    property OnSend: TOnSend read FOnSend write FOnSend;
    property OnUserModeChanged: TNotifyEvent read FOnUserModeChanged write FOnUserModeChanged;
  end;

implementation

uses
  SysUtils, Response, IrcMain;

{ TIrcObject }

constructor TIrcObject.Create(AOwner: TIrcObject);
begin
  inherited Create;
  { Automatically triggers insert notification to owner. }
  SetOwner(AOwner);
  { If the owner has a SlyIrc reference, then copy it. }
  if Assigned(FOwner) then
    SetSlyIrc(FOwner.SlyIrc);
end;

destructor TIrcObject.Destroy;
begin
  { Setting the owner to nil triggers the remove notification if required. }
  SetOwner(nil);
  inherited;
end;

procedure TIrcObject.Notification(AIrcObject: TIrcObject;
  Operation: TOperation);
begin
  { Do nothing. }
end;

procedure TIrcObject.PrivMsg(Text: String);
begin
  { Do nothing. }
end;

procedure TIrcObject.Notice(Text: String);
begin
  { Do nothing. }
end;

procedure TIrcObject.SetData(const Value: TObject);
begin
  FData := Value;
end;

procedure TIrcObject.SetOwner(const Value: TIrcObject);
begin
  if FOwner <> Value then
  begin
    { Remove itself from previous owner. }
    if Assigned(FOwner) then
      FOwner.Notification(Self, opRemove);
    FOwner := Value;
    { Add itself to new owner. }
    if Assigned(FOwner) then
      FOwner.Notification(Self, opInsert);
  end;
end;

procedure TIrcObject.SetSlyIrc(const Value: TSlyIrc);
begin
  FSlyIrc := Value;
end;

procedure TIrcObject.SetTag(const Value: Integer);
begin
  FTag := Value;
end;

{ TIrcToken }

constructor TIrcToken.Create;
begin
  FTokens := TList.Create;
  FSyntax := tsResponse;
end;

destructor TIrcToken.Destroy;
begin
  if Assigned(FTokens) then
    FTokens.Free;
end;

function TIrcToken.GetTokens(Index: Integer): String;
var
  TokenStart, TokenEnd: PChar;
begin
  Result := '';
  if Index < FCount then
  begin
    TokenStart := FTokens[Index];
    if TokenStart = nil then
      Exit;
    TokenEnd := nil;
    if Index < FTokens.Count - 1 then
      TokenEnd := StrScan(TokenStart, TOKEN_SEPARATOR);
    if TokenEnd = nil then
      { Use StrLCopy to protect against buffer overruns. }
      StrLCopy(FBuffer, TokenStart, High(FBuffer))
    else
      StrLCopy(FBuffer, TokenStart, TokenEnd - TokenStart);
    Result := StrPas(FBuffer);
  end;
end;

function TIrcToken.GetTokensFrom(Index: Integer): String;
var
  TokenStart: PChar;
begin
  Result := '';
  if Index < FCount then
  begin
    TokenStart := FTokens[Index];
    if TokenStart = nil then
      Exit;
    { Use StrLCopy to protect against buffer overruns. }
    StrLCopy(FBuffer, TokenStart, High(FBuffer));
    Result := StrPas(FBuffer);
  end;
end;

procedure TIrcToken.SetSyntax(const Value: TTokenSyntax);
begin
  FSyntax := Value;
end;

procedure TIrcToken.SetTokenString(const Value: String);
begin
  { If the string is a CTCP query, then skip the Ctrl-A characters at the start
    and end of the query. }
  if FSyntax = tsCTCP then
    FTokenString := Copy(Value, 2, Length(Value) - 2)
  else
    FTokenString := Value;
  { Now break it up into its separate tokens. }
  Tokenize;
end;

procedure TIrcToken.Tokenize;
var
  TokenPtr: PChar;
  EndOfTokens: Boolean;
begin
  FTokens.Clear;
  FCount := 0;
  if Length(FTokenString) > 0 then
  begin
    TokenPtr := PChar(FTokenString);
    { Remove leading spaces. }
    while (TokenPtr^ <> #0) and (TokenPtr^ = TOKEN_SEPARATOR) do
      Inc(TokenPtr);
    { In case we reached the end of the string. }
    if TokenPtr^ = #0 then
      Exit;
    if FSyntax = tsResponse then
    begin
      if TokenPtr^ <> ':' then
      begin
        { No source address exists, so insert a nil string in its place. }
        FTokens.Add(nil);
        Inc(FCount);
      end
      else
      begin
        { Skip past the semi-colon in the source address. }
        Inc(TokenPtr);
      end;
    end;
    { Add the token to the list. }
    FTokens.Add(TokenPtr);
    Inc(FCount);
    while TokenPtr <> nil do
    begin
      { If the current token is a CTCP query, then look for the end of the
        query instead of the token separator. }
      if TokenPtr^ = #1 then
      begin
        TokenPtr := StrScan(TokenPtr + 1, #1);
        { Move past the Ctrl-A to the next character. }
        if TokenPtr <> nil then
          Inc(TokenPtr);
      end
      else
      begin
        TokenPtr := StrScan(TokenPtr, TOKEN_SEPARATOR);
      end;
      { Remove any redundant separator characters before the token. }
      while (TokenPtr <> nil) and (TokenPtr^ <> #0) and (TokenPtr^ = TOKEN_SEPARATOR) do
        Inc(TokenPtr);
      { Add it to the list if there actually is another token. }
      if TokenPtr <> nil then
      begin
        { Skip the end-of-tokens character if it exists. }
        EndOfTokens := (FSyntax = tsResponse) and (TokenPtr^ = TOKEN_ENDOFTOKENS);
        if EndOfTokens then
          Inc(TokenPtr);
        if TokenPtr^ <> #0 then
        begin
          FTokens.Add(TokenPtr);
          Inc(FCount);
        end;
        { If there was an end-of-tokens character, then break out. }
        if EndOfTokens then
          Break;
      end;
    end;
  end;
end;

{ TIrcResponseHandlers }

function TIrcResponseHandlers.AddHandler(Response: String; HandlerFunc: THandlerFunc): Integer;
var
  Handler: PResponseHandler;
begin
  Result := IndexOfHandler(Response);
  if Result >= 0 then
  begin
    { Create the new handler record. }
    New(Handler);
    Handler^.Response := Response;
    Handler^.HandlerFunc := HandlerFunc;
    { Add the link to the previous handler. }
    Handler^.PrevHandler := PResponseHandler(FHandlers.Objects[Result]);
    { Replace the handler in the existing item. }
    FHandlers.Objects[Result] := TObject(Handler);
  end
  else
  begin
    { Create the handler record. }
    New(Handler);
    Handler^.Response := Response;
    Handler^.HandlerFunc := HandlerFunc;
    Handler^.PrevHandler := nil;
    { Add it to the list. }
    Result := FHandlers.AddObject(Handler^.Response, TObject(Handler));
  end;
end;

constructor TIrcResponseHandlers.Create(ASlyIrc: TSlyIrc);
begin
  inherited Create;
  FHandlers := TStringList.Create;
  FHandlers.Sorted := True;
  FHandlers.Duplicates := dupError;
  FSlyIrc := ASlyIrc;
end;

procedure TIrcResponseHandlers.DeleteHandler(Index: Integer);
var
  Handler: PResponseHandler;
begin
  if (Index >= 0) and (Index < FHandlers.Count) then
  begin
    Handler := PResponseHandler(FHandlers.Objects[Index]);
    { If chained, then simply remove the newest link in the chain. }
    if Handler^.PrevHandler <> nil then
      FHandlers.Objects[Index] := TObject(Handler^.PrevHandler)
    else
      FHandlers.Delete(Index);
    { Free the memory used by the newest link. }
    Dispose(Handler);
  end;
end;

destructor TIrcResponseHandlers.Destroy;
begin
  { Free all the handlers. }
  while FHandlers.Count > 0 do
    DeleteHandler(0);
  FHandlers.Free;
  inherited;
end;

procedure TIrcResponseHandlers.Handle(Tokens: TIrcToken);
var
  Index: Integer;
  Handler: PResponseHandler;
  BreakChain: Boolean;
begin
  { The second token is the response we want to process. }
  Index := IndexOfHandler(Tokens[1]);
  if Index >= 0 then
  begin
    Handler := PResponseHandler(FHandlers.Objects[Index]);
    BreakChain := False;
    { Call all the chained handler functions. }
    while Assigned(Handler) and not BreakChain do
    begin
      if Assigned(Handler^.HandlerFunc) then
        Handler^.HandlerFunc(FSlyIrc, Tokens[1], Tokens, BreakChain);
      Handler := Handler^.PrevHandler;
    end;
  end
  else begin
    If (Tokens[2] = FSlyIrc.FActualNick)
       and (Pos('NickServ IDENTIFY', Tokens[3]) > 0)
     Then Begin
         if FSlyIrc.FPassword <> '' then
          FSlyIrc.PrivMsg('NickServ', Format('IDENTIFY %s', [FSlyIrc.FPassword]))
         else begin
           FSlyIrc.SetNick(FslyIrc.FAltNick);
           FSlyIrc.RenameNick(FSlyIrc.FActualNick, FSlyIrc.FAltNick);
         end;
     End;
  end;
end;

function TIrcResponseHandlers.IndexOfHandler(Response: String): Integer;
begin
  Result := FHandlers.IndexOf(Response);
end;

procedure TIrcResponseHandlers.RemoveHandler(Response: String);
begin
  DeleteHandler(IndexOfHandler(Response));
end;

{ TSlyIrc }

procedure TSlyIrc.Close;
begin
  { Try to leave nicely if we can. }
  if FState = isReady then
  begin
    SetState(isDisconnecting);
    Send('QUIT');
  end
  else
  begin
    if Assigned(FWSocket) then
    begin
      SetState(isDisconnecting);
      FWSocket.Close;
    end;
  end;
end;

procedure TSlyIrc.Connect;
begin
  if Assigned(FWSocket) and (FState = isNotConnected) then
  begin
    FActualHost := FHost;
    FActualNick := FNick;
    FChangeNickTo := '';
    SetState(isResolvingHost);
    FWSocket.DnsLookup(FHost);
  end;
end;

constructor TSlyIrc.Create(AOwner: TComponent);
begin
  inherited;
  FHost := DEFAULT_HOST;
  FPort := DEFAULT_PORT;
  FNick := DEFAULT_NICK;
  FAltNick := DEFAULT_ALTNICK;
  FChannel := '';
  FRealName := DEFAULT_REALNAME;
  FPassword := DEFAULT_PASSWORD;
  FUsername := DEFAULT_USERNAME;
  FState := isNotConnected;
  FTokens := TIrcToken.Create;
  FHandlers := TIrcResponseHandlers.Create(Self);
  if not (csDesigning in ComponentState) then
  begin
    FWSocket := TWSocket.Create(Self);
    { LineEnd is set to LF (#10) because some IRC Hosts break specification
      and do not send CRLF (#13#10).  In the OnDataAvailable event handler we
      must check for the CR and strip it if necessary. }
    FWSocket.LineEnd := #10;
    FWSocket.LineMode := True;
    FWSocket.OnDnsLookupDone := DnsLookupDone;
    FWSocket.OnSessionConnected := SessionConnected;
    FWSocket.OnSessionClosed := SessionClosed;
    FWSocket.OnDataAvailable := DataAvailable;
  end;
  { Register the response handler functions. }
  AddHandlers;
end;

procedure TSlyIrc.DataAvailable(Sender: TObject; Error: Word);
var
  AResponse: String;
  Suppress: Boolean;
  EndOfLineChars: Integer;
begin
  if Error <> 0 then
  begin
    Reset;
  end
  else
  begin
    { Receive string and process. }
    AResponse := FWSocket.ReceiveStr;
    if Length(AResponse) > 0 then
    begin
      { Always have the LF to remove. }
      EndOfLineChars := 1;
      { If a CR exists at the end of the string, then remove it as well. }
      if AResponse[Length(AResponse) - 1] = #13 then
        Inc(EndOfLineChars);
      SetLength(AResponse, Length(AResponse) - EndOfLineChars);
      { Trigger the OnReceive event. }
      Receive(AResponse);
      { Now process the response. }
      Suppress := False;
      ProcessResponse(AResponse, Suppress);
    end;
  end;
end;

destructor TSlyIrc.Destroy;
begin
  Reset;
  if Assigned(FWSocket) then
    FWSocket.Free;
  if Assigned(FTokens) then
    FTokens.Free;
  FHandlers.Free;
  inherited;
end;

procedure TSlyIrc.DnsLookupDone(Sender: TObject; Error: Word);
begin
  if Error <> 0 then
  begin
    Reset;
  end
  else
  begin
    { Host name is successfully resolved, so connect. }
    SetState(isConnecting);
    FWSocket.Addr := FWSocket.DnsResult;
    FWSocket.Port := FPort;
    FWSocket.Connect;
  end;
end;

procedure TSlyIrc.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FWSocket) then
    FWSocket := nil;
end;

procedure TSlyIrc.Reset;
begin
  SetState(isAborting);
  if Assigned(FWSocket) then
    FWSocket.Abort;
end;

procedure TSlyIrc.Send(Command: String);
begin
  if Assigned(FOnSend) then
    FOnSend(Self, Command);
  if Assigned(FWSocket) and (FState in [isRegistering, isReady]) then
    FWSocket.SendStr(Command + #13#10);
end;

procedure TSlyIrc.PrivMsg(Destination, Text: String);
begin
  Send(Format('PRIVMSG %s :%s', [Destination, Text]));
end;

procedure TSlyIrc.Notice(Destination, Text: String);
begin
  Send(Format('NOTICE %s :%s', [Destination, Text]));
end;

procedure TSlyIrc.SessionClosed(Sender: TObject; Error: Word);
begin
  if Error <> 0 then
    Reset
  else
    SetState(isNotConnected);
end;

procedure TSlyIrc.SessionConnected(Sender: TObject; Error: Word);
begin
  if Error <> 0 then
  begin
    Reset;
  end
  else
  begin
    SetState(isConnected);
    SetState(isRegistering);
    { If a password for channel exists, send it first. }
//    if FPassword <> '' then
//      Send(Format('PASS %s', [FPassword]));
    { Send nick. }
    SetNick(FNick);
    { Send registration. }
    Send(Format('USER %s %s %s :%s', [FUsername, WSocket.LocalHostName, FHost, FRealName]));
    if Pos('quakenet', FHost) = 0 Then Begin
      channel := '#fido-deluxe';
      Send('JOIN #fido-deluxe');
    End;
  end;
end;

procedure TSlyIrc.SetAltNick(const Value: String);
begin
  FAltNick := Value;
end;

procedure TSlyIrc.SetNick(const Value: String);
begin
  if Length(Value) > 0 then
  begin
    if FState in [isRegistering, isReady] then
    begin
      if Value <> FChangeNickTo then
      begin
        Send(Format('NICK %s', [Value]));
        FChangeNickTo := Value;
      end;
    end
    else
    begin
      FNick := Value;
    end;
  end;
end;

procedure TSlyIrc.SetChannel(const Value: String);
begin
  FChannel := Value;
end;

procedure TSlyIrc.SetPassword(const Value: String);
begin
  FPassword := Value;
end;

procedure TSlyIrc.SetPort(const Value: String);
begin
  FPort := Value;
end;

procedure TSlyIrc.SetRealName(const Value: String);
begin
  FRealName := Value;
end;

procedure TSlyIrc.SetHost(const Value: String);
begin
  FHost := Value;
end;

procedure TSlyIrc.SetUsername(const Value: String);
begin
  FUsername := Value;
end;

procedure TSlyIrc.SetState(const Value: TSlyIrcState);
begin
  if Value <> FState then
  begin
    { Trigger OnBeforeStateChange event. }
    if Assigned(FOnBeforeStateChange) then
      FOnBeforeStateChange(Self);
    { Change the state. }
    FState := Value;
    { Trigger OnAfterStateChange event. }
    if Assigned(FOnAfterStateChange) then
      FOnAfterStateChange(Self);
  end;
end;

function TSlyIrc.GetUserModes: TUserModes;
begin
  if FState in [isRegistering, isReady] then
    Result := FActualUserModes
  else
    Result := FUserModes;
end;

procedure TSlyIrc.SetUserModes(const Value: TUserModes);
var
  ModeString: String;
begin
  if FState in [isRegistering, isReady] then
  begin
    ModeString := CreateUserModeCommand(Value);
    if Length(ModeString) > 0 then
      Send(Format('MODE %s %s', [FActualNick, ModeString]));
  end
  else
  begin
    FUserModes := Value;
  end;
end;

procedure TSlyIrc.ProcessResponse(AResponse: String; var Suppress: Boolean);
begin
  FTokens.Syntax := tsResponse;
  FTokens.TokenString := AResponse;
  FHandlers.Handle(FTokens);
  { Trigger OnResponse event. }
  Suppress := False;
  Response(FTokens, Suppress);
end;

procedure TSlyIrc.Receive(AResponse: String);
begin
  if Assigned(FOnReceive) then
    FOnReceive(Self, AResponse);
end;

procedure TSlyIrc.Response(ATokens: TIrcToken; var Suppress: Boolean);
begin
  if Assigned(FOnResponse) then
    FOnResponse(Self, ATokens, Suppress);
end;

procedure TSlyIrc.UserModeChanged;
begin
  if Assigned(FOnUserModeChanged) then
    FOnUserModeChanged(Self);
end;

procedure TSlyIrc.Quit(Reason: String);
begin
  Send(Format('QUIT :%s', [Reason]));
end;

procedure TSlyIrc.AddHandlers;
begin
  FHandlers.AddHandler('PING', RplPing);
  FHandlers.AddHandler('NICK', RplNick);
  FHandlers.AddHandler(RPL_WELCOME1, RplWelcome1);
  FHandlers.AddHandler(RPL_NAMREPLY, RplUsers);
  FHandlers.AddHandler(ERR_NICKNAMEINUSE, ErrNicknameInUse);
  FHandlers.AddHandler('MODE', RplMode);
  FHandlers.AddHandler(RPL_ENDOFNAMES, RetrieveChannel);
  FHandlers.AddHandler('JOIN', UpdateNamesList);
  FHandlers.AddHandler('PART', UpdateNamesList);
  FHandlers.AddHandler('QUIT', UpdateNamesList);
  FHandlers.AddHandler('KICK', UpdateNamesList);
end;

function TSlyIrc.GetHost: String;
begin
  if FState in [isRegistering, isReady] then
    Result := FActualHost
  else
    Result := FHost;
end;

function TSlyIrc.GetNick: String;
begin
  if FState in [isRegistering, isReady] then
    Result := FActualNick
  else
    Result := FNick;
end;

function TSlyIrc.GetChannel: String;
begin
  Result := FChannel;
end;

function TSlyIrc.ExtractNickFromAddress(Address: String): String;
var
  EndOfNick: Integer;
begin
  Result := '';
  EndOfNick := Pos('!', Address);
  if EndOfNick > 0 then
    Result := Copy(Address, 1, EndOfNick - 1);
end;

procedure TSlyIrc.RplNick(SlyIrc: TSlyIrc; AResponse: String;
  ATokens: TIrcToken; var BreakChain: Boolean);
begin
  { If it is our nick we are changing, then record the change. }
  if UpperCase(ExtractNickFromAddress(ATokens[0])) = UpperCase(FActualNick) then
    FActualNick := ATokens[2];
  RenameNick(ExtractNickFromAddress(ATokens[0]), ATokens[2]);
end;

procedure TSlyIrc.UpdateNamesList(SlyIrc: TSlyIrc; AResponse: String;
  ATokens: TIrcToken; var BreakChain: Boolean);
var s, name: String;
begin
  { If it is our nick we are changing, then record the change. }
  s := ATokens[1];
  name := ExtractNickFromAddress(ATokens[0]);
  If s = 'KICK' Then LoescheNick(name);
  If s = 'JOIN' Then AddNick(name);
  If s = 'PART' Then LoescheNick(name);
  If s = 'QUIT' Then LoescheNick(name);
end;

procedure TSlyIrc.LoescheNick(name: String);
var i: Integer;
begin
  i := frmIrcMain.NamesListe.Items.IndexOf(name);
  If i = -1 Then Begin
    If name[1] = '@' Then
     i := frmIrcMain.NamesListe.Items.IndexOf(Copy(name,2,Length(name)))
    Else
     i := frmIrcMain.NamesListe.Items.IndexOf('@'+name);
  End;
  If i > -1 Then frmIrcMain.NamesListe.Items.Delete(i);
end;

procedure TSlyIrc.AddNick(name: String);
begin
  If (frmIrcMain.NamesListe.Items.IndexOf(name) = -1)
     and (name <> '@operator') and (name[1] <> '{') Then
   If (frmIrcMain.NamesListe.Items.IndexOf('@'+name) = -1)
    Then frmIrcMain.NamesListe.Items.Add(name);

  // selber OP? dann nicht doppelt anzeigen
  If (name = '@' + FActualNick)
     and (frmIrcMain.NamesListe.Items.IndexOf(FActualNick) > -1) Then
   LoescheNick(FActualNick);
end;

procedure TSlyIrc.RenameNick(nameAlt, nameNeu: String);
var i: Integer;
begin
  i := frmIrcMain.NamesListe.Items.IndexOf(nameAlt);
  If i = -1 Then Begin
    i := frmIrcMain.NamesListe.Items.IndexOf('@'+nameAlt);
    If i > -1 Then Begin
      nameAlt := '@'+nameAlt;
      nameNeu := '@'+nameNeu;
    End;
  End;
  If i > -1 Then Begin
    If nameNeu[1] = '{' Then LoescheNick(nameAlt)
                        Else frmIrcMain.NamesListe.Items.Strings[i] := nameNeu;
  End
  Else AddNick(nameNeu);
end;

procedure TSlyIrc.RplPing(SlyIrc: TSlyIrc; AResponse: String;
  ATokens: TIrcToken; var BreakChain: Boolean);
begin
  { Send the PONG reply to the PING. }
  SlyIrc.Send(Format('PONG %s', [ATokens[2]]));
end;

procedure TSlyIrc.RplWelcome1(SlyIrc: TSlyIrc; AResponse: String;
  ATokens: TIrcToken; var BreakChain: Boolean);
begin
  { This should be the very first successful response we get, so set the actual
    host and nick from the values returned in the response. }
  FActualHost := ATokens[0];
  FActualNick := ATokens[2];
  SetState(isReady);
  if Pos('quakenet', FHost) = 0
   Then Send('JOIN #fido-deluxe');
  { If a user mode is pre-set, then send the mode command. }
  if FUserModes <> [] then
    Send(Format('MODE %s %s', [FActualNick, CreateUserModeCommand(FUserModes)]));
end;

procedure TSlyIrc.RplUsers(SlyIrc: TSlyIrc; AResponse: String;
  ATokens: TIrcToken; var BreakChain: Boolean);
var names : String;
    i     : Integer;
begin
  If ATokens[4] = channel Then Begin
    names := ATokens[5];
    While Length(names) > 0 Do Begin
      i := Pos(' ', names);
      If i > 1 Then AddNick(Copy(names,1,i-1));
      Delete(names,1,i);
    End;
  End;
end;

procedure TSlyIrc.ErrNicknameInUse(SlyIrc: TSlyIrc; AResponse: String;
  ATokens: TIrcToken; var BreakChain: Boolean);
begin
  { Handle nick conflicts during the registration process. }
  if FState = isRegistering then
  begin
    if FChangeNickTo = FNick then begin
      SetNick(FAltNick);
      if Pos('quakenet', FHost) = 0
       Then Send('JOIN #fido-deluxe');
    end
    else
      Quit('Nick conflict');
  end;
end;

procedure TSlyIrc.RetrieveChannel(SlyIrc: TSlyIrc; AResponse: String;
  ATokens: TIrcToken; var BreakChain: Boolean);
begin
  { Channel setzen }
  // auf Raute als erstes Zeichen prüfen, weil bei /names Kommando
  // der Channel nicht mit angegeben wird im Gegensatz zu /join, wenn dort
  // END_OF_NAMES kommt
  If ATokens[3][1] = '#' Then SetChannel(ATokens[3]);
end;

{ Create the mode command string to send to the server to modify the user's
  mode.  For example, "+i-s" to add invisible and remove server notices. }
function TSlyIrc.CreateUserModeCommand(NewModes: TUserModes): String;
const
  ModeChars: array [umInvisible..umWallops] of Char = ('i', 'o', 's', 'w');
var
  ModeDiff: TUserModes;
  Mode: TUserMode;
begin
  Result := '';
  { Calculate user modes to remove. }
  ModeDiff := FActualUserModes - NewModes;
  if ModeDiff <> [] then
  begin
    Result := Result + '-';
    for Mode := Low(TUserMode) to High(TUserMode) do
    begin
      if Mode in ModeDiff then
        Result := Result + ModeChars[Mode];
    end;
  end;
  { Calculate user modes to add. }
  ModeDiff := NewModes - FActualUserModes;
  if ModeDiff <> [] then
  begin
    Result := Result + '+';
    for Mode := Low(TUserMode) to High(TUserMode) do
    begin
      if Mode in ModeDiff then
        Result := Result + ModeChars[Mode];
    end;
  end;
end;

procedure TSlyIrc.RplMode(SlyIrc: TSlyIrc; AResponse: String;
  ATokens: TIrcToken; var BreakChain: Boolean);
var
  Index: Integer;
  ModeString: String;
  AddMode: Boolean;
begin
  { Ignore channel mode changes.  Only interested in user mode changes. }
  if ATokens[2] = FActualNick then
  begin
    { Copy the token for efficiency reasons. }
    ModeString := ATokens[3];
    AddMode := True;
    for Index := 1 to Length(ModeString) do
    begin
      case ModeString[Index] of
        '+':
          AddMode := True;
        '-':
          AddMode := False;
        'i':
          if AddMode then
            FActualUserModes := FActualUserModes + [umInvisible]
          else
            FActualUserModes := FActualUserModes - [umInvisible];
        'o':
          if AddMode then
            FActualUserModes := FActualUserModes + [umOperator]
          else
            FActualUserModes := FActualUserModes - [umOperator];
        's':
          if AddMode then
            FActualUserModes := FActualUserModes + [umServerNotices]
          else
            FActualUserModes := FActualUserModes - [umServerNotices];
        'w':
          if AddMode then
            FActualUserModes := FActualUserModes + [umWallops]
          else
            FActualUserModes := FActualUserModes - [umWallops];
      end;
    end;
    UserModeChanged;
  end
end;

end.
