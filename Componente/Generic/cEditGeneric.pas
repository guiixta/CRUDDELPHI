unit cEditGeneric;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Forms,
  Winapi.Messages;

type

  TTipoCaracter = (tcLivre, tcLetras, tcNumeros);

  TEditGeneric = class(TEdit)

  private
    { Private declarations }
    FTipoKey: TTipoCaracter;

    procedure TextOnly(var Key: char);
    procedure NumberOnly(var Key: char);
  protected
    { Protected declarations }
    procedure DoExit; override;
    procedure KeyPress(var Key: char); override;
  public
    { Public declarations }
    procedure Habilitar;
    procedure Desabilitar;
    procedure ValidarValor;
  published
    { Published declarations }
    property TipoKey: TTipoCaracter read FTipoKey write FTipoKey
      default tcLivre;
  end;

implementation

{ TEditGeneric }

procedure TEditGeneric.Desabilitar;
begin
  Self.Enabled := false;
end;

procedure TEditGeneric.Habilitar;
begin
  Self.Enabled := true;
end;

procedure TEditGeneric.KeyPress(var Key: char);
var
  ParentForm: TCustomForm;

begin

  if Key = #13 then
  begin

    ParentForm := GetParentForm(Self);
    if ParentForm <> nil then
    begin
      { Passar o focus para o proximo controle }
      ParentForm.Perform(WM_NEXTDLGCTL, 0, 0);
    end;

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

procedure TEditGeneric.NumberOnly(var Key: char);
begin
  if not(CharinSet(Key, ['0' .. '9']) or (Key = #8)) then
  begin
    Key := #0;
  end;
end;

procedure TEditGeneric.TextOnly(var Key: char);
begin
  if not(CharinSet(Key, ['a' .. 'z', 'A' .. 'Z']) or (Key = #8) or (Key = #32))
  then
  begin
    Key := #0;
  end;
end;

procedure TEditGeneric.ValidarValor;
var
  control: string;
begin

  control := Trim(Self.Text);

  if control.IsEmpty then
  begin
    if Self.CanFocus then
      Self.SetFocus;

    raise Exception.Create(Self.Name + ' Campo não pode ser nulo');

  end;
end;

procedure TEditGeneric.DoExit;
var
  control: string;
  ParentForm: TCustomForm;
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
  if (Screen.ActiveControl <> nil) and ((Screen.ActiveControl.Name = 'btnClose') or
    (Screen.ActiveControl.Name = 'btnPesquisa')) then
  begin
    inherited DoExit;
    exit;
  end;

  control := Trim(Self.Text);

  if control.IsEmpty then
  begin
    if Self.CanFocus then
      Self.SetFocus;

    raise Exception.Create(Self.Name + ' Campo não pode ser nulo');

  end;

  inherited DoExit;
end;

end.
