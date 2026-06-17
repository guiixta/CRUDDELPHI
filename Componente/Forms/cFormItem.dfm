object FormItem: TFormItem
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = '- Items'
  ClientHeight = 258
  ClientWidth = 330
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
    Left = 11
    Top = 29
    Width = 15
    Height = 13
    Caption = 'ID:'
  end
  object LNome: TLabel
    Left = 11
    Top = 82
    Width = 31
    Height = 13
    Caption = 'Nome:'
  end
  object LValor: TLabel
    Left = 193
    Top = 82
    Width = 28
    Height = 13
    Caption = 'Valor:'
  end
  object DDescricao: TLabel
    Left = 14
    Top = 134
    Width = 50
    Height = 13
    Caption = 'Descri'#231#227'o:'
  end
  object Panel1: TPanel
    Left = 0
    Top = 217
    Width = 330
    Height = 41
    Align = alBottom
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 4
    ExplicitLeft = -10
    ExplicitTop = 212
    ExplicitWidth = 514
    object btnAction: TButton
      Left = 165
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Caption'
      TabOrder = 0
      OnClick = btnActionClick
    end
    object btnClose: TButton
      Left = 246
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Cancelar'
      TabOrder = 1
      OnClick = btnCloseClick
    end
  end
  object EId: TEdit
    Left = 11
    Top = 48
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'EId'
    OnEnter = EIdEnter
    OnExit = EIdExit
  end
  object ENome: TEdit
    Left = 11
    Top = 101
    Width = 167
    Height = 21
    TabOrder = 1
  end
  object MDesc: TMemo
    Left = 11
    Top = 152
    Width = 304
    Height = 56
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object EValor: TMaskEdit
    Left = 194
    Top = 98
    Width = 121
    Height = 21
    TabOrder = 2
    Text = ''
  end
end
