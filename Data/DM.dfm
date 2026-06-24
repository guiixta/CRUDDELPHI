object Data: TData
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 413
  Width = 464
  object ConnSQL: TSQLConnection
    Left = 42
    Top = 24
  end
  object UsuarioSource: TDataSource
    DataSet = UserSDataSet
    Left = 171
    Top = 112
  end
  object Query: TSQLQuery
    Params = <>
    Left = 88
    Top = 24
  end
  object UserSDataSet: TSimpleDataSet
    Aggregates = <>
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    Params = <>
    Left = 90
    Top = 113
  end
  object ItemSource: TDataSource
    DataSet = ItemSDataSet
    Left = 171
    Top = 168
  end
  object ItemSDataSet: TSimpleDataSet
    Aggregates = <>
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    Params = <>
    Left = 90
    Top = 169
  end
  object PedidosSource: TDataSource
    DataSet = PedidoSDataSet
    Left = 171
    Top = 233
  end
  object PedidoSDataSet: TSimpleDataSet
    Aggregates = <>
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    Params = <>
    Left = 90
    Top = 225
  end
  object PedidosItems: TDataSource
    DataSet = PedidosItemSDataSet
    Left = 187
    Top = 288
  end
  object PedidosItemSDataSet: TSimpleDataSet
    Aggregates = <>
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    Params = <>
    Left = 90
    Top = 281
  end
  object IndirectConsult: TSimpleDataSet
    Aggregates = <>
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    Params = <>
    Left = 258
    Top = 113
  end
  object PedidosItemLocal: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 304
    Top = 312
  end
  object PesquisaSource: TDataSource
    Left = 347
    Top = 112
  end
end
