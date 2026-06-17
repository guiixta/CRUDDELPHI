unit uTFPBase;

interface

uses
  System.Classes, Vcl.Forms;

type
  TOnFilterChange = procedure(Sender: TObject) of object;

  TFPBase = interface
    ['{9C9FB9E4-C55F-4527-8BCF-BA0B16C4D2D0}']
    function getConsulta: string;
    procedure SetOnChange(AEvent: TOnFilterChange);
  end;

implementation

end.
