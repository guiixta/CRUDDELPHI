unit cPainelGeneric;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Controller, Vcl.ExtCtrls, fDBGrid, Vcl.StdCtrls, Vcl.Buttons, FrameCount,
  uFrameBase, uInterfaces;

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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
  Controller.FilterShow(Ctipo,
    procedure
    begin
      if not Assigned(btnRemFilter) then
        exit;


      if Controller.getIsFilter then
        btnRemFilter.Visible := true
      else
        btnRemFilter.Visible := false;

    end);

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
  Close;
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

procedure TPainelGeneric.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Obs: IObservador;
begin

  if (GridPanel.ControlCount > 0) and
    (Supports(GridPanel.Controls[0], IObservador, Obs)) then
    Controller.RemObserver(Obs);

  if (CountPanel.ControlCount > 0) and
    (Supports(CountPanel.Controls[0], IObservador, Obs)) then
    Controller.RemObserver(Obs);

  Action := caFree;
end;

procedure TPainelGeneric.MostrarPainel(tipo: string);
begin

  Self.Caption := Format('Painel - %s', [tipo]);
  Controller.initGrid(tipo);
  btnRemFilter.Visible := false;
  Controller.Notificar;
  Self.Show;
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
