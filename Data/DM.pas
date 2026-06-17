unit DM;

interface

uses
  System.SysUtils, System.Classes, Data.FMTBcd, Datasnap.DBClient, SimpleDS,
  Data.DB, Data.SqlExpr, Data.DBXFirebird, Vcl.Dialogs;

type
  TData = class(TDataModule)
    ConnSQL: TSQLConnection;
    UsuarioSource: TDataSource;
    Query: TSQLQuery;
    UserSDataSet: TSimpleDataSet;
    ItemSource: TDataSource;
    ItemSDataSet: TSimpleDataSet;
    PedidosSource: TDataSource;
    PedidoSDataSet: TSimpleDataSet;
    PedidosItems: TDataSource;
    PedidosItemSDataSet: TSimpleDataSet;
    IndirectConsult: TSimpleDataSet;
    PedidosItemLocal: TClientDataSet;
    PesquisaSource: TDataSource;
    procedure DataModuleCreate(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
    procedure FormatarValorGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    destructor Destroy; override;
  end;

var
  Data: TData;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

destructor TData.Destroy;
begin
  PedidosItemLocal.Free;
  inherited Destroy;
end;

procedure TData.FormatarValorGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := FormatFloat('#,##0.00', Sender.AsInteger / 100.0);
end;

procedure TData.DataModuleCreate(Sender: TObject);
begin
  try
    with ConnSQL do
    begin
      ConnectionName := 'FBConnection';
      DriverName := 'Firebird';
      Params.Values['DataBase'] := ExtractFilePath(ParamStr(0)) +
        '..\..\Data\DB.FDB';
      Params.Values['User_Name'] := 'SYSDBA';
      Params.Values['Password'] := 'masterkey';
      LoginPrompt := false;
      Connected := true;
    end;

    UserSDataSet.Connection := ConnSQL;
    ItemSDataSet.Connection := ConnSQL;
    PedidoSDataSet.Connection := ConnSQL;
    PedidosItemSDataSet.Connection := ConnSQL;
    IndirectConsult.Connection := ConnSQL;

    Query.SQLConnection := ConnSQL;

    UserSDataSet.DataSet.CommandText :=
      'SELECT ID, NOME, CPF, TELEFONE, DATA_NASCIMENTO, ESTADO_CIVIL, ENDERECO FROM USUARIOS ORDER BY ID ASC';

    UsuarioSource.DataSet := UserSDataSet;

    UserSDataSet.FetchOnDemand := true;
    UserSDataSet.Open;

    ItemSDataSet.DataSet.CommandText := 'SELECT * FROM ITENS ORDER BY ID ASC';
    ItemSource.DataSet := ItemSDataSet;

    ItemSDataSet.FetchOnDemand := true;
    ItemSDataSet.Open;
    ItemSDataSet.FieldByName('VALOR').OnGetText := FormatarValorGetText;

    PedidoSDataSet.DataSet.CommandText :=
      Format('SELECT p.ID, u.NOME, p.VALOR, p.DATETIME, p.ID_USUARIO, ' +
      ' (SELECT COUNT(*) FROM PEDIDOS_ITENS pi WHERE pi.ID_PEDIDO = p.ID) AS QUANTIDADE '
      + ' FROM PEDIDOS p ' + ' INNER JOIN USUARIOS u ON u.ID = p.ID_USUARIO ' +
      ' ORDER BY p.ID ASC', []);

    PedidosSource.DataSet := PedidoSDataSet;

    PedidoSDataSet.FetchOnDemand := true;
    PedidoSDataSet.Open;

    PedidoSDataSet.FieldByName('VALOR').OnGetText := FormatarValorGetText;

    UsuarioSource.Enabled := true;
    ItemSource.Enabled := true;
    PedidosSource.Enabled := true;

    if not PedidosItemLocal.Active then
    begin
      with PedidosItemLocal do
      begin
        Close;
        FieldDefs.Clear;

        FieldDefs.Add('ID_PEDIDO', ftInteger);
        FieldDefs.Add('ID_ITEM', ftInteger);
        FieldDefs.Add('SEQUENCIAL', ftInteger);
        FieldDefs.Add('NOME', ftString, 29);
        FieldDefs.Add('QUANTIDADE', ftInteger);
        FieldDefs.Add('VALOR', ftString, 25);

        CreateDataSet;
      end;
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create('Error na conexão ' + E.Message);
      abort;
    end;

  end;

end;

end.
