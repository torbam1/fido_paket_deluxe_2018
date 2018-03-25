unit PdfLib_TLB;

// ************************************************************************ //
// WARNUNG                                                                  //
// -------                                                                  //
// Die Typen, die in dieser Datei deklariert sind, sind Daten einer Typbibliothek.
// Wenn diese Typbibliothek explizit oder indirekt (via Verweis)  //
// re-importiert wird oder  die Anweisung 'Aktualisieren' im Editor //
// für Typbibliotheken beim Bearbeiten der Typbibliothek aktiviert ist //
// wird der Inhalt dieser Datei neu generiert und alle    //
// manuellen Änderungen gehen verloren.                           //
// ************************************************************************ //

// PASTLWTR : $Revision:   1.11.1.75  $
// Datei generiert aus 10.07.2001 19:43:02 aus der unten beschriebenen Typbibliothek.

// ************************************************************************ //
// Typbibl.: C:\Programme\Borland\Delphi4\Projects\pdf\pdf.ocx
// IID\LCID: {CA8A9783-280D-11CF-A24D-444553540000}\0
// Hilfedatei: 
// HilfsString: Acrobat Control for ActiveX
// Version:    1.3
// ************************************************************************ //

interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, StdVCL;

// *********************************************************************//
// GUIDS deklariert in Typbibliothek. Folgende Präfixe wurden verwendet:      //
//   Typbibl.     : LIBID_xxxx                                    //
//   CoClasses          : CLASS_xxxx                                    //
//   DISPInterfaces     : DIID_xxxx                                     //
//   Non-DISP interfaces: IID_xxxx                                      //
// *********************************************************************//
const
  LIBID_PdfLib: TGUID = '{CA8A9783-280D-11CF-A24D-444553540000}';
  DIID__DPdf: TGUID = '{CA8A9781-280D-11CF-A24D-444553540000}';
  DIID__DPdfEvents: TGUID = '{CA8A9782-280D-11CF-A24D-444553540000}';
  CLASS_Pdf: TGUID = '{CA8A9780-280D-11CF-A24D-444553540000}';
type

// *********************************************************************//
// Forward-Deklarationen von Schnittstellen definiert in Typbibl.            //
// *********************************************************************//
  _DPdf = dispinterface;
  _DPdfEvents = dispinterface;

// *********************************************************************//
// Deklaration von CoClasses definiert in Typbibl.                     //
// (HINWEIS: Hier wird jede CoClass ihrer Standardschnittstelle zugewiesen            //
// *********************************************************************//
  Pdf = _DPdf;


// *********************************************************************//
// DispIntf:  _DPdf
// Flags:     (4112) Hidden Dispatchable
// GUID:      {CA8A9781-280D-11CF-A24D-444553540000}
// *********************************************************************//
  _DPdf = dispinterface
    ['{CA8A9781-280D-11CF-A24D-444553540000}']
    property src: WideString dispid 1;
    function LoadFile(const fileName: WideString): WordBool; dispid 2;
    procedure setShowToolbar(On_: WordBool); dispid 3;
    procedure gotoFirstPage; dispid 4;
    procedure gotoLastPage; dispid 5;
    procedure gotoNextPage; dispid 6;
    procedure gotoPreviousPage; dispid 7;
    procedure setCurrentPage(n: Integer); dispid 8;
    procedure goForwardStack; dispid 9;
    procedure goBackwardStack; dispid 10;
    procedure setPageMode(const pageMode: WideString); dispid 11;
    procedure setLayoutMode(const layoutMode: WideString); dispid 12;
    procedure setNamedDest(const namedDest: WideString); dispid 13;
    procedure Print; dispid 14;
    procedure printWithDialog; dispid 15;
    procedure setZoom(percent: Single); dispid 16;
    procedure setZoomScroll(percent: Single; left: Single; top: Single); dispid 17;
    procedure setView(const viewMode: WideString); dispid 18;
    procedure setViewScroll(const viewMode: WideString; offset: Single); dispid 19;
    procedure setViewRect(left: Single; top: Single; width: Single; height: Single); dispid 20;
    procedure printPages(from: Integer; to_: Integer); dispid 21;
    procedure printPagesFit(from: Integer; to_: Integer; shrinkToFit: WordBool); dispid 22;
    procedure printAll; dispid 23;
    procedure printAllFit(shrinkToFit: WordBool); dispid 24;
    procedure setShowScrollbars(On_: WordBool); dispid 25;
    procedure AboutBox; dispid -552;
  end;

// *********************************************************************//
// DispIntf:  _DPdfEvents
// Flags:     (4096) Dispatchable
// GUID:      {CA8A9782-280D-11CF-A24D-444553540000}
// *********************************************************************//
  _DPdfEvents = dispinterface
    ['{CA8A9782-280D-11CF-A24D-444553540000}']
  end;


// *********************************************************************//
// Deklaration der Proxy-Klasse des OLE-Elements
// Name des Steuerelements     : TPdf
// Hilfe-String      : Acrobat Control for ActiveX
// Standard-Interface: _DPdf
// Vorgabe Intf. DISP? : Yes
// Ereignis-Interface: _DPdfEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TPdf = class(TOleControl)
  private
    FIntf: _DPdf;
    function  GetControlInterface: _DPdf;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function LoadFile(const fileName: WideString): WordBool;
    procedure setShowToolbar(On_: WordBool);
    procedure gotoFirstPage;
    procedure gotoLastPage;
    procedure gotoNextPage;
    procedure gotoPreviousPage;
    procedure setCurrentPage(n: Integer);
    procedure goForwardStack;
    procedure goBackwardStack;
    procedure setPageMode(const pageMode: WideString);
    procedure setLayoutMode(const layoutMode: WideString);
    procedure setNamedDest(const namedDest: WideString);
    procedure Print;
    procedure printWithDialog;
    procedure setZoom(percent: Single);
    procedure setZoomScroll(percent: Single; left: Single; top: Single);
    procedure setView(const viewMode: WideString);
    procedure setViewScroll(const viewMode: WideString; offset: Single);
    procedure setViewRect(left: Single; top: Single; width: Single; height: Single);
    procedure printPages(from: Integer; to_: Integer);
    procedure printPagesFit(from: Integer; to_: Integer; shrinkToFit: WordBool);
    procedure printAll;
    procedure printAllFit(shrinkToFit: WordBool);
    procedure setShowScrollbars(On_: WordBool);
    procedure AboutBox;
    property  ControlInterface: _DPdf read GetControlInterface;
  published
    property  TabStop;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
    property src: WideString index 1 read GetWideStringProp write SetWideStringProp stored False;
  end;

procedure Register;

implementation

uses ComObj;

procedure TPdf.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID: '{CA8A9780-280D-11CF-A24D-444553540000}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: nil;
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
end;

procedure TPdf.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as _DPdf;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TPdf.GetControlInterface: _DPdf;
begin
  CreateControl;
  Result := FIntf;
end;

function TPdf.LoadFile(const fileName: WideString): WordBool;
begin
  Result := ControlInterface.LoadFile(fileName);
end;

procedure TPdf.setShowToolbar(On_: WordBool);
begin
  ControlInterface.setShowToolbar(On_);
end;

procedure TPdf.gotoFirstPage;
begin
  ControlInterface.gotoFirstPage;
end;

procedure TPdf.gotoLastPage;
begin
  ControlInterface.gotoLastPage;
end;

procedure TPdf.gotoNextPage;
begin
  ControlInterface.gotoNextPage;
end;

procedure TPdf.gotoPreviousPage;
begin
  ControlInterface.gotoPreviousPage;
end;

procedure TPdf.setCurrentPage(n: Integer);
begin
  ControlInterface.setCurrentPage(n);
end;

procedure TPdf.goForwardStack;
begin
  ControlInterface.goForwardStack;
end;

procedure TPdf.goBackwardStack;
begin
  ControlInterface.goBackwardStack;
end;

procedure TPdf.setPageMode(const pageMode: WideString);
begin
  ControlInterface.setPageMode(pageMode);
end;

procedure TPdf.setLayoutMode(const layoutMode: WideString);
begin
  ControlInterface.setLayoutMode(layoutMode);
end;

procedure TPdf.setNamedDest(const namedDest: WideString);
begin
  ControlInterface.setNamedDest(namedDest);
end;

procedure TPdf.Print;
begin
  ControlInterface.Print;
end;

procedure TPdf.printWithDialog;
begin
  ControlInterface.printWithDialog;
end;

procedure TPdf.setZoom(percent: Single);
begin
  ControlInterface.setZoom(percent);
end;

procedure TPdf.setZoomScroll(percent: Single; left: Single; top: Single);
begin
  ControlInterface.setZoomScroll(percent, left, top);
end;

procedure TPdf.setView(const viewMode: WideString);
begin
  ControlInterface.setView(viewMode);
end;

procedure TPdf.setViewScroll(const viewMode: WideString; offset: Single);
begin
  ControlInterface.setViewScroll(viewMode, offset);
end;

procedure TPdf.setViewRect(left: Single; top: Single; width: Single; height: Single);
begin
  ControlInterface.setViewRect(left, top, width, height);
end;

procedure TPdf.printPages(from: Integer; to_: Integer);
begin
  ControlInterface.printPages(from, to_);
end;

procedure TPdf.printPagesFit(from: Integer; to_: Integer; shrinkToFit: WordBool);
begin
  ControlInterface.printPagesFit(from, to_, shrinkToFit);
end;

procedure TPdf.printAll;
begin
  ControlInterface.printAll;
end;

procedure TPdf.printAllFit(shrinkToFit: WordBool);
begin
  ControlInterface.printAllFit(shrinkToFit);
end;

procedure TPdf.setShowScrollbars(On_: WordBool);
begin
  ControlInterface.setShowScrollbars(On_);
end;

procedure TPdf.AboutBox;
begin
  ControlInterface.AboutBox;
end;

procedure Register;
begin
  RegisterComponents('ActiveX',[TPdf]);
end;

end.
