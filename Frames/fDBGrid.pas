unit fDBGrid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cDGridGeneric, Data.DB,
  uInterfaces, Vcl.DBGrids, uFrameBase;

type
  TFGrid = class(TFrameBase)
  private
    { Private declarations }



//  protected
//    function _AddRef: Integer; stdcall;
//    function _Release: Integer; stdcall;
  public
    { Public declarations }
    GridControl: TDBGridType;

    procedure Iniciar(ADataSource: TDataSource); override;
    procedure Atualizar; override;

  end;

implementation

{$R *.dfm}
{ TFrame1 }

uses
  Controller;
//function TFGrid._AddRef: Integer;
//begin
//  Result := -1;
//end;
//
//function TFGrid._Release: Integer;
//begin
//  Result := -1;
//end;

procedure TFGrid.Iniciar(ADataSource: TDataSource);
begin
  GridControl := TDBGridType.Create(Self);

  with GridControl do
  begin
    Parent := Self;
    Align := alClient;
    DataSource := ADataSource;
  end;

  if Assigned(ADataSource.DataSet) and ADataSource.DataSet.Active then
  begin
    GridControl.Columns.State := csDefault;
  end;

end;

procedure TFGrid.Atualizar;
begin
  if Assigned(GridControl) and Assigned(GridControl.DataSource) then
  begin
    TController.GetInstancia.AjustaLayoutGrid(GridControl);
    GridControl.Update;
    GridControl.DataSource.DataSet.Refresh;
  end;
end;

end.
