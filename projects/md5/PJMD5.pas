{
 * PJMD5.pas
 *
 * A Delphi Pascal implementation of the MD5 Message-Digest algorithm (RFC1321,
 * see http://www.faqs.org/rfcs/rfc1321.html.
 *
 * This work is derived from the RSA Data Security, Inc. MD5 Message-Digest
 * Algorithm. The copyright notice is included in this project's documentation.
 * The notice must be included with any redistribution of this work or any
 * derived work.
 *
 * $Rev$
 * $Date$
 *
 * ***** BEGIN LICENSE BLOCK *****
 *
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 *
 * Portions of the code are based on the reference implementation from the RFC,
 * translated into Pascal from the original C. The MD5 algorithm and the
 * reference implementation are Copyright (C) 1991-2, RSA Data Security, Inc.
 * Created 1991. All rights reserved.
 *
 * The Original Pascal Code is PJMD5.pas.
 *
 * The Initial Developer of the Original Code is Peter Johnson
 * (http://www.delphidabbler.com/).
 *
 * Portions created by the Initial Developer are Copyright (C) 2010 Peter
 * Johnson. All Rights Reserved.
 *
 * Contributor(s)
 *   NONE
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK *****
}

unit PJMD5;

// Delphi 2009 or later is required to compile: requires Unicode support
{$UNDEF CANCOMPILE}
{$IFDEF CONDITIONALEXPRESSIONS}
  {$IF CompilerVersion >= 20.0}
    {$DEFINE CANCOMPILE}
  {$IFEND}
{$ENDIF}
{$IFNDEF CANCOMPILE}
  {$MESSAGE FATAL 'Delphi 2009 or later required'}
{$ENDIF}

{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CAST OFF}

interface

uses
  SysUtils, Classes;

type

  EPJMD5 = class(Exception);

  TPJMD5Digest = record
  strict private
    function GetLongWord(Idx: Integer): LongWord;
  public
    class operator Equal(const D1, D2: TPJMD5Digest): Boolean;
    class operator NotEqual(const D1, D2: TPJMD5Digest): Boolean;
    class operator Implicit(const D: TPJMD5Digest): string;
    class operator Implicit(const S: string): TPJMD5Digest;
    class operator Implicit(const D: TPJMD5Digest): TBytes;
    class operator Implicit(const B: TBytes): TPJMD5Digest;
    property Parts[Idx: Integer]: LongWord read GetLongWord; default;
    case Integer of
      0: (Bytes: packed array[0..15] of Byte);
      1: (LongWords: packed array[0..3] of LongWord);
      2: (A, B, C, D: LongWord);
  end;

  TPJMD5 = class(TObject)
  strict private
    // number of LongWord blocks of data processed at a time
    const BLOCKSIZE = 16;
    // size of buffer in which data is processed in bytes
    const BUFFERSIZE = SizeOf(LongWord) * BLOCKSIZE;
    // default size of buffer for block reads from streams
    const DEFREADBUFFERSIZE = 64 * 1024;
    type
      TMDChunk = array[0..Pred(BUFFERSIZE)] of Byte;
      TMDBuffer = record
        Data: TMDChunk;
        Cursor: Byte;
        function IsEmpty: Boolean;
        function IsFull: Boolean;
        function SpaceRemaining: Byte;
        procedure Copy(const Bytes: array of Byte; const StartIdx: Cardinal;
          const Size: Cardinal);
        procedure Clear;
      end;
      TMDReadBuffer = record
        Buffer: Pointer;
        Size: Cardinal;
        procedure Alloc(const ASize: Cardinal);
        procedure Release;
      end;
    var
      // state of digest
      fState: TPJMD5Digest;
      // digest that is output
      fDigest: TPJMD5Digest;
      // whether digest has been finalised or not
      fFinalized: Boolean;
      // number of bytes processed
      fByteCount: UINT64;
      // buffer that stores unprocessed data
      fBuffer: TMDBuffer;
      // buffer used to read data from streams etc
      fReadBuffer: TMDReadBuffer;
      // required size of read buffer
      fReadBufferSize: Cardinal;
    function GetDigest: TPJMD5Digest;
    procedure Transform(const Bytes: array of Byte; const StartIdx: Cardinal);
    procedure Update(const X: array of Byte; const Size: Cardinal);
    class function DoCalculate(const DoProcess: TProc<TPJMD5>): TPJMD5Digest;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Process(const X: TBytes; const Size: Cardinal); overload;
    class function Calculate(const X: TBytes;
      const Size: Cardinal): TPJMD5Digest; overload;
    procedure Process(const X: TBytes); overload;
    class function Calculate(const X: TBytes): TPJMD5Digest; overload;
    procedure Process(const Buf; const Size: Cardinal); overload;
    class function Calculate(const Buf; const Size: Cardinal): TPJMD5Digest;
      overload;
    procedure Process(const S: AnsiString); overload;
    class function Calculate(const S: AnsiString): TPJMD5Digest; overload;
    procedure Process(const S: UnicodeString; const Encoding: TEncoding);
      overload;
    class function Calculate(const S: UnicodeString;
      const Encoding: TEncoding): TPJMD5Digest; overload;
    procedure Process(const S: UnicodeString); overload;
    class function Calculate(const S: UnicodeString): TPJMD5Digest; overload;
    procedure Process(const Stream: TStream); overload;
    class function Calculate(const Stream: TStream): TPJMD5Digest; overload;
    procedure ProcessFile(const FileName: TFileName);
    class function CalculateFile(const FileName: TFileName): TPJMD5Digest;
    procedure Reset;
    procedure Finalize;
    property Digest: TPJMD5Digest read GetDigest;
    property ReadBufferSize: Cardinal
      read fReadBufferSize write fReadBufferSize default DEFREADBUFFERSIZE;
    property Finalized: Boolean read fFinalized;
  end;

implementation

uses
  Math;

// Copies the bytes of a long word array into an array of bytes, low order bytes
// first. The size of Bytes must be the same as the size of LWords in bytes.
procedure LongWordsToBytes(const LWords: array of LongWord;
  out Bytes: array of Byte);
var
  I, J: Cardinal;
begin
  Assert(Length(Bytes) = SizeOf(LongWord) * Length(LWords));
  J := 0;
  for I := 0 to Length(LWords) - 1 do
  begin
    Bytes[J] := LWords[I] and $FF;
    Bytes[J + 1] := (LWords[I] shr 8) and $FF;
    Bytes[J + 2] := (LWords[I] shr 16) and $FF;
    Bytes[J + 3] := (LWords[I] shr 24) and $FF;
    Inc(J, 4);
  end;
end;

// Copies an array of bytes, starting at given index, into an array of LongWord.
// Assumes that number of bytes after StartIndex in Bytes is >= size of LongWord
// array. Bytes are copied from LongWord values low order first.
procedure BytesToLongWords(const Bytes: array of Byte; const StartIdx: Cardinal;
  out LWords: array of LongWord);
var
  I, J: Cardinal;
begin
  J := StartIdx;
  for I := 0 to Length(LWords) - 1 do
  begin
    LWords[I] := Bytes[J] or (Bytes[J + 1] shl 8)
      or (Bytes[J + 2] shl 16) or (Bytes[J + 3] shl 24);
    Inc(J, 4);
  end;
end;

// F, G, H and I are basic MD5 functions.

function F(const X, Y, Z: LongWord): LongWord; inline;
begin
  Result := (X and Y) or ((not X) and Z);
end;

function G(const X, Y, Z: LongWord): LongWord; inline;
begin
  Result := (X and Z) or (Y and not Z);
end;

function H(const X, Y, Z: LongWord): LongWord; inline;
begin
  Result := X xor Y xor Z;
end;

function I(const X, Y, Z: LongWord): LongWord; inline;
begin
  Result := Y xor (X or not Z);
end;

function RotateLeft(const X: LongWord; const N: Byte): LongWord; inline;
begin
  Result := (X shl N) or (X shr (32 - N));
end;

// FF, GG, HH, and II transformations for rounds 1, 2, 3, and 4.

procedure FF(var A: LongWord; const B, C, D, X: LongWord; const S: Byte;
  const AC: LongWord);
begin
  A := RotateLeft(A + F(B, C, D) + X + AC, S) + B;
end;

procedure GG(var A: LongWord; const B, C, D, X: LongWord; const S: Byte;
  const AC: LongWord);
begin
  A := RotateLeft(A + G(B, C, D) + X + AC, S) + B;
end;

procedure HH(var A: LongWord; const B, C, D, X: LongWord; const S: Byte;
  const AC: LongWord);
begin
  A := RotateLeft(A + H(B, C, D) + X + AC, S) + B;
end;

procedure II(var A: LongWord; const B, C, D, X: LongWord; const S: Byte;
  const AC: LongWord);
begin
  A := RotateLeft(A + I(B, C, D) + X + AC, S) + B;
end;

const
  PADDING: array[0..63] of Byte = (
    $80, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00
  );

resourcestring
  sAlreadyFinalized = 'Can''t update a finalised digest';
  sBadMD5StrLen = 'Can''t cast string of length %d to TPJMD5Digest';
  sBadMD5StrChars = 'Can''t cast string %s to TPJMD5Digest: invalid hex digits';
  sByteArrayTooSmall = 'Can''t cast TBytes array to TPJMD5Digest: '
    + 'not enough bytes';

{ TPJMD5 }

class function TPJMD5.Calculate(const Buf; const Size: Cardinal): TPJMD5Digest;
begin
  with Create do
    try
      Process(Buf, Size);
      Result := Digest;
    finally
      Free;
    end;
end;

class function TPJMD5.Calculate(const S: AnsiString): TPJMD5Digest;
begin
  Result := DoCalculate(
    procedure(Instance: TPJMD5) begin Instance.Process(S); end
  );
end;

class function TPJMD5.Calculate(const X: TBytes;
  const Size: Cardinal): TPJMD5Digest;
begin
  Result := DoCalculate(
    procedure(Instance: TPJMD5) begin Instance.Process(X, Size); end
  );
end;

class function TPJMD5.Calculate(const X: TBytes): TPJMD5Digest;
begin
  Result := DoCalculate(
    procedure(Instance: TPJMD5) begin Instance.Process(X); end
  );
end;

class function TPJMD5.Calculate(const Stream: TStream): TPJMD5Digest;
begin
  Result := DoCalculate(
    procedure(Instance: TPJMD5) begin Instance.Process(Stream); end
  );
end;

class function TPJMD5.Calculate(const S: UnicodeString): TPJMD5Digest;
begin
  Result := DoCalculate(
    procedure(Instance: TPJMD5) begin Instance.Process(S); end
  );
end;

class function TPJMD5.Calculate(const S: UnicodeString;
  const Encoding: TEncoding): TPJMD5Digest;
begin
  Result := DoCalculate(
    procedure(Instance: TPJMD5) begin Instance.Process(S, Encoding); end
  );
end;

class function TPJMD5.CalculateFile(const FileName: TFileName): TPJMD5Digest;
begin
  Result := DoCalculate(
    procedure(Instance: TPJMD5) begin Instance.ProcessFile(FileName); end
  );
end;

constructor TPJMD5.Create;
begin
  inherited Create;
  Reset;
  fReadBuffer.Release;
  fReadBufferSize := DEFREADBUFFERSIZE;
end;

destructor TPJMD5.Destroy;
begin
  fBuffer.Clear;
  fReadBuffer.Release;
  inherited;
end;

class function TPJMD5.DoCalculate(const DoProcess: TProc<TPJMD5>): TPJMD5Digest;
var
  Instance: TPJMD5;
begin
  Instance := TPJMD5.Create;
  try
    DoProcess(Instance);
    Result := Instance.Digest;
  finally
    Instance.Free;
  end;
end;

procedure TPJMD5.Finalize;
var
  Index: Cardinal;
  PadLen: Cardinal;
  ByteCount: UINT64;
  BitCount: UINT64;
  EncodedBitCount: array[0..7] of Byte;
begin
  if fFinalized then
    Exit;

  // Store byte count
  ByteCount := fByteCount;

  // Pad the data and write padding to digest
  Index := fByteCount mod 64;
  if Index < (64 - 8) then
    // write bytes to take length to 56 mod 24
    PadLen := (64 - 8) - Index
  else
    // at or beyond 56th byte: need 128-8-cur_pos bytes
    PadLen := (128 - 8) - Index;
  Update(PADDING, PadLen);

  // Write the bit count and let it wrap round
  {$IFOPT R+}
    {$DEFINE RANGECHECKS}
    {$R-}
  {$ELSE}
    {$UNDEF RANGECHECKS}
  {$ENDIF}
  BitCount := 8 * ByteCount;
  {$IFDEF RANGECHECKS}
    {$R+}
  {$ENDIF}
  LongWordsToBytes(Int64Rec(BitCount).Cardinals, EncodedBitCount);
  Update(EncodedBitCount, SizeOf(EncodedBitCount));

  Assert(fBuffer.IsEmpty);

  fDigest := fState;
  fFinalized := True;
end;

function TPJMD5.GetDigest: TPJMD5Digest;
begin
  if not fFinalized then
    Finalize;
  Result := fDigest;
end;

procedure TPJMD5.Process(const S: UnicodeString; const Encoding: TEncoding);
begin
  Process(Encoding.GetBytes(S));
end;

procedure TPJMD5.Process(const S: UnicodeString);
begin
  Process(S, TEncoding.Default);
end;

procedure TPJMD5.Process(const Buf; const Size: Cardinal);
begin
  Process(TBytes(@Buf), Size);
end;

procedure TPJMD5.Process(const S: AnsiString);
begin
  Process(Pointer(S)^, Length(S));
end;

procedure TPJMD5.Process(const Stream: TStream);
var
  BytesRead: Cardinal;
begin
  fReadBuffer.Alloc(fReadBufferSize);
  while Stream.Position < Stream.Size do
  begin
    BytesRead := Stream.Read(fReadBuffer.Buffer^, fReadBuffer.Size);
    Process(fReadBuffer.Buffer^, BytesRead);
  end;
end;

procedure TPJMD5.Process(const X: TBytes);
begin
  Process(X, Length(X));
end;

procedure TPJMD5.Process(const X: TBytes; const Size: Cardinal);
begin
  Update(X, Size);
end;

procedure TPJMD5.ProcessFile(const FileName: TFileName);
var
  Stm: TFileStream;
begin
  Stm := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    Process(Stm);
  finally
    Stm.Free;
  end;
end;

procedure TPJMD5.Reset;
begin
  fState.A := $67452301;
  fState.B := $efcdab89;
  fState.C := $98badcfe;
  fState.D := $10325476;
  FillChar(fDigest, SizeOf(fDigest), 0);
  fBuffer.Clear;  // flags buffer as empty
  fFinalized := False;
  fByteCount := 0;
end;

procedure TPJMD5.Transform(const Bytes: array of Byte;
  const StartIdx: Cardinal);
const
  // Constants for MD5Transform routine.
  S11 =  7;   S12 = 12;   S13 = 17;   S14 = 22;
  S21 =  5;   S22 =  9;   S23 = 14;   S24 = 20;
  S31 =  4;   S32 = 11;   S33 = 16;   S34 = 23;
  S41 =  6;   S42 = 10;   S43 = 15;   S44 = 21;
var
  Block: array[0..Pred(BLOCKSIZE)] of LongWord;
  A, B, C, D: LongWord;
begin
  Assert(SizeOf(Block) = SizeOf(TMDChunk));
  Assert(UInt64(Length(Bytes)) - StartIdx >= SizeOf(TMDChunk));

  // Store states
  A := fState.A;
  B := fState.B;
  C := fState.C;
  D := fState.D;

  BytesToLongWords(Bytes, StartIdx, Block);

  // Round 1
  FF(A, B, C, D, Block[ 0], S11, $d76aa478); // 1
  FF(D, A, B, C, Block[ 1], S12, $e8c7b756); // 2
  FF(C, D, A, B, Block[ 2], S13, $242070db); // 3
  FF(B, C, D, A, Block[ 3], S14, $c1bdceee); // 4
  FF(A, B, C, D, Block[ 4], S11, $f57c0faf); // 5
  FF(D, A, B, C, Block[ 5], S12, $4787c62a); // 6
  FF(C, D, A, B, Block[ 6], S13, $a8304613); // 7
  FF(B, C, D, A, Block[ 7], S14, $fd469501); // 8
  FF(A, B, C, D, Block[ 8], S11, $698098d8); // 9
  FF(D, A, B, C, Block[ 9], S12, $8b44f7af); // 10
  FF(C, D, A, B, Block[10], S13, $ffff5bb1); // 11
  FF(B, C, D, A, Block[11], S14, $895cd7be); // 12
  FF(A, B, C, D, Block[12], S11, $6b901122); // 13
  FF(D, A, B, C, Block[13], S12, $fd987193); // 14
  FF(C, D, A, B, Block[14], S13, $a679438e); // 15
  FF(B, C, D, A, Block[15], S14, $49b40821); // 16

  // Round 2
  GG(A, B, C, D, Block[ 1], S21, $f61e2562); // 17
  GG(D, A, B, C, Block[ 6], S22, $c040b340); // 18
  GG(C, D, A, B, Block[11], S23, $265e5a51); // 19
  GG(B, C, D, A, Block[ 0], S24, $e9b6c7aa); // 20
  GG(A, B, C, D, Block[ 5], S21, $d62f105d); // 21
  GG(D, A, B, C, Block[10], S22,  $2441453); // 22
  GG(C, D, A, B, Block[15], S23, $d8a1e681); // 23
  GG(B, C, D, A, Block[ 4], S24, $e7d3fbc8); // 24
  GG(A, B, C, D, Block[ 9], S21, $21e1cde6); // 25
  GG(D, A, B, C, Block[14], S22, $c33707d6); // 26
  GG(C, D, A, B, Block[ 3], S23, $f4d50d87); // 27
  GG(B, C, D, A, Block[ 8], S24, $455a14ed); // 28
  GG(A, B, C, D, Block[13], S21, $a9e3e905); // 29
  GG(D, A, B, C, Block[ 2], S22, $fcefa3f8); // 30
  GG(C, D, A, B, Block[ 7], S23, $676f02d9); // 31
  GG(B, C, D, A, Block[12], S24, $8d2a4c8a); // 32

  // Round 3
  HH(A, B, C, D, Block[ 5], S31, $fffa3942); // 33
  HH(D, A, B, C, Block[ 8], S32, $8771f681); // 34
  HH(C, D, A, B, Block[11], S33, $6d9d6122); // 35
  HH(B, C, D, A, Block[14], S34, $fde5380c); // 36
  HH(A, B, C, D, Block[ 1], S31, $a4beea44); // 37
  HH(D, A, B, C, Block[ 4], S32, $4bdecfa9); // 38
  HH(C, D, A, B, Block[ 7], S33, $f6bb4b60); // 39
  HH(B, C, D, A, Block[10], S34, $bebfbc70); // 40
  HH(A, B, C, D, Block[13], S31, $289b7ec6); // 41
  HH(D, A, B, C, Block[ 0], S32, $eaa127fa); // 42
  HH(C, D, A, B, Block[ 3], S33, $d4ef3085); // 43
  HH(B, C, D, A, Block[ 6], S34,  $4881d05); // 44
  HH(A, B, C, D, Block[ 9], S31, $d9d4d039); // 45
  HH(D, A, B, C, Block[12], S32, $e6db99e5); // 46
  HH(C, D, A, B, Block[15], S33, $1fa27cf8); // 47
  HH(B, C, D, A, Block[ 2], S34, $c4ac5665); // 48

  // Round 4
  II(A, B, C, D, Block[ 0], S41, $f4292244); // 49
  II(D, A, B, C, Block[ 7], S42, $432aff97); // 50
  II(C, D, A, B, Block[14], S43, $ab9423a7); // 51
  II(B, C, D, A, Block[ 5], S44, $fc93a039); // 52
  II(A, B, C, D, Block[12], S41, $655b59c3); // 53
  II(D, A, B, C, Block[ 3], S42, $8f0ccc92); // 54
  II(C, D, A, B, Block[10], S43, $ffeff47d); // 55
  II(B, C, D, A, Block[ 1], S44, $85845dd1); // 56
  II(A, B, C, D, Block[ 8], S41, $6fa87e4f); // 57
  II(D, A, B, C, Block[15], S42, $fe2ce6e0); // 58
  II(C, D, A, B, Block[ 6], S43, $a3014314); // 59
  II(B, C, D, A, Block[13], S44, $4e0811a1); // 60
  II(A, B, C, D, Block[ 4], S41, $f7537e82); // 61
  II(D, A, B, C, Block[11], S42, $bd3af235); // 62
  II(C, D, A, B, Block[ 2], S43, $2ad7d2bb); // 63
  II(B, C, D, A, Block[ 9], S44, $eb86d391); // 64

  // Update state from results
  Inc(fState.A, A);
  Inc(fState.B, B);
  Inc(fState.C, C);
  Inc(fState.D, D);

  // For security
  FillChar(Block, SizeOf(Block), 0);
end;

procedure TPJMD5.Update(const X: array of Byte; const Size: Cardinal);
var
  BytesLeft: Cardinal;
  BytesToCopy: Cardinal;
begin
  if fFinalized then
    raise EPJMD5.Create(sAlreadyFinalized);
  BytesLeft := Size;
  if not fBuffer.IsEmpty then
  begin
    // buffer contains some data: we must add our new data here until buffer is
    // full or we have no more data
    // we add either sufficient data to fill buffer or all we've got if its less
    // than remaining space in buffer
    BytesToCopy := Min(fBuffer.SpaceRemaining, BytesLeft);
    fBuffer.Copy(X, Size - BytesLeft, BytesToCopy);
    Inc(fByteCount, BytesToCopy);
    Dec(BytesLeft, BytesToCopy);
    if fBuffer.IsFull then
    begin
      // if we filled buffer we Transform the digest from it and empty it
      Transform(fBuffer.Data, 0);
      fBuffer.Clear;
    end;
  end;
  // if we have more than a buffers worth of data we Transform the digest from it
  // until there's less than a buffer's worth left
  while BytesLeft >= BUFFERSIZE do
  begin
    Transform(X, Size - BytesLeft);
    Inc(fByteCount, BUFFERSIZE);
    Dec(BytesLeft, BUFFERSIZE);
  end;
  // the following assertion must be true because:
  // case 1: buffer is empty and above loop only terminates when X has less
  //         than BUFFERSIZE bytes remaining
  // case 2: X had less than enough bytes to fill buffer so they were all copied
  //         there => X has no bytes left
  Assert((BytesLeft = 0) or (fBuffer.IsEmpty and (BytesLeft < BUFFERSIZE)));
  // above assertion implies following (this is redundant) because:
  // case 1: if ByteLeft = 0 it must be LTE space remaining in buffer
  // case 2: if ByteLeft <> 0 it is less than BUFFERSIZE which is equal to
  //         buffer space remaining since buffer is empty
  Assert(BytesLeft <= fBuffer.SpaceRemaining);
  if BytesLeft > 0 then
  begin
    // we have bytes left over (which must be less than space remaining)
    // we copy all the remaining bytes to the buffer and, if it gets full we
    // Transform the digest from the buffer and empty it
    fBuffer.Copy(X, Size - BytesLeft, BytesLeft);
    Inc(fByteCount, BytesLeft);
    if fBuffer.IsFull then
    begin
      Transform(fBuffer.Data, 0);
      fBuffer.Clear;
    end;
  end;
end;

{ TPJMD5.TMDBuffer }

procedure TPJMD5.TMDBuffer.Clear;
var
  I: Integer;
begin
  for I := 0 to Length(Data) - 1 do
    Data[I] := 0;
  Cursor := 0;
end;

procedure TPJMD5.TMDBuffer.Copy(const Bytes: array of Byte;
  const StartIdx: Cardinal; const Size: Cardinal);
var
  Idx: Integer;
begin
  Assert(Size <= SpaceRemaining);
  for Idx := StartIdx to StartIdx + Size - 1 do
  begin
    Data[Cursor] := Bytes[Idx];
    Inc(Cursor);
  end;
end;

function TPJMD5.TMDBuffer.IsEmpty: Boolean;
begin
  Result := Cursor = 0;
end;

function TPJMD5.TMDBuffer.IsFull: Boolean;
begin
  Result := SpaceRemaining = 0;
end;

function TPJMD5.TMDBuffer.SpaceRemaining: Byte;
begin
  Result := SizeOf(Data) - Cursor;
end;

{ TPJMD5.TMDReadBuffer }

procedure TPJMD5.TMDReadBuffer.Alloc(const ASize: Cardinal);
begin
  if (ASize <> Size) then
  begin
    Release;
    if ASize > 0 then
    begin
      GetMem(Buffer, ASize);
      Size := ASize;
    end;
  end;
end;

procedure TPJMD5.TMDReadBuffer.Release;
begin
  if Assigned(Buffer) then
  begin
    FreeMem(Buffer);
    Size := 0;
  end;
end;

{ TPJMD5Digest }

class operator TPJMD5Digest.Equal(const D1, D2: TPJMD5Digest): Boolean;
var
  Idx: Integer;
begin
  Result := True;
  for Idx := Low(D1.LongWords) to High(D1.LongWords) do
    if D1.LongWords[Idx] <> D2.LongWords[Idx] then
    begin
      Result := False;
      Exit;
    end;
end;

function TPJMD5Digest.GetLongWord(Idx: Integer): LongWord;
begin
  Assert((Idx >= Low(LongWords)) and (Idx <= High(LongWords)));
  Result := Self.LongWords[Idx];
end;

class operator TPJMD5Digest.Implicit(const D: TPJMD5Digest): string;
var
  B: Byte;
const
  Digits: array[0..15] of Char = (
    '0', '1', '2', '3', '4', '5', '6', '7',
    '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'
  );
begin
  Result := '';
  for B in D.Bytes do
    Result := Result + Digits[(B shr 4) and $0f] + Digits[B and $0f];
end;

class operator TPJMD5Digest.Implicit(const S: string): TPJMD5Digest;
var
  Idx: Integer;
  B: Integer;
  ByteStr: string;
begin
  FillChar(Result, SizeOf(Result), 0);
  if Length(S) <> 2 * Length(Result.Bytes) then
    raise EPJMD5.CreateFmt(sBadMD5StrLen, [Length(S)]);
  // we know string is correct length (32)
  for Idx := 0 to Pred(Length(Result.Bytes)) do
  begin
    ByteStr := S[2 * Idx + 1] + S[2 * Idx + 2];
    if not TryStrToInt('$' + ByteStr, B) then
      raise EPJMD5.CreateFmt(sBadMD5StrChars, [S]);
    Result.Bytes[Idx] := Byte(B);
  end;
end;

class operator TPJMD5Digest.Implicit(const B: TBytes): TPJMD5Digest;
var
  Idx: Integer;
begin
  Assert(Low(B) = Low(Result.Bytes));
  if Length(B) < Length(Result.Bytes) then
    raise EPJMD5.Create(sByteArrayTooSmall);
  for Idx := Low(Result.Bytes) to High(Result.Bytes) do
    Result.Bytes[Idx] := B[Idx];
end;

class operator TPJMD5Digest.Implicit(const D: TPJMD5Digest): TBytes;
var
  Idx: Integer;
begin
  SetLength(Result, Length(D.Bytes));
  Assert(Low(D.Bytes) = Low(Result));
  for Idx := Low(D.Bytes) to High(D.Bytes) do
    Result[Idx] := D.Bytes[Idx];
end;

class operator TPJMD5Digest.NotEqual(const D1, D2: TPJMD5Digest): Boolean;
begin
  Result := not (D1 = D2);
end;

end.

