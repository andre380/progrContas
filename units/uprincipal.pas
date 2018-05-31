unit uPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids,
  StdCtrls, ComCtrls, ExtCtrls, Grids, Spin, Buttons, uframeCliente,
  ufraListacontas, ufraCadastracontas, ufraListaClientes, ufraListaCheques,
  ufraCadCheque, DateTimePicker, Types, IBConnection, sqldb, db,
  dateutils,

  uqryDinamicaLZ,ufuncoes;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnApagar: TBitBtn;
    btnNovo: TBitBtn;
    btnAlterar: TBitBtn;
    btnCancelar: TBitBtn;
    btnSalvar: TBitBtn;
    fraCadastracontas1: TfraCadastracontas;
    fraCadCheque1: TfraCadCheque;
    fraCliente1: TfraCliente;
    base: TIBConnection;
    fraLisClientes1: TfraLisClientes;
    fraListaContas1: TfraListaContas;
    fraListaContas2: TfraListaContas;
    frListaCheques1: TfrListaCheques;
    frListaCheques2: TfrListaCheques;
    pagePrincipal: TPageControl;
    pagecliente: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    qryChequesBANCO_DEPOSITO: TStringField;
    qryChequesBANCO_ORIGEM: TStringField;
    qryChequesCLIENTE_CODIGO_CLIENTE: TLongintField;
    qryChequesCODIGO: TLongintField;
    qryChequesCOMPENSADO: TLongintField;
    qryChequesDATAVENCIMENTO: TDateField;
    qryChequesDEVOLVIDO: TLongintField;
    qryChequesDONO_CHEQUE: TStringField;
    qryChequesNOME: TStringField;
    qryChequesNUMERO_CHEQUE: TStringField;
    qryChequesVALOR: TBCDField;
    qryCliente: TSQLQuery;
    qryClienteBAIRRO: TStringField;
    qryClienteCIDADE: TStringField;
    qryClienteCODIGO: TLongintField;
    qryClienteCPF: TStringField;
    qryClienteDATACADASTRO: TDateTimeField;
    qryClienteEMAIL: TStringField;
    qryClienteENDERECO: TStringField;
    qryClienteNASCIMENTO: TDateField;
    qryClienteNOME: TStringField;
    qryClientePERFIL: TLongintField;
    qryClienteRG: TStringField;
    qryClienteSTATUS: TLongintField;
    qryClienteTELEFONE1: TStringField;
    qryClienteTELEFONE2: TStringField;
    qryContas: TSQLQuery;
    qryCheques: TSQLQuery;
    qryContasCli: TSQLQuery;
    qryContasCLIENTE_CODIGO_CLIENTE: TLongintField;
    qryContasCLIENTE_CODIGO_CLIENTE1: TLongintField;
    qryContasCODIGO: TLongintField;
    qryContasCODIGO1: TLongintField;
    qryContasDESCRICAO: TStringField;
    qryContasDESCRICAO1: TStringField;
    qryContasNOME: TStringField;
    qryContasQUITACAO: TDateField;
    qryContasQUITACAO1: TDateField;
    qryContasVALOR: TBCDField;
    qryContasVALOR1: TBCDField;
    qryContasVALORPAGO: TBCDField;
    qryContasVALORPAGO1: TBCDField;
    qryContasVENCIMENTO: TDateField;
    pageclienteTab_Cheques: TTabSheet;
    pagePrincipalTabCheques: TTabSheet;
    qryContasVENCIMENTO1: TDateField;
    trCheques: TSQLTransaction;
    trContas: TSQLTransaction;
    trcliente: TSQLTransaction;
    trContascli: TSQLTransaction;
    trdefault: TSQLTransaction;
    PgPrincipalTabClientes: TTabSheet;
    pageClienteTab_Lista: TTabSheet;
    pageClientetTab_Formulario: TTabSheet;
    pgPrincipalTabContas: TTabSheet;
    pageClienteTab_Contas: TTabSheet;
    procedure btnAlterarClick(Sender: TObject);
    procedure btnApagarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pageclienteChange(Sender: TObject);
    procedure qryClienteAfterScroll(DataSet: TDataSet);

    procedure ControlaBotoes(editando:Boolean);
    function salvacliente:Boolean;
    function criaConta:boolean;
    procedure carregaCliente;
    procedure atualizaclientes;
  private
    { private declarations }
    edCliente,
    inCliente,
    edCheque,
    inCheque,
    edConta,
    inConta:Boolean;
    codcliente:integer;
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

procedure TForm1.btnNovoClick(Sender: TObject);
begin
  if pagePrincipal.ActivePageIndex=0 then
  begin
    pagecliente.ActivePageIndex:=1;
    fraCliente1.limpa;
    inCliente:=true;
  end;
  ControlaBotoes(true);
end;

procedure TForm1.btnSalvarClick(Sender: TObject);
var
  contaOk: Boolean;
begin
  contaok:=true;
  if inCliente or edCliente then
  begin
    if fraCliente1.valida then
    begin
      if fraCadastracontas1.alterou then
      begin
        contaOk:=fraCadastracontas1.valida;
      end;
      if contaok and confirma('salvar as alterações no cliente')  then
      begin
        salvacliente;
        if contaok then
        criaConta;
        inCliente:=false;
        ControlaBotoes(False);
      end;
    end;
  end;

end;

procedure TForm1.btnAlterarClick(Sender: TObject);
begin
  if pagePrincipal.ActivePageIndex=0 then
  begin
    pagecliente.ActivePageIndex:=1;
    fraCliente1.limpa;
    fraCliente1.carrega;
    edCliente:=true;
  end;
  ControlaBotoes(true);
end;

procedure TForm1.btnApagarClick(Sender: TObject);
var
  qry: Tqrydinamica;
begin
  if pagePrincipal.ActivePageIndex = 0 then
  begin
    qry:=Tqrydinamica.create(base);
    if QuestionDlg('apagar cliente','apagar o cliente mesmo?',mtWarning,[1,2],1) = mrOK  then
      if QuestionDlg('APAGA MESMO?','apagar todas as contas e cheques do cliente TUDO MESMO ?',mtWarning,[1,2],1) = mrOK then
      begin
        //opa
        qry.executasql('select * from cliente where cliente.codigo = '+qryClienteCODIGO.AsString);
        qry.qry.Delete;
        qry.commit;
        atualizaclientes;
      end;
  end;
end;

procedure TForm1.btnCancelarClick(Sender: TObject);
begin
  ControlaBotoes(False);
  IF fraCliente1.Visible THEN
  begin
    fraCliente1.limpa;
    fraCadastracontas1.limpa;
    carregaCliente;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  fraLisClientes1.qry:=qryCliente;
  qryCliente.Open;
  edCliente := false;
  inCliente := false;
  edCheque  := false;
  inCheque  := false;
  edConta   := false;
  inConta   := false;
end;

procedure TForm1.ControlaBotoes(editando:Boolean);
begin
  btnNovo.Enabled:=not editando;
  btnAlterar.Enabled:=not editando;
  btnCancelar.Enabled:= editando;
  btnSalvar.Enabled:= editando;
  btnApagar.Enabled:= not editando;
end;

procedure TForm1.pageclienteChange(Sender: TObject);
begin
  if  pagecliente.ActivePageIndex=0 then
  begin
    qryCliente.locate('codigo',codcliente,[]);
  end;
  if  pagecliente.ActivePageIndex=1 then
  begin
    carregaCliente;
  end;
end;

procedure TForm1.qryClienteAfterScroll(DataSet: TDataSet);
begin
  if pagecliente.ActivePageIndex=0 then
    codcliente:=qryClienteCODIGO.AsInteger;
end;

function TForm1.salvacliente:Boolean;
var
  newCodigo: LongInt;
  qry:Tqrydinamica;
begin
  if inCliente or edCliente then
  begin
    if edCliente then
    begin
      qry:=Tqrydinamica.create(base);
      qry.executasql('select * from cliente where cliente.codigo = '+qryClienteCODIGO.AsString);
      qry.edit;
      //qry.fieldbyname('CODIGO').AsInteger:=newCodigo;
      qry.fieldbyname('NOME').AsString:=fraCliente1.nome;
      qry.fieldbyname('BAIRRO').AsString:=fraCliente1.bairro;
      qry.fieldbyname('CIDADE').AsString:=fraCliente1.cidade;
      qry.fieldbyname('CPF').AsString:=fraCliente1.cpf;
      qry.fieldbyname('DATACADASTRO').AsDateTime:=fraCliente1.datacadastro;
      qry.fieldbyname('EMAIL').AsString:=fraCliente1.email;
      qry.fieldbyname('ENDERECO').AsString:=fraCliente1.endereco;
      qry.fieldbyname('NASCIMENTO').AsDateTime:=fraCliente1.datanascimento;
      qry.fieldbyname('RG').AsString:=fraCliente1.rg;
      qry.fieldbyname('TELEFONE1').AsString:=fraCliente1.telefone1;
      qry.fieldbyname('TELEFONE2').AsString:=fraCliente1.telefone2;
      qry.fieldbyname('PERFIL').AsInteger:=fraCliente1.perfil;
      qry.post;
      qry.commit;
    end
    else
    begin
      qry:=Tqrydinamica.create(base);
      qry.executasql('select max(cliente.codigo) from cliente');
      newCodigo:=qry.campoint('max')+1;

      qryCliente.Append;
      qryClienteCODIGO.AsInteger:=newCodigo;
      qryClienteNOME.AsString:=fraCliente1.nome;
      qryClienteBAIRRO.AsString:=fraCliente1.bairro;
      qryClienteCIDADE.AsString:=fraCliente1.cidade;
      qryClienteCPF.AsString:=fraCliente1.cpf;
      qryClienteDATACADASTRO.AsDateTime:=fraCliente1.datacadastro;
      qryClienteEMAIL.AsString:=fraCliente1.email;
      qryClienteENDERECO.AsString:=fraCliente1.endereco;
      qryClienteNASCIMENTO.AsDateTime:=fraCliente1.datanascimento;
      qryClienteRG.AsString:=fraCliente1.rg;
      qryClienteTELEFONE1.AsString:=fraCliente1.telefone1;
      qryClienteTELEFONE2.AsString:=fraCliente1.telefone2;
      qryClientePERFIL.AsInteger:=fraCliente1.perfil;

      qryCliente.Post;
      qryCliente.ApplyUpdates;
      trcliente.Commit;

    end;
    result:=true;
    atualizaclientes;
  end;
end;

function TForm1.criaConta: boolean;
var
  newCodigo: LongInt;
  codcli:string;
  qry:Tqrydinamica;
  diadomes, cont: Integer;
  vencimento: TDate;
  valor: Currency;
begin
  // debug lembrar de ler a variavel codcliente

  qry:=Tqrydinamica.create(base);
  codcli:=IntToStr(codcliente);
  vencimento:=fraCadastracontas1.vencimento;
  valor := fraCadastracontas1.valor/fraCadastracontas1.parcelas;
  for cont := 1 to fraCadastracontas1.parcelas do
  begin
    vencimento:=IncMonth(vencimento);
    qry.executasql('select max(contas.codigo) from contas where contas.cliente_codigo_cliente = '+q(codcli));
    newCodigo:=qry.campoint('max')+1;
    qry.sql:='insert into contas values (:CLIENTE_CODIGO_CLIENTE,:CODIGO,:DESCRICAO,:VALOR,:VALORPAGO,:VENCIMENTO,null)';
    qry.prepare;
    qry.ParamByName('CLIENTE_CODIGO_CLIENTE').AsInteger:= codcliente;
    qry.ParambyName('CODIGO').AsInteger                := newCodigo;
    qry.ParambyName('DESCRICAO').AsString              := 'p'+IntToStr(cont)+' '+fraCadastracontas1.descricao;
    qry.ParambyName('VALOR').AsCurrency                := valor;
    qry.ParambyName('VALORPAGO').AsCurrency            := 0;
    qry.ParambyName('VENCIMENTO').AsDate               := vencimento;
    qry.qry.ExecSQL;
    qry.commit;

  end;
  result:=true;
      //atualizacontas;
end;

procedure TForm1.carregaCliente;
begin
  fraCliente1.nome           := qryClienteNOME.AsString;
  fraCliente1.bairro         := qryClienteBAIRRO.AsString;
  fraCliente1.cidade         := qryClienteCIDADE.AsString;
  fraCliente1.cpf            := qryClienteCPF.AsString;
  fraCliente1.datacadastro   := qryClienteDATACADASTRO.AsDateTime;
  fraCliente1.email          := qryClienteEMAIL.AsString;
  fraCliente1.endereco       := qryClienteENDERECO.AsString;
  fraCliente1.datanascimento := qryClienteNASCIMENTO.AsDateTime;
  fraCliente1.rg             := qryClienteRG.AsString;
  fraCliente1.telefone1      := qryClienteTELEFONE1.AsString;
  fraCliente1.telefone2      := qryClienteTELEFONE2.AsString;
  fraCliente1.perfil         := qryClientePERFIL.AsInteger;
  fraCliente1.carrega;
end;

procedure TForm1.atualizaclientes;
begin
  trcliente.Active:=false;
  qrycliente.Open;
end;

end.

