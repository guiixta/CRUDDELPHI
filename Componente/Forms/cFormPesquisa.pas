unit cFormPesquisa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, cDGridGeneric, uInterfaces,
  System.Generics.Collections, Controller, DM,
  uTFPBase;

type

  TDBGrid = class(TDBGridType);

  TFormPesquisa = class(TForm)
    Panel1: TPanel;
    GridPesquisa: TDBGrid;
    btnAction: TButton;
    btnClose: TButton;
    cmbCampos: TComboBox;
    PFilter: TPanel;
    Label1: TLabel;
    procedure cmbCamposChange(Sender: TObject);
    procedure btnActionClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GridPesquisaDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  var
    Frame: TWinControl;
    Controller: TController;
    OptionsSelect: TStringList;
    Busca: string;
    DataControl: TData;
    ACampos: TDictionary<string, TTypeFilters>;
    AAClose: TProc;

    procedure LimparPanel;
  public
    { Public declarations }

    procedure MostarForm(ALocal: string;
      Campos: TDictionary<string, TTypeFilters>; AClose: TProc);

    procedure FiltrarGrid(Sender: TObject);

  end;

var
  FormPesquisa: TFormPesquisa;

implementation

{$R *.dfm}
{ TFormPesquisa }

uses
  PEspecifico, PRange, PSelect, PValue, cEditGeneric, cEditMaskGeneric;

procedure TFormPesquisa.btnActionClick(Sender: TObject);
begin
  with DataControl do
  begin
    if not IndirectConsult.RecordCount > 0 then
      raise Exception.Create('Nada selecionado!');
  end;

  Self.Close;
end;

procedure TFormPesquisa.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFormPesquisa.cmbCamposChange(Sender: TObject);
var
  LCampo: string;
  TipoFilter: TTypeFilters;
  TipoInput: TTypeInputs;
  OldTable: string;
begin
  if cmbCampos.ItemIndex = -1 then
    exit;

  LCampo := cmbCampos.Items[cmbCampos.ItemIndex];
  TipoFilter := TTypeFilters
    (Integer(cmbCampos.Items.Objects[cmbCampos.ItemIndex]));

  OldTable := Controller.getTabelaCurrent;
  Controller.ChangeTableCurrent(Busca);

  TipoInput := Controller.getTypeInput(LCampo);

  Controller.ChangeTableCurrent(OldTable);

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
          SetOnChange(FiltrarGrid);
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
          SetOnChange(FiltrarGrid);
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
          SetOnChange(FiltrarGrid);
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
          SetOnChange(FiltrarGrid);
        end;
      end;
  end;

end;

procedure TFormPesquisa.FiltrarGrid(Sender: TObject);
var
  Filtro: string;
begin

  if Frame is TFPEspecifico then
    Filtro := TFPEspecifico(Frame).getConsulta
  else if Frame is TFPRange then
    Filtro := TFPRange(Frame).getConsulta
  else if Frame is TFPSelect then
    Filtro := TFPSelect(Frame).getConsulta
  else if Frame is TFPValue then
    Filtro := TFPValue(Frame).getConsulta
  else
    exit;

  Controller.Pesquisar(Busca, cmbCampos.Items[cmbCampos.ItemIndex], Filtro);

  if GridPesquisa.CanFocus then
    GridPesquisa.SetFocus;

end;

procedure TFormPesquisa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(OptionsSelect) then
    FreeAndNil(OptionsSelect);

  FreeAndNil(Frame);

  if Assigned(ACampos) then
    FreeAndNil(ACampos);

  if Assigned(AAClose) then
    AAClose();

  Action := caFree;
end;

procedure TFormPesquisa.FormDestroy(Sender: TObject);
begin
  Close;
end;

procedure TFormPesquisa.GridPesquisaDblClick(Sender: TObject);
begin
  if not GridPesquisa.DataSource.DataSet.RecordCount > 0 then
    raise Exception.Create('Nada selecionado!');

  btnAction.Click;
end;

procedure TFormPesquisa.LimparPanel;
var
  I: Integer;
begin
  for I := PFilter.ControlCount - 1 downto 0 do
  begin
    PFilter.Controls[I].Free;
  end;
  Frame := nil;
end;

procedure TFormPesquisa.MostarForm(ALocal: string;
  Campos: TDictionary<string, TTypeFilters>; AClose: TProc);
var
  campo: string;
begin
  Busca := ALocal;
  ACampos := Campos;
  AAClose := AClose;
  Self.Caption := ALocal[1] + LowerCase(Copy(ALocal, 2, MaxInt)) +
    ' - Pesquisa';

  DataControl := DM.Data;
  GridPesquisa.DataSource := DataControl.PesquisaSource;

  cmbCampos.Items.Clear;
  Controller := TController.GetInstancia;

  { Populando combo }
  for campo in Campos.Keys do
  begin
    cmbCampos.Items.AddObject(campo, TObject(Integer(Campos[campo])));
  end;

  if cmbCampos.Items.Count > 0 then
  begin
    cmbCampos.ItemIndex := 0;
    cmbCampos.OnChange(cmbCampos);
  end;

  Self.Show;

end;

end.
