unit uTThreadBack;

interface

uses
  Classes, SysUtils,uRotinasLZ,Dialogs;
type
  prc = TThreadMethod;

  { TThreadBack }

  TThreadBack = class(TThread)
  private
    FProcesso: TThreadMethod;
  protected
    FPronto :boolean;
  public
    property Pronto : boolean read FPronto;
    constructor create(processo:TThreadMethod=nil;FreeOnTerminate:boolean = true);
    procedure Execute; override;
    //destroy a thread não pode ser destruida enquanto não terminar o processo (não consegui matar a thread)(MR Meeseeks)
  end;

  { Moc }

  Moc = class
    msg :string;
    btnDef:string;
    FACaption, FAPrompt, FADefault : String;
    bolRResult:boolean;
    intResult:integer;
    strResult:string;

    constructor Informa(smessage:string);
    constructor Adverte(smessage:string);
    constructor Erro(smessage:string);
    class function Confirma(sMensagem: string;sBotaoDefault:string='N'):Boolean;
    class Function ConfirmaOuCancela(sMensagem: string;sBotaoDefault:string='N'):Integer;
    class function InputBox(const ACaption, APrompt, ADefault : String) : String;

    procedure evlInforma;
    procedure evlAdverte;
    procedure evlErro;
    procedure evlconfirma;
    procedure evlConfirmaOuCancela;
    procedure evlInputbox;
  end;

implementation

{ Moc }

constructor Moc.Informa(smessage: string);
begin
  msg:=smessage;
  sincThread(prc(evlinforma));
  self.free;
  self:=nil;//o constructor retorna o ponteiro para self e da access violation se a variavel self não estiver alocada
end;

constructor Moc.Adverte(smessage: string);
begin
  msg:=smessage;
  sincThread(prc(self.evlAdverte));
  self.Free;
  self:=nil;
end;

constructor Moc.Erro(smessage: string);
begin
  msg:=smessage;
  sincThread(prc(self.evlErro));
  self.Free;
  self:=nil;
end;

class function Moc.Confirma(sMensagem: string; sBotaoDefault: string): Boolean;
//var tmp:moc;
begin
  with moc.Create do
  begin
    msg:=sMensagem;
    btnDef:=sBotaoDefault;
    sincThread(prc(evlconfirma));
    result:=bolRResult;
    Free;
  end;
  //tmp:= moc.Create;
  //tmp.msg:=sMensagem;
  //tmp.btnDef:=sBotaoDefault;
  //sincThread(prc(tmp.evlconfirma));
  //result:=tmp.bolRResult;
  //tmp.Free;
end;

class function Moc.ConfirmaOuCancela(sMensagem: string; sBotaoDefault: string
  ): Integer;
var
  tmp: Moc;
begin
  tmp:= moc.Create;
  tmp.msg:=sMensagem;
  tmp.btnDef:=sBotaoDefault;
  sincThread(prc(tmp.evlconfirmaoucancela));
  result:=tmp.intResult;
  tmp.Free;
end;

class function Moc.InputBox(const ACaption, APrompt, ADefault: String): String;
begin
  with moc.Create do
  begin
    FACaption:=ACaption;
    FAPrompt:=APrompt;
    FADefault:=ADefault;
    sincThread(prc(evlInputBox));
    result:=strResult;
    free;
  end;
end;

procedure Moc.evlInforma;
begin
  uRotinasLZ.informa(msg);
end;

procedure Moc.evlAdverte;
begin
  uRotinasLZ.Adverte(msg);
end;

procedure Moc.evlErro;
begin
  uRotinasLZ.Erro(msg);
end;

procedure Moc.evlconfirma;
begin
  bolRResult:=uRotinasLZ.Confirma(msg,btnDef);
end;

procedure Moc.evlConfirmaOuCancela;
begin
  intResult:=uRotinasLZ.ConfirmaOuCancela(msg,btnDef);
end;

procedure Moc.evlInputbox;
begin
  strResult:=Dialogs.InputBox(FACaption, fAPrompt, fADefault);
end;

{ TThreadBack }

constructor TThreadBack.create(processo:TThreadMethod;FreeOnTerminate:boolean);
begin
  inherited create(true);
  FProcesso:=processo;
  self.FreeOnTerminate:=FreeOnTerminate;
  FPronto:=false;
  self.Suspended:=false;
end;


procedure TThreadBack.Execute;
begin
  FPronto:=False;
  FProcesso;
  FProcesso:=nil;
  FPronto:=true;
end;

end.

