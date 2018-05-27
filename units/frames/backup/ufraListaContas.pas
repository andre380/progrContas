unit ufraListacontas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, ExtCtrls,
  DBGrids, Buttons, StdCtrls,dialogs,sqldb;

type

  { TFrame1 }

  TFrame1 = class(TFrame)
    btnPagar: TButton;
    btnImprime: TButton;
    chkAntigas: TCheckBox;
    chkAvencer: TCheckBox;
    chkPagas: TCheckBox;
    chkVencidas: TCheckBox;
    DateTimePicker1: TDateTimePicker;
    DBGrid1: TDBGrid;
    edtFiltro: TLabeledEdit;
    btnLimpaFiltro: TSpeedButton;
    procedure btnImprimeClick(Sender: TObject);
    procedure btnLimpaFiltroClick(Sender: TObject);
    procedure btnPagarClick(Sender: TObject);
    procedure chkAvencerChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    qry:TSQLQuery;
  end;

implementation

{$R *.lfm}

{ TFrame1 }

procedure TFrame1.btnPagarClick(Sender: TObject);
var
  valor: String;
begin
  valor:=InputBox('Pagamento','Valor pago','20,00');
end;

procedure TFrame1.chkAvencerChange(Sender: TObject);
begin
  if Assigned(qry) then
  begin

  end
  else
  ShowMessage('Erro: qry não definida');
end;

procedure TFrame1.btnLimpaFiltroClick(Sender: TObject);
begin
  edtFiltro.Clear;
end;

procedure TFrame1.btnImprimeClick(Sender: TObject);
begin
  if Assigned(qry) then
  begin

  end
  else
  ShowMessage('Erro: qry não definida');
end;

end.

