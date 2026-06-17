unit PedidosController;

interface

uses
  Controller, SimpleDS, System.SysUtils, DM, System.Generics.Collections,
  uInterfaces, Data.DB, Datasnap.DBClient, System.StrUtils;

type
  TPedidosController = class(TInterfacedObject, ISubject)
  private
  var
    DataControl: TData;
    Controller: TController;

    ListaObserver: TList<IObservador>;
    ListaItems: TList<TItemPedidos>;

    class var InstanciaControl: TPedidosController;
  public

    function getUser(AId: string): TSimpleDataSet;
    function getItem(AId: string): TSimpleDataSet;
    function getData(): string;
    function getHora(): string;

    procedure DeleteRel(AId, ASequencial: string);
    procedure PushRel(AIdPedido: string);

    procedure InsertVisual(Item: TItemPedidos);

    procedure Incluir(AId, AValor, AIdUser: string);
    procedure Alterar(AId, AValor: string);
    procedure Deletar(AId: string);

    procedure remList(AId, ASeq: string);

    procedure AddObserver(Obj: IObservador);
    procedure RemObserver(Obj: IObservador);

    procedure Notificar;

    constructor Create;
    destructor Destroy; override;

    class function GetInstancia: TPedidosController;
    class procedure LiberarInstancia;

  end;

implementation

{ TPedidosController }

uses
  Data.DBXCommon, Data.SqlExpr;

procedure TPedidosController.AddObserver(Obj: IObservador);
begin
  ListaObserver.Add(Obj);
end;

procedure TPedidosController.Alterar(AId, AValor: string);
var
  t: TDBXTransaction;
  Item: TItemPedidos;
begin

  t := DataControl.ConnSQL.BeginTransaction;

  try

    with DataControl.Query do
    begin
      SQL.Clear;
      SQL.Add('UPDATE PEDIDOS');
      SQL.Add('SET VALOR = :Pvalor');
      SQL.Add('WHERE ID = :PidPedido');
      ParamByName('Pvalor').AsInteger := Round(StrToFloat(ReplaceStr(AValor, '.', '')) * 100);
      ParamByName('PidPedido').AsInteger := StrToInt(AId);
      ExecSQL;
    end;

    { ATUALIZANDO ITENS NO PEDIDO }
    with DataControl.Query do
    begin
      SQL.Clear;
      SQL.Add('INSERT INTO PEDIDOS_ITENS (ID_PEDIDO, SEQUENCIAL, ID_ITEM, QUANTIDADE)');
      SQL.Add('VALUES (:PidPedidos, :PSequencial, :PidItem, :PQuantidade)');
      for Item in ListaItems do
      begin
        ParamByName('PidPedidos').AsInteger := StrToInt(Item.IdPedido);
        ParamByName('PIdItem').AsInteger := StrToInt(Item.IdItem);
        ParamByName('PSequencial').AsInteger := StrToInt(Item.Sequencial);
        ParamByName('PQuantidade').AsInteger := StrToInt(Item.Quantidade);
        ExecSQL;
      end;

    end;


    ListaItems.Clear;

    DataControl.ConnSQL.CommitFreeAndNil(t);

    Controller.Notificar;

  except
    on E: Exception do
    begin
      DataControl.ConnSQL.RollbackFreeAndNil(t);
      raise Exception.Create('Falha ao atualizar dados do pedido ' + E.Message);
    end;

  end;

end;

constructor TPedidosController.Create;
begin
  DataControl := DM.Data;

  ListaObserver := TList<IObservador>.Create;
  ListaItems := TList<TItemPedidos>.Create;

  Controller := TController.GetInstancia;
end;

procedure TPedidosController.Deletar(AId: string);
begin

  try

    with DataControl.Query do
    begin
      SQL.Clear;
      SQL.Add('DELETE FROM PEDIDOS');
      SQL.Add('WHERE ID = :PId');
      ParamByName('PId').AsInteger := StrToInt(AId);
      ExecSQL;
    end;

    Controller.Notificar;

  except
    on E: Exception do
    begin
      raise Exception.Create('Falha ao deletar pedido ' + E.Message);
    end;

  end;

end;

procedure TPedidosController.DeleteRel(AId, ASequencial: string);
begin
  try

    with DataControl.Query do
    begin
      SQL.Clear;
      SQL.Add('DELETE FROM PEDIDOS_ITENS');
      SQL.Add('WHERE ID_PEDIDO = :PId AND SEQUENCIAL = :PSeq');
      ParamByName('PId').AsInteger := StrToInt(AId);
      ParamByName('PSeq').AsInteger := StrToInt(ASequencial);
      ExecSQL;
    end;

    Notificar;

  except
    on E: Exception do
    begin
      raise Exception.Create('Falha ao remover item do pedido ' + E.Message);
    end;

  end;
end;

destructor TPedidosController.Destroy;
begin
  if InstanciaControl = Self then
    InstanciaControl := nil;

  ListaObserver.Free;
  ListaItems.Free;

  inherited Destroy;
end;

function TPedidosController.getData: string;
begin
  Result := FormatDateTime('dd/mm/yyyy', Now);
end;

function TPedidosController.getHora: string;
begin
  Result := FormatDateTime('hh:nn', Now);
end;

class function TPedidosController.GetInstancia: TPedidosController;
begin
  if not Assigned(InstanciaControl) then
    InstanciaControl := TPedidosController.Create;

  Result := InstanciaControl;
end;

function TPedidosController.getItem(AId: string): TSimpleDataSet;
begin
  DataControl.IndirectConsult.Close;

  DataControl.IndirectConsult.DataSet.CommandText :=
    Format('SELECT * FROM ITENS WHERE ID = %d;', [StrToInt(AId)]);

  DataControl.IndirectConsult.Open;

  Result := DataControl.IndirectConsult;
end;

function TPedidosController.getUser(AId: string): TSimpleDataSet;
begin

  DataControl.IndirectConsult.Close;

  DataControl.IndirectConsult.DataSet.CommandText :=
    Format('SELECT * FROM USUARIOS WHERE ID = %d;', [StrToInt(AId)]);

  DataControl.IndirectConsult.Open;

  Result := DataControl.IndirectConsult;

end;

procedure TPedidosController.Incluir(AId, AValor, AIdUser: string);
var
  t: TDBXTransaction;
  Item: TItemPedidos;
begin

  t := DataControl.ConnSQL.BeginTransaction;

  try

    with DataControl.Query do
    begin
      SQL.Clear;
      SQL.Add('INSERT INTO PEDIDOS (ID, VALOR, ID_USUARIO)');
      SQL.Add('VALUES (:Pid, :Pvalor, :PIdUser)');
      ParamByName('Pid').AsInteger := StrToInt(AId);
      ParamByName('Pvalor').AsInteger := Round(StrToFloat(ReplaceStr(AValor, '.', '')) * 100);
      ParamByName('PIdUser').AsString := AIdUser;
      ExecSQL;
    end;

    with DataControl.Query do
    begin
      SQL.Clear;
      SQL.Add('INSERT INTO PEDIDOS_ITENS (ID_PEDIDO, SEQUENCIAL, ID_ITEM, QUANTIDADE)');
      SQL.Add('VALUES (:PidPedidos, :PSequencial, :PidItem, :PQuantidade)');
      for Item in ListaItems do
      begin
        ParamByName('PidPedidos').AsInteger := StrToInt(Item.IdPedido);
        ParamByName('PSequencial').AsInteger := StrToInt(Item.Sequencial);
        ParamByName('PidItem').AsInteger := StrToInt(Item.IdItem);
        ParamByName('PQuantidade').AsInteger := StrToInt(Item.Quantidade);
        ExecSQL;
      end;
    end;

    DataControl.ConnSQL.CommitFreeAndNil(t);

    Controller.Notificar;

  except
    on E: Exception do
    begin
      DataControl.ConnSQL.RollbackFreeAndNil(t);
      raise Exception.Create('Falha ao cadastrar pedido ' + E.Message);
    end;

  end;

end;

procedure TPedidosController.InsertVisual(Item: TItemPedidos);
begin

  with DataControl.PedidosItemLocal do
  begin
    if not Active then
    begin
      Close;
      FieldDefs.Clear;

      FieldDefs.Add('ID_PEDIDO', ftInteger);
      FieldDefs.Add('ID_ITEM', ftInteger);
      FieldDefs.Add('SEQUENCIAL', ftInteger);
      FieldDefs.Add('NOME', ftString, 29);
      FieldDefs.Add('QUANTIDADE', ftInteger);
      FieldDefs.Add('VALOR', ftInteger);

      CreateDataSet;
    end;

    DataControl.PedidosItems.DataSet := DataControl.PedidosItemLocal;

    Append;

    try
      FieldByName('ID_PEDIDO').AsInteger := StrToInt(Item.IdPedido);
      FieldByName('ID_ITEM').AsInteger := StrToInt(Item.IdItem);
      FieldByName('SEQUENCIAL').AsInteger := StrToInt(Item.Sequencial);
      FieldByName('NOME').AsString := Item.Nome;
      FieldByName('QUANTIDADE').AsInteger := StrToInt(Item.Quantidade);
      FieldByName('VALOR').AsInteger := Round(StrToFloat(ReplaceStr(Item.Valor, '.', '')) * 100);

      FieldByName('VALOR').OnGetText := DataControl.FormatarValorGetText;

      Post;

      Notificar;
    except
      Cancel;
      raise Exception.Create('Erro ao adicionar na memoria');

    end;

    ListaItems.Add(Item);

  end;
end;

class procedure TPedidosController.LiberarInstancia;
begin
  if Assigned(InstanciaControl) then
  begin
    InstanciaControl.Free;
    InstanciaControl := nil;
  end;
end;

procedure TPedidosController.PushRel(AIdPedido: string);
begin
  try

    with DataControl do
    begin
      PedidosItemSDataSet.Close;

      PedidosItemSDataSet.DataSet.CommandText :=
        Format('SELECT ' + '  pi.ID_PEDIDO, ' + '  pi.ID_ITEM, ' +
        '  pi.SEQUENCIAL, ' + '  i.NOME, ' + '  pi.QUANTIDADE, ' +
        '  (pi.QUANTIDADE * i.VALOR) AS VALOR ' + 'FROM PEDIDOS_ITENS pi ' +
        'INNER JOIN ITENS i ON (i.ID = pi.ID_ITEM) ' +
        'WHERE pi.ID_PEDIDO = %s', [AIdPedido]);

      PedidosItems.DataSet := PedidosItemSDataSet;

      PedidosItemSDataSet.FetchOnDemand := true;
      PedidosItemSDataSet.Open;

      PedidosItems.Enabled := true;

      { Local e Simple do banco iguais }
      PedidosItemLocal.Data := PedidosItemSDataSet.Data;

      PedidosItemLocal.FieldByName('VALOR').OnGetText := FormatarValorGetText;

      PedidosItems.DataSet := PedidosItemLocal;
    end;

    Notificar;

  except
    on E: Exception do
    begin
      raise Exception.Create('Falha ao buscar items do pedido ' + E.Message);
    end;

  end;
end;

procedure TPedidosController.remList(AId, ASeq: string);
var
  i: integer;
begin
  for i := 0 to Pred(ListaItems.Count) do
  begin
    if (ListaItems[i].IdItem = Aid) and (ListaItems[i].Sequencial = ASeq) then
    begin
      ListaItems.Delete(i);
    end;
  end;

end;

procedure TPedidosController.Notificar;
var
  Obs: IObservador;
begin
  for Obs in ListaObserver do
  begin
    Obs.Atualizar;
  end;
end;

procedure TPedidosController.RemObserver(Obj: IObservador);
begin
  ListaObserver.Remove(Obj)
end;

initialization

finalization

TPedidosController.LiberarInstancia;

end.
