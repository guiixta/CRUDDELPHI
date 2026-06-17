unit EditCNPJFile;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Graphics, Vcl.Dialogs, Vcl.Mask, System.RegularExpressions,
  Winapi.Messages;

type
  EditCNPJ = class(TMaskEdit)
  private
    { Private declarations }
    FCPF: Boolean;

    function ValidarCNPJ(cnpj: string): Boolean;
    function ValidarCPF(cpf: string): Boolean;
    procedure StandartExitCNPJ(Sender: TObject);
    procedure StandartExitCPF(Sender: TObject);
    procedure Focus(Sender: TObject);
    procedure SetCPF(const Value: Boolean);

  protected
    { Protected declarations }
    procedure KeyPress(var Key: char); override;
  public
    { Public declarations }

    constructor Create(AOwner: TComponent); override;
    procedure ValidarValor;
  published
    { Published declarations }
    property cpf: Boolean read FCPF write SetCPF;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Standard', [EditCNPJ]);
end;

{ EditCNPJ }

constructor EditCNPJ.Create(AOwner: TComponent);
begin
  inherited;

  Self.OnEnter := Focus;
  Self.BorderStyle := bsNone;

  Self.Clear;

  Self.Cursor := crIBeam;

  Self.NumbersOnly := true;

end;

procedure EditCNPJ.Focus(Sender: TObject);
begin
  Self.Color := clInfoBk;
end;

procedure EditCNPJ.KeyPress(var Key: char);
var
  ParentForm: TCustomForm;

begin

  if Key = #13 then
  begin
    Key := #0;

    ParentForm := GetParentForm(Self);
    if ParentForm <> nil then
    begin
      { Passar o focus para o proximo controle }
      ParentForm.Perform(WM_NEXTDLGCTL, 0, 0);
    end;

  end;

  inherited KeyPress(Key);
end;

procedure EditCNPJ.SetCPF(const Value: Boolean);
begin
  if Value then
  begin
    Self.OnExit := StandartExitCPF;
    Self.EditMask := '000\.000\.000\-00;1;_';
  end
  else
  begin
    Self.OnExit := StandartExitCNPJ;
    Self.EditMask := '00\.000\.000\/0000\-00;1;_';
  end;

  FCPF := Value;
end;

procedure EditCNPJ.StandartExitCNPJ(Sender: TObject);
var
  cnpj, pattern: string;
begin
  pattern := '[^\d]';
  cnpj := TRegEx.Replace(Self.Text, pattern, '');

  if Length(cnpj) = 0 then
  begin
    if Self.CanFocus then
      Self.SetFocus;

    Self.SelectAll;
    raise Exception.Create('Não o pode ficar vazio');
  end;

  if Length(cnpj) <> 14 then
    raise Exception.Create('Tamanho invalido');

  if not ValidarCNPJ(cnpj) then
  begin
    if Self.CanFocus then
      Self.SetFocus;

    Self.SelectAll;
    raise Exception.Create('CNPJ INVALIDO');
  end;

  Self.Color := clWhite;

end;

procedure EditCNPJ.StandartExitCPF(Sender: TObject);
var
  cpf, pattern: string;
begin
  pattern := '[^\d]';
  cpf := TRegEx.Replace(Self.Text, pattern, '');

  if Length(cpf) = 0 then
  begin
    if Self.CanFocus then
      Self.SetFocus;

    Self.SelectAll;
    raise Exception.Create('CPF Não pode ficar vazio');
  end;

  if Length(cpf) <> 11 then
    raise Exception.Create('Tamanho invalido');

  if not ValidarCPF(cpf) then
  begin
    if Self.CanFocus then
      Self.SetFocus;

    Self.SelectAll;
    raise Exception.Create('CPF INVALIDO');
  end;

  Self.Color := clWhite;

end;

function EditCNPJ.ValidarCPF(cpf: string): Boolean;
var

  n1, n2, n3, n4, n5, n6, n7, n8, n9: integer;

  d1, d2: integer;

  digitado, calculado: string;

begin

  n1 := StrToInt(cpf[1]);

  n2 := StrToInt(cpf[2]);

  n3 := StrToInt(cpf[3]);

  n4 := StrToInt(cpf[4]);

  n5 := StrToInt(cpf[5]);

  n6 := StrToInt(cpf[6]);

  n7 := StrToInt(cpf[7]);

  n8 := StrToInt(cpf[8]);

  n9 := StrToInt(cpf[9]);

  d1 := n9 * 2 + n8 * 3 + n7 * 4 + n6 * 5 + n5 * 6 + n4 * 7 + n3 * 8 + n2 * 9
    + n1 * 10;

  d1 := 11 - (d1 mod 11);

  if d1 >= 10 then
    d1 := 0;

  d2 := d1 * 2 + n9 * 3 + n8 * 4 + n7 * 5 + n6 * 6 + n5 * 7 + n4 * 8 + n3 * 9 +
    n2 * 10 + n1 * 11;

  d2 := 11 - (d2 mod 11);

  if d2 >= 10 then
    d2 := 0;

  calculado := inttostr(d1) + inttostr(d2);

  digitado := cpf[10] + cpf[11];

  if calculado = digitado then

    Result := true

  else

    Result := false;

end;

procedure EditCNPJ.ValidarValor;
var
  control, pattern: string;

begin

  pattern := '[^a-z+A-Z+0-9]';

  control := TRegEx.Replace(Self.Text, pattern, '');

  if control.IsEmpty then
  begin
    if Self.CanFocus then
      Self.SetFocus;

    raise Exception.Create(Self.Name + ' Campo não pode ser nulo');

  end;

  if FCPF then
  begin
    if not ValidarCPF(control) then
    begin
      if Self.CanFocus then
        Self.SetFocus;

      raise Exception.Create('CPF Inválido');
    end;

  end;

end;

function EditCNPJ.ValidarCNPJ(cnpj: string): Boolean;
var

  n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12: integer;

  d1, d2: integer;

  digitado, calculado: string;

begin

  n1 := StrToInt(cnpj[1]);

  n2 := StrToInt(cnpj[2]);

  n3 := StrToInt(cnpj[3]);

  n4 := StrToInt(cnpj[4]);

  n5 := StrToInt(cnpj[5]);

  n6 := StrToInt(cnpj[6]);

  n7 := StrToInt(cnpj[7]);

  n8 := StrToInt(cnpj[8]);

  n9 := StrToInt(cnpj[9]);

  n10 := StrToInt(cnpj[10]);

  n11 := StrToInt(cnpj[11]);

  n12 := StrToInt(cnpj[12]);

  d1 := n12 * 2 + n11 * 3 + n10 * 4 + n9 * 5 + n8 * 6 + n7 * 7 + n6 * 8 + n5 * 9
    + n4 * 2 + n3 * 3 + n2 * 4 + n1 * 5;

  d1 := 11 - (d1 mod 11);

  if d1 >= 10 then
    d1 := 0;

  d2 := d1 * 2 + n12 * 3 + n11 * 4 + n10 * 5 + n9 * 6 + n8 * 7 + n7 * 8 + n6 * 9
    + n5 * 2 + n4 * 3 + n3 * 4 + n2 * 5 + n1 * 6;

  d2 := 11 - (d2 mod 11);

  if d2 >= 10 then
    d2 := 0;

  calculado := inttostr(d1) + inttostr(d2);

  digitado := cnpj[13] + cnpj[14];

  if calculado = digitado then

    Result := true

  else

    Result := false;

end;

end.
