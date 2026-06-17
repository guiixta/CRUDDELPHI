unit cFormItem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.ExtCtrls,
  cEditGeneric, cEditMaskGeneric, ItemController, Vcl.Mask, System.UITypes;

type
  TEdit = class(TEditGeneric);
  TMaskEdit = class(TEditMaskGeneric);

  TFormItem = class(TForm)
    LID: TLabel;
    Panel1: TPanel;
    btnAction: TButton;
    btnClose: TButton;
    EId: TEdit;
    ENome: TEdit;
    LNome: TLabel;
    LValor: TLabel;
    MDesc: TMemo;
    DDescricao: TLabel;
    EValor: TMaskEdit;
    procedure EIdEnter(Sender: TObject);
    procedure EIdExit(Sender: TObject);
    procedure btnActionClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  var
    FAction: string;
    DadosForm: TDataSource;
    executando: boolean;
    IController: TItemController;

    procedure HabilitarGeral;
    procedure DesabilitarGeral;
  public
    { Public declarations }
    procedure MostrarForm(Action: string; Dados: TDataSource);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  FormItem: TFormItem;

implementation

{$R *.dfm}
{ TForm1 }

procedure TFormItem.btnActionClick(Sender: TObject);
var
  EditControl: TComponent;
begin

  if executando then
    exit;

  executando := true;

  if FAction = 'Deletar' then
  begin
    IController.Deletar(EId.Text);

    ShowMessage('Item Deletado com sucesso!');
  end
  else
  begin

    for EditControl in Self do
    begin

      if EditControl.Name = 'EId' then
        Continue;

      if EditControl is TEditGeneric then
        TEditGeneric(EditControl).ValidarValor
      else if EditControl is TEditMaskGeneric then
        TEditMaskGeneric(EditControl).ValidarValor;

    end;

    if FAction = 'Incluir' then
    begin

      IController.Inserir(EId.Text, ENome.Text, EValor.Text, MDesc.Text);

      ShowMessage('Item Criado com sucesso!');

      { Limpando os campos }
      for EditControl in Self do
      begin

        if EditControl.Name = 'EId' then
          Continue;

        if EditControl is TEditGeneric then
          TEditGeneric(EditControl).Text := ''
        else if EditControl is TEditMaskGeneric then
          TEditMaskGeneric(EditControl).Text := ''
        else if EditControl is TMemo then
          TMemo(EditControl).Text := '';

      end;

      EId.Enabled := true;

      if EId.CanFocus then
        EId.SetFocus;

      DesabilitarGeral;

    end;

    if FAction = 'Alterar' then
    begin
      IController.Atualizar(EId.Text, ENome.Text, EValor.Text, MDesc.Text);

      ShowMessage('Item Alterado com sucesso!');

      Self.Close;
    end;

  end;

  executando := false;
end;

procedure TFormItem.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

constructor TFormItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  IController := TItemController.Create;

  ENome.TipoKey := tcLetras;
  EValor.TipoMask := tmDinheiro;


  DesabilitarGeral;

end;

procedure TFormItem.DesabilitarGeral;
var
  EditControl: TComponent;
begin
  for EditControl in Self do
  begin

    if EditControl.Name = 'EId' then
      Continue;

    if EditControl is TEditGeneric then
      TEditGeneric(EditControl).Desabilitar
    else if EditControl is TEditMaskGeneric then
      TEditMaskGeneric(EditControl).Desabilitar
    else if EditControl is TMemo then
      TMemo(EditControl).Enabled := false;
  end;
end;

destructor TFormItem.Destroy;
begin

  IController.Free;

  inherited Destroy;
end;

procedure TFormItem.EIdEnter(Sender: TObject);
begin
  if FAction = 'Incluir' then
  begin
    DadosForm.DataSet.Last;
    EId.Text := IntToStr(DadosForm.DataSet.FieldByName('ID').AsInteger + 1);
  end
  else
  begin
    EId.Text := IntToStr(DadosForm.DataSet.FieldByName('ID').AsInteger);
  end;

end;

procedure TFormItem.EIdExit(Sender: TObject);
begin
  if (Screen.ActiveControl <> nil) and (Screen.ActiveControl.Name = 'btnClose')
  then
  begin
    inherited DoExit;
    exit;
  end;

  if FAction = 'Incluir' then
  begin

    if DadosForm.DataSet.Locate('ID', StrToInt(EId.Text), []) then
    begin

      if EId.CanFocus then
        EId.SetFocus;

      raise Exception.Create('ID já em uso');
    end;

  end
  else
  begin

    if not DadosForm.DataSet.Locate('ID', StrToInt(EId.Text), []) then
    begin
      if EId.CanFocus then
        EId.SetFocus;

      raise Exception.Create('Item não encontrado');
    end;

    if FAction = 'Alterar' then
    begin

      with DadosForm.DataSet do
      begin
        ENome.Text := FieldByName('NOME').AsString;
        EValor.Text := FieldByName('VALOR').AsString;
        MDesc.Text := FieldByName('DESCRICAO').AsString;
      end;

    end;

    if FAction = 'Deletar' then
    begin

      if MessageDlg('Tem certeza? Essa ação não pode ser desfeita',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        btnAction.Click;
      end;

      Self.Close;
    end;

  end;

  HabilitarGeral;

  if ENome.CanFocus then
    ENome.SetFocus;

  EId.Desabilitar;

end;

procedure TFormItem.HabilitarGeral;
var
  EditControl: TComponent;
begin
  for EditControl in Self do
  begin

    if EditControl.Name = 'EId' then
      Continue;

    if EditControl is TEditGeneric then
      TEditGeneric(EditControl).Habilitar
    else if EditControl is TEditMaskGeneric then
      TEditMaskGeneric(EditControl).Habilitar
    else if EditControl is TMemo then
      TMemo(EditControl).Enabled := true;
  end;
end;

procedure TFormItem.MostrarForm(Action: string; Dados: TDataSource);
begin
  FAction := Action;
  DadosForm := Dados;

  Self.Caption := Action + Self.Caption;

  btnAction.Caption := '&' + Action;

  Self.ActiveControl := EId;

  Self.ShowModal;

  Self.ActiveControl := nil;

end;

end.
