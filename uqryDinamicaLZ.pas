unit uqryDinamicaLZ;



interface
uses SysUtils, Classes, DB, IBConnection, sqldb, forms,MemDS,Dialogs;

type

  { Tqrydinamica }

  Tqrydinamica = class
    private
    fdbConexaoServidor :TIBConnection;
    procedure SetfdbConexaoServidor(const Value: TIBConnection);
    procedure setrecno(value:integer);
    function getrecordcount:integer;
    function getrecno:integer;
    public
    Trans : TSQLTransaction;
    qry   : TSQLQuery;
    sql   : string;
    property dbConexaoServidor :TIBConnection read fdbConexaoServidor write SetfdbConexaoServidor;
    property RecordCount:integer read getrecordcount;
    property recno:integer read getrecno write setrecno ;
    procedure next;
    procedure Last;
    procedure First;
    procedure FetchAll;
    function eof :Boolean;
    procedure alimentaMMO(MMO:TMemDataset; RecriaCampos:boolean=false;limpadados:boolean=true);
    //executa o sql no parametro e ativa a query se for um select
    function executasql(aSQL:string;comita:boolean=true):boolean; overload;
    //executa o sql previamente configurado
    function executasql(comita:boolean=true):boolean;overload;
    function campostr(nomedocampo:string):string;
    function campocurr(nomedocampo:string):Currency;
    function campodata(nomedocampo:string):TDateTime;
    function campoint(nomedocampo:string):Integer;
    function FieldByName(const FieldName: string): TField;
    function paramstr(param,valor:string):boolean;
    function paramint(param:string;valor:integer):boolean;
    function paramcurr(param:string;valor:currency):boolean;
    function paramdate(param:string;valor:TDate):boolean;
    function paramtime(param:string;valor:TDateTime):boolean;
    procedure edit;
    procedure delete;
    procedure post;
    procedure commit;
    procedure rollback;
    constructor create(database:TIBConnection);
    procedure prepare;
    procedure unprepare;
    function ParamByName(Const AParamName : String) : TParam;

    destructor destroy; override;
    function str(value:integer):string;overload;
    function str(value:Currency):string;overload;
    function strdate(value:TDateTime;mascara:string='yyyy-mm-dd'):string;
  end;
  function q(s:string):string;

implementation

function q(s: string): string;
begin
  result:=QuotedStr(s);
end;

{ Tqrydinamica }

procedure Tqrydinamica.alimentaMMO(MMO: TMemDataset;
  RecriaCampos: boolean;limpadados:boolean);
var cont:integer; nomecampo:string; fieldmmo:tfield;  gravouAlgo :boolean;
begin
  //if not Assigned(mmo) then
  //begin
  //  showmessage('MMO não definido');
  //  exit;
  //end;
  //try
  //  //curSqlWait;
  //  if RecriaCampos then
  //  begin
  //    mmo.Close;
  //    mmo.CopyFromDataset(qry,false);
  //  end;
  //  First;
  //  if limpadados then
  //    mmo.close;
  //  mmo.Open;
  //  mmo.DisableControls;
  //  gravoualgo:=true;
  //  while not eof do
  //  begin
  //    if gravouAlgo then;
  //      mmo.Append;
  //    gravouAlgo:=false;
  //    for cont := 0 to qry.Fields.Count -1 do
  //    begin
  //      nomecampo:=qry.Fields.Fields[cont].FieldName;
  //      fieldmmo:=mmo.FindField(nomecampo);
  //      try
  //        if qry.Fields.Fields[cont].DataType in[ftFloat, ftCurrency, ftBCD] then
  //          fieldmmo.AsString:=TiraMascaraFloat(qry.Fields.Fields[cont].AsString)
  //        else
  //          fieldmmo.AsString:=qry.Fields.Fields[cont].AsString;
  //        gravouAlgo:=true
  //      except end;
  //    end;
  //    if gravouAlgo then
  //      mmo.Post;
  //    next;
  //  end;
  //    mmo.First;
  //    mmo.EnableControls;
  //Finally
  //  curSeta;
  //end;
end;

function Tqrydinamica.campocurr(nomedocampo: string): Currency;
begin
  result:=0;
  if qry.Active then
  begin
    try
      result := qry.FieldByName(nomedocampo).AsCurrency;
    except on e:exception do
    begin
      showmessage('Falha ao ler o campo '+ nomedocampo +' ['+ e.Message+']');
    end;
    end;
  end
  else
  showmessage('Não existe uma consulta ativa para o campo '+nomedocampo);
end;

function Tqrydinamica.campodata(nomedocampo: string): TDateTime;
begin
  result:=0;
  if qry.Active then
  begin
    try
      result := qry.FieldByName(nomedocampo).AsDateTime;
    except on e:exception do
    begin
      showmessage('Falha ao ler o campo '+ nomedocampo +' ['+ e.Message+']');
    end;
    end;
  end
  else
  showmessage('Não existe uma consulta ativa para o campo '+nomedocampo);
end;

function Tqrydinamica.campoint(nomedocampo: string): Integer;
begin
  result:=0;
  if qry.Active then
  begin
    try
      result := qry.FieldByName(nomedocampo).AsInteger;
    except on e:exception do
    begin
      showmessage('Falha ao ler o campo '+ nomedocampo +' ['+ e.Message+']');
    end;
    end;
  end
  else
  showmessage('Não existe uma consulta ativa para o campo '+nomedocampo);
end;

function Tqrydinamica.FieldByName(const FieldName: string): TField;
begin
  result:=qry.FieldByName(FieldName);
end;

function Tqrydinamica.paramstr(param, valor: string): boolean;
begin
  if pos(UpperCase(':'+param),UpperCase(sql))> 0 then
  begin
    if valor = '' then
    begin
      sql:= StringReplace(sql,':'+param+' ','NULL'+' ',[rfReplaceAll, rfIgnoreCase]); // com espaço ao lado
      sql:= StringReplace(sql,':'+param+',','NULL'+',',[rfReplaceAll, rfIgnoreCase]); // encostado na virgula
      sql:= StringReplace(sql,':'+param+']','NULL'+']',[rfReplaceAll, rfIgnoreCase]); // encostado em colchetes
      sql:= StringReplace(sql,':'+param+')','NULL'+')',[rfReplaceAll, rfIgnoreCase]); // encostado em parenteses
      sql:= StringReplace(sql,':'+param+'''','NULL'+'''',[rfReplaceAll, rfIgnoreCase]); // encostado em aspasimples
      sql:= StringReplace(sql,':'+param+'"','NULL'+'"',[rfReplaceAll, rfIgnoreCase]); // encostado em aspadupla
    end
    else
    begin
      sql:= StringReplace(sql,':'+param+' ',q(valor)+' ',[rfReplaceAll, rfIgnoreCase]); // com espaço ao lado
      sql:= StringReplace(sql,':'+param+',',q(valor)+',',[rfReplaceAll, rfIgnoreCase]); // encostado na virgula
      sql:= StringReplace(sql,':'+param+']',q(valor)+']',[rfReplaceAll, rfIgnoreCase]); // encostado em colchetes
      sql:= StringReplace(sql,':'+param+')',q(valor)+')',[rfReplaceAll, rfIgnoreCase]); // encostado em parenteses
      sql:= StringReplace(sql,':'+param+'''',q(valor)+'''',[rfReplaceAll, rfIgnoreCase]); // encostado em aspasimples
      sql:= StringReplace(sql,':'+param+'"',q(valor)+'"',[rfReplaceAll, rfIgnoreCase]); // encostado em aspadupla
    end;
    result:=True;
  end
  else
  begin
    showmessage('Parametro '+param+' não encontrado');
    result:=false;
  end;
end;

function Tqrydinamica.paramint(param: string; valor: integer): boolean;
begin
 result:=paramstr(param,str(valor));
end;

function Tqrydinamica.paramcurr(param: string; valor: currency): boolean;
begin
  result:=paramstr(param,str(valor));
end;

function Tqrydinamica.paramdate(param: string; valor: TDate): boolean;
begin
  result:=paramstr(param,strdate(valor));
end;

function Tqrydinamica.paramtime(param: string; valor: TDateTime): boolean;
begin
  result:=paramstr(param,strdate(valor,'hh:nn:ss'));
end;

procedure Tqrydinamica.edit;
begin
  qry.Edit;
end;

procedure Tqrydinamica.delete;
begin
  qry.Delete;
end;

procedure Tqrydinamica.post;
begin
  qry.Post;
end;

procedure Tqrydinamica.commit;
begin
  qry.ApplyUpdates;
  Trans.CommitRetaining;
end;

procedure Tqrydinamica.rollback;
begin
  trans.RollbackRetaining;
end;

function Tqrydinamica.campostr(nomedocampo: string): string;
begin
  result:='';
  if qry.Active then
  begin
    try
      result := qry.FieldByName(nomedocampo).AsString;
    except on e:exception do
    begin
      showmessage('Falha ao ler o campo '+ nomedocampo +' ['+ e.Message+']');
    end;
    end;
  end
  else
  showmessage('Não existe uma consulta ativa para o campo '+nomedocampo);
end;

constructor Tqrydinamica.create(database: TIBConnection);
begin
  //if database = nil then
  //database:=dtm_Conexao.dtbSomaRetaguarda;
  fdbConexaoServidor:= database;
  {================================}
  {== Cria o Objeto da Transacção =}
  {================================}
  Trans :=TSQLTransaction.Create(Application);
  Trans.DataBase:=database;
  Trans.Params.Add('read_committed');
  Trans.Params.Add('rec_version');
  {===============================}
  {== Cria o objeto da Query     =}
  {===============================}
  qry :=TSQLQuery.Create(Application);
  qry.Database :=database;
  qry.transaction :=Trans;
end;

procedure Tqrydinamica.prepare;
begin
  qry.SQL.text:=sql;
  qry.Prepare;
end;

procedure Tqrydinamica.unprepare;
begin
  qry.Close;
  qry.UnPrepare;
end;

function Tqrydinamica.ParamByName(const AParamName: String): TParam;
begin
  if not qry.Prepared then
    prepare;
  result:=qry.ParamByName(AParamName);
end;

destructor Tqrydinamica.destroy;
begin
  if qry.Active then
  begin
    trans.Rollback;
    qry.Transaction.active:=false;//. close;
  end;
  qry.Free;
  Trans.Free;
  inherited;
end;


function Tqrydinamica.str(value: integer): string;
begin
  result:=IntToStr(value);
end;

function Tqrydinamica.str(value: Currency): string;
begin
  result:= CurrToStr(value);
end;

function Tqrydinamica.strdate(value: TDateTime; mascara: string): string;
begin
  result:=FormatDateTime(mascara,value,[]);
end;

function Tqrydinamica.eof: Boolean;
begin
  result:=qry.Eof;
end;

function Tqrydinamica.executasql(aSQL: string;comita:boolean): boolean;
begin
  // chr(39) = aspa simples '
  if qry.Active then
  begin
    trans.Rollback;
    qry.Transaction.active:=false;//. close;
  end;
  if qry.Prepared and (sql = aSQL)then
  else
  begin
    qry.SQL.Clear;
    qry.SQL.Add(aSQL);
  end;
  result:=true;
  try
    if (pos('DROP',UpperCase(trim(aSQL))) = 1) or
       (pos('CREATE',UpperCase(trim(aSQL))) = 1) or
       (pos('ALTER',UpperCase(trim(aSQL))) = 1) or
       (pos('INSERT',UpperCase(trim(aSQL))) = 1) or
       (pos('EXECUTE',UpperCase(trim(aSQL))) = 1)or
       (pos('DELETE',UpperCase(trim(aSQL))) = 1)or
       (pos('UPDATE',UpperCase(trim(aSQL))) = 1) then
    begin
      qry.ExecSQL;
      if comita then
        Trans.Commit;
    end
    else
    begin
      qry.Open;
      if comita then
      begin
        qry.ApplyUpdates;
        trans.CommitRetaining;
      end;
      if qry.RecordCount < 1  then
        result:=false;
    end;
  except on e:exception do
  begin
    showmessage(e.Message+#13+' ['+qry.sql.Text+']');
    result:=false;
    trans.Rollback;
  end
  end;
end;

function Tqrydinamica.executasql(comita:boolean=true): boolean;
begin
  result:=executasql(sql,comita);
end;

procedure Tqrydinamica.FetchAll;
begin
  //qry.FetchAll; no laz é automatico
end;

procedure Tqrydinamica.First;
begin
  qry.First;
end;

function Tqrydinamica.getrecno: integer;
begin
  result:=qry.RecNo;
end;

function Tqrydinamica.getrecordcount: integer;
begin
  result:=qry.RecordCount;
end;

procedure Tqrydinamica.Last;
begin
  qry.Last;
end;

procedure Tqrydinamica.next;
begin
  qry.Next;
end;

procedure Tqrydinamica.SetfdbConexaoServidor(const Value: TIBConnection);
begin
  if qry.Active then
  begin
    trans.Rollback;
    qry.Transaction.active:=false;//. close;
  end;
  fdbConexaoServidor:=value;
  trans.DataBase:=value;
  qry.Database:=value;
end;

procedure Tqrydinamica.setrecno(value: integer);
begin
  qry.RecNo:=value;
end;


end.
