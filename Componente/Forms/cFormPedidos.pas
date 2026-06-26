unit cFormPedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.Grids,
  Vcl.DBGrids,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, cEditGeneric, cEditMaskGeneric,
  Vcl.Mask, SimpleDS, PedidosController, cDGridGeneric, uInterfaces,
  System.UITypes, System.StrUtils;

type
  TEdit = class(TEditGeneric);
  TMaskEdit = class(TEditMaskGeneric);
  TDBGrid = class(TDBGridType);

  TFormPedidos = class(TForm, IObservador)
    EId: TEdit;
    LPedidos: TLabel;
    LData: TLabel;
    LHora: TLabel;
    EUser: TEdit;
    Label1: TLabel;
    ENomeUser: TEdit;
    LNomeUser: TLabel;
    btnPesquisa: TBitBtn;
    GridItems: TPanel;
    Panel2: TPanel;
    PItems: TPanel;
    GridItensPedidos: TDBGrid;
    btnInc: TBitBtn;
    btnDel: TBitBtn;
    Footer: TPanel;
    Label2: TLabel;
    LValorTotal: TLabel;
    btnAction: TButton;
    btnClose: TButton;
    EData: TMaskEdit;
    EHora: TMaskEdit;
    procedure EUserExit(Sender: TObject);
    procedure EUserKeyPress(Sender: TObject; var Key: Char);
    procedure btnIncClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnActionClick(Sender: TObject);
    procedure EIdExit(Sender: TObject);
    procedure btnPesquisaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  var
    FAction: string;
    DadosForm: TDataSource;
    ItensPedidosForm: TDataSource;
    IndirectForm: TSimpleDataSet;

    PController: TPedidosController;
    executando: boolean;

  public
    { Public declarations }

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure MostrarForm(Action: string; Dados: TDataSource;
      ItemPedidos: TDataSource);

    procedure Atualizar;
  end;

var
  FormPedidos: TFormPedidos;

implementation

{$R *.dfm}
{ TFormPedidos }

uses
  cFormPedidosItem, Controller;

procedure TFormPedidos.Atualizar;
var
  valorTotal: integer;
  sValor: string;
begin
  valorTotal := 0;
  if (ItensPedidosForm <> nil) and (ItensPedidosForm.DataSet <> nil) and
    (ItensPedidosForm.DataSet.Active) then
  begin

    PItems.Caption := Format('Items (%d)',
      [ItensPedidosForm.DataSet.RecordCount]);

    ItensPedidosForm.DataSet.First;
    while not ItensPedidosForm.DataSet.Eof do
    begin
      sValor := ItensPedidosForm.DataSet.FieldByName('VALOR').AsString;
      valorTotal := valorTotal + StrToIntDef(sValor, 0);
      ItensPedidosForm.DataSet.Next;
    end;
    ItensPedidosForm.DataSet.First;

    LValorTotal.Caption := FormatFloat('#,##0.00', valorTotal / 100.0);

  end
  else
  begin

    PItems.Caption := 'Items (0)';
  end;
end;

procedure TFormPedidos.btnPesquisaClick(Sender: TObject);
begin

  TController.GetInstancia.SearchShow('usuarios',
    procedure
    begin
      if not IndirectForm.Active then
        exit;

      if not IndirectForm.RecordCount > 0 then
        exit;

      EUser.Text := IndirectForm.FieldByName('ID').AsString;
      ENomeUser.Text := IndirectForm.FieldByName('NOME').AsString;
    end);

end;

procedure TFormPedidos.btnActionClick(Sender: TObject);
begin
  if executando then
    exit;

  if not ItensPedidosForm.DataSet.Active then
    raise Exception.Create('Pedido não pode ficar sem itens!');

  if not ItensPedidosForm.DataSet.RecordCount > 0 then
    raise Exception.Create('Pedido não pode ficar sem itens!');

  if ItensPedidosForm.DataSet.FieldByName('SEQUENCIAL').AsInteger = 0 then
    raise Exception.Create('Pedido não pode ficar sem itens!');

  executando := true;

  if FAction = 'Incluir' then
  begin

    if EUser.Text = '' then
    begin
      raise Exception.Create('Usuário não pode ser vazio');
      if EUser.CanFocus then
        EUser.SetFocus;
    end;

    PController.Incluir(EId.Text, LValorTotal.Caption, EUser.Text);

    ShowMessage('Pedido adicionado com sucesso!');

    ItensPedidosForm.DataSet.Active := false;

    EId.Text := IntToStr(StrToInt(EId.Text) + 1);
    EData.Text := PController.getData;
    EHora.Text := PController.getHora;

    EUser.Text := '';

    if EUser.CanFocus then
      EUser.SetFocus;

  end;

  if FAction = 'Alterar' then
  begin

    PController.Alterar(EId.Text, LValorTotal.Caption);

    ShowMessage('Alterado com sucesso!');

    EId.Enabled := true;
    EId.Text := '';

    if EId.CanFocus then
      EId.SetFocus;

  end;

  if FAction = 'Deletar' then
  begin
    PController.Deletar(EId.Text);

    ShowMessage('Pedido deletado com sucesso!');

    EId.Text := '';

    if EId.CanFocus then
    begin
      EId.SetFocus;
    end;
  end;

  executando := false;
end;

procedure TFormPedidos.btnCloseClick(Sender: TObject);
begin
  if ItensPedidosForm.DataSet is TClientDataSet then
  begin
    with TClientDataSet(ItensPedidosForm.DataSet) do
    begin

      if Active then
      begin
        CancelUpdates;
        EmptyDataSet;
      end
      else
        CreateDataSet;
    end;
  end;

  Close;
end;

procedure TFormPedidos.btnDelClick(Sender: TObject);
begin

  if FAction = 'Incluir' then
  begin
    if (ItensPedidosForm.DataSet.IsEmpty or not ItensPedidosForm.DataSet.Active)
    then
      raise Exception.Create('Sem dados para excluir');

    if MessageDlg('Tem certeza? Essa ação não pode ser desfeita',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      PController.remList(IntToStr(ItensPedidosForm.DataSet.RecNo),
        ItensPedidosForm.DataSet.FieldByName('SEQUENCIAL').AsString);
      ItensPedidosForm.DataSet.Delete;
    end;

    PController.Notificar;

  end;

  if FAction = 'Alterar' then
  begin
    if (ItensPedidosForm.DataSet.IsEmpty or not ItensPedidosForm.DataSet.Active)
    then
      raise Exception.Create('Sem dados para excluir');

    if executando then
      exit;

    executando := true;

    if MessageDlg('Tem certeza? Essa ação não pode ser desfeita',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      PController.DeleteRel(EId.Text, ItensPedidosForm.DataSet.FieldByName
        ('SEQUENCIAL').AsString);

      PController.PushRel(EId.Text);
    end;

    executando := false;

  end;

end;

procedure TFormPedidos.btnIncClick(Sender: TObject);
var
  proxSeq: string;
  Form: TFormItensPedidos;
begin

  if ItensPedidosForm.DataSet.Active and (not ItensPedidosForm.DataSet.IsEmpty)
  then
  begin
    ItensPedidosForm.DataSet.Last;
    proxSeq := IntToStr(ItensPedidosForm.DataSet.FieldByName('SEQUENCIAL')
      .AsInteger + 1);
  end
  else
    proxSeq := '1';

  Form := TFormItensPedidos.Create(Application);
  Form.MostrarForm(proxSeq, EId.Text);

end;

constructor TFormPedidos.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ENomeUser.Enabled := false;

  EData.SetTipoMascara(tmData);
  EHora.SetTipoMascara(tmHora);
  EUser.TipoKey := tcNumeros;
  EId.TipoKey := tcNumeros;

  PController := TPedidosController.GetInstancia;
  PController.AddObserver(Self);

  EData.Text := PController.getData;
  EHora.Text := PController.getHora;

end;

destructor TFormPedidos.Destroy;
begin
  PController.RemObserver(Self);
  inherited Destroy;
end;

procedure TFormPedidos.EIdExit(Sender: TObject);
begin

  if (Screen.ActiveControl <> nil) and (Screen.ActiveControl.Name = 'btnClose')
  then
  begin
    inherited DoExit;
    exit;
  end;

  if not DadosForm.DataSet.Locate('ID', EId.Text, []) then
    raise Exception.Create('Pedido não encontrado ou inexistente');

  if FAction = 'Alterar' then
  begin
    EUser.Text := DadosForm.DataSet.FieldByName('ID_USUARIO').AsString;
    ENomeUser.Text := DadosForm.DataSet.FieldByName('NOME').AsString;

    PController.PushRel(EId.Text);

    EId.Enabled := false;
  end;

  if FAction = 'Deletar' then
  begin

    if MessageDlg('Tem certeza? Essa ação não pode ser desfeita',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      btnAction.Click;
    end
    else
    begin
      Self.Close;
    end;

  end;

end;

procedure TFormPedidos.EUserExit(Sender: TObject);
begin
  if (Screen.ActiveControl <> nil) and ((Screen.ActiveControl = btnClose) or
    (Screen.ActiveControl = btnPesquisa)) then
  begin
    inherited DoExit;
    exit;
  end;

  IndirectForm := PController.getUser(EUser.Text);

  if IndirectForm.RecordCount > 0 then
    ENomeUser.Text := IndirectForm.FieldByName('NOME').AsString
  else
  begin
    ShowMessage('Usuário não encontrado');

    if EUser.CanFocus then
      EUser.SetFocus;

    EUser.Text := '';
    ENomeUser.Text := '';

  end;
end;

procedure TFormPedidos.EUserKeyPress(Sender: TObject; var Key: Char);
begin

  if Key = #13 then
  begin
    EUser.DoExit;
  end;

end;

procedure TFormPedidos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFormPedidos.MostrarForm(Action: string; Dados: TDataSource;
ItemPedidos: TDataSource);
begin

  FAction := Action;
  DadosForm := Dados;
  ItensPedidosForm := ItemPedidos;
  executando := false;

  GridItensPedidos.DataSource := ItensPedidosForm;

  IndirectForm := PController.getUser('1');
  Self.Caption := FAction + ' - Pedidos';
  btnAction.Caption := '&' + FAction;

  if FAction = 'Incluir' then
  begin
    EId.Enabled := false;

    btnAction.Caption := FAction[1] + '&' + Copy(FAction, 2, MaxInt);

    DadosForm.DataSet.Last;
    EId.Text := IntToStr(DadosForm.DataSet.FieldByName('ID').AsInteger + 1);

    Self.ActiveControl := EUser;
    EUser.DoEnter;
    btnPesquisa.Enabled := true;

  end;

  if FAction = 'Alterar' then
  begin
    EId.Enabled := true;

    EId.Text := DadosForm.DataSet.FieldByName('ID').AsString;

    Self.ActiveControl := EId;
    EId.DoEnter;

    EUser.Enabled := false;
    btnPesquisa.Enabled := false;

  end;

  if FAction = 'Deletar' then
  begin
    EId.Enabled := true;

    EId.Text := DadosForm.DataSet.FieldByName('ID').AsString;

    Self.ActiveControl := EId;
    EId.DoEnter;

    EUser.Enabled := false;
  end;

  PController.LimparLocal;

  Self.Show;

end;

end.
