unit PValue;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls,
  uInterfaces, uTFPBase, cEditGeneric, cEditMaskGeneric, EditCNPJFile,
  System.StrUtils;

type
  TFPValue = class(TFrame, TFPBase)
    PValor: TPanel;
    cmbValue: TComboBox;
    Label1: TLabel;
    PEditMolde: TPanel;
  private
    { Private declarations }
  var
    SCampo: string;
    FEditGenerate: TWinControl;

    procedure LimparEdit;
  public
    { Public declarations }
    procedure Iniciar(ACampo: string; TipoInput: TTypeInputs);
    function getConsulta: string;
    procedure SetOnChange(AEvent: TOnFilterChange);
  end;

implementation

{$R *.dfm}
{ TFPValue }

var
  Tipo: TTypeInputs;

function TFPValue.getConsulta: string;
var
  value, operador: string;
begin
  if FEditGenerate is TEditGeneric then
    value := TEditGeneric(FEditGenerate).Text
  else
    value := TEditMaskGeneric(FEditGenerate).Text;
  if value.IsEmpty then
    raise Exception.Create('Campo não pode ser vazio!');

  if cmbValue.Items[cmbValue.ItemIndex] = 'Maior que' then
    operador := '>'
  else if cmbValue.Items[cmbValue.ItemIndex] = 'Menor que' then
    operador := '<'
  else
    operador := '=';

  if Tipo = tiDinheiro then
    value := IntToStr(Round(StrToFloat(ReplaceStr(ReplaceStr(value, '.', ''), ',', ''))));

  Result := Format('WHERE %s %s %s', [Label1.Caption, operador, value]);

end;

procedure TFPValue.Iniciar(ACampo: string; TipoInput: TTypeInputs);
begin
  SCampo := ACampo;

  Label1.Caption := ACampo;

  Tipo := TipoInput;

  LimparEdit;

  case TipoInput of
    tiTexto:
      begin
        FEditGenerate := TEditGeneric.Create(self);
        TEditGeneric(FEditGenerate).TipoKey := tcLetras;
      end;
    tiNumber:
      begin
        FEditGenerate := TEditGeneric.Create(self);
        TEditGeneric(FEditGenerate).TipoKey := tcNumeros;
      end;
    tiCpf:
      begin
        FEditGenerate := EditCNPJ.Create(self);
        EditCNPJ(FEditGenerate).cpf := true;
      end;
    tiDinheiro:
      begin
        FEditGenerate := TEditMaskGeneric.Create(self);
        TEditMaskGeneric(FEditGenerate).SetTipoMascara(tmDinheiro);
      end;
    tiTelefone:
      begin
        FEditGenerate := TEditMaskGeneric.Create(self);
        TEditMaskGeneric(FEditGenerate).SetTipoMascara(tmTelefone);
      end;
    tiLivre:
      begin
        FEditGenerate := TEditGeneric.Create(self);
        TEditGeneric(FEditGenerate).TipoKey := tcLivre;
      end;
  end;

  if not Assigned(FEditGenerate) then
    raise Exception.Create('Componente não criado!');

  FEditGenerate.Parent := PEditMolde;
  FEditGenerate.Align := alClient;
  FEditGenerate.Visible := true;

end;

procedure TFPValue.LimparEdit;
begin
  if Assigned(FEditGenerate) then
  begin
    FEditGenerate.Free;
    FEditGenerate := nil;
  end;

end;

procedure TFPValue.SetOnChange(AEvent: TOnFilterChange);
begin
  if FEditGenerate is TEditGeneric then
    TEditGeneric(FEditGenerate).OnExit := AEvent
  else if FEditGenerate is TEditMaskGeneric then
    TEditMaskGeneric(FEditGenerate).OnExit := AEvent
  else
    EditCNPJ(FEditGenerate).OnExit := AEvent;
end;

end.
