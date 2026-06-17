unit uInterfaces;

interface

type

  IObservador = interface
    ['{EC67B863-FA16-44B2-A65C-AE74B499BFE6}']
    procedure Atualizar;
  end;

  ISubject = interface
    ['{0C0526DF-9961-4D69-A836-2D52E047130D}']
    procedure AddObserver(Observer: IObservador);
    procedure RemObserver(Observer: IObservador);
    procedure Notificar;
  end;

  TItemPedidos = record
    IdPedido: string;
    IdItem: string;
    Sequencial: string;
    Nome: string;
    Valor: string;
    Quantidade: string;
  end;

  TTypeInputs = (tiTexto, tiNumber, tiLivre, tiCpf, tiTelefone, tiDinheiro);

  TTypeFilters = (tfEspecifico, tfRange, tfValue, tfSelect, tfTable);

implementation

end.
