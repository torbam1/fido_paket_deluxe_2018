�
 TANGABEN 0�  TPF0TAngabenAngabenLeft� Top� Width�Height5Caption"Installation des Fido-Paket deluxeColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Pitch
fpVariable
Font.Style OldCreateOrderPositionpoDesktopCenterScaledOnCloseQueryFormCloseQueryOnCreate
FormCreateOnShowFormShowPixelsPerInch`
TextHeight TLabelNameLeftTop	WidthHeightCaptionName  TLabelplzLeftTop'Width-HeightCaption	PLZ / Ort  TLabelTelefonLeftTopEWidth$HeightCaptionTelefon  TLabelPfadLeftTopSWidthrHeightCaptionInstallationsverzeichnis:   TLabelDeviceLeftTopiWidthHeightCaption<(Internet-) Verbindung �ber das DF� Netzwerk herstellen mit:  TLabelLBetriebssystemLeftTopWidth� HeightCaption!Erkanntes Betriebssystem: Windows  TLabelLCDPNodeLeftTopwWidthHeightCaption;Bei folgendem System als Fido-Teilnehmer (Point) eintragen:  TLabelLBeschreibungLeftTop�WidthHeightCaptionKVorwahl      Ort                                                 Sysop-Name  TLabel	LFakeInfoLeftTopWidth0HeightCaption	LFakeInfo  TEditTBOrtLeftPTop$Width� HeightTabOrder
OnKeyPressTBOrtKeyPress  TRadioGroupBSLeftTop� WidthAHeight)CaptionBetriebssystemColumns	ItemIndex Items.StringsWindows 95/98/MEWindows NT/2000/XP TabOrderVisible  TButtonCBokLeft(Top�Width� Height!Caption&Installation startenTabOrderOnClick	CBokClick  TButtonCBexitLeft� Top�Width� Height!Caption&Abbruch (Beenden)TabOrderOnClickCBexitClick  	TComboBoxListeDevicesLeftTopyWidth9HeightHint@Wenn Du Dir nicht sicher bist, belasse es bei der VoreinstellungStylecsDropDownList
ItemHeightParentShowHintShowHint	TabOrderOnChangeListeDevicesChange  TEditTBNameLeftPTopWidth� HeightHint Bitte Vor- und Nachname eingebenParentShowHintShowHint	TabOrder 
OnKeyPressTBNameKeyPress  	TMaskEdit	TBTelefonLeftPTopAWidth� HeightHintBBitte die Vorwahl und Rufnummer mit Minuszeichen getrennt eingebenEditMask#####################;1; 	MaxLengthParentShowHintShowHint	TabOrderText                     OnClickTBTelefonClick
OnKeyPressTBTelefonKeyPress  	TComboBoxCdpNodelistLeftTop�Width�HeightStylecsDropDownListDropDownCount
Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameCourier New
Font.Pitch
fpVariable
Font.Style 
ItemHeight
ParentFontSorted	TabOrder	OnChangeCdpNodelistChange  TButtonCBInstallDirLeftTop+Width� Height!Caption$Installations-&Verzeichnis ausw�hlenTabOrderOnClickCBInstallDirClick  	TComboBoxCdpNodelist2Left`Top� Width9HeightStylecsDropDownListEnabledFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameCourier New
Font.Pitch
fpVariable
Font.Style 
ItemHeight
ParentFontSorted	TabOrderVisible  	TComboBoxCdpNodelist_internetLeft`TopWidth9HeightStylecsDropDownListEnabledFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameCourier New
Font.Pitch
fpVariable
Font.Style 
ItemHeight
ParentFontSorted	TabOrderVisible  	TComboBoxCdpNodelist2_internetLeft`Top#Width9HeightStylecsDropDownListEnabledFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameCourier New
Font.Pitch
fpVariable
Font.Style 
ItemHeight
ParentFontSorted	TabOrderVisible  	TComboBoxCdpNodelist_dstnLeft`Top;Width9HeightStylecsDropDownListEnabledFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameCourier New
Font.Pitch
fpVariable
Font.Style 
ItemHeight
ParentFontSorted	TabOrderVisible  	TComboBoxCdpNodelist2_dstnLeftTop3Width9HeightStylecsDropDownListEnabledFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameCourier New
Font.Pitch
fpVariable
Font.Style 
ItemHeight
ParentFontSorted	TabOrderVisible  	TComboBox
lstEntriesLeftTopyWidthIHeightStylecsDropDownListFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameCourier New
Font.Pitch
fpVariable
Font.Style 
ItemHeight
ParentFontTabOrderVisible  	TGroupBoxProfiKonfigLeftTop� WidthTHeightYCaptionExperten-EinstellungenTabOrder 	TComboBoxCBProxyLeftTopWidthaHeight
ItemHeightItems.Strings
kein Proxy
http ProxySocks4 ProxySocks5 Proxy TabOrder TextCBProxyOnChangeCBProxyChange  TEdit	TBProxyIPLeftpTopWidth!HeightTabOrderTextProxy IPVisible  	TMaskEdit	ProxyPortLeft@TopWidth)HeightEditMask	99999;0;_	MaxLengthTabOrderVisible  	TCheckBox
CBProxyPwdLeftTop8WidthqHeightCaptionProxy AnmeldungTabOrderVisibleOnClickCBProxyPwdClick  TEditTBProxyUserLeft� Top8WidthQHeightTabOrderTextuserVisible  TEdit
TBProxyPwdLeft� Top8WidthYHeightTabOrderTextpasswortVisible   	TComboBoxCBechoListeLefthTop� Width9HeightStylecsDropDownListEnabledFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameCourier New
Font.Pitch
fpVariable
Font.Style 
ItemHeight
ParentFontSorted	TabOrderVisible  TButtonCBupdateLeftHTop`WidthiHeight$CaptionAktualisiere ListeTabOrderOnClickCBupdateClick  	TCheckBoxchkIstSchonPointLeft Top�WidthyHeightCaption.Keine Neuanmeldung, ich kenne die ZugangsdatenTabOrder
  TTimerTimerOnTimer
TimerTimerLeft�Top8  TPBFolderDialogVerzeichnisAuswahlFlagsOnlyComputersOnlyFileSystemShowPath 
RootFolderfoMyComputerNewFolderVisible	LabelCaptions.Strings"Default=Installations-Verzeichnis:0009=Install folder:0406=Valgt mappe:0407=Installations-Verzeichnis:0409=Install folder:0413=Installatie map:0813=Installatie map:0c0a=Instalar en carpeta: NewFolderCaptions.StringsDefault=Neues Verzeichnis0009=New folder0406=Ny mappe0407=Neues Verzeichnis0409=New folder0413=Nieuwe map0813=Nieuwe map0c0a=Nuevo directorio Version
1.10.00.00LefthTop�    