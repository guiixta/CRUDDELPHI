unit cEditMaskGeneric;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Forms,
  Vcl.Mask, System.RegularExpressions, System.DateUtils, Windows, cEditGeneric,
  Winapi.Messages;

type

  TTipoMask = (tmTelefone, tmData, tmDinheiro, tmHora);

  TEditMaskGeneric = class(TMaskEdit)

  private
    { Private declarations }
    FTipoKey: TTipoCaracter;
    FTipoMask: TTipoMask;

    procedure TextOnly(var Key: char);
    procedure NumberOnly(var Key: char);
  protected
    { Protected declarations }
    procedure DoExit; override;
    procedure KeyPress(var Key: char); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DinheiroMask(var Key: char);
  public
    { Public declarations }
    procedure Habilitar;
    procedure Desabilitar;
    procedure SetTipoMascara(TValue: TTipoMask);
    constructor Create(AOwner: TComponent); override;
    procedure ValidarValor;
  published
    { Published declarations }
    property TipoMask: TTipoMask read FTipoMask write FTipoMask default tmData;
  end;

implementation

{ TEditMaskGeneric }

constructor TEditMaskGeneric.Create(AOwner: TComponent);
begin

  FTipoKey := tcNumeros;

  inherited Create(AOwner);

end;

procedure TEditMaskGeneric.Desabilitar;
begin
  Self.Enabled := false;
end;

procedure TEditMaskGeneric.DinheiroMask(var Key: char);
var
  TextoLimpo: string;
  ValorNumerico: Double;
begin

  if not (CharInSet(Key, ['0'..'9', #8])) then
  begin
    Key := #0;
    Exit;
  end;

  TextoLimpo := TRegEx.Replace(Self.Text, '[^0-9]', '');

  if Key = #8 then {Apagar}
  begin
    if TextoLimpo.Length > 0 then
      Delete(TextoLimpo, TextoLimpo.Length, 1);
  end
  else
  begin
    TextoLimpo := TextoLimpo + Key;
  end;


  if TextoLimpo.IsEmpty then
    TextoLimpo := '0';


  ValorNumerico := StrToFloatDef(TextoLimpo, 0) / 100;


  Self.Text := FormatFloat('#,##0.00', ValorNumerico);


  Self.SelStart := Length(Self.Text);

  Key := #0;
end;

procedure TEditMaskGeneric.Habilitar;
begin
  Self.Enabled := true;
end;

procedure TEditMaskGeneric.KeyDown(var Key: Word; Shift: TShiftState);
var
  DataAtual: TDate;
  SData: string;
begin

  case FTipoMask of
    tmData:
      begin
        DataAtual := Date;
        SData := DateToStr(DataAtual);
        if Key = VK_F2 then
        begin
          SData := DateToStr(StartOfTheMonth(DataAtual));
          Self.Text := SData;
        end;

        if Key = VK_F3 then
          Self.Text := SData;

        if Key = VK_F4 then
        begin
          SData := DateToStr(EndOfTheMonth(DataAtual));
          Self.Text := SData;
        end;
      end;
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TEditMaskGeneric.KeyPress(var Key: char);
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

    exit;
  end;

  if FTipoMask = tmDinheiro then
  begin
    DinheiroMask(Key);
  end;

  case FTipoKey of
    tcLetras:
      TextOnly(Key);
    tcNumeros:
      NumberOnly(Key);
    tcLivre:
      ;

  end;

  if Key <> #0 then
    inherited KeyPress(Key);
end;

procedure TEditMaskGeneric.NumberOnly(var Key: char);
begin
  if not(CharinSet(Key, ['0' .. '9']) or (Key = #8)) then
  begin
    Key := #0;
  end;
end;

procedure TEditMaskGeneric.SetTipoMascara(TValue: TTipoMask);
begin
  FTipoMask := TValue;

  case FTipoMask of
    tmTelefone:
      Self.EditMask := '\(00\)90000\-0000;1;_';
    tmData:
      Self.EditMask := '90\/90\/0000;1;_';
    tmDinheiro:
      begin
        Self.EditMask := '';
        Self.Text := '0,00';
      end;
    tmHora:
      Self.EditMask := '!90:00;1;_';
  end;
end;

procedure TEditMaskGeneric.TextOnly(var Key: char);
begin
  if not(CharinSet(Key, ['a' .. 'z', 'A' .. 'Z']) or (Key = #8) or (Key = #32))
  then
  begin
    Key := #0;
  end;
end;

procedure TEditMaskGeneric.ValidarValor;
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
end;

procedure TEditMaskGeneric.DoExit;
var
  control, pattern: string;
  ParentForm: TCustomForm;
  DataDigitada: TDateTime;
begin

  ParentForm := GetParentForm(Self);

  { Caso estiver fechando o modal }
  if (ParentForm <> nil) and ((ParentForm.ModalResult <> mrNone) or
    (not ParentForm.Visible)) then
  begin
    inherited DoExit;
    exit;
  end;

  { Se for um btnClose não validar e prosseguir com a ação do button }
  if (Screen.ActiveControl <> nil) and (Screen.ActiveControl.Name = 'btnClose')
  then
  begin
    inherited DoExit;
    exit;
  end;

  pattern := '[^a-z+A-Z+0-9]';

  control := TRegEx.Replace(Self.Text, pattern, '');

  if control.IsEmpty then
  begin
    if Self.CanFocus then
      Self.SetFocus;

    raise Exception.Create(Self.Name + ' Campo não pode ser nulo');

  end;

  case FTipoMask of
    tmData:
      begin

        if TryStrToDate(Self.Text, DataDigitada) then
        begin

          if DataDigitada > Date then
          begin

            Self.Text := FormatDateTime('dd/mm/yyyy', Date);
          end;
        end
        else
        begin

          if Self.CanFocus then
            Self.SetFocus;

          raise Exception.Create('Por favor, insira uma data válida.');
        end;
      end;
  end;

  inherited DoExit;
end;

end.
