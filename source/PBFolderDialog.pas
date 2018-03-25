{Author:	Poul Bak}
{Copyright © 1999 : BakSoft-Denmark (Poul Bak). All rights reserved.}
{http://home11.inet.tele.dk/BakSoft/}
{Mailto: baksoft-denmark@dk2net.dk}
{}
{Component Version: 1.10.00.00}
{}
{PBFolderDialog is SHBrowseForFolder dialog with capability of creating new folders when browsing for a folder.}
{It can show path above the window.}
{The 'New folder'-button caption and a 'Label'-caption (shown above the path) are automatic localized (national language) detected every time the application runs.}
{The component is based on Todd Fast's TBrowseFolder component.}

unit PBFolderDialog;

interface

uses
	Windows, Messages, Classes, Forms, Dialogs, SysUtils, ActiveX, Shlobj,
	FileCtrl, Controls, Graphics, Registry;

type
{Decides what foldertypes to accept and whether to show path.}
	TBrowseInfoFlags=(OnlyComputers, OnlyPrinters, OnlyDomains, OnlyAncestors,
		OnlyFileSystem, ShowPath);
{Decides what foldertypes to accept and whether to show path.}
	TBrowseInfoFlagSet=set of TBrowseInfoFlags;
{List of Foldernames used as the root-folder. Users can not browse to a folder above that level.}
	TSHFolders=(foDesktop,foDesktopExpanded,foPrograms,foControlPanel,foPrinters,foPersonal,foFavorites,foStartup,foRecent,
		foSendto,foRecycleBin,foStartMenu,foDesktopFolder,foMyComputer,foNetwork,foNetworkNeighborhood,
		foFonts,foTemplates);

	TPBFolderDialog = class;
{The event that is triggered when the dialog has initialized.}
	TBrowserInitializedEvent=procedure(Sender: TPBFolderDialog; DialogHandle: HWND) of object;
{The event that is triggered whenever a folder is selected.}
	TSelectionChangedEvent=procedure(Sender: TPBFolderDialog; DialogHandle: HWND; const ItemIDList: PItemIDList; const Folder: String) of object;

{Author:	Poul Bak}
{Copyright © 1999 : BakSoft-Denmark (Poul Bak). All rights reserved.}
{http://home11.inet.tele.dk/BakSoft/}
{Mailto: baksoft-denmark@dk2net.dk}
{}
{Component Version: 1.00.00.00}
{}
{PBFolderDialog is SHBrowseForFolder dialog with capability of creating new folders when browsing for a folder.}
{It can show path above the window.}
{The 'New folder'-button caption and a 'Label'-caption (shown above the path) are automatic localized (national language) detected every time the application runs.}
	TPBFolderDialog = class(TComponent)
	private
		FDialogHandle : HWnd;
		FNewFolderHandle : HWnd;
		FLabelCaption : String;
		FParentHandle : HWnd;
		FDisplayName : String;
		FImageIndex : Integer;
		FFolder : String;
		FSelectedFolder : String;
		FFlags : TBrowseInfoFlagSet;
		FRootFolder : TSHFolders;
		FNewFolderVisible : Boolean;
		FNewFolderEnabled : Boolean;
		FNewFolderCaption : String;
		FNewFolderWidth : Integer;
		FRestart : Boolean;
		FValidPath : Boolean;
		FVersion, FLocale : string;
		FNewFolderCaptions : TStrings;
		FLabelCaptions : TStrings;
		FOnInitialized : TBrowserInitializedEvent;
		FOnSelectionChanged : TSelectionChangedEvent;
		function LocaleText(List : TStrings) : string;
		function MakeDisplayPath(Path : string; MaxL : integer) : string;
		procedure Dummy(Value: String);
		procedure SetNewFolderCaption(Value : String);
		procedure SetNewFolderEnabled(Value : Boolean);
		procedure SetNewFolderWidth(Value : Integer);
		procedure SetNewFolderCaptions(Value : TStrings);
		procedure SetSelectedFolder(Value : String);
		procedure SetFlags(Value : TBrowseInfoFlagSet);
		procedure SetLabelCaptions(Value : TStrings);
	protected
	public
		constructor Create(AOwner : TComponent); override;
		destructor Destroy; override;
{Use the Execute function to browse for a folder. if the user presses 'Ok' the Folder-property will contain the path to the selected folder.}
{If the user presses 'Cancel' the Folder-property will not change.}
		function Execute : Boolean;
{Use this procedure to set the selected folder to an ItemIDList.}
{Use it from an event.}
		procedure SetSelectionPIDL(const Hwnd : HWND; const ItemIDList : PItemIDList);
{Use this procedure to set the selected folder to a path.}
{Use it from an event.}
		procedure SetSelectionPath(const Hwnd : HWND; const Path : String);
{Use this procedure to Enable/Disable the 'Ok'-button.}
{Use it from an event.}
		procedure EnableOK(const Hwnd : HWND; const Value : Boolean);
{Use this procedure to get an ItemIDList, when you know the path.}
		procedure GetIDListFromPath(Path: String; var ItemIDList: PItemIDList);
{This property gives the Window-title (when you open a folder in Explorer).}
{The DisplayName is normally the short foldername.}
		property DisplayName : String read FDisplayName;
{A system index to the image for the folder.}
		property ImageIndex : Integer read FImageIndex;
{The handle of the parent window (the form that called the dialog.}
		property ParentHandle : HWnd read FParentHandle write FParentHandle;
{The handle of the dialog.}
		property DialogHandle : HWnd read FDialogHandle write FDialogHandle;
{The handle of the 'New folder' button.}
		property NewFolderHandle : HWnd read FNewFolderHandle write FNewFolderHandle;
{The currently selected folder. You can access and set this path in one of the events.}
		property SelectedFolder : String read FSelectedFolder write SetSelectedFolder;
	published
{The Folder that is selected when the dialog opens and, when returned, contains the path to the folder the user selected.}
		property Folder : String read FFolder write FFolder;
{Decides what foldertypes to accept and whether to show path.}
		property Flags : TBrowseInfoFlagSet read FFlags write SetFlags;
{The root-folder. Users can not browse to a folder above that level.}
		property RootFolder : TSHFolders read FRootFolder write FRootFolder default foDesktopExpanded;
{Decides if the 'New folder' button shall be visible.}
		property NewFolderVisible : Boolean read FNewFolderVisible write FNewFolderVisible default FALSE;
{Decides if the 'New folder' button shall be enabled.}
		property NewFolderEnabled : Boolean read FNewFolderEnabled write SetNewFolderEnabled default TRUE;
{Sets the with of the 'New folder' button. Change it if it isn't large enough for your language.}
		property NewFolderWidth : Integer read FNewFolderWidth write SetNewFolderWidth default 110;
{The event that is triggered when the dialog has initialized.}
		property OnInitialized : TBrowserInitializedEvent read FOnInitialized write FOnInitialized;
{The event that is triggered whenever a folder is selected.}
		property OnSelectionChanged : TSelectionChangedEvent read FOnSelectionChanged write FOnSelectionChanged;
{LabelCaptions is the localized caption-list for the caption above the browsewindow.}
{See the 'International codes.txt'-file to find the codes.}
{At runtime the text that fits the Windows-language is used.}
{If the Windows-localeversion is not found in the list the 'Default'-value is used.}
		property LabelCaptions : TStrings read FLabelCaptions write SetLabelCaptions;
{NewFolderCaptions is the localized caption-list for the caption of the 'New folder' button.}
{See the 'International codes.txt'-file to find the codes.}
{At runtime the text that fits the Windows-language is used.}
{If the Windows-localeversion is not found in the list the 'Default'-value is used.}
		property NewFolderCaptions : TStrings read FNewFolderCaptions write SetNewFolderCaptions;
//Component-Version: 1.00.00.00
//ReadOnly property.
		property Version : string read FVersion write Dummy;
	end;

procedure Register;

implementation

const
	_BUTTON_ID=255;
	MAX_PATH_DISPLAY_LENGTH=50;
	NUMBER_OF_BROWSE_INFO_FLAGS=6;
	BROWSE_FLAG_ARRAY: array[TBrowseInfoFlags] of Integer = (BIF_BROWSEFORCOMPUTER,
		BIF_BROWSEFORPRINTER, BIF_DONTGOBELOWDOMAIN, BIF_RETURNFSANCESTORS,
		BIF_RETURNONLYFSDIRS, BIF_STATUSTEXT);
	SH_FOLDERS_ARRAY: array[TSHFolders] of Integer=
		(CSIDL_DESKTOP,-1,
		CSIDL_PROGRAMS,CSIDL_CONTROLS,CSIDL_PRINTERS,CSIDL_PERSONAL,CSIDL_FAVORITES,
		CSIDL_STARTUP,CSIDL_RECENT,CSIDL_SENDTO,CSIDL_BITBUCKET,CSIDL_STARTMENU,CSIDL_DESKTOPDIRECTORY,
		CSIDL_DRIVES,CSIDL_NETWORK,CSIDL_NETHOOD,CSIDL_FONTS,CSIDL_TEMPLATES);


procedure CenterWindow(HWindow: HWND);
var
	Rect0: TRect;
begin
	GetWindowRect(HWindow,Rect0);
	SetWindowPos(HWindow,0,
		(Screen.Width div 2) - ((Rect0.Right-Rect0.Left) div 2),
		(Screen.Height div 2) - ((Rect0.Bottom - Rect0.Top) div 2),
		0,0,SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER);
end;

function WndProc(HWindow: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
	Instance: TPBFolderDialog;
	NewFolder : String;
begin
	Instance:=TPBFolderDialog(GetWindowLong(HWindow,GWL_USERDATA));
	if (Msg=WM_COMMAND) and (Lo(wParam)=_BUTTON_ID) then
	begin
		NewFolder := InputBox(Instance.FNewFolderCaption, '', '');
		if NewFolder <> '' then
		begin
			Instance.FRestart := True;
			if (NewFolder[1] <> '\')
				and (Instance.FSelectedFolder[Length(Instance.FSelectedFolder)] <> '\')
				then NewFolder := '\' + NewFolder;
			Instance.FSelectedFolder := Instance.FSelectedFolder + NewFolder;
			ForceDirectories(Instance.FSelectedFolder);
			Keybd_Event(VK_ESCAPE, 0, 0, 0);
			Keybd_Event(VK_ESCAPE, 0, KEYEVENTF_KEYUP, 0);
		end;
		Result:=0;
	end
	else Result:=DefDlgProc(HWindow,Msg,wParam,lParam);
end;

procedure AddControls(HWindow: HWND; Instance: TPBFolderDialog);
var
	NewFolderWindowHandle: HWND;
	TempFont: TFont;
	ControlCreateStyles: Integer;
begin
	ControlCreateStyles := WS_CHILD or WS_CLIPSIBLINGS or WS_VISIBLE or WS_TABSTOP
		or BS_PUSHBUTTON;
	NewFolderWindowHandle:=CreateWindow('Button', PChar(Instance.FNewFolderCaption), ControlCreateStyles,
	12, 276, Instance.FNewFolderWidth, 23, HWindow, _BUTTON_ID, HInstance, nil);
	TempFont := NIL;
	try
		TempFont:=TFont.Create;
		PostMessage(NewFolderWindowHandle,WM_SETFONT,Longint(TempFont.Handle),MAKELPARAM(1,0));
	finally
		TempFont.Free;
	end;
	EnableWindow(NewFolderWindowHandle,Instance.FNewFolderEnabled);
	SetWindowLong(HWindow,GWL_WNDPROC,Longint(@WndProc));
	Instance.FNewFolderHandle:=NewFolderWindowHandle;
end;

procedure BrowserCallbackProc(HWindow: HWND; uMsg: Integer; lParameter: LPARAM; lpPBFolderDialog: LPARAM); stdcall;
var
	Instance: TPBFolderDialog;
	Path: String;
	TempPath: array[0..MAX_PATH] of Char;
	SHFolderI: IShellFolder;
	lpDisplay : TStrRet;
begin
	Instance:=TPBFolderDialog(lpPBFolderDialog);
	case uMsg of
		BFFM_INITIALIZED:
		begin
			Instance.DialogHandle:=HWindow;
			CenterWindow(HWindow);
			SetWindowLong(HWindow,GWL_USERDATA,lpPBFolderDialog);
			if Instance.FNewFolderVisible then AddControls(HWindow,Instance);
			if IsWindow(Instance.FNewFolderHandle) then EnableWindow(Instance.FNewFolderHandle, Instance.FValidPath);
			if DirectoryExists(Instance.FFolder) then
				Instance.SetSelectionPath(HWindow,Instance.FFolder);
			if Assigned(Instance.OnInitialized) then
				Instance.OnInitialized(Instance,HWindow);
		end;
		BFFM_SELCHANGED:
		begin
			SHGetPathFromIDList(PItemIDList(lParameter),TempPath);
			Instance.FSelectedFolder := StrPas(TempPath);
			if (ShowPath in Instance.FFlags) then
			begin
				SetLength(Path,MAX_PATH);
				Path := Instance.MakeDisplayPath(StrPas(TempPath), MAX_PATH_DISPLAY_LENGTH);
				if Path = '' then
				begin
					if SHGetDeskTopFolder(SHFolderI) = NOERROR then
					begin
						SHFolderI.GetDisplayNameOf(PItemIDList(lParameter), SHGDN_FORPARSING, lpDisplay);
						if lpDisplay.uType = STRRET_CSTR then Path := StrPas(lpDisplay.cStr);
					end;
				end;
				SendMessage(HWindow,BFFM_SETSTATUSTEXT,0,Longint(PChar(Path)));
			end;
			Instance.FValidPath := (Instance.FSelectedFolder <> '');
			if (OnlyFileSystem in Instance.FFlags) then Instance.EnableOK(HWindow, Instance.FValidPath)
			else Instance.EnableOK(HWindow, True);
			if IsWindow(Instance.FNewFolderHandle)
				then EnableWindow(Instance.FNewFolderHandle, Instance.FValidPath);
			if Assigned(Instance.OnSelectionChanged) then
				Instance.OnSelectionChanged(Instance,HWindow,PItemIDList(lParameter),Instance.SelectedFolder);
		end;
	end;
end;

constructor TPBFolderDialog.Create(AOwner: TComponent);
var
	FReg : TRegistry;
begin
	inherited Create(AOwner);
	SetLength(FDisplayName,MAX_PATH);
	SetLength(FFolder,MAX_PATH);
	FParentHandle:=0;
	FRootFolder:=foDesktopExpanded;
	FNewFolderVisible:=True;
	FNewFolderEnabled:=True;
	FNewFolderWidth:=110;
	FFlags:=[ShowPath];
	FFolder:='';
	FSelectedFolder:='';
	FValidPath := True;
	FVersion := '1.10.00.00';
	FReg := TRegistry.Create;
	with FReg do
	begin
		if OpenKey('\Control Panel\Desktop\ResourceLocale', False) then
		begin {Windows 9x installation language}
			FLocale := ReadString('');
			FLocale := UpperCase(Copy(FLocale, length(FLocale) - 3, 4));
		end
		else
		begin {Windows NT installation language}
			RootKey := HKEY_USERS;
			if OpenKey('\.DEFAULT\Control Panel\International', False) then
			begin
				FLocale := ReadString('Locale');
				FLocale := UpperCase(Copy(FLocale, length(FLocale) - 3, 4));
			end;
		end;
	end;
	FReg.Free;
	FNewFolderCaptions := TStringList.Create;
	FNewFolderCaptions.CommaText := '"Default=Neues Verzeichnis", "0009=New folder",' +
		'"0406=Ny mappe", "0407=Neues Verzeichnis", "0409=New folder", "0413=Nieuwe map"' +
                '"0813=Nieuwe map"';
	SetNewFolderCaption(LocaleText(FNewFolderCaptions));
	FLabelCaptions := TStringList.Create;
	FLabelCaptions.CommaText := '"Default=Installations-Verzeichnis:", "0009=Install folder:",' +
		'"0406=Valgt mappe:", "0407=Installations-Verzeichnis:", "0409=Install folder:",' +
		'"0413=Installatie map:", "0813=Installatie map:"';
	FLabelCaption := LocaleText(FLabelCaptions);
end;

destructor TPBFolderDialog.Destroy;
begin
	FNewFolderCaptions.Free;
	FLabelCaptions.Free;
	inherited Destroy;
end;

procedure TPBFolderDialog.GetIDListFromPath(Path: String; var ItemIDList: PItemIDList);
var
	ShellFolderInterface: IShellFolder;
	CharsParsed: ULONG;
	Attributes: ULONG;
begin
	if SHGetDesktopFolder(ShellFolderInterface)=NOERROR then
	begin
		if DirectoryExists(Path) then
			ShellFolderInterface.ParseDisplayName(0,nil,StringToOleStr(Path),CharsParsed,ItemIDList,Attributes);
	end;
end;

procedure TPBFolderDialog.SetSelectionPIDL(const Hwnd: HWND; const ItemIDList: PItemIDList);
begin
	SendMessage(Hwnd,BFFM_SETSELECTION,Ord(FALSE),Longint(ItemIDList));
end;

procedure TPBFolderDialog.SetSelectionPath(const Hwnd: HWND; const Path: String);
begin
	SendMessage(Hwnd,BFFM_SETSELECTION,Ord(TRUE),Longint(PChar(Path)));
end;

procedure TPBFolderDialog.EnableOK(const Hwnd: HWND; const Value: Boolean);
begin
	SendMessage(Hwnd,BFFM_ENABLEOK,0,Ord(Value));
end;

procedure TPBFolderDialog.SetNewFolderEnabled(Value: Boolean);
begin
	FNewFolderEnabled:=Value;
	if (IsWindow(FNewFolderHandle)) then EnableWindow(FNewFolderHandle,Value);
end;

procedure TPBFolderDialog.SetNewFolderCaption(Value: String);
begin
	FNewFolderCaption:=Value;
	if (IsWindow(FNewFolderHandle)) then SetWindowText(FNewFolderHandle,PChar(Value));
end;

procedure TPBFolderDialog.SetNewFolderWidth(Value: Integer);
begin
	if Value<=0 then FNewFolderWidth:=110
	else FNewFolderWidth:=Value;
end;

procedure TPBFolderDialog.SetSelectedFolder(Value: String);
begin
	SetSelectionPath(DialogHandle,Value);
end;

procedure TPBFolderDialog.SetFlags(Value : TBrowseInfoFlagSet);
begin
	FFlags := Value;
end;

procedure TPBFolderDialog.SetLabelCaptions(Value : TStrings);
begin
	if FLabelCaptions.Text <> Value.Text then
	begin
		FLabelCaptions.Assign(Value);
		FLabelCaption := LocaleText(Value);
	end;
end;

procedure TPBFolderDialog.SetNewFolderCaptions(Value : TStrings);
begin
	if FNewFolderCaptions.Text <> Value.Text then
	begin
		FNewFolderCaptions.Assign(Value);
		FNewFolderCaption := LocaleText(Value);
	end;
end;

procedure TPBFolderDialog.Dummy(Value: String);
begin
//	Read only !
end;

function TPBFolderDialog.LocaleText(List : TStrings) : string;
begin
	if List.Count = 0 then Result := ''
	else
	begin
		if List.IndexOfName(FLocale) <> -1 then Result := List.Values[FLocale]
		else if List.IndexOfName('Default') <> -1 then Result := List.Values['Default']
		else Result := List.Values[List.Names[0]];
	end;
end;

function TPBFolderDialog.MakeDisplayPath(Path : string; MaxL : integer) : string;
var
	t, Pos0, NumBack : integer;
begin
	Result := '';
        t := Length(Path);
        if t > 0 then
         if Path[t] = '\' then Path := Path + 'Fido'
                          else Path := Path + '\Fido';
	if (Length(Path) <= MaxL) or (MaxL < 6) or (Pos('\', Path) = 0) then Result := Copy(Path, 1, MaxL)
	else
	begin
		NumBack := 0;
		for t := 3 to Length(Path) do if (Path[t] = '\') then inc(NumBack);
		if NumBack < 2 then Result := Copy(Path, 1, MaxL)
		else
		begin
			Pos0 := Pos('\', Path);
			if Pos0 < 3 then
			begin
				Result := '\\';
				Path := Copy(Path, 3, Length(Path) - 2);
			end;
			Pos0 := Pos('\', Path);
			Result := Result + Copy(Path, 1, Pos0) + '...';
			repeat
				Path := Copy(Path, Pos0 + 1, Length(Path) - Pos0);
				Pos0 := Pos('\', Path);
			until ((Length(Result + Path) + 1) <= MaxL) or (Pos0 = 0);
			if ((Length(Result + Path) + 1) <= MaxL) then Result := Result + '\' + Path
			else Result := Copy(Result + '\' + Path, 1, MaxL - 3) + '...';
		end;
	end;
end;

function TPBFolderDialog.Execute: Boolean;
var
	BrowseInfo: TBrowseInfo;
	ItemIDList: PItemIDList;
	i: Integer;
	TempPath: array[0..MAX_PATH] of Char;
begin
	FSelectedFolder := FFolder;
	ItemIDList := NIL;
	try
		if IsWindow(FParentHandle) then BrowseInfo.hwndOwner:=FParentHandle
		else if (Owner is TWinControl) then BrowseInfo.hwndOwner:=TWinControl(Owner).Handle
		else BrowseInfo.hwndOwner:=Application.MainForm.Handle;
		if FRootFolder=foDesktopExpanded then BrowseInfo.pidlRoot:=nil
		else SHGetSpecialFolderLocation(Application.Handle,SH_FOLDERS_ARRAY[FRootFolder],BrowseInfo.pidlRoot);
		BrowseInfo.pszDisplayName:=PChar(FDisplayName);
		BrowseInfo.lpszTitle:=PChar(FLabelCaption);
		BrowseInfo.ulFlags:=0;
		for i:=0 to NUMBER_OF_BROWSE_INFO_FLAGS-1 do
		begin
			if( TBrowseInfoFlags(i) in FFlags)
				then	BrowseInfo.ulFlags:=BrowseInfo.ulFlags
				or BROWSE_FLAG_ARRAY[TBrowseInfoFlags(i)];
		end;
		BrowseInfo.lpfn:=@BrowserCallbackProc;
		BrowseInfo.lParam:=Longint(Self);
		BrowseInfo.iImage:=0;
		FSelectedFolder := FFolder;
		repeat
			FRestart := False;
			FFolder := FSelectedFolder;
			{SHBrowseForFolder; return is nil if user cancels}
			ItemIDList:=SHBrowseForFolder(BrowseInfo);
		until not FRestart;

		Result:=(ItemIDList <> nil);
		if Result then
		begin
			SHGetPathFromIDList(ItemIDList,TempPath);
			FFolder:=StrPas(TempPath);
			FSelectedFolder:=FFolder;
			FImageIndex:=BrowseInfo.iImage;
		end;
	finally
		CoTaskMemFree(ItemIDList);
		CoTaskMemFree(BrowseInfo.pidlRoot);
	end;
end;

procedure Register;
begin
	RegisterComponents('PB', [TPBFolderDialog]);
end;

end.
