unit ufraListaClientes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, Buttons, DBGrids, Dialogs,
  sqldb, db,uqryDinamicaLZ;

type

  { TfraLisClientes }

  TfraLisClientes = class(TFrame)
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
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
    filtro:string;

  end;

implementation

{$R *.lfm}

{ TfraLisClientes }

procedure TfraLisClientes.Timer1Timer(Sender: TObject);
begin
  if assigned(dtsGrid.DataSet) and (dtsGrid.DataSet.Filter <> filtro) then
  begin
    dtsGrid.DataSet.FilterOptions:=[foCaseInsensitive];
    dtsGrid.DataSet.Filter:=filtro;
    dtsGrid.DataSet.Filtered:=true;
  end;
end;

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
  if Assigned(dtsGrid.DataSet) then
  begin
    filtro:= '(nome = '+q('*'+edtfiltro.Text+'*')+') or (cpf = '+q('*'+edtfiltro.Text+'*')+')';
    if trim(edtFiltro.Text) = '' then
    filtro:='';
  end
  else
  ShowMessage('Erro: qry não definida');
end;

end.

