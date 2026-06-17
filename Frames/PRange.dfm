object FPRange: TFPRange
  Left = 0
  Top = 0
  Width = 315
  Height = 57
  TabOrder = 0
  object PRange: TPanel
    Left = 0
    Top = 0
    Width = 315
    Height = 57
    Align = alClient
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    object LabelRange: TLabel
      Left = 180
      Top = 21
      Width = 6
      Height = 13
      Caption = 'a'
    end
    object Label1: TLabel
      Left = 84
      Top = 3
      Width = 25
      Height = 13
      Caption = 'Label'
    end
    object Label2: TLabel
      Left = 192
      Top = 3
      Width = 25
      Height = 13
      Caption = 'Label'
    end
    object EditRange1: TEdit
      Left = 84
      Top = 18
      Width = 88
      Height = 21
      TabOrder = 0
    end
    object EditRange2: TEdit
      Left = 192
      Top = 18
      Width = 88
      Height = 21
      TabOrder = 1
    end
    object comboRange: TComboBox
      Left = 8
      Top = 18
      Width = 66
      Height = 21
      Style = csDropDownList
      TabOrder = 2
      OnChange = comboRangeChange
      Items.Strings = (
        'Entre'
        'Especifico')
    end
  end
end
