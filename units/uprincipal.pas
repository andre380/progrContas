unit uPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids,
  StdCtrls, ComCtrls, ExtCtrls, Grids, Spin, Buttons, uframeCliente,
  ufraListacontas, ufraCadastracontas, ufraListaClientes, ufraListaCheques,
  ufraCadCheque, DateTimePicker, Types, IBConnection, sqldb, db,variants,
  dateutils,

  uqryDinamicaLZ,ufuncoes;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    btnApagar: TBitBtn;
    btnAtualizar: TBitBtn;
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
    qryContasCliCPF: TStringField;
    qryContasCLIENTE_CODIGO_CLIENTE: TLongintField;
    qryContasCLIENTE_CODIGO_CLIENTE1: TLongintField;
    qryContasCliNOME: TStringField;
    qryContasCliTELEFONE1: TStringField;
    qryContasCODIGO: TLongintField;
    qryContasCODIGO1: TLongintField;
    qryContasCPF: TStringField;
    qryContasDESCRICAO: TStringField;
    qryContasDESCRICAO1: TStringField;
    qryContasNOME: TStringField;
    qryContasQUITACAO: TDateField;
    qryContasQUITACAO1: TDateField;
    qryContasTELEFONE1: TStringField;
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
    procedure btnAtualizarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pageclienteChange(Sender: TObject);
    procedure pagePrincipalChange(Sender: TObject);
    procedure PgPrincipalTabClientesContextPopup(Sender: TObject;
      MousePos: TPoint; var Handled: Boolean);
    procedure qryClienteAfterScroll(DataSet: TDataSet);

    procedure ControlaBotoes(editando:Boolean);
    function salvacliente:Boolean;
    function criaConta:boolean;
    function SalvaCheque :Boolean;
    procedure carregaCliente;
    procedure atualizaclientes;
    procedure atualizacontas;
    procedure atualizaCheques;
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
    edCliente,
    inCliente,
    edCheque,
    inCheque,
    edConta,
    inConta:Boolean;
    codcliente,codconta:integer;
  public
    { public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.btnNovoClick(Sender: TObject);
begin
  if pagePrincipal.ActivePageIndex=0 then
  begin
    pagecliente.ActivePageIndex:=1;
    fraCliente1.limpa;
    fraCadastracontas1.limpa;
    fraCadCheque1.limpa;
    inCliente:=true;
  end;
  ControlaBotoes(true);
end;

procedure TfrmPrincipal.btnSalvarClick(Sender: TObject);
var
  contaOk, chequeOk, clienteChg: Boolean;
begin
  contaok:=true;
  chequeOk:=True;
  clienteChg:=true;
  if inCliente or edCliente then
  begin
    if fraCliente1.valida then
    begin
      if fraCadastracontas1.alterou then
      begin
        contaOk:=fraCadastracontas1.valida;
      end;
      if fraCadCheque1.alterou then
      begin
        chequeOk:=fraCadCheque1.valida;
      end;
      if contaok and chequeOk and (inCliente or confirma('salvar as alterações no cliente'))  then
      begin
        salvacliente;
        if fraCadastracontas1.alterou and contaok  then
          criaConta;
        if fraCadCheque1.alterou and chequeOk then
          salvacheque;
        ControlaBotoes(False);
        avisa('Gravação concluida!');
      end;
    end;
  end;
  atualizaclientes;
  atualizacontas;
  atualizaCheques;
end;

procedure TfrmPrincipal.btnAlterarClick(Sender: TObject);
begin
  if pagePrincipal.ActivePageIndex=0 then
  begin
    pagecliente.ActivePageIndex:=1;
    fraCliente1.limpa;
    fraCliente1.carrega;
    fraCadastracontas1.limpa;
    fraCadCheque1.limpa;
    edCliente:=true;
  end;
  ControlaBotoes(true);
end;

procedure TfrmPrincipal.btnApagarClick(Sender: TObject);
var
  qry: Tqrydinamica;
begin
  if pagePrincipal.ActivePageIndex = 0 then
  begin
    qry:=Tqrydinamica.create(base);
    if QuestionDlg('apagar cliente','apagar o cliente '+qryClienteNOME.AsString+ '?',mtWarning,[1,2],1) = mrOK  then
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

procedure TfrmPrincipal.btnAtualizarClick(Sender: TObject);
begin
  atualizaclientes;
  atualizacontas;
end;

procedure TfrmPrincipal.btnCancelarClick(Sender: TObject);
begin
  ControlaBotoes(False);
  IF fraCliente1.Visible THEN
  begin
    fraCliente1.limpa;
    fraCadastracontas1.limpa;
    fraCadCheque1.limpa;
    carregaCliente;
  end;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  fraLisClientes1.qry:=qryCliente;
  qryCliente.Open;
  edCliente := false;
  inCliente := false;
  edCheque  := false;
  inCheque  := false;
  edConta   := false;
  inConta   := false;
  base.DatabaseName:=ExtractFileDir(ParamStr(0))+'\base.fdb';
  base.Connected:=true;
end;

procedure TfrmPrincipal.ControlaBotoes(editando:Boolean);
begin
  btnNovo.Enabled:=not editando;
  btnAlterar.Enabled:=not editando;
  btnCancelar.Enabled:= editando;
  btnSalvar.Enabled:= editando;
  btnApagar.Enabled:= not editando;
  btnAtualizar.Enabled:=not editando;
  if not editando then
  begin
    inCliente:=false;
    edCliente:=False;
    fraCadCheque1.limpa;
    fraCadastracontas1.limpa;
  end;
end;

procedure TfrmPrincipal.pageclienteChange(Sender: TObject);
begin
  if  pagecliente.ActivePageIndex=0 then
  begin
    qryCliente.locate('codigo',codcliente,[]);
  end;
  if  pagecliente.ActivePageIndex=1 then
  begin
    carregaCliente;
  end;
  if  pagecliente.ActivePageIndex=2 then
  begin
    pageClienteTab_Contas.Caption:= 'Contas de '+Copy(qryClienteNOME.AsString,1,50);
    trContascli.Active:=false;
    qryContasCli.ParamByName('CodCliente').AsInteger:=codcliente;
    qryContasCli.Open;
 end
  else
    pageClienteTab_Contas.Caption:= 'Contas do cliente';
  if  pagecliente.ActivePageIndex=3 then
  begin
    pageclienteTab_Cheques.Caption:= 'Cheques de '+copy(qryClienteNOME.AsString,1,50);
  end
  else
    pageclienteTab_Cheques.Caption:= 'Cheques do cliente';

end;

procedure TfrmPrincipal.pagePrincipalChange(Sender: TObject);
begin
  if pagePrincipal.ActivePage = pgPrincipalTabContas then
  begin
    atualizacontas;
  end;
end;

procedure TfrmPrincipal.PgPrincipalTabClientesContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin

end;

procedure TfrmPrincipal.qryClienteAfterScroll(DataSet: TDataSet);
begin
  if pagecliente.ActivePageIndex=0 then
    codcliente:=qryClienteCODIGO.AsInteger;
end;

function TfrmPrincipal.salvacliente:Boolean;
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
      trcliente.CommitRetaining;

    end;
    codcliente:=qryClienteCODIGO.AsInteger;
    result:=true;
    atualizaclientes;
  end;
end;

function TfrmPrincipal.criaConta: boolean;
var
  newCodigo: LongInt;
  codcli, str1, parc:string;
  qry:Tqrydinamica;
  diadomes, cont: Integer;
  vencimento: TDate;
  valor: Currency;
begin
  // debug lembrar de ler a variavel codcliente

  qry:=Tqrydinamica.create(base);
  codcli:=IntToStr(codcliente);
  vencimento:=IncMonth(fraCadastracontas1.vencimento,-1);
  valor := fraCadastracontas1.valor/fraCadastracontas1.parcelas;
  parc:= str(fraCadastracontas1.parcelas);
  str1:='';
  for cont := 1 to fraCadastracontas1.parcelas do
  begin
    vencimento:=IncMonth(vencimento);
    qry.executasql('select max(contas.codigo) from contas where contas.cliente_codigo_cliente = '+q(codcli));
    newCodigo:=qry.campoint('max')+1;
    qry.sql:='insert into contas values (:CLIENTE_CODIGO_CLIENTE,:CODIGO,:DESCRICAO,:VALOR,:VALORPAGO,:VENCIMENTO,null)';
    qry.prepare;
    if parc <> '1' then
    str1:='['+IntToStr(cont)+'/'+parc+'] ';
    qry.ParamByName('CLIENTE_CODIGO_CLIENTE').AsInteger:= codcliente;
    qry.ParambyName('CODIGO').AsInteger                := newCodigo;
    qry.ParambyName('DESCRICAO').AsString              := str1+fraCadastracontas1.descricao;
    qry.ParambyName('VALOR').AsCurrency                := valor;
    qry.ParambyName('VALORPAGO').AsCurrency            := 0;
    qry.ParambyName('VENCIMENTO').AsDate               := vencimento;
    qry.qry.ExecSQL;
    qry.commit;

  end;
  result:=true;
  atualizacontas;
end;

function TfrmPrincipal.SalvaCheque: Boolean;
var
  qry: Tqrydinamica;
  newcodCheque: integer;
begin
  qry:=Tqrydinamica.create(base);
  qry.executasql('select max(cheques.codigo) from cheques where cheques.cliente_codigo_cliente = '+q(str(codcliente)));
  newcodCheque:=qry.campoint('max')+1;
  qry.sql:= 'INSERT INTO CHEQUES values(:CLIENTE_CODIGO_CLIENTE, :CODIGO, :VALOR, :DATAVENCIMENTO, :NUMERO_CHEQUE, :BANCO_ORIGEM, :DONO_CHEQUE, :BANCO_DEPOSITO, :COMPENSADO, :DEVOLVIDO)';
  qry.prepare;
  qry.parambyname('CLIENTE_CODIGO_CLIENTE').AsInteger:=codcliente;
  qry.parambyname('CODIGO').AsInteger        := newcodCheque;
  qry.parambyname('VALOR').AsCurrency        := fraCadCheque1.valor;
  qry.parambyname('BANCO_DEPOSITO').asstring := fraCadCheque1.BancoDeposito;
  qry.parambyname('BANCO_ORIGEM').asstring   := fraCadCheque1.BancoOrigem;
  qry.parambyname('NUMERO_CHEQUE').asstring  := fraCadCheque1.NumeroCheque;
  qry.parambyname('DONO_CHEQUE').asstring    := fraCadCheque1.donocheque;
  qry.parambyname('DATAVENCIMENTO').AsDate   := fraCadCheque1.Vencimento;
  qry.parambyname('COMPENSADO').AsBoolean    := fraCadCheque1.compensado;
  qry.parambyname('DEVOLVIDO').AsBoolean     := fraCadCheque1.devolvido;
  qry.qry.ExecSQL;
  qry.commit;
  qry.Free;
end;

procedure TfrmPrincipal.carregaCliente;
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

procedure TfrmPrincipal.atualizaclientes;
begin
  trcliente.Active:=false;
  qrycliente.Open;
  qryCliente.Locate('codigo',codcliente,[]);
end;

procedure TfrmPrincipal.atualizacontas;
begin
  qryContas.Transaction.Active:=false;
  qryContas.Open;
  qrycontas.Locate('cliente_codigo_cliente;codigo',vararrayof([codcliente,codconta]),[]);
end;

procedure TfrmPrincipal.atualizaCheques;
begin
  trCheques.Active:=false;
  qryCheques.Open;
end;

procedure TfrmPrincipal.Timer1Timer(Sender: TObject);
begin

end;

end.

