unit uFrameBase;

interface

uses
  System.Classes, Vcl.Forms, uInterfaces, Data.DB;

type

  TFrameBaseClass = class of TFrameBase;

  TFrameBase = class(TFrame, IObservador)
  public
    procedure Iniciar(ADataSource: TDataSource); virtual; abstract;
    procedure Atualizar; virtual; abstract;
  end;

implementation

end.

