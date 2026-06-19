unit cFormFilter;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, uInterfaces,
  Controller, System.Generics.Collections, uTFPBase, System.RegularExpressions;

type
  TFormFIlter = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    btnClose: TButton;
    btnAction: TButton;
    cmbCampos: TComboBox;
    Label1: TLabel;
    PFilter: TPanel;
    cmbOrder: TComboBox;
    cmbDirect: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    procedure cmbCamposChange(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnActionClick(Sender: TObject);
  private
    { Private declarations }
  var
    Controller: TController;
    Frame: TWinControl;
    OptionsSelect: TStringList;
    TypeInput: TTypeInputs;

    procedure LimparPanel;
  public
    { Public declarations }
    procedure MostarForm(Campos: TDictionary<string, TTypeFilters>);
  end;

var
  FormFIlter: TFormFIlter;

implementation

{$R *.dfm}

uses
  PEspecifico, PRange, PSelect, PValue, PTable;

procedure TFormFIlter.btnActionClick(Sender: TObject);
var
  filtroFrame, filtroCombo, filtroFinal, CDirect: string;
begin

  if cmbDirect.Items[cmbDirect.ItemIndex] = 'Ascendente' then
    CDirect := 'ASC'
  else
    CDirect := 'DESC';

  if cmbOrder.Items[cmbOrder.ItemIndex] = 'Nenhum' then
    filtroCombo := Format('ORDER BY %s %s',
      [cmbCampos.Items[cmbCampos.ItemIndex], CDirect])
  else
    filtroCombo := Format('ORDER BY %s %s', [cmbOrder.Items[cmbOrder.ItemIndex],
      CDirect]);

  filtroFrame := (Frame as TFPBase).getConsulta;

  if TypeInput = tiDinheiro then
    filtroFrame := TregEx.Replace(filtroFrame, '[^a-zA-Z0-9 ><=%'']', '');

  filtroFinal := Format('%s %s', [filtroFrame, filtroCombo]);



  Controller.Filtrar(cmbCampos.Items[cmbCampos.ItemIndex], filtroFinal);

  Controller.switchIsFilter;

  Self.Close;

end;

procedure TFormFIlter.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFormFIlter.cmbCamposChange(Sender: TObject);
var
  LCampo: string;
  TipoFilter: TTypeFilters;
  TipoInput: TTypeInputs;
begin
  if cmbCampos.ItemIndex = -1 then
    exit;

  LCampo := cmbCampos.Items[cmbCampos.ItemIndex];
  TipoFilter := TTypeFilters
    (Integer(cmbCampos.Items.Objects[cmbCampos.ItemIndex]));

  TipoInput := Controller.getTypeInput(LCampo);
  TypeInput := TipoInput;
  if Assigned(OptionsSelect) then
  begin
    OptionsSelect.Free;
    OptionsSelect := nil;
  end;

  LimparPanel;
  case TipoFilter of
    tfEspecifico:
      begin
        Frame := TFPEspecifico.Create(Self);
        with TFPEspecifico(Frame) do
        begin
          Iniciar(LCampo, TipoInput);
          Parent := PFilter;
          Align := alClient;
        end;

      end;

    tfRange:
      begin
        Frame := TFPRange.Create(Self);
        with TFPRange(Frame) do
        begin
          Iniciar(LCampo);
          Parent := PFilter;
          Align := alClient;
        end;

      end;

    tfSelect:
      begin
        OptionsSelect := Controller.getOptions(LCampo);
        Frame := TFPSelect.Create(Self);
        with TFPSelect(Frame) do
        begin
          Iniciar(LCampo, OptionsSelect);
          Parent := PFilter;
          Align := alClient;
        end;
      end;

    tfValue:
      begin
        Frame := TFPValue.Create(Self);
        with TFPValue(Frame) do
        begin
          Iniciar(LCampo, TipoInput);
          Parent := PFilter;
          Align := alClient;
        end;
      end;

    tfTable:
      begin
        Frame := TFPTable.Create(Self);
        with TFPTable(Frame) do
        begin
          Iniciar('ID', 'NOME', LCampo);
          Parent := PFilter;
          Align := alClient;
        end;
      end;

  end;

end;

procedure TFormFIlter.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(OptionsSelect) then
    FreeAndNil(OptionsSelect);

  if Assigned(Frame) then
    FreeAndNil(Frame);

end;

procedure TFormFIlter.LimparPanel;
var
  I: Integer;
begin
  for I := PFilter.ControlCount - 1 downto 0 do
  begin
    PFilter.Controls[I].Free;
  end;


end;

procedure TFormFIlter.MostarForm(Campos: TDictionary<string, TTypeFilters>);
var
  campo: string;
begin
  Controller := TController.GetInstancia;
  cmbCampos.Items.Clear;
  cmbOrder.Items.Clear;

  cmbOrder.Items.Add('Nenhum');

  for campo in Campos.Keys do
  begin
    cmbCampos.Items.AddObject(campo, TObject(Integer(Campos[campo])));
  end;

  for campo in Campos.Keys do
  begin
    cmbOrder.Items.Add(campo);
  end;

  if cmbCampos.Items.Count > 0 then
  begin
    cmbCampos.ItemIndex := 0;

    if Assigned(cmbCampos) then
      cmbCampos.OnChange(cmbCampos);
  end;

  cmbOrder.ItemIndex := 0;
  cmbDirect.ItemIndex := 0;

  Self.ShowModal;
end;

end.
