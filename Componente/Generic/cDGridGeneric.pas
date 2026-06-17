unit cDGridGeneric;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Dialogs, Vcl.Grids,
  Vcl.DBGrids,
  System.Types, DB, SimpleDS, SqlExpr, DBClient, System.StrUtils, Vcl.Graphics,
  System.RegularExpressions, System.UITypes, Winapi.Windows, Winapi.Messages;

type
  TDBGridType = class(TDBGrid)
  private
    { Private declarations }

  protected
    { Protected declarations }
    procedure TitleClick(Column: TColumn); override;
    procedure DrawColumnCell(const Rect: TRect; DataCol: Integer;
      Column: TColumn; State: TGridDrawState); override;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
  end;

implementation

{ TDBGridType }

uses
  Controller;

var
  order: string = 'ASC';

procedure TDBGridType.TitleClick(Column: TColumn);
var
  Command, OldSql, NomeColuna, CNomeVisual, NovaOrdenacao: string;
  NomeVisuais: TStringList;
  GSimpleData: TSimpleDataSet;
  i: Integer;
  Controller: TController;
begin
  inherited TitleClick(Column);

  Controller := TController.getInstancia;

  if Self.DataSource = nil then
  begin
    exit;
  end;

  Self.DataSource.DataSet.DisableControls;
  Self.Parent.Perform(WM_SETREDRAW, 0, 0);
  NomeVisuais := TStringList.Create;
  try
    NomeColuna := Column.FieldName;


    for i := 0 to Pred(Self.Columns.Count) do
    begin
      NomeVisuais.Add(Self.Columns[i].Title.Caption);
    end;

    if Self.DataSource.DataSet is TSimpleDataSet then
    begin

      GSimpleData := TSimpleDataSet(Self.DataSource.DataSet);

      GSimpleData.Active := false;

      OldSql := GSimpleData.DataSet.CommandText;

      if order = 'ASC' then
        order := 'DESC'
      else
        order := 'ASC';

      NovaOrdenacao := '$1 ' + NomeColuna + ' ' + order;

      Command := TRegEx.Replace(OldSql,
        '(\bORDER\s+BY\s+)[a-zA-Z0-9_\.]+(\s+(?:ASC|DESC)\b)?', NovaOrdenacao,
        [roIgnoreCase]);

      GSimpleData.DataSet.CommandText := Command;
      GSimpleData.Active := true;

      for CNomeVisual in NomeVisuais do
      begin
        Self.Columns[NomeVisuais.IndexOf(CNomeVisual)].Title.Caption :=
          CNomeVisual;
      end;



    end;
  finally
    Self.Parent.Perform(WM_SETREDRAW, 1, 0);
    Self.Invalidate; // Força uma única pintura final limpa
    Self.DataSource.DataSet.EnableControls;
    Controller.Notificar;
    NomeVisuais.Free;
  end;
end;

constructor TDBGridType.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Self.DoubleBuffered := true;

  Self.Options := Self.Options - [dgIndicator];
  Self.Options := Self.Options - [dgEditing];

  Self.DrawingStyle := gdsGradient;
  Self.GradientStartColor := $00D6D6D6;
  Self.GradientEndColor := clWhite;
end;

procedure TDBGridType.DrawColumnCell(const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
var
  i: Integer;
begin
  inherited DrawColumnCell(Rect, DataCol, Column, State);

  { Centralizando titles e deixando primeira letra maiuscula }

  for i := 0 to Pred(Self.Columns.Count) do
  begin
    Self.Columns[i].Title.Alignment := taCenter;
    if (Self.Columns[i].Title.Caption <> '') and
      (CharInSet(Self.Columns[i].Title.Caption[1], ['A' .. 'Z'])) then
    begin
      Self.Columns[i].Title.Caption := Copy(Self.Columns[i].Title.Caption, 1, 1)
        + LowerCase(Copy(Self.Columns[i].Title.Caption, 2,
        Length(Self.Columns[i].Title.Caption)));
    end;
  end;

  { Zebramento do DbGrid }
  if gdSelected in State then
  begin
    Self.Canvas.Brush.Color := clHighlight;
    Self.Canvas.Font.Color := clHighlightText;
  end
  else
  begin
    if Odd(Self.DataSource.DataSet.RecNo) then
      Self.Canvas.Brush.Color := $D8D1D8
    else
      Self.Canvas.Brush.Color := clWhite;

    Self.Canvas.Font.Color := clBlack;
  end;

  Self.Canvas.FillRect(Rect);

  Self.DefaultDrawColumnCell(Rect, DataCol, Column, State);

end;

end.
