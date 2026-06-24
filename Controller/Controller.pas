unit Controller;

interface

uses uInterfaces, System.Generics.Collections, uFrameBase, System.Classes,
  System.SysUtils, Data.DB, cDGridGeneric;

type

  TController = class(TInterfacedObject, ISubject)
  private
    ListaObserver: TList<IObservador>;
    TabelaCurrent: string;
    isFilter: boolean;

    class var InstanciaControl: TController;
    constructor Create;

  public
    destructor Destroy; override;
    class function GetInstancia: TController;
    class procedure LiberarInstancia;

    function FrameGen(Frame: TFrameBaseClass; Tipo: string): TFrameBase;
    function getTypeInput(ACampo: string): TTypeInputs;
    function getOptions(ACampo: string): TStringList;
    function getCampos(ALocal: string): TDictionary<string, TTypeFilters>;
    function getTabelaCurrent: String;

    procedure FormShow(Action, NameForm: string);

    procedure FilterShow;
    procedure SearchShow(ALocal: string);

    procedure ChangeTableCurrent(ALocal: string);

    procedure Filtrar(ACampo, AFiltro: string);

    procedure initGrid(ATipo: string);
    procedure switchIsFilter;
    function getIsFilter: boolean;

    procedure AjustaLayoutGrid(AGrid: TDBGridType);
    procedure Pesquisar(ALocal, ACampo, AValor: string);

    { Subject Metodos }
    procedure AddObserver(IObserver: IObservador);
    procedure RemObserver(IObserver: IObservador);
    procedure Notificar;
  end;

implementation

{ TController }

uses
  DM, fDBGrid, Vcl.Forms, Vcl.Dialogs, System.RegularExpressions,
  cFormUsuario, cFormItem, cFormPedidos, cFormFilter, cFormPesquisa;

var
  DataControl: TData;

procedure TController.AddObserver(IObserver: IObservador);
begin
  ListaObserver.Add(IObserver);
end;

procedure TController.AjustaLayoutGrid(AGrid: TDBGridType);
var
  nome: string;
begin

  nome := AGrid.DataSource.DataSet.Name;

  if nome = 'UserSDataSet' then
  begin
    with AGrid do
    begin
      Columns[4].Title.Caption := 'Data Nascimento';
      Columns[5].Title.Caption := 'Estado Civil';
      Columns[6].Title.Caption := 'Endereço';
    end;
  end
  else if nome = 'ItemSDataSet' then
  begin
    with AGrid do
    begin
      Columns[0].Title.Caption := 'Item';
      DataSource.DataSet.FieldByName('VALOR').OnGetText :=
        DataControl.FormatarValorGetText;
    end;
  end
  else if nome = 'PedidoSDataSet' then
  begin
    with AGrid do
    begin
      Columns[0].Title.Caption := 'Pedido';
      Columns[3].Visible := false;
      Columns[4].Visible := false;
      DataSource.DataSet.FieldByName('VALOR').OnGetText :=
        DataControl.FormatarValorGetText;
    end;
  end;

end;

procedure TController.ChangeTableCurrent(ALocal: string);
begin
  TabelaCurrent := ALocal;
end;

constructor TController.Create;
begin
  inherited Create;
  ListaObserver := TList<IObservador>.Create;
  isFilter := false;
  DataControl := DM.Data;
end;

destructor TController.Destroy;
begin

  if InstanciaControl = Self then
    InstanciaControl := nil;

  ListaObserver.Free;

  inherited Destroy;
end;

procedure TController.FilterShow;
var
  Campos: TDictionary<string, TTypeFilters>;
  Filtro: TFormFilter;
begin
  Campos := nil;
  Filtro := nil;
  try

    Campos := getCampos(TabelaCurrent);

    if not Campos.Count > 0 then
      raise Exception.Create('Falha ao obter campos');

    Filtro := TFormFilter.Create(nil);
    Filtro.MostarForm(Campos);

  finally
    if Assigned(Filtro) then
      Filtro.Free;

    Campos.Free;
  end;

end;

procedure TController.Filtrar(ACampo, AFiltro: string);
var
  filtroControl: string;
begin

  if LowerCase(TabelaCurrent) = 'usuarios' then
  begin

    with DataControl.UserSDataSet do
    begin
      Close;
      DataSet.CommandText :=
        Format('SELECT ID, NOME, CPF, TELEFONE, DATA_NASCIMENTO, ESTADO_CIVIL, ENDERECO FROM USUARIOS %s;',
        [AFiltro]);
      Open;
    end;

  end;

  if LowerCase(TabelaCurrent) = 'itens' then
  begin

    with DataControl.ItemSDataSet do
    begin
      Close;
      DataSet.CommandText := Format('SELECT * FROM ITENS %s;', [AFiltro]);
      Open;
    end;

  end;

  if LowerCase(TabelaCurrent) = 'pedidos' then
  begin
    filtroControl := TRegEx.Replace(AFiltro, 'DATA', 'DATETIME');
    filtroControl := TRegEx.Replace(filtroControl, 'QUANTIDADE',
      '(SELECT COUNT(*) FROM PEDIDOS_ITENS pi WHERE pi.ID_PEDIDO = p.ID)');

    if ACampo = 'USUARIOS' then
    begin
      filtroControl := TRegEx.Replace(filtroControl, 'USUARIOS',
        'p.ID_USUARIO');
      filtroControl := TRegEx.Replace(filtroControl, '\s+ID\s+',
        ' p.ID_USUARIO', [roIgnoreCase]);
    end;

    filtroControl :=
      Format('SELECT p.ID, u.NOME, p.VALOR, p.DATETIME, p.ID_USUARIO, (SELECT COUNT(*) FROM PEDIDOS_ITENS pi WHERE pi.ID_PEDIDO = p.ID) AS QUANTIDADE FROM PEDIDOS p INNER JOIN USUARIOS u ON u.ID = p.ID_USUARIO %s;',
      [filtroControl]);

    with DataControl.PedidoSDataSet do
    begin
      Close;
      DataSet.CommandText := filtroControl;
      Open;
    end;

  end;

  Notificar;

end;

procedure TController.FormShow(Action, NameForm: string);
var
  FrmControl: TForm;
begin

  if NameForm = 'usuario' then
  begin
    FrmControl := TFormUsuario.Create(nil);
    try
      TFormUsuario(FrmControl).MostrarForm(Action, DataControl.UsuarioSource);
    finally
      FrmControl.Free;
    end;

  end;

  if NameForm = 'item' then
  begin
    FrmControl := TFormItem.Create(nil);
    try
      TFormItem(FrmControl).MostrarForm(Action, DataControl.ItemSource);
    finally
      FrmControl.Free;
    end;

  end;

  if NameForm = 'pedido' then
  begin
    FrmControl := TFormPedidos.Create(nil);
    try
      TFormPedidos(FrmControl).MostrarForm(Action, DataControl.PedidosSource,
        DataControl.PedidosItems);
    finally
      FrmControl.Free;
    end;
  end;

end;

function TController.FrameGen(Frame: TFrameBaseClass; Tipo: string): TFrameBase;
begin

  Result := nil;

  if Tipo = 'usuario' then
  begin
    Result := Frame.Create(nil);
    Result.Iniciar(DataControl.UsuarioSource);

    TabelaCurrent := 'usuarios';

  end;

  if Tipo = 'item' then
  begin
    Result := Frame.Create(nil);
    Result.Iniciar(DataControl.ItemSource);

    TabelaCurrent := 'itens';

  end;

  if Tipo = 'pedido' then
  begin
    Result := Frame.Create(nil);
    Result.Iniciar(DataControl.PedidosSource);

    TabelaCurrent := 'pedidos';
  end;

  if Result is TFGrid then
    AjustaLayoutGrid(TFGrid(Result).GridControl);

  if Assigned(Result) then
    AddObserver(Result);

end;

function TController.getCampos(ALocal: string)
  : TDictionary<string, TTypeFilters>;
begin
  Result := TDictionary<string, TTypeFilters>.Create;
  if LowerCase(ALocal) = 'usuarios' then
  begin
    Result.Add('ID', tfEspecifico);
    Result.Add('NOME', tfEspecifico);
    Result.Add('CPF', tfEspecifico);
    Result.Add('TELEFONE', tfEspecifico);
    Result.Add('DATA_NASCIMENTO', tfRange);
    Result.Add('ENDERECO', tfEspecifico);
    Result.Add('ESTADO_CIVIL', tfSelect);

  end;

  if ALocal = 'itens' then
  begin
    Result.Add('ID', tfEspecifico);
    Result.Add('NOME', tfEspecifico);
    Result.Add('VALOR', tfEspecifico);
    Result.Add('DESCRICAO', tfEspecifico);
  end;

  if ALocal = 'pedidos' then
  begin
    Result.Add('ID', tfEspecifico);
    Result.Add('USUARIOS', tfTable);
    Result.Add('VALOR', tfValue);
    Result.Add('QUANTIDADE', tfValue);
    Result.Add('DATA', tfRange);
  end;

end;

class function TController.GetInstancia: TController;
begin
  if not Assigned(InstanciaControl) then
    InstanciaControl := TController.Create;

  Result := InstanciaControl;
end;

function TController.getIsFilter: boolean;
begin
  Result := isFilter;
end;

function TController.getOptions(ACampo: string): TStringList;
begin
  Result := TStringList.Create;

  if ACampo = 'ESTADO_CIVIL' then
  begin
    Result.Add('01 - Solteiro(a)');
    Result.Add('02 - Casado(a)');
    Result.Add('03 - Divorciado(a)');
    Result.Add('04 - Viúvo(a)');
    Result.Add('05 - Separado(a)');
  end;

end;

function TController.getTabelaCurrent: String;
begin
  Result := TabelaCurrent;
end;

function TController.getTypeInput(ACampo: string): TTypeInputs;
var
  Tipo: TTypeInputs;
begin

  Tipo := tiTexto;
  if LowerCase(TabelaCurrent) = 'usuarios' then
  begin

    if ACampo = 'ID' then
      Tipo := tiNumber;

    if ACampo = 'NOME' then
      Tipo := tiTexto;

    if ACampo = 'CPF' then
      Tipo := tiCpf;

    if ACampo = 'ENDERECO' then
      Tipo := tiLivre;

    if ACampo = 'TELEFONE' then
      Tipo := tiTelefone;

  end;

  if LowerCase(TabelaCurrent) = 'itens' then
  begin
    if ACampo = 'ID' then
      Tipo := tiNumber;

    if ACampo = 'NOME' then
      Tipo := tiTexto;

    if ACampo = 'VALOR' then
      Tipo := tiDinheiro;

    if ACampo = 'DESCRICAO' then
      Tipo := tiLivre;
  end;

  if LowerCase(TabelaCurrent) = 'pedidos' then
  begin
    if ACampo = 'ID' then
      Tipo := tiNumber;

    if ACampo = 'VALOR' then
      Tipo := tiDinheiro;

    if ACampo = 'QUANTIDADE' then
      Tipo := tiNumber;

  end;

  Result := Tipo;

end;

procedure TController.initGrid(ATipo: string);
begin
  if LowerCase(ATipo) = 'usuario' then
  begin
    with DataControl.UserSDataSet do
    begin
      Close;
      DataSet.CommandText :=
        'SELECT ID, NOME, CPF, TELEFONE, DATA_NASCIMENTO, ESTADO_CIVIL, ENDERECO FROM USUARIOS ORDER BY ID ASC;';
      Open;
    end;

  end;

  if LowerCase(ATipo) = 'item' then
  begin
    with DataControl.ItemSDataSet do
    begin
      Close;
      DataSet.CommandText := 'SELECT * FROM ITENS ORDER BY ID ASC;';
      Open;
    end;

  end;

  if LowerCase(ATipo) = 'pedido' then
  begin
    with DataControl.PedidoSDataSet do
    begin
      Close;
      DataSet.CommandText :=
        Format('SELECT p.ID, u.NOME, p.VALOR, p.DATETIME, p.ID_USUARIO, ' +
        ' (SELECT COUNT(*) FROM PEDIDOS_ITENS pi WHERE pi.ID_PEDIDO = p.ID) AS QUANTIDADE '
        + ' FROM PEDIDOS p ' + ' INNER JOIN USUARIOS u ON u.ID = p.ID_USUARIO '
        + ' ORDER BY p.ID ASC;', []);
      Open;
    end;
  end;
end;

class procedure TController.LiberarInstancia;
begin
  if Assigned(InstanciaControl) then
  begin
    InstanciaControl.Free;
    InstanciaControl := nil;
  end;
end;

procedure TController.Notificar;
var
  Obs: IObservador;
begin
  for Obs in ListaObserver do
  begin
    Obs.Atualizar;
  end;
end;

procedure TController.Pesquisar(ALocal, ACampo, AValor: string);
var
  pesquisa: string;
begin
  pesquisa := '';

  if LowerCase(ALocal) = 'usuarios' then
  begin
    pesquisa :=
      Format('SELECT ID, NOME, CPF, TELEFONE, DATA_NASCIMENTO, ESTADO_CIVIL, ENDERECO FROM USUARIOS %s ORDER BY %s ASC;',
      [AValor, ACampo]);
  end;

  if LowerCase(ALocal) = 'itens' then
  begin
    pesquisa := Format('SELECT * FROM ITENS %s ORDER BY %s ASC;',
      [AValor, ACampo]);
  end;

  if pesquisa <> '' then
  begin
    with DataControl do
    begin
      IndirectConsult.Close;
      IndirectConsult.DataSet.CommandText := pesquisa;
      PesquisaSource.DataSet := IndirectConsult;
      IndirectConsult.Open;

      if Assigned(IndirectConsult.FindField('VALOR')) then
        IndirectConsult.FieldByName('VALOR').OnGetText := FormatarValorGetText;
    end;
  end;

end;

procedure TController.RemObserver(IObserver: IObservador);
begin
  ListaObserver.Remove(IObserver)
end;

procedure TController.SearchShow(ALocal: string);
begin

  FormPesquisa.MostarForm(ALocal, getCampos(ALocal));

end;

procedure TController.switchIsFilter;
begin
  if isFilter then
    isFilter := false
  else
    isFilter := true;
end;

initialization

finalization

TController.LiberarInstancia;

end.
