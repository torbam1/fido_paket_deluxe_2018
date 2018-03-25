unit crc; { CRC-16 Checksumme erstellen }

interface

Function crc_bilden_hex(CDPstring: String): String;
Function crc_bilden_dez(CDPstring: String): String;
Function Numb2Hex(numb: Word): String;

Var
  checksum     : LongInt; { berechnete CRC16 (dezimal)                    }


implementation

Function Byte2Hex(numb : Byte): String; { konvertiert Byte in Hex String }
Const HexChars: Array[0..15] of Char = '0123456789ABCDEF';
Begin
  Byte2Hex := '00';
  Byte2Hex[1] := HexChars[numb shr  4];
  Byte2Hex[2] := HexChars[numb and 15];
End; { Byte2Hex }

Function Numb2Hex(numb: Word): String;  { konvertiert Word in Hex String }
Begin
  Numb2Hex := Byte2Hex(hi(numb)) + Byte2Hex(lo(numb));
End; { Numb2Hex }

Function crc16_string(InString: String): Word;
{ CRC16 eines Strings berechnen, String wird uebergeben }
Var
  CRC   : Word;    { CRC16                             }
  i     : Integer; { Indexvariable fuer Schleife       }
  Index : Byte;    { Indexvariable fuer CRC-Berechnung }
Begin
  CRC := 0; { CRC initalisieren }

  { fuer jedes Zeichen des Strings CRC berechnen }
  For i := 1 to Length(InString) Do
  Begin
    CRC := (CRC xor (Ord(InString[i]) SHL 8));
    For Index := 1 to 8 Do
      If ((CRC and $8000) <> 0)
       Then CRC := ((CRC SHL 1) xor $1021)
       Else CRC := (CRC SHL 1)
  End;

  crc16_string := (CRC and $FFFF) { berechnete CRC16 zurueckgeben }
End; { crc16_string }


Function crc_bilden_hex(CDPstring: String): String;
Begin
  checksum := crc16_string(CDPString); { CRC16 eines Strings berechnen }
  checksum := checksum mod 32768;
  crc_bilden_hex := numb2hex(checksum);
End;

Function crc_bilden_dez(CDPstring: String): String;
Var crc_str: String;
Begin
  checksum := crc16_string(CDPString); { CRC16 eines Strings berechnen }
  checksum := checksum mod 32768;
  Str(checksum, crc_str);
  crc_bilden_dez := crc_str;
End;

{main}
Begin
End.

