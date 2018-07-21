program ProgrContas;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, datetimectrls, uPrincipal, ufrabotoes, uframeCliente, ufraListacontas,
  ufraCadastracontas, ufraListaClientes, ufraCadCheque, ufraListaCheques,
ufuncoes, FGInt
  { you can add units after this };

{$R *.res}

begin
  //testes;
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.

