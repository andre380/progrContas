unit ufraListaClientes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, Buttons, DBGrids,sqldb;

type

  { TFrame2 }

  TFrame2 = class(TFrame)
    btnLimpaFiltro: TSpeedButton;
    DBGrid1: TDBGrid;
    edtFiltro: TLabeledEdit;
    procedure btnLimpaFiltroClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure edtFiltroChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    qry:TSQLQuery;
  end;

implementation

{$R *.lfm}

{ TFrame2 }

procedure TFrame2.btnLimpaFiltroClick(Sender: TObject);
begin
  edtFiltro.Clear;
end;

procedure TFrame2.DBGrid1DblClick(Sender: TObject);
begin
  DBGrid1.OnDblClick:=;
end;

procedure TFrame2.edtFiltroChange(Sender: TObject);
begin
  if Assigned(qry) then
  begin

  end
  else
  ShowMessage('Erro: qry não definida');
end;

end.

