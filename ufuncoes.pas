unit ufuncoes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Dialogs;
  function confirma(pergunta:string):boolean;

implementation

function confirma(pergunta: string): boolean;
begin
  //1 ok, 2 cancel, 3abort, 4retry, 5ignore, 6yes, 7no, 8 all, 9 no to all, 10 yes to all
  //(mtWarning, mtError, mtInformation, mtConfirmation,mtCustom)
  result:=false;
  if QuestionDlg('Pergunta',pergunta,mtConfirmation,[1,2],1) = 1 then
  result:=true;
end;

end.

