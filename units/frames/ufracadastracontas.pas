unit ufraCadastracontas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, ExtCtrls, Spin,
  StdCtrls;

type

  { TfraCadastracontas }

  TfraCadastracontas = class(TFrame)
    btnGerar: TButton;
    DateTimePicker1: TDateTimePicker;
    edtDescricao: TLabeledEdit;
    edtValor: TLabeledEdit;
    Label1: TLabel;
    Label2: TLabel;
    spnParcelas: TSpinEdit;
  private
    { private declarations }
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

end.

