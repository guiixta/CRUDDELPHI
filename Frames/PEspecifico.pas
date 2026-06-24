unit PEspecifico;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls,
  uInterfaces, cEditGeneric, cEditMaskGeneric, EditCNPJFile, uTFPBase;

type
  TFPEspecifico = class(TFrame, TFPBase)
    Pedit: TPanel;
    PEditMolde: TPanel;
    Label1: TLabel;
  private
    { Private declarations }
  var
    SCampo: string;
    FEditGenerate: TWinControl;

    procedure LimparEdit;
  public
    { Public declarations }
    procedure Iniciar(ACampo: string; ATipo: TTypeInputs);
    function getConsulta: string;
    procedure SetOnChange(AEvent: TOnFilterChange);
  end;

implementation

{$R *.dfm}
{ TFPEspecifico }

function TFPEspecifico.getConsulta: string;
var
  valor: string;
begin
  if not Assigned(FEditGenerate) then
    raise Exception.Create('Sem edit para valores');

  if FEditGenerate is TEditMaskGeneric then
    valor := TEditMaskGeneric(FEditGenerate).Text
  else
    valor := TEditGeneric(FEditGenerate).Text;

  if valor.IsEmpty then
    raise Exception.Create('Valor não pode ser nulo');

  Result := Format('WHERE %s CONTAINING %s', [SCampo, QuotedStr(valor)]);;

end;

procedure TFPEspecifico.Iniciar(ACampo: string; ATipo: TTypeInputs);
begin
  SCampo := ACampo;

  Label1.Caption := ACampo;

  LimparEdit;

  case ATipo of
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
    tiDinheiro:
      begin
        FEditGenerate := TEditMaskGeneric.Create(self);
        TEditMaskGeneric(FEditGenerate).SetTipoMascara(tmDinheiro);
      end;
    tiCpf:
      begin
        FEditGenerate := EditCNPJ.Create(self);
        EditCNPJ(FEditGenerate).cpf := true;
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

procedure TFPEspecifico.LimparEdit;
begin
  if Assigned(FEditGenerate) then
  begin
    FEditGenerate.Free;
    FEditGenerate := nil;
  end;
end;

procedure TFPEspecifico.SetOnChange(AEvent: TOnFilterChange);
begin
  if FEditGenerate is TEditGeneric then
    TEditGeneric(FEditGenerate).OnExit := AEvent
  else if FEditGenerate is TEditMaskGeneric then
    TEditMaskGeneric(FEditGenerate).OnExit := AEvent
  else
    EditCNPJ(FEditGenerate).OnExit := AEvent;

end;

end.
