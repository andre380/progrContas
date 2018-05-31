unit ufraListaClientes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, Buttons, DBGrids, Dialogs,
  sqldb, db;

type

  { TfraLisClientes }

  TfraLisClientes = class(TFrame)
  private
    Fqry: TSQLQuery;
    procedure Setqry(AValue: TSQLQuery);
  published
    btnLimpaFiltro: TSpeedButton;
    DBGrid1: TDBGrid;
    dtsGrid: TDataSource;
    edtFiltro: TLabeledEdit;
    procedure btnLimpaFiltroClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure edtFiltroChange(Sender: TObject);
    property qry :TSQLQuery read Fqry write Setqry;
  private
    { private declarations }
  public
    { public declarations }

  end;

implementation

{$R *.lfm}

{ TfraLisClientes }

procedure TfraLisClientes.Setqry(AValue: TSQLQuery);
begin
  if Fqry=AValue then Exit;
  dtsGrid.DataSet:= AValue;
  Fqry:=AValue;
end;

procedure TfraLisClientes.btnLimpaFiltroClick(Sender: TObject);
begin
  edtFiltro.Clear;
end;

procedure TfraLisClientes.DBGrid1DblClick(Sender: TObject);
begin
  //
end;

procedure TfraLisClientes.edtFiltroChange(Sender: TObject);
begin
  if Assigned(qry) then
  begin

  end
  else
  ShowMessage('Erro: qry não definida');
end;

end.

