unit ItemController;

interface

uses
  Controller, DM, System.SysUtils, System.StrUtils;

type
  TItemController = class
  private
  var
    Controller: TController;
  public
    constructor Create;

    procedure Inserir(AId, ANome, AValor, ADesc: string);
    procedure Deletar(AId: string);
    procedure Atualizar(AId, ANome, AValor, ADesc: string);
    procedure Filtrar(Filter: string);
  end;

implementation

{ TItemController }

procedure TItemController.Atualizar(AId, ANome, AValor, ADesc: string);
var
  valorInt: integer;
begin
  try

    valorInt := StrToInt(ReplaceStr(StringReplace(AValor, ',', '',
      [rfReplaceAll]), '.', ''));

    with Data.Query do
    begin
      SQL.Clear;
      SQL.Add('UPDATE ITENS');
      SQL.Add('SET NOME = :Pnome, VALOR = :Pvalor, DESCRICAO = :PDesc');
      SQL.Add('WHERE ID = :Pid');
      ParamByName('Pid').AsInteger := StrToInt(AId);
      ParamByName('Pnome').AsString := ANome;
      ParamByName('Pvalor').AsInteger := valorInt;
      ParamByName('Pdesc').AsString := ADesc;
      ExecSQL;
    end;

    Controller.Notificar;
  except
    on E: Exception do
    begin
      raise Exception.Create('Falha ao atualizar Item' + E.Message);
    end;

  end;
end;

constructor TItemController.Create;
begin
  Controller := TController.GetInstancia;
end;

procedure TItemController.Deletar(AId: string);
begin
  try
    with Data.Query do
    begin
      SQL.Clear;
      SQL.Add('DELETE FROM ITENS');
      SQL.Add('WHERE ID = :Pid');
      ParamByName('Pid').AsInteger := StrToInt(AId);
      ExecSQL;
    end;
    Controller.Notificar;
  except
    on E: Exception do
    begin
      raise Exception.Create('Falha ao deletar Item' + E.Message);
    end;

  end;
end;

procedure TItemController.Filtrar(Filter: string);
begin
  try
    Data.UserSDataSet.Active := false;

    with Data.UserSDataSet.Dataset do
    begin
      CommandText := Filter
    end;

    Data.UserSDataSet.Active := true;
  except
    on E: Exception do
    begin
      raise Exception.Create('Falha ao filtrar usuário ' + E.Message);
    end;

  end;
end;

procedure TItemController.Inserir(AId, ANome, AValor, ADesc: string);
var
  valorInt: integer;
begin
  try
    valorInt := StrToInt(ReplaceStr(StringReplace(AValor, ',', '',
      [rfReplaceAll]), '.', ''));

    with Data.Query do
    begin
      SQL.Clear;
      SQL.Add('INSERT INTO ITENS (ID, NOME, VALOR, DESCRICAO)');
      SQL.Add('VALUES (:Pid, :PNome, :Pvalor, :Pdesc)');
      ParamByName('Pid').AsInteger := StrToInt(AId);
      ParamByName('Pnome').AsString := ANome;
      ParamByName('Pvalor').AsInteger := valorInt;
      ParamByName('Pdesc').AsString := ADesc;
      ExecSQL;
    end;

    Controller.Notificar;
  except
    on E: Exception do
    begin
      raise Exception.Create('Falha ao inserir Item ' + E.Message);
    end;

  end;
end;

end.
