object FormFIlter: TFormFIlter
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Filtros'
  ClientHeight = 272
  ClientWidth = 340
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 239
    Width = 340
    Height = 33
    Align = alBottom
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    object btnClose: TButton
      Left = 254
      Top = 3
      Width = 75
      Height = 25
      Caption = '&Cancelar'
      TabOrder = 0
      OnClick = btnCloseClick
    end
    object btnAction: TButton
      Left = 174
      Top = 3
      Width = 75
      Height = 25
      Caption = '&Filtrar'
      TabOrder = 1
      OnClick = btnActionClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 156
    Width = 340
    Height = 83
    Align = alBottom
    Caption = 'Ordem'
    TabOrder = 1
    object Label2: TLabel
      Left = 11
      Top = 24
      Width = 63
      Height = 13
      Caption = 'Ordenar Por:'
    end
    object Label3: TLabel
      Left = 184
      Top = 21
      Width = 78
      Height = 13
      Caption = 'Direcionamento:'
    end
    object cmbOrder: TComboBox
      Left = 11
      Top = 40
      Width = 145
      Height = 21
      Style = csDropDownList
      TabOrder = 0
    end
    object cmbDirect: TComboBox
      Left = 184
      Top = 40
      Width = 145
      Height = 21
      Style = csDropDownList
      TabOrder = 1
      Items.Strings = (
        'Ascendente'
        'Descendente')
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 340
    Height = 154
    Align = alTop
    Caption = 'Filtro'
    TabOrder = 2
    object Label1: TLabel
      Left = 11
      Top = 32
      Width = 100
      Height = 13
      Caption = 'Selecione um campo:'
    end
    object cmbCampos: TComboBox
      Left = 11
      Top = 51
      Width = 145
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = cmbCamposChange
    end
    object PFilter: TPanel
      Left = 11
      Top = 78
      Width = 318
      Height = 59
      Caption = 'PFilter'
      ShowCaption = False
      TabOrder = 1
    end
  end
end
