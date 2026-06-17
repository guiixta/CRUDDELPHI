object FPValue: TFPValue
  Left = 0
  Top = 0
  Width = 222
  Height = 48
  TabOrder = 0
  object PValor: TPanel
    Left = 0
    Top = 0
    Width = 222
    Height = 48
    Align = alClient
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    object Label1: TLabel
      Left = 91
      Top = 3
      Width = 31
      Height = 13
      Caption = 'Label1'
    end
    object cmbValue: TComboBox
      Left = 4
      Top = 19
      Width = 81
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'Maior que'
      Items.Strings = (
        'Maior que'
        'Menor que'
        'Igual a')
    end
    object PEditMolde: TPanel
      Left = 91
      Top = 19
      Width = 104
      Height = 21
      Caption = 'PEditMolde'
      TabOrder = 1
    end
  end
end
