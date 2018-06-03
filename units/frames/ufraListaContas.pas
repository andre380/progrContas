unit ufraListacontas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, ExtCtrls,
  DBGrids, Buttons, StdCtrls,dialogs,sqldb, db,ufuncoes,uqryDinamicaLZ, variants;

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
    function getqry:TSQLQuery;
    procedure Setqry(AValue: TSQLQuery);
  published
    btnPagar: TButton;
    btnImprime: TButton;
    edtDTPagamento: TDateTimePicker;
    DBGrid1: TDBGrid;
    dtsGrid: TDataSource;
    edtFiltro: TLabeledEdit;
    btnLimpaFiltro: TSpeedButton;
    procedure btnImprimeClick(Sender: TObject);
    procedure btnLimpaFiltroClick(Sender: TObject);
    procedure btnPagarClick(Sender: TObject);
    property qry :TSQLQuery read getqry write Setqry;
  private
    { private declarations }
  public
    filtro:string;
    { public declarations }
    filtroBTNs:string;
    filtropesquisa:string;
  end;

implementation
uses
  uPrincipal;
{$R *.lfm}

{ TfraListaContas }

procedure TfraListaContas.btnPagarClick(Sender: TObject);
var
  valorPg: String;
  qryd: Tqrydinamica;
  valorDev: Currency;
  codcli,codconta:integer;
begin
  valorDev:=dtsGrid.DataSet.FieldByName('valor').AsCurrency-dtsGrid.DataSet.FieldByName('valorpago').AsCurrency;
  valorPg:=InputBox('Pagamento','Valor pago',
                str(valorDev) );
  if StrToCurrDef(valorPg,0) > 0 then
  begin
    codcli:=qry.FieldByName('cliente_codigo_cliente').AsInteger;
    codconta:=qry.FieldByName('codigo').AsInteger;
    qryd:=Tqrydinamica.create(frmPrincipal.base);
    if dtsGrid.DataSet.FieldByName('valorpago').AsCurrency+StrToCurr(valorPg)>=dtsGrid.DataSet.FieldByName('valor').AsCurrency then
    begin
      qryd.executasql(' UPDATE CONTAS '+
                      ' SET '          +
                      '    VALORPAGO = '+str(dtsGrid.DataSet.FieldByName('valorpago').AsCurrency+StrToCurr(valorPg),'.')+
                      ',    QUITACAO = '+q(strdate(edtDTPagamento.Date))+
                      ' WHERE (CLIENTE_CODIGO_CLIENTE = '+dtsGrid.DataSet.FieldByName('CLIENTE_CODIGO_CLIENTE').AsString+
                      ') AND (CODIGO = '+dtsGrid.DataSet.FieldByName('CODIGO').AsString+')'
                     );
      avisa('pagamento encerrado!');
    end
    else
    begin
      qryd.executasql(' UPDATE CONTAS '+
                      ' SET '          +
                      '    VALORPAGO = '+str(dtsGrid.DataSet.FieldByName('valorpago').AsCurrency+StrToCurr(valorPg),'.')+
                      ' WHERE (CLIENTE_CODIGO_CLIENTE = '+dtsGrid.DataSet.FieldByName('CLIENTE_CODIGO_CLIENTE').AsString+
                      ') AND (CODIGO = '+dtsGrid.DataSet.FieldByName('CODIGO').AsString+')'
                     );
        avisa('pagamento parcial concluido!');
    end;
    qry.Transaction.Active:=false;
    qry.Open;
    qry.locate('cliente_codigo_cliente;codigo',VarArrayOf([codcli,codconta]),[]);
  end;
end;

procedure TfraListaContas.btnLimpaFiltroClick(Sender: TObject);
begin
  edtFiltro.Clear;
end;

procedure TfraListaContas.edtFiltroChange(Sender: TObject);
begin
  if Assigned(dtsGrid.DataSet) then
  begin
    filtropesquisa:= '(nome = '+q('*'+edtfiltro.Text+'*')+') or (cpf = '+q('*'+edtfiltro.Text+'*')+')';
    if trim(edtFiltro.Text) = '' then
      filtropesquisa:='';
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
      filtroBTNs:='(DTOS(vencimento) >= '+q(strdate(Date,'yyyymmdd'))+') and (DTOS(vencimento) < '+q(strdate(Date+15,'yyyymmdd'))+')and ( valor > valorpago)';
    end;
    IF rgFiltros.ItemIndex =1 then// VENCIDAS
    begin
      filtroBTNs:='(DTOS(vencimento) <= '+q(strdate(Date,'yyyymmdd'))+') and ( valor > valorpago)';
    end;
    IF rgFiltros.ItemIndex =2 then // Antigas
    begin
      filtroBTNs:='DTOS(vencimento) < '+q(strdate(IncMonth(Date,-6)));
    end;
    IF rgFiltros.ItemIndex =3 then //pagas
    begin
      filtroBTNs:='valor <= valorpago';
    end;
    IF rgFiltros.ItemIndex =4 then
    begin
      filtroBTNs:='';
    end;
  end
  else
  ShowMessage('Erro: qry não definida');
end;

procedure TfraListaContas.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled:=false;
  if Assigned(qry)then
  begin
    edtDTPagamento.Date:= qry.FieldByName('vencimento').AsDateTime;
  end;
  if trim(filtropesquisa) <> '' then
  begin
    if trim(filtroBTNs) <> '' then
      filtro:='('+filtropesquisa+') and ('+filtroBTNs+')'
    else
      filtro:=filtropesquisa;
  end
  else
    filtro:= filtroBTNs;
  if Assigned(dtsGrid.DataSet)and (dtsGrid.DataSet.Filter <> filtro)  then
  begin
    dtsGrid.DataSet.Filter:=filtro;
    dtsGrid.DataSet.Filtered:=true;
  end;
  Timer1.Enabled:=true;
end;

function TfraListaContas.getqry: TSQLQuery;
begin
  result:=TSQLQuery(dtsGrid.DataSet);
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

