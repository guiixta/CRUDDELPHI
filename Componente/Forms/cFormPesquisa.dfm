object FormPesquisa: TFormPesquisa
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = ' - Pesquisar'
  ClientHeight = 336
  ClientWidth = 436
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 27
    Width = 100
    Height = 13
    Caption = 'Selecione um campo:'
  end
  object Panel1: TPanel
    Left = 0
    Top = 295
    Width = 436
    Height = 41
    Align = alBottom
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    object btnAction: TButton
      Left = 267
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Salvar'
      TabOrder = 0
      OnClick = btnActionClick
    end
    object btnClose: TButton
      Left = 350
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Cancelar'
      TabOrder = 1
      OnClick = btnCloseClick
    end
  end
  object GridPesquisa: TDBGrid
    Left = 8
    Top = 144
    Width = 417
    Height = 120
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = GridPesquisaDblClick
  end
  object cmbCampos: TComboBox
    Left = 8
    Top = 43
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 2
    OnChange = cmbCamposChange
  end
  object PFilter: TPanel
    Left = 8
    Top = 70
    Width = 417
    Height = 54
    Caption = 'PFilter'
    ShowCaption = False
    TabOrder = 3
  end
end
