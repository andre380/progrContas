unit ufraListaCheques;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, Forms, Controls, ExtCtrls, Buttons,Dialogs,
  DBGrids, StdCtrls;

type

  { TfrListaCheques }

  TfrListaCheques = class(TFrame)
  private
    Fqry: TSQLQuery;
    procedure Setqry(AValue: TSQLQuery);
  published
    btnLimpaFiltro: TSpeedButton;
    chkTodos: TCheckBox;
    chkAvencer: TCheckBox;
    chkCompensado: TCheckBox;
    chkDevolvido: TCheckBox;
    dtsGrid: TDataSource;
    DBGrid1: TDBGrid;
    edtFiltro: TLabeledEdit;
    procedure chkTodosChange(Sender: TObject);
    procedure edtFiltroChange(Sender: TObject);
    property qry :TSQLQuery read Fqry write Setqry;
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
  if Assigned(dtsGrid.DataSet) then
  begin

  end
  else
  ShowMessage('Erro: qry não definida');
end;

procedure TfrListaCheques.Setqry(AValue: TSQLQuery);
begin
  if Fqry=AValue then Exit;
  dtsGrid.DataSet:= AValue;
  Fqry:=AValue;
end;

procedure TfrListaCheques.chkTodosChange(Sender: TObject);
begin
  if Assigned(dtsGrid.DataSet) then
  begin

  end
  else
  ShowMessage('Erro: qry não definida');
end;

end.

