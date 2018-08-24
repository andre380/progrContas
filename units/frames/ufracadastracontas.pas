unit ufraCadastracontas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, ExtCtrls, Spin,
  StdCtrls,Graphics;

type

  { TfraCadastracontas }

  TfraCadastracontas = class(TFrame)
    edtEntrada: TLabeledEdit;
    edtVencimento: TDateTimePicker;
    edtDescricao: TLabeledEdit;
    edtValor: TLabeledEdit;
    Label1: TLabel;
    Label2: TLabel;
    spnParcelas: TSpinEdit;
    procedure edtDescricaoChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    alterou:boolean;
    descricao:string;
    valor,entrada:Currency;
    vencimento:TDate;
    parcelas:integer;
    function valida:boolean;
    procedure limpa;
    procedure carrega;
  end;

implementation

{$R *.lfm}

{ TfraCadastracontas }

procedure TfraCadastracontas.edtDescricaoChange(Sender: TObject);
begin
  alterou:=true;
end;

function TfraCadastracontas.valida: boolean;
begin
  result:=true;
  if StrToCurrDef(edtEntrada.Text,-1)=-1 then
  begin
    result:=false;
    edtEntrada.EditLabel.Font.Color:=clRed;
    edtEntrada.SetFocus;
  end
  else
    edtEntrada.EditLabel.Font.Color:=clBlack;
  if StrToCurrDef(edtValor.Text,0)=0 then
  begin
    result:=false;
    edtValor.EditLabel.Font.Color:=clRed;
    edtValor.SetFocus;
  end
  else
    edtValor.EditLabel.Font.Color:=clBlack;
  if Length(edtDescricao.Text)<3 then
  begin
    result:=false;
    edtDescricao.SetFocus;
    edtDescricao.EditLabel.Font.Color:=clRed;
  end
  else
    edtDescricao.EditLabel.Font.Color:=clBlack;
  if Result then
  begin
    descricao:=edtDescricao.Text;
    valor:= StrToCurrDef(edtValor.Text,0);
    entrada:=StrToCurrDef(edtEntrada.Text,0);
    vencimento:=edtVencimento.Date;
    parcelas:=spnParcelas.Value;
  end;
end;

procedure TfraCadastracontas.limpa;
begin
  alterou:=false;

  edtDescricao.Text:='';
  edtValor.Text:='';
  edtEntrada.Text:='';
  edtVencimento.Date:=Date+30;
  spnParcelas.Value:=1;

  descricao:=edtDescricao.Text;
  valor:= StrToCurrDef(edtValor.Text,0);
  entrada:= 0;
  vencimento:=edtVencimento.Date;
  parcelas:=spnParcelas.Value;
  edtDescricao.EditLabel.Font.Color:=clBlack;
  edtValor.EditLabel.Font.Color:=clBlack;
end;

procedure TfraCadastracontas.carrega;
begin
  edtDescricao.Text  := descricao;
  edtValor.Text      := CurrToStr(valor);
  edtEntrada.Text    := CurrToStr(entrada);
  edtVencimento.Date := vencimento;
  spnParcelas.Value  := parcelas;
end;

end.

