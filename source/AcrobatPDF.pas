unit AcrobatPDF;


{==============================================================================}
interface

uses SysUtils, Classes, Controls, PdfLib_TLB;

function AcrobatIsInstalled : boolean;
function CreateEmbeddedPdfViewer(var Viewer:TPdf; Owner:TComponent): boolean;


{==============================================================================}
implementation

uses Windows, Registry;


function RegistryReadString(const AKey: HKey; AName: String): String;
  {Returns the string value of 'standard' registry key. If not found, the
  function returns false.}
var
  ARegistry : TRegistry;                             {registry access}
  AValue    : String;
begin
  Result := '';                                     {assume not found}
  ARegistry := TRegistry.Create;                    {create object}

  with ARegistry do
  begin
    try
      Rootkey:=AKey;
      if OpenKeyReadOnly(AName) then begin
        AValue := ReadString('');          {get the value for standard string }
        If (Length(AValue) > 1) and (AValue[1] = #34) Then Delete(AValue,1,1);
        If (Length(AValue) > 1) and (AValue[Length(AValue)] = #34) Then
         Delete(AValue,Length(AValue),1);
        Result := AValue;
      end;
    finally
      Free;
    end;
  end;
end;

{------------------------------------------------------------------------------}
function AcrobatIsInstalled: boolean;
begin
 Result := FileExists(RegistryReadString(HKEY_CLASSES_ROOT,
                      '\Software\Adobe\Acrobat\Exe'));
end;

{------------------------------------------------------------------------------}
function CreateEmbeddedPdfViewer(var Viewer:TPdf; Owner:TComponent) :
boolean;
{
 Given a nil TPdf object and a container control, create a PDF
 viewer instance, embedded in the control.  The PDF control is set
 for CLIENT alignment.
}
begin
 Result := true;
 Viewer := TPdf.Create(Owner);
 try
   with Viewer
  do begin
//   Parent  := TWinControl(Owner);
   Parent  := Viewer;
//   Align   := alClient;
//   Visible := true;
  end;
 except
  Result := false;
 end;
end;


end.
