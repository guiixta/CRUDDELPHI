unit PTable;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTFPBase, Vcl.StdCtrls,
  Vcl.Buttons;

type
  TFPTable = class(TFrame, TFPBase)
    EId: TEdit;
    LID: TLabel;
    EView: TEdit;
    btnPesquisa: TBitBtn;
    LView: TLabel;
    procedure btnPesquisaClick(Sender: TObject);
    procedure EIdKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Iniciar(ACampoSearch, ACampoView, ATable: string);
    function getConsulta: string;
    procedure SetOnChange(AEvent: TOnFilterChange);
  end;

implementation

{$R *.dfm}

uses
  Controller, DM;

{ TFrame1 }

var
  tableCurrent: string;

procedure TFPTable.btnPesquisaClick(Sender: TObject);
begin

  TController.GetInstancia.SearchShow(tableCurrent);

  if not Data.IndirectConsult.Active then
    exit;

  if not Data.IndirectConsult.RecordCount > 0 then
    exit;

  EId.Text := Data.IndirectConsult.FieldByName(LID.Caption).AsString;
  EView.Text := Data.IndirectConsult.FieldByName(LView.Caption).AsString;

end;

procedure TFPTable.EIdKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    TController.GetInstancia.Pesquisar(tableCurrent, LID.Caption, getConsulta);

    if not Data.IndirectConsult.Active then
      exit;

    if not Data.IndirectConsult.RecordCount > 0 then
      exit;

    EView.Text := Data.IndirectConsult.FieldByName(LView.Caption).AsString;
  end;
end;

function TFPTable.getConsulta: string;
begin

  if EId.Text = '' then
    raise Exception.Create('Não pode ser vazio');

  Result := Format('WHERE %s = %s', [LID.Caption, EId.Text]);

end;

procedure TFPTable.Iniciar(ACampoSearch, ACampoView, ATable: string);
begin

  LID.Caption := ACampoSearch;
  LView.Caption := ACampoView;

  tableCurrent := ATable;

end;

procedure TFPTable.SetOnChange(AEvent: TOnFilterChange);
begin
  EId.OnExit := AEvent;
end;

end.
