(*//////////////////////////////////////////////////////////////////////
                     WExecLib (Windows Execute Library)
                (c) copyright 1997 Santronics Software Inc.
                                Version 1.1

WEXECLIB is a non-visual component library (VCL) for processing external
commands with wait and redirection options.

Features:

    - Spawning and Shelling of 32 bit and 16 bit applications.

      Spawning means, a child process is executed and your application does
      not wait for the child process to complete.  Your application simply
      forgets about the process.  Essentially, it is the same as simply
      using Win32 API WinExec().

      Shelling means, a child process is executed and your application does
      wait for the child process to complete.   Your application will use
      Win32 API events to watch for the completion.  While it is waiting,
      it will cooperately keep your application active to do other things.
      When it is complete, an OnComplete method is called.

    - Redirection of child process output to your application.

      Using Win32 piping methods, this library offers the option to pipe
      application output to your application.

    - Optional Error and Debug logging to watch various steps.

Special notes:

    - One of the more important ideas in this library (besides piping or
      waiting for a process to complete), is the idea of using the
      environment string COMSPEC to find the current Command Line Processor
      (command.com under Win95, cmd.exe under NT).

      When calling 16 bit applications under Win95, Win95 has a strange
      behavior of never returning back to the application.  By using the
      comspec to find the current processor and calling the command line
      processor instead passing the 16 bit application as parameters, the
      process will return.  Under NT, you don't have this problem.

      It is also useful to use the COMSPEC when calling DOS level commands,
      such as DIR, ERASE, COPY, MOVE, etc.

      Technically, it is ok to always use the COMSPEC, even with 32 bit
      applications.   But it is unnecessary when calling 32 bit
      applications and its not necessary under NT except when calling DOS
      level commands.

Installation:

    - You can use this unit without installing it as a component on your
      delphi component palette!  Isn't that a blessing!   You can simply
      a simple inherited object to run in console mode or in a gui mode.
      See examples.

    - If you want to put the component on your palette, use your normal
      Delphi method of installing components, in this case WEXECLIB.PAS

Legal:

    WExecLib is copyrighted 1997 by Santronics Software Inc.

    You may use this unit as you please for your own work, except
    mis-represent this unit as your own, i.e.,  you can't say you wrote
    this unit and distribute it to others even if you make changes to it.

    You may make (and it is encouraged) changes to this library and
    distribute it to others, but you must keep the original copyright as
    shown above in the source file.

Contact/Support:

    Hector Santos/President of Santronics Software Inc

    email: hector@santronics.com
    fido:  1:135/382

    There will be support only on a "normal basis" on the Borland Newsgroup
    or by direct email.   By normal, I mean, send your message, and if I
    happen to read it and I feel I can answer your question, I will reply.

    Of course, if you find any bugs, please submit them to me at the above
    address.  We have many products to support so please indicate WEXECLIB,
    and where did you download it from (has it been modified).

    If you need any customization or special programming needs, I will
    consider the work on a per fee basis.

History:

1.0    05/30/97  - Original Release
1.1    08/18/97  - Added Delphi 2.0 compiler support.

////////////////////////////////////////////////////////////////////////*)

{$O+,H+,I-,S-,A-}
unit wexeclib;

interface

uses
  Windows, DosLib2, SysUtils, Classes, Messages;

{$IFDEF VER90}
Const
  DUPLICATE_CLOSE_SOURCE = $00000001;
  DUPLICATE_SAME_ACCESS  = $00000002;
{$ENDIF}

CONST
  EXEC_HIDE     =  SW_HIDE;            // Background, no redirect
  EXEC_DEFAULT  =  SW_NORMAL;          // Show Normal Window For App
  EXEC_REDIRECT = -2;                  // Background, redirection

type

  TOnRedirectChar  = procedure(Sender: TObject; const ch : char) of object;
  TOnTaskSwitch    = Function(Sender: TObject):Boolean of object;
  TOnComplete      = Function(Sender: TObject):Boolean of object;
  TOnError         = procedure(Sender: TObject; Const Msg: string) of object;
  TOnDebug         = procedure(Sender: TObject; const msg : string) of object;

  TRunProcess   = class(TComponent)
  private

    //
    // Events
    //

    FOnRedirectChar  : TOnRedirectChar;
    FOnTaskSwitch    : TOnTaskSwitch;
    FOnError         : TOnError;
    FOnDebug         : TOnDebug;
    FOnComplete      : TOnComplete;

    //
    // Inspector Properties

    FCommand         : String;
    FUseWait         : Boolean;
    FUseComSpec      : Boolean;
    FUseShow         : Integer;

    //
    // Accessible Properties
    //

    FPiInfo          : TProcessInformation;
    FError           : Integer;

  protected

    hThisProc   : THANDLE;            // current process handle
    hPipeIn     : THANDLE;            // Pipe input
    hPipeOut    : THANDLE;            // Pipe output
    hConsoleOut : THANDLE;            // console output

    Procedure FlushRedirection;

  public

    AbortWait : Boolean;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Function  Execute : boolean;

    //
    // Virtual functions, useful when using component in console mode
    //

    Procedure LogError(Const S : String);    virtual;
    Procedure LogDebug(Const S : String);    virtual;
    Function DoTaskSwitch : boolean;         virtual;
    Procedure RedirectChar(const ch : char); virtual;
    Procedure Complete;                      virtual;

  published

    property LastError: Integer Read FError;
    property ProcessInfo: TProcessInformation Read FPiInfo;

    //
    // Properties for Object Inspector
    //

    property Command: String Read FCommand Write FCommand;
    property UseWait: Boolean read FUseWait Write FUseWait default TRUE;
    property UseComSpec: Boolean read FUseComSpec Write FUseComSpec default FALSE;
    property UseShow: integer read FUseShow Write FUseShow default EXEC_HIDE;

    //
    // Events for Object Inspector
    //

    property OnError: TOnError read FOnError write FOnError;
    property OnDebug: TOnDebug read FOnDebug write FOnDebug;
    property OnTaskSwitch: TOnTaskSwitch read FOnTaskSwitch write FOnTaskSwitch;
    property OnRedirectChar: TOnRedirectChar read FOnRedirectChar write FOnRedirectChar;
    property OnComplete: TOnComplete read FOnComplete write FOnComplete;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Santronics', [TRunProcess]);
end;

(********************************************************************)

constructor TRunProcess.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fUseWait    := TRUE;
  fUseComSpec := FALSE;
  fUseShow    := EXEC_REDIRECT;
end;

destructor TRunProcess.Destroy;
begin
  inherited Destroy;
end;

function TRunProcess.Execute : Boolean;
 var
   proccmd      : string;
   sa           : TSECURITYATTRIBUTES;
   si           : TSTARTUPINFO;
   RedirectOn   : boolean;
 begin

  ZeroMemory(@result,sizeof(result));
  result := FALSE;
  if FCommand = '' then
     begin
       fError := ERROR_INVALID_PARAMETER;
       LogError('Process Command Empty');
       exit;
     end;

  if FUseComSpec Then
     begin
       proccmd := GetEnv('COMSPEC');
       LogDebug('Using COMSPEC='+proccmd);
       proccmd := proccmd+' /C '+FCommand;
     end
  else
     begin
       proccmd := FindProcessFile(FCommand,TRUE);
       if proccmd = '' then
          begin
            FError := ERROR_FILE_NOT_FOUND;
            LogError('Process not found: "'+FCommand+'"');
            exit;
          end
       else
       LogDebug('Process Full File Name: '+ProcCmd);

       if pos(' ',FCommand) > 0 then
          proccmd := proccmd + copy(FCommand,
                                    pos(' ',FCommand),
                                    length(FCommand));
     end;

  hThisProc := GetCurrentProcess;

  RedirectOn := FUseShow = EXEC_REDIRECT;
  if RedirectOn then
     begin
       LogDebug('Creating Redirection Handles');
       FUseShow  := SW_HIDE;
       ZeroMemory(@sa,sizeof(sa));
       sa.nLength := sizeof(sa);
       sa.bInheritHandle := True;
       if not CreatePipe(hPipeOut,hPipeIn,@sa,0) then
          begin
           FError := GetLastError;
           LogError('Error CreatePipe : '+IntToStr(GetLastError));
           exit;
          end;

       if not DuplicateHandle(hThisProc,
                              hPipeIn,
                              hThisProc,
                              @hConsoleOut,
                              0,
                              TRUE,
                              DUPLICATE_CLOSE_SOURCE
                                or DUPLICATE_SAME_ACCESS
                              ) then
          begin
            FError := GetLastError;
            LogError('Error DuplicateHandle: '+IntToStr(GetLastError));
            CloseHandle(hPipeOut);
            CloseHandle(hPipeIn);
            CloseHandle(hConsoleOut);
            exit;
          end;
                             
     end;

  ZeroMemory(@si,sizeof(si));
  si.cb := sizeof(si);

  if FUseShow >= SW_HIDE then
     begin
       si.dwFlags     := si.dwFlags or STARTF_USESHOWWINDOW;
       si.wShowWindow := FUseShow;
     end;

  if RedirectOn then
     begin
       si.dwFlags    := si.dwFlags or STARTF_USESTDHANDLES;
       si.hStdOutput := hConsoleOut;
       si.hStdError  := hConsoleOut;
     end;

  try
    LogDebug('Creating Process: ['+proccmd+']');
    AbortWait := FALSE;
    if CreateProcess(nil,                     // lpApplication
                     pChar(proccmd),          // lpCommandLine
                     nil,                     // lpProcessAttributes
                     nil,                     // lpThreadAttributes
                     RedirectOn,              // bInheritHandles
                     NORMAL_PRIORITY_CLASS
                       or CREATE_NEW_CONSOLE, // dwCreateFlags
                     nil,                     // lpEnvironment
                     nil,                     // lpCurrentDirectory
                     si,                      // lpStartupInfo
                     FPiInfo) then            // lpProcessInformation
       begin
        try
          Result := TRUE;
          fError := 0;
          if FUseWait then
             begin
               LogDebug('Begin Wait Process Completion');
               if RedirectOn then
                  begin
                   CloseHandle(hConsoleOut);
                   hConsoleOut := INVALID_HANDLE_VALUE;
                   LogDebug('Begin Redirection');
                  end;
               while WaitForSingleObject(FpiInfo.hProcess, 100) <> WAIT_OBJECT_0 do
                 begin
                  if AbortWait or (not DoTaskSwitch) then
                     begin
                       LogError('Force Exit: Process Wait Completion Aborted');
                       exit;
                     end;
                  if redirectOn then FlushRedirection;
                 end;
               if ReDirectOn then
                  begin
                    FlushRedirection;
                    LogDebug('End Redirection');
                  end;
               LogDebug('End Wait Process Completion');
             end;
        finally
          CloseHandle(FpiInfo.hThread);
          CloseHandle(FpiInfo.hProcess);
          LogDebug('Closing Process/Thread handles');
        end;
       end
    else
       begin
         Result := FALSE;
         FError := GetLastError;
         LogError('CreateProcess Error ('+IntToStr(FError)+') '+FCommand);
       end;
  finally
    if RedirectOn then
       begin
        CloseHandle(hPipeOut);
//        CloseHandle(hPipeIn); // nicht nötig durch DUPLICATE_CLOSE_SOURCE
        If hConsoleOut <> INVALID_HANDLE_VALUE then CloseHandle(hConsoleOut);
        LogDebug('Closing Redirection Handles');
       end;
    if Result then Complete;
  end;
 end;

Procedure TRunProcess.RedirectChar(const ch : char);
 begin
   if Assigned(FOnRedirectChar) then
      FOnRedirectChar(Self,ch);
 end;

Procedure TRunProcess.FlushRedirection;
const max = 1024;
var
   buffer : array[0..max] of char;
   i      : integer;
   n      : cardinal;
  begin
    While PeekNamedPipe(hPipeOut,@Buffer,Max,@n,Nil,Nil) do
       begin
         if n <=0 then break;
         LogDebug('Flush Redirection (bytes: '+IntToStr(N)+')');
         if ReadFile(hPipeOut, Buffer, Max, n, nil) then
            for i := 0 to n-1 do RedirectChar(buffer[i]);
       end;
  end;


Procedure TRunProcess.Complete;
 begin
   if Assigned(FOnComplete) then
      FOnComplete(Self);
 end;

Function TRunProcess.DoTaskSwitch:Boolean;
  begin
    Result := True;
    if Assigned(FOnTaskSwitch) then
       Result := FOnTaskSwitch(Self);
  end;

Procedure TRunProcess.LogDebug(Const s : String);
  begin
    if Assigned(FOnDebug) then FOnDebug(Self,S);
  end;

Procedure TRunProcess.LogError(Const s : String);
  begin
    if Assigned(FOnError) then FOnError(Self,S);
  end;

end.
