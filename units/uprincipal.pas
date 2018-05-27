unit uPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids,
  StdCtrls, ComCtrls, ExtCtrls, Grids, Spin, uframeCliente, ufraListacontas,
  ufraCadastracontas, DateTimePicker, Types;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    fraCadastracontas1: TfraCadastracontas;
    fraCliente1: TfraCliente;
    lblCpf: TLabel;
    LblNome: TLabel;
    pageContas: TPageControl;
    bosta: TPageControl;
    tabClientes: TTabSheet;
    tabLista: TTabSheet;
    tabFormulario: TTabSheet;
    tabContas: TTabSheet;
    tabCliente_Contas: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  fraCliente1.valida;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  fraCliente1.limpa;
end;

end.

