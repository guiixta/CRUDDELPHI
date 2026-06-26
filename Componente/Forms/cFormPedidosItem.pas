unit cFormPedidosItem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls,
  PedidosController, SimpleDS, cEditGeneric, uInterfaces, Data.DB, Controller;

type

  TEdit = class(TEditGeneric);

  TFormItensPedidos = class(TForm)
    Panel1: TPanel;
    btnAction: TButton;
    btnClose: TButton;
    ESeq: TEdit;
    LSeq: TLabel;
    EIdItem: TEdit;
    LIdItem: TLabel;
    ENome: TEdit;
    Label1: TLabel;
    EQuant: TEdit;
    Label2: TLabel;
    EValorTotal: TEdit;
    Label3: TLabel;
    btnPesquisa: TBitBtn;
    procedure EIdItemExit(Sender: TObject);
    procedure btnActionClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure EQuantExit(Sender: TObject);
    procedure btnPesquisaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }

  var
    PIController: TPedidosController;
    AidPedido: string;
    IndirectForm: TSimpleDataSet;
    ItemToPedido: TItemPedidos;
  public
    { Public declarations }
    procedure MostrarForm(ISeq, IdPedido: string);
  end;

var
  FormItensPedidos: TFormItensPedidos;

implementation

{$R *.dfm}
{ TFormItensPedidos }

var
  adicionando: boolean;

procedure TFormItensPedidos.btnActionClick(Sender: TObject);
begin

  if adicionando then
    exit;

  adicionando := true;

  if (StrToInt(EQuant.Text) <= 0) and (StrToInt(EIdItem.Text) <= 0) then
    raise Exception.Create('Quantidade não pode ser nula');

  with ItemToPedido do
  begin
    IdPedido := AidPedido;
    IdItem := EIdItem.Text;
    Sequencial := ESeq.Text;
    Nome := ENome.Text;
    Quantidade := EQuant.Text;
    Valor := EValorTotal.Text;
  end;

  PIController.InsertVisual(ItemToPedido);

  ShowMessage('Item Adicionado com sucesso');

  EIdItem.Text := '';
  ENome.Text := '';
  EValorTotal.Text := '';
  ESeq.Text := IntToStr(StrToInt(ESeq.Text) + 1);

  if EIdItem.CanFocus then
    EIdItem.SetFocus;

  EQuant.Text := '';

  adicionando := false;
end;

procedure TFormItensPedidos.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFormItensPedidos.btnPesquisaClick(Sender: TObject);
begin
  TController.GetInstancia.SearchShow('itens',
    procedure
    begin
      if not IndirectForm.Active then
        exit;

      if not IndirectForm.RecordCount > 0 then
        exit;

      EIdItem.Text := IndirectForm.FieldByName('ID').AsString;
      ENome.Text := IndirectForm.FieldByName('NOME').AsString;

      if EQuant.CanFocus then
        EQuant.SetFocus;
    end);

end;

procedure TFormItensPedidos.EIdItemExit(Sender: TObject);
begin
  if (Screen.ActiveControl <> nil) and ((Screen.ActiveControl = btnClose) or
    (Screen.ActiveControl = btnPesquisa)) then
  begin
    inherited DoExit;
    exit;
  end;
  IndirectForm := PIController.getItem(EIdItem.Text);

  if IndirectForm.RecordCount > 0 then
  begin
    ENome.Text := IndirectForm.FieldByName('NOME').AsString;
    EQuant.Text := '1';

    EValorTotal.Text := FormatFloat('#,##0.00',
      IndirectForm.FieldByName('VALOR').AsInteger *
      StrToInt(EQuant.Text) / 100.0);

    if EQuant.CanFocus then
      EQuant.SetFocus;
  end
  else
  begin
    ShowMessage('Item não encontrado');

    if EIdItem.CanFocus then
      EIdItem.SetFocus;
  end;

end;

procedure TFormItensPedidos.EQuantExit(Sender: TObject);
begin
  if (Screen.ActiveControl <> nil) and (Screen.ActiveControl.Name = 'btnClose')
  then
  begin
    inherited DoExit;
    exit;
  end;

  if EQuant.Text = '0' then
    raise Exception.Create('Quantidade não pode ser 0');

  EValorTotal.Text := FormatFloat('#,##0.00', StrToInt(EQuant.Text) *
    IndirectForm.FieldByName('VALOR').AsInteger / 100.0);

end;

procedure TFormItensPedidos.FormClose(Sender: TObject;
var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFormItensPedidos.MostrarForm(ISeq, IdPedido: string);
begin
  EIdItem.TipoKey := tcNumeros;
  EQuant.TipoKey := tcNumeros;

  ESeq.Text := ISeq;
  AidPedido := IdPedido;
  PIController := TPedidosController.GetInstancia;
  IndirectForm := PIController.getUser('1');

  Self.Show;

  Self.ActiveControl := EIdItem;

end;

end.
