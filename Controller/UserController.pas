unit UserController;

interface

uses
  DM, System.SysUtils, Controller;

type
  TUserController = class
  private
  var
    Controller: TController;
  public
    constructor Create;

    procedure Inserir(AId, ANome, ACpf, ATel, AEstado, AEndereco,
      AData: string);
    procedure Deletar(AId: string);
    procedure Atualizar(AId, ANome, ACpf, ATel, AData, AEC, AEnd: string);
    procedure Filtrar(Filter: string);
  end;

implementation

{ TUserController }

procedure TUserController.Atualizar(AId, ANome, ACpf, ATel, AData, AEC,
  AEnd: string);
begin
  try
    with Data.Query do
    begin
      SQL.Clear;
      SQL.Add('UPDATE USUARIOS');
      SQL.Add('SET NOME = :Pnome, CPF = :Pcpf, TELEFONE = :Ptelefone, DATA_NASCIMENTO = :Pdata, ESTADO_CIVIL = :PestadoCivil, ENDERECO = :Pendereco');
      SQL.Add('WHERE ID = :Pid');
      ParamByName('Pid').AsInteger := StrToInt(AId);
      ParamByName('Pnome').AsString := ANome;
      ParamByName('Pcpf').AsString := ACpf;
      ParamByName('Ptelefone').AsString := ATel;
      ParamByName('Pdata').AsDate := StrToDate(AData);
      ParamByName('PestadoCivil').AsString := AEC;
      ParamByName('Pendereco').AsString := AEnd;
      ExecSQL;
    end;

    Controller.Notificar;
  except
    on E: Exception do
    begin
      raise Exception.Create('Falha ao atualizar usuário' + E.Message);
    end;

  end;
end;

constructor TUserController.Create;
begin
  Controller := TController.GetInstancia;
end;

procedure TUserController.Deletar(AId: string);
begin
  try
    with Data.Query do
    begin
      SQL.Clear;
      SQL.Add('DELETE FROM USUARIOS');
      SQL.Add('WHERE ID = :Pid');
      ParamByName('Pid').AsInteger := StrToInt(AId);
      ExecSQL;
    end;
    Controller.Notificar;
  except
    on E: Exception do
    begin
      raise Exception.Create('Falha ao deletar usuário' + E.Message);
    end;

  end;
end;

procedure TUserController.Filtrar(Filter: string);
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

procedure TUserController.Inserir(AId, ANome, ACpf, ATel, AEstado, AEndereco,
  AData: String);
begin

  try

    with Data.Query do
    begin
      SQL.Clear;
      SQL.Add('INSERT INTO USUARIOS (ID, NOME, CPF, TELEFONE, DATA_NASCIMENTO, ESTADO_CIVIL, ENDERECO)');
      SQL.Add('VALUES (:Pid, :Pnome, :Pcpf, :Ptelefone, :Pdata, :PestadoCivil, :Pendereco)');
      ParamByName('Pid').AsInteger := StrToInt(AId);
      ParamByName('Pnome').AsString := ANome;
      ParamByName('Pcpf').AsString := ACpf;
      ParamByName('Ptelefone').AsString := ATel;
      ParamByName('Pdata').AsDate := StrToDate(AData);
      ParamByName('PestadoCivil').AsString := AEstado;
      ParamByName('Pendereco').AsString := AEndereco;
      ExecSQL;
    end;

    Controller.Notificar;
  except
    on E: Exception do
    begin
      raise Exception.Create('Falha ao criar usuário ' + E.Message);
    end;

  end;

end;

end.
