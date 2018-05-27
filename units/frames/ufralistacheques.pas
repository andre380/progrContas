unit ufraListaCheques;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, Buttons, DBGrids,
  StdCtrls;

type

  { TfrListaCheques }

  TfrListaCheques = class(TFrame)
    btnLimpaFiltro: TSpeedButton;
    chkTodos: TCheckBox;
    chkAvencer: TCheckBox;
    chkCompensado: TCheckBox;
    chkDevolvido: TCheckBox;
    DBGrid1: TDBGrid;
    edtFiltro: TLabeledEdit;
    procedure chkTodosChange(Sender: TObject);
    procedure edtFiltroChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

{ TfrListaCheques }

procedure TfrListaCheques.edtFiltroChange(Sender: TObject);
begin
  if Assigned(qry) then
  begin

  end
  else
  ShowMessage('Erro: qry não definida');
end;

procedure TfrListaCheques.chkTodosChange(Sender: TObject);
begin
  if Assigned(qry) then
  begin

  end
  else
  ShowMessage('Erro: qry não definida');
end;

end.

