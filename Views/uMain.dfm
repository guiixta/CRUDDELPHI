object MainPainel: TMainPainel
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Menu In'#237'cial'
  ClientHeight = 468
  ClientWidth = 811
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Left = 760
    Top = 8
    object Ser1: TMenuItem
      Caption = 'Paineis'
      object Usuarios1: TMenuItem
        Caption = 'Usu'#225'rios'
        OnClick = Usuarios1Click
      end
      object Items1: TMenuItem
        Caption = 'Items'
        OnClick = Items1Click
      end
      object Pedidos1: TMenuItem
        Caption = 'Pedidos'
        OnClick = Pedidos1Click
      end
    end
  end
end
