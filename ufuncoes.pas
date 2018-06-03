unit ufuncoes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Dialogs;
  function confirma(pergunta:string):boolean;
  function str(value:integer):string;overload;
  function str(value:Currency):string;overload;
  function strdate(value:TDateTime;mascara:string='yyyy-mm-dd'):string;
  function q(s:string):string;



implementation

function confirma(pergunta: string): boolean;
begin
  //1 ok, 2 cancel, 3abort, 4retry, 5ignore, 6yes, 7no, 8 all, 9 no to all, 10 yes to all
  //(mtWarning, mtError, mtInformation, mtConfirmation,mtCustom)
  result:=false;
  if QuestionDlg('Pergunta',pergunta,mtConfirmation,[1,2],1) = 1 then
  result:=true;
end;

function str(value: integer): string;
begin
    result:=IntToStr(value);
end;

function str(value: Currency): string;
begin
    result:= CurrToStr(value);
end;

function strdate(value: TDateTime; mascara: string): string;
begin
  result:=FormatDateTime(mascara,value,[]);
end;

function q(s: string): string;
begin
  result := QuotedStr(s);
end;

end.

