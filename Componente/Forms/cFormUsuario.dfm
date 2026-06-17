object FormUsuario: TFormUsuario
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = ' - Usu'#225'rio'
  ClientHeight = 253
  ClientWidth = 515
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object LID: TLabel
    Left = 18
    Top = 40
    Width = 15
    Height = 13
    Caption = 'ID:'
  end
  object LName: TLabel
    Left = 18
    Top = 102
    Width = 31
    Height = 13
    Caption = 'Nome:'
  end
  object LData: TLabel
    Left = 18
    Top = 154
    Width = 100
    Height = 13
    Caption = 'Data de Nascimento:'
  end
  object LEstado: TLabel
    Left = 159
    Top = 154
    Width = 59
    Height = 13
    Caption = 'Estado Civil:'
  end
  object LEndereco: TLabel
    Left = 320
    Top = 154
    Width = 49
    Height = 13
    Caption = 'Endere'#231'o:'
  end
  object LCPF: TLabel
    Left = 159
    Top = 102
    Width = 23
    Height = 13
    Caption = 'CPF:'
  end
  object LTelefone: TLabel
    Left = 320
    Top = 102
    Width = 46
    Height = 13
    Caption = 'Telefone:'
  end
  object Panel1: TPanel
    Left = 0
    Top = 212
    Width = 515
    Height = 41
    Align = alBottom
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 7
    object btnAction: TButton
      Left = 344
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Caption'
      TabOrder = 0
      OnClick = btnActionClick
    end
    object btnClose: TButton
      Left = 425
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Cancelar'
      TabOrder = 1
      OnClick = btnCloseClick
    end
  end
  object CEstado: TComboBox
    Left = 159
    Top = 173
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 5
    OnKeyPress = CEstadoKeyPress
    Items.Strings = (
      '01 - Solteiro(a)'
      '02 - Casado(a)'
      '03 - Divorciado(a)'
      '04 - Vi'#250'vo(a)'
      '05 - Separado(a)')
  end
  object ECpf: EditCNPJ
    Left = 159
    Top = 121
    Width = 145
    Height = 21
    Cursor = crIBeam
    BorderStyle = bsNone
    EditMask = '000\.000\.000\-00;1;_'
    MaxLength = 14
    TabOrder = 2
    Text = '   .   .   -  '
    CPF = True
  end
  object EId: TEdit
    Left = 18
    Top = 59
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'EId'
    OnEnter = EIdEnter
    OnExit = EIdExit
  end
  object ENome: TEdit
    Left = 18
    Top = 121
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object EEndereco: TEdit
    Left = 320
    Top = 173
    Width = 121
    Height = 21
    TabOrder = 6
    OnKeyPress = EEnderecoKeyPress
  end
  object EData: TMaskEdit
    Left = 18
    Top = 173
    Width = 121
    Height = 21
    TabOrder = 4
    Text = ''
  end
  object ETelefone: TMaskEdit
    Left = 320
    Top = 121
    Width = 121
    Height = 21
    TabOrder = 3
    Text = ''
  end
end
