unit ufraListacontas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, ExtCtrls,
  DBGrids, Buttons, StdCtrls,dialogs,sqldb, db,ufuncoes;

type

  { TfraListaContas }

  TfraListaContas = class(TFrame)
    rgFiltros: TRadioGroup;
    Timer1: TTimer;
    procedure edtFiltroChange(Sender: TObject);
    procedure rgFiltrosClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    Fqry: TSQLQuery;
    procedure Setqry(AValue: TSQLQuery);
  published
    btnPagar: TButton;
    btnImprime: TButton;
    DateTimePicker1: TDateTimePicker;
    DBGrid1: TDBGrid;
    dtsGrid: TDataSource;
    edtFiltro: TLabeledEdit;
    btnLimpaFiltro: TSpeedButton;
    procedure btnImprimeClick(Sender: TObject);
    procedure btnLimpaFiltroClick(Sender: TObject);
    procedure btnPagarClick(Sender: TObject);
    property qry :TSQLQuery read Fqry write Setqry;
  private
    { private declarations }
  public
    filtro:string;
    { public declarations }
    filtroBTNs:string;
    filtropesquisa:string;
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

procedure TfraListaContas.rgFiltrosClick(Sender: TObject);
begin
  if Assigned(dtsGrid.DataSet) then
  begin
    IF rgFiltros.ItemIndex =0 then// A VENCER
    begin
      filtroBTNs:='(vencimento >= '+q(strdate(Date))+') and (venciemnto > '+q(strdate(Date+15))+')';
    end;
    IF rgFiltros.ItemIndex =1 then// VENCIDAS
    begin
      filtroBTNs:='vencimento < '+q(strdate(Date));
    end;
    IF rgFiltros.ItemIndex =2 then // Antigas
    begin
      filtroBTNs:='vencimento <= '+q(strdate(IncMonth(Date,-6)));
    end;
    IF rgFiltros.ItemIndex =3 then //pagas
    begin
      filtroBTNs:='valor <= valorpago';
    end;
    IF rgFiltros.ItemIndex =4 then
    begin
      filtroBTNs:='';
    end;
    if trim(filtropesquisa) <> '' then
    begin
      if trim(filtroBTNs) <> '' then
        filtro:=filtropesquisa+' and '+filtroBTNs
      else
        filtro:=filtropesquisa;
    end
    else
      filtro:= filtroBTNs;
  end
  else
  ShowMessage('Erro: qry não definida');
end;

procedure TfraListaContas.Timer1Timer(Sender: TObject);
begin
if Assigned(dtsGrid.DataSet)and (dtsGrid.DataSet.Filter <> filtro) then
 begin
   dtsGrid.DataSet.Filter:=filtro;
   dtsGrid.DataSet.Filtered:=true;;
 end;
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

