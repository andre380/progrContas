unit ufraCadCheque;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, StdCtrls,
  ExtCtrls,Graphics;

type

  { TfraCadCheque }

  TfraCadCheque = class(TFrame)
    chkCompensado: TCheckBox;
    chkDevolvido: TCheckBox;
    edtVencimento: TDateTimePicker;
    edtdonocheque: TLabeledEdit;
    Label1: TLabel;
    edtValor: TLabeledEdit;
    edtNumeroCheque: TLabeledEdit;
    edtBancoOrigem: TLabeledEdit;
    edtBancoDeposito: TLabeledEdit;
    procedure edtValorChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    alterou:boolean;

    BancoDeposito, BancoOrigem, NumeroCheque, donocheque: String;
    Vencimento: TDate;
    compensado, devolvido: Boolean;
    valor: Currency;

    procedure limpa;
    function valida:Boolean;
  end;

implementation

{$R *.lfm}

{ TfraCadCheque }

procedure TfraCadCheque.edtValorChange(Sender: TObject);
begin
  alterou:=true;
end;

procedure TfraCadCheque.limpa;
begin
  alterou:=False;
 edtVencimento.Date:=NullDate;
 edtBancoDeposito.Text        := '';
 edtBancoOrigem.Text          := '';
 edtNumeroCheque.Text         := '';
 edtdonocheque.Text           := '';
 edtValor.Text                := '';
 chkCompensado.Checked        := False;
 chkDevolvido.Checked         := False;
end;

function TfraCadCheque.valida: Boolean;
begin
  Result:=True;
  if Length(edtBancoOrigem.Text) < 5 then
  begin
    Result:=false;
    edtBancoOrigem.SetFocus;
    edtBancoOrigem.EditLabel.font.Color:=clRed;
  end
  else
    edtBancoOrigem.EditLabel.font.Color:=clBlack;
  if Length(edtNumeroCheque.Text) < 5 then
  begin
    Result:=false;
    edtNumeroCheque.SetFocus;
    edtNumeroCheque.EditLabel.font.Color:=clRed;
  end
  else
    edtNumeroCheque.EditLabel.font.Color:=clBlack;
  if StrToCurrDef(edtValor.Text,0) = 0 then
  begin
    Result:=false;
    edtValor.SetFocus;
    edtValor.EditLabel.font.Color:=clRed;
  end
  else
    edtValor.EditLabel.font.Color:=clBlack;
  if Length(edtdonocheque.Text) < 5 then
  begin
    Result:=false;
    edtdonocheque.SetFocus;
    edtdonocheque.EditLabel.font.Color:=clRed;
  end
  else
    edtdonocheque.EditLabel.font.Color:=clBlack;
 if edtVencimento.DateIsNull then
  begin
    Label1.Font.Color:=clRed;
    edtVencimento.setfocus;
    result:=false;
  end
  else
    Label1.Font.Color:=clBlack;

  if Result then
  begin
   BancoDeposito:= edtBancoDeposito.Text;
   BancoOrigem  := edtBancoOrigem.Text;
   NumeroCheque := edtNumeroCheque.Text;
   donocheque   := edtdonocheque.Text;
   Vencimento   := edtVencimento.Date;
   compensado   := chkCompensado.Checked;
   devolvido    := chkDevolvido.Checked;
   valor        := StrToCurrDef(edtValor.Text,0);
  end;
end;

end.

