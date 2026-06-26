unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

type
  TMainPainel = class(TForm)
    MainMenu1: TMainMenu;
    Ser1: TMenuItem;
    Usuarios1: TMenuItem;
    Items1: TMenuItem;
    Pedidos1: TMenuItem;
    Image1: TImage;
    procedure Usuarios1Click(Sender: TObject);
    procedure Items1Click(Sender: TObject);
    procedure Pedidos1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainPainel: TMainPainel;

implementation

{$R *.dfm}

uses
  cPainelGeneric;

procedure TMainPainel.Items1Click(Sender: TObject);
var
  Painel: TPainelGeneric;
begin
  Painel := TPainelGeneric.Create(self, 'itens');
  Painel.MostrarPainel('Itens');
end;

procedure TMainPainel.Pedidos1Click(Sender: TObject);
var
  Painel: TPainelGeneric;
begin
  Painel := TPainelGeneric.Create(self, 'pedidos');
  Painel.MostrarPainel('Pedidos');
end;

procedure TMainPainel.Usuarios1Click(Sender: TObject);
var
  Painel: TPainelGeneric;
begin
  Painel := TPainelGeneric.Create(self, 'usuarios');
  Painel.MostrarPainel('Usuário');
end;

end.
