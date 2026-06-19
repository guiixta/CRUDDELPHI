unit PRange;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, cEditMaskGeneric, uTFPBase;

type

  TEdit = class(TEditMaskGeneric);

  TFPRange = class(TFrame, TFPBase)
    PRange: TPanel;
    LabelRange: TLabel;
    EditRange1: TEdit;
    EditRange2: TEdit;
    comboRange: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure comboRangeChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Iniciar(ACampo: string);
    function getConsulta: string;
    procedure SetOnChange(AEvent: TOnFilterChange);
  end;

implementation

{$R *.dfm}
{ TFrame3 }

procedure TFPRange.comboRangeChange(Sender: TObject);
begin
  if comboRange.Items[comboRange.ItemIndex] = 'Especifico' then
  begin
    LabelRange.Visible := false;
    Label2.Visible := false;
    EditRange2.Visible := false;
  end
  else
  begin
    LabelRange.Visible := true;
    Label2.Visible := true;
    EditRange2.Visible := true;
  end;
end;

function TFPRange.getConsulta: string;
var
  Data1, Data2: string;
begin

  if EditRange1.Text = '' then
  begin
    if EditRange1.CanFocus then
      EditRange1.SetFocus;

    raise Exception.Create('Entrada não pode ser vazio');
  end;

  if EditRange2.Visible then
  begin
    if EditRange2.Text = '' then
    begin
      if EditRange2.CanFocus then
        EditRange2.SetFocus;

      raise Exception.Create('Entrada não pode ser vazio');
    end;
  end;

  Data1 := FormatDateTime('yyyy-mm-dd', StrToDate(EditRange1.Text));
  if comboRange.Items[comboRange.ItemIndex] = 'Entre' then
  begin
    Data2 := FormatDateTime('yyyy-mm-dd', StrToDate(EditRange2.Text));
    Result := Format('WHERE CAST(%s AS DATE) BETWEEN %s AND %s',
      [Label1.Caption, QuotedStr(Data1), QuotedStr(Data2)]);
  end
  else
    Result := Format('WHERE CAST(%s AS DATE) = %s', [Label1.Caption, QuotedStr(Data1)]);
end;

procedure TFPRange.Iniciar(ACampo: string);
begin
  Label1.Caption := ACampo;
  Label2.Caption := ACampo;

  EditRange1.SetTipoMascara(tmData);
  EditRange2.SetTipoMascara(tmData);

  comboRange.ItemIndex := 0;

end;

procedure TFPRange.SetOnChange(AEvent: TOnFilterChange);
begin

  if comboRange.Items[comboRange.ItemIndex] = 'Especifico' then
    EditRange1.OnExit := AEvent
  else
    EditRange2.OnExit := AEvent;

end;

end.
