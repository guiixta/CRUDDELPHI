unit cFormUsuario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cEditGeneric, Vcl.ExtCtrls,
  Vcl.StdCtrls, EditCNPJFile,
  Vcl.Mask, cEditMaskGeneric, Data.DB, UserController, System.UITypes;

type

  TEdit = class(TEditGeneric);
  TMaskEdit = class(TEditMaskGeneric);

  TFormUsuario = class(TForm)
    Panel1: TPanel;
    LID: TLabel;
    LName: TLabel;
    LData: TLabel;
    LEstado: TLabel;
    CEstado: TComboBox;
    LEndereco: TLabel;
    LCPF: TLabel;
    ECpf: EditCNPJ;
    LTelefone: TLabel;
    btnAction: TButton;
    btnClose: TButton;
    EId: TEdit;
    ENome: TEdit;
    EEndereco: TEdit;
    EData: TMaskEdit;
    ETelefone: TMaskEdit;
    procedure EIdEnter(Sender: TObject);
    procedure EIdExit(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnActionClick(Sender: TObject);
    procedure EEnderecoKeyPress(Sender: TObject; var Key: Char);
    procedure CEstadoKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }

    procedure HabilitarGeral;
    procedure DesabilitarGeral;

  var
    executando: boolean;
    UController: TUserController;
    FAction: String;
    DadosForm: TDataSource;
  public
    { Public declarations }
    procedure MostrarForm(Action: string; Dados: TDataSource);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  FormUsuario: TFormUsuario;

implementation

{$R *.dfm}
{ TFormUsuario }

procedure TFormUsuario.btnActionClick(Sender: TObject);
var
  EditControl: TComponent;
  EstadoC: string;
begin

  if executando then
    exit;

  executando := true;

  if FAction = 'Deletar' then
  begin
    UController.Deletar(EId.Text);

    ShowMessage('Usuário Deletado com sucesso!');
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
        TEditMaskGeneric(EditControl).ValidarValor
      else if EditControl is EditCNPJ then
        EditCNPJ(EditControl).ValidarValor;

    end;

    if CEstado.ItemIndex = -1 then
    begin
      if CEstado.CanFocus then
        CEstado.SetFocus;

      raise Exception.Create('Estado não pode ficar vazio');
    end;

    EstadoC := CEstado.Items[CEstado.ItemIndex];
    EstadoC := EstadoC[1] + EstadoC[2];

    if FAction = 'Incluir' then
    begin

      UController.Inserir(EId.Text, ENome.Text, ECpf.Text, ETelefone.Text,
        EstadoC, EEndereco.Text, EData.Text);

      ShowMessage('Usuário Criado com sucesso!');

      { Limpando os campos }
      for EditControl in Self do
      begin

        if EditControl.Name = 'EId' then
          Continue;

        if EditControl is TEditGeneric then
          TEditGeneric(EditControl).Text := ''
        else if EditControl is TEditMaskGeneric then
          TEditMaskGeneric(EditControl).Text := ''
        else if EditControl is EditCNPJ then
          EditCNPJ(EditControl).Text := '';

      end;

      EId.Enabled := true;

      if EId.CanFocus then
        EId.SetFocus;

      DesabilitarGeral;

    end;

    if FAction = 'Alterar' then
    begin
      UController.Atualizar(EId.Text, ENome.Text, ECpf.Text, ETelefone.Text,
        EData.Text, EstadoC, EEndereco.Text);

      ShowMessage('Usuário Alterado com sucesso!');

      Self.Close;
    end;

  end;

  executando := false;

end;

procedure TFormUsuario.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormUsuario.CEstadoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    EEndereco.SetFocus;
end;

constructor TFormUsuario.Create(AOwner: TComponent);

begin
  inherited Create(AOwner);

  UController := TUserController.Create;

end;

procedure TFormUsuario.DesabilitarGeral;
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
    else if EditControl is EditCNPJ then
      EditCNPJ(EditControl).Enabled := false
    else if EditControl is TComboBox then
      TComboBox(EditControl).Enabled := false
  end;
end;

destructor TFormUsuario.Destroy;
begin

  UController.Free;

  inherited Destroy;
end;

procedure TFormUsuario.EEnderecoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btnAction.Click;
  end;
end;

procedure TFormUsuario.EIdEnter(Sender: TObject);
begin

  if FAction = '' then
    exit;


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

procedure TFormUsuario.EIdExit(Sender: TObject);
begin
  { Caso for para o btnCancel para fechar }
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

      raise Exception.Create('Usuário não encontrado');
    end;

    if FAction = 'Alterar' then
    begin

      with DadosForm.DataSet do
      begin
        ENome.Text := FieldByName('NOME').AsString;
        ECpf.Text := FieldByName('CPF').AsString;
        ETelefone.Text := FieldByName('TELEFONE').AsString;
        EData.Text := FieldByName('DATA_NASCIMENTO').AsString;
        EEndereco.Text := FieldByName('ENDERECO').AsString;
        CEstado.ItemIndex := FieldByName('ESTADO_CIVIL').AsInteger - 1;
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

procedure TFormUsuario.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFormUsuario.HabilitarGeral;
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
      TEditMaskGeneric(EditControl).Habilitar;
  end;

  CEstado.Enabled := true;
  ECpf.Enabled := true;
end;

procedure TFormUsuario.MostrarForm(Action: string; Dados: TDataSource);
begin

  FAction := Action; { Determinar o comportamento do form }
  DadosForm := Dados; { Visualização geral de dados }

  Self.Caption := Action + Self.Caption;

  btnAction.Caption := '&' + Action;

  Self.ActiveControl := EId;
  EId.DoEnter;

  Self.Show;

  { Iniciar com campos adesabiltados }
  DesabilitarGeral;

  CEstado.ItemIndex := 0;

  EData.SetTipoMascara(tmData);
  ETelefone.SetTipoMascara(tmTelefone);
  ENome.TipoKey := tcLetras;

end;

end.
