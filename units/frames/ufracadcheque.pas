unit ufraCadCheque;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, StdCtrls,
  ExtCtrls;

type

  { TfraCadCheque }

  TfraCadCheque = class(TFrame)
    CheckBox1: TCheckBox;
    chkDevolvido: TCheckBox;
    edtVencimento: TDateTimePicker;
    edtdonocheque: TLabeledEdit;
    Label1: TLabel;
    edtValor: TLabeledEdit;
    edtNumeroCheque: TLabeledEdit;
    edtBancoOrigem: TLabeledEdit;
    edtBancoDeposito: TLabeledEdit;
  private
    { private declarations }
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

end.

