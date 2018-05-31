unit ufraListacontas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, ExtCtrls,
  DBGrids, Buttons, StdCtrls,dialogs,sqldb, db;

type

  { TfraListaContas }

  TfraListaContas = class(TFrame)
    procedure edtFiltroChange(Sender: TObject);
  private
    Fqry: TSQLQuery;
    procedure Setqry(AValue: TSQLQuery);
  published
    btnPagar: TButton;
    btnImprime: TButton;
    chkAntigas: TCheckBox;
    chkAvencer: TCheckBox;
    chkPagas: TCheckBox;
    chkVencidas: TCheckBox;
    DateTimePicker1: TDateTimePicker;
    DBGrid1: TDBGrid;
    dtsGrid: TDataSource;
    edtFiltro: TLabeledEdit;
    btnLimpaFiltro: TSpeedButton;
    procedure btnImprimeClick(Sender: TObject);
    procedure btnLimpaFiltroClick(Sender: TObject);
    procedure btnPagarClick(Sender: TObject);
    procedure chkAvencerChange(Sender: TObject);
    property qry :TSQLQuery read Fqry write Setqry;
  private
    { private declarations }
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

{ TfraListaContas }

procedure TfraListaContas.btnPagarClick(Sender: TObject);
var
  valor: String;
begin
  valor:=InputBox('Pagamento','Valor pago','20,00');
end;

procedure TfraListaContas.chkAvencerChange(Sender: TObject);
begin
  if Assigned(dtsGrid.DataSet) then
  begin

  end
  else
  ShowMessage('Erro: qry não definida');
end;

procedure TfraListaContas.btnLimpaFiltroClick(Sender: TObject);
begin
  edtFiltro.Clear;
end;

procedure TfraListaContas.edtFiltroChange(Sender: TObject);
begin
  if Assigned(dtsGrid.DataSet) then
  begin

  end
  else
  ShowMessage('Erro: qry não definida');

end;

procedure TfraListaContas.Setqry(AValue: TSQLQuery);
begin
  if Fqry=AValue then Exit;
  dtsGrid.DataSet:= AValue;
  Fqry:=AValue;
end;

procedure TfraListaContas.btnImprimeClick(Sender: TObject);
begin
  if Assigned(dtsGrid.DataSet) then
  begin

  end
  else
  ShowMessage('Erro: qry não definida');
end;

end.

