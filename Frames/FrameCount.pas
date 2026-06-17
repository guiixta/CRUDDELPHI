unit FrameCount;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB,
  uInterfaces, uFrameBase;

type
  TFrameCT = class(TFrameBase)
    Label1: TLabel;
    LabelCount: TLabel;
  private
    { Private declarations }
  var
    FixDataSet: TDataSource;
  public
    { Public declarations }
    procedure Iniciar(ADataSource: TDataSource); override;

    procedure Atualizar; override;
  end;

implementation

{$R *.dfm}
{ TFrame1 }

procedure TFrameCT.Atualizar;
begin
  Iniciar(FixDataSet);
end;

procedure TFrameCT.Iniciar(ADataSource: TDataSource);
begin

  if Assigned(ADataSource) then
  begin
    LabelCount.Caption := IntToStr(ADataSource.Dataset.RecordCount);

    FixDataSet := ADataSource;
  end
  else
    LabelCount.Caption := '-';

end;

end.
