program Project1;

uses
  Vcl.Forms,
  uMain in 'Views\uMain.pas' {MainPainel},
  DM in 'Data\DM.pas' {Data: TDataModule},
  uInterfaces in 'Interfaces\uInterfaces.pas',
  cDGridGeneric in 'Componente\Generic\cDGridGeneric.pas',
  fDBGrid in 'Frames\fDBGrid.pas' {FGrid: TFrame},
  cPainelGeneric in 'Componente\Generic\cPainelGeneric.pas' {PainelGeneric},
  Controller in 'Controller\Controller.pas',
  uFrameBase in 'Interfaces\uFrameBase.pas',
  cEditGeneric in 'Componente\Generic\cEditGeneric.pas',
  cFormUsuario in 'Componente\Forms\cFormUsuario.pas' {FormUsuario},
  cEditMaskGeneric in 'Componente\Generic\cEditMaskGeneric.pas',
  EditCNPJFile in 'Componente\EditCNPJFile.pas',
  UserController in 'Controller\UserController.pas',
  cFormItem in 'Componente\Forms\cFormItem.pas' {FormItem},
  ItemController in 'Controller\ItemController.pas',
  cFormPedidos in 'Componente\Forms\cFormPedidos.pas' {FormPedidos},
  PedidosController in 'Controller\PedidosController.pas',
  cFormPedidosItem in 'Componente\Forms\cFormPedidosItem.pas' {FormItensPedidos},
  PEspecifico in 'Frames\PEspecifico.pas' {FPEspecifico: TFrame},
  PRange in 'Frames\PRange.pas',
  PValue in 'Frames\PValue.pas' {FPValue: TFrame},
  PSelect in 'Frames\PSelect.pas',
  cFormFilter in 'Componente\Forms\cFormFilter.pas' {FormFIlter},
  uTFPBase in 'Interfaces\uTFPBase.pas',
  FrameCount in 'Frames\FrameCount.pas',
  cFormPesquisa in 'Componente\Forms\cFormPesquisa.pas' {FormPesquisa},
  PTable in 'Frames\PTable.pas' {FPTable: TFrame};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainPainel, MainPainel);
  Application.CreateForm(TData, Data);
  Application.CreateForm(TPainelGeneric, PainelGeneric);
  Application.CreateForm(TFormItem, FormItem);
  Application.CreateForm(TFormPedidos, FormPedidos);
  Application.CreateForm(TFormItensPedidos, FormItensPedidos);
  Application.CreateForm(TFormFIlter, FormFIlter);
  Application.CreateForm(TFormPesquisa, FormPesquisa);
  Application.Run;
end.
