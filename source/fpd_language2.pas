unit fpd_language2;
// language file for Fido-Package deluxe (www.fido-deluxe.de.vu)
// last change: 11-Jun-2005

interface

var s: array[1..255] of string;
    sprache  : String[20]; // Sprache (deutsch, englisch, flaemisch)
    sprache_Hinweis, sprache_Fehler, sprache_Info: PChar;
    sprache_Fehlercode: string;

procedure sprachen_strings_initialisieren(sprache: String);

implementation

procedure sprachen_strings_initialisieren(sprache: String);
begin
if sprache = 'englisch' then begin
  s[0072] := 'Fido-Menu';
  s[0106] := 'The Fido-Package deluxe is uninstalled, now.';
  s[0107] := 'Uninstall';
  s[0108] := 'Really uninstall the Fido-Package deluxe?';

  sprache_Hinweis := 'Notice';
  sprache_Fehler := 'Error';
  sprache_Info := 'Info';
end

else if sprache = 'flaemisch' then begin
  s[0072] := 'Fido-Menu';
  s[0106] := 'Das Fido-Paket deluxe ist nun deinstalliert.';
  s[0107] := 'Verwijderen';
  s[0108] := 'Ben je zeker dat je Fido-Pakket Deluxe wilt verwijderen?';

  sprache_Hinweis := 'Tip';
  sprache_Fehler := 'Fout';
  sprache_Info := 'Info';
end

else if sprache = 'russisch' then begin
  s[0072] := 'Fido-menu';
  s[0106] := 'Фидо-пакет удалён.';
  s[0107] := 'Удалить';
  s[0108] := 'ЁНа самом деле удалить Фидо-пакет делюкс?';

  sprache_Hinweis := 'Указание';
  sprache_Fehler := 'Ошибка';
  sprache_Info := 'Информация';
end

else if sprache = 'spanisch' then begin
  s[0072] := 'Fido-Menu';
  s[0106] := 'Fido-Package deluxe est desinstalado ahora.';
  s[0107] := 'Desinstalar';
  s[0108] := 'їRealmente quieres desinstalar Fido-Package deluxe?';

  sprache_Hinweis := 'Aviso';
  sprache_Fehler := 'Error';
  sprache_Info := 'Info';
end

else {if sprache = 'deutsch' then} begin
  s[0072] := 'Fido-Menь';
  s[0106] := 'Das Fido-Paket deluxe ist nun deinstalliert.';
  s[0107] := 'Deinstallation';
  s[0108] := 'Soll das Fido-Paket deluxe wirklich deinstalliert werden?';

  sprache_Hinweis := 'Hinweis';
  sprache_Fehler := 'Fehler';
  sprache_Info := 'Info';
end


end;

end.

