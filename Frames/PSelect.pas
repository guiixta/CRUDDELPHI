unit PSelect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls,
  uTFPBase;

type
  TFPSelect = class(TFrame, TFPBase)
    PSelection: TPanel;
    cmbSelect: TComboBox;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Iniciar(ACampo: string; Items: TStringList);
    function getConsulta: string;
    procedure SetOnChange(AEvent: TOnFilterChange);
  end;

implementation

{$R *.dfm}
{ TFPSelect }

function TFPSelect.getConsulta: string;
var
  item: string;
begin
  if cmbSelect.ItemIndex = -1 then
    raise Exception.Create('Seleção não pode ficar vazia!');

  item := cmbSelect.Items[cmbSelect.ItemIndex];
  item := item[1] + item[2];

  Result := Format('WHERE %s = %s', [Label1.Caption, item]);
end;

procedure TFPSelect.Iniciar(ACampo: string; Items: TStringList);
var
  item: string;
begin

  Label1.Caption := ACampo;

  cmbSelect.Items.Clear;

  for item in Items do
  begin
    cmbSelect.Items.Add(item);
  end;

  cmbSelect.ItemIndex := 0;

end;

procedure TFPSelect.SetOnChange(AEvent: TOnFilterChange);
begin
  cmbSelect.OnChange := AEvent;
end;

end.
