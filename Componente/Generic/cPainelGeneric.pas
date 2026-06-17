unit cPainelGeneric;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Controller, Vcl.ExtCtrls, fDBGrid, Vcl.StdCtrls, Vcl.Buttons, FrameCount,
  uFrameBase;

type
  TPainelGeneric = class(TForm)
    GridPanel: TPanel;
    CountPanel: TPanel;
    btnSair: TBitBtn;
    btnInc: TBitBtn;
    btnAlter: TBitBtn;
    btnDel: TBitBtn;
    btnFilter: TBitBtn;
    btnRemFilter: TBitBtn;
    procedure btnSairClick(Sender: TObject);
    procedure btnIncClick(Sender: TObject);
    procedure btnAlterClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnFilterClick(Sender: TObject);
    procedure btnRemFilterClick(Sender: TObject);
  private
    { Private declarations }
  var
    Ctipo: string;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; tipo: string); reintroduce; overload;
    procedure MostrarPainel(tipo: string);
    procedure switchVisible;
  end;

var
  PainelGeneric: TPainelGeneric;

implementation

{$R *.dfm}
{ TForm1 }

var
  Controller: TController;

procedure TPainelGeneric.btnAlterClick(Sender: TObject);
begin
  Controller.FormShow('Alterar', Ctipo);
end;

procedure TPainelGeneric.btnDelClick(Sender: TObject);
begin
  Controller.FormShow('Deletar', Ctipo);
end;

procedure TPainelGeneric.btnFilterClick(Sender: TObject);
begin
  Controller.FilterShow;
  if Controller.getIsFilter then
    btnRemFilter.Visible := true
  else
    btnRemFilter.Visible := false;
end;

procedure TPainelGeneric.btnIncClick(Sender: TObject);
begin
  Controller.FormShow('Incluir', Ctipo);
end;

procedure TPainelGeneric.btnRemFilterClick(Sender: TObject);
begin
  Controller.initGrid(Ctipo);
  Controller.switchIsFilter;
  Controller.Notificar;

  btnRemFilter.Visible := false;
end;

procedure TPainelGeneric.btnSairClick(Sender: TObject);
begin
  Self.Close;
end;

constructor TPainelGeneric.Create(AOwner: TComponent; tipo: string);
var
  FrameDB: TFrameBase;
  FrameCT: TFrameBase;
begin
  inherited Create(AOwner);

  Ctipo := tipo;

  Controller := TController.GetInstancia;

  FrameDB := Controller.FrameGen(TFGrid, tipo);
  FrameCT := Controller.FrameGen(TFrameCT, tipo);

  Controller.Notificar;

  if Assigned(FrameDB) then
  begin
    FrameDB.Parent := GridPanel;
    FrameDB.Align := alClient;
  end;

  if Assigned(FrameCT) then
  begin
    FrameCT.Parent := CountPanel;
    FrameCT.Align := alRight;
  end;
end;

procedure TPainelGeneric.MostrarPainel(tipo: string);
begin

  Self.Caption := Format('Painel - %s', [tipo]);
  Controller.initGrid(tipo);
  btnRemFilter.Visible := false;
  Controller.Notificar;
  Self.ShowModal;
  Self.Focused;

end;

procedure TPainelGeneric.switchVisible;
begin
  if Controller.getIsFilter then
    btnRemFilter.Visible := true
  else
    btnRemFilter.Visible := false;
end;

end.
