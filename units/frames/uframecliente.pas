unit uframeCliente;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, ExtCtrls,
  ComCtrls, Spin, StdCtrls,Graphics;

type

  { TfraCliente }

  TfraCliente = class(TFrame)
    edtNascimento: TDateTimePicker;
    edtDataCadastro: TDateTimePicker;
    edtNome: TLabeledEdit;
    edtEndereco: TLabeledEdit;
    edtCPF: TLabeledEdit;
    edtTelefone1: TLabeledEdit;
    edtTelefone2: TLabeledEdit;
    edtEmail: TLabeledEdit;
    edtRG: TLabeledEdit;
    lblNascimento: TLabel;
    lblPerfil: TLabel;
    lblDtCadastro: TLabel;
    edtCidade: TLabeledEdit;
    edtBairro: TLabeledEdit;
    lblSituacao: TLabel;
    spnPerfil: TSpinEdit;
  private
    { private declarations }
  public
    { public declarations }
    function valida:boolean;
    procedure limpa;
  end;

implementation

{$R *.lfm}

{ TfraCliente }

function TfraCliente.valida: boolean;
begin
  result:=true;
  if Length(edtTelefone1.Text)< 5 then
  begin
    edtTelefone1.EditLabel.Font.Color:=clRed;
    edtTelefone1.setfocus;
    result:=false;
  end
  else
    edtTelefone1.EditLabel.Font.Color:=clBlack;
  if Length(edtEmail.Text)< 5 then
  begin
    edtEmail.EditLabel.Font.Color:=clRed;
    edtEmail.setfocus;
    result:=false;
  end
  else
    edtEmail.EditLabel.Font.Color:=clBlack;
 if Length(edtCidade.Text)< 5 then
  begin
    edtCidade.EditLabel.Font.Color:=clRed;
    edtCidade.setfocus;
    result:=false;
  end
  else
    edtCidade.EditLabel.Font.Color:=clBlack;
  if Length(edtBairro.Text)< 5 then
  begin
    edtBairro.EditLabel.Font.Color:=clRed;
    edtBairro.setfocus;
    result:=false;
  end
  else
    edtBairro.EditLabel.Font.Color:=clBlack;
  if Length(edtEndereco.Text)< 5 then
  begin
    edtEndereco.EditLabel.Font.Color:=clRed;
    edtEndereco.setfocus;
    result:=false;
  end
  else
    edtEndereco.EditLabel.Font.Color:=clBlack;
  if edtNascimento.DateIsNull then
  begin
    lblNascimento.Font.Color:=clRed;
    edtNascimento.setfocus;
    result:=false;
  end
  else
    lblNascimento.Font.Color:=clBlack;
  if Length(edtRG.Text)< 5 then
  begin
    edtRG.EditLabel.Font.Color:=clRed;
    edtRG.setfocus;
    result:=false;
  end
  else
    edtRG.EditLabel.Font.Color:=clBlack;
  if Length(edtCPF.Text)< 5 then
  begin
    edtCPF.EditLabel.Font.Color:=clRed;
    edtCPF.setfocus;
    result:=false;
  end
  else
    edtCPF.EditLabel.Font.Color:=clBlack;
  if Length(edtNome.Text)< 5 then
  begin
    edtNome.EditLabel.Font.Color:=clRed;
    edtNome.setfocus;
    result:=false;
  end
  else
    edtNome.EditLabel.Font.Color:=clBlack;
end;

procedure TfraCliente.limpa;
begin
    edtNome.EditLabel.Font.Color:=clBlack;
    edtCPF.EditLabel.Font.Color:=clBlack;
    edtRG.EditLabel.font.Color:=clBlack;
    lblNascimento.font.Color:=clBlack;
    edtEndereco.EditLabel.Font.Color:=clBlack;
    edtBairro.EditLabel.Font.Color:=clBlack;
    edtCidade.EditLabel.Font.Color:=clBlack;
    edtEmail.EditLabel.Font.Color:=clBlack;
    edtTelefone1.EditLabel.Font.Color:=clBlack;

    edtNome.Text:='';
    edtCPF.Text:='';
    edtrg.Text:='';
    edtNascimento.Date:=NullDate;
    edtEndereco.Text:='';
    edtBairro.Text:='';
    edtCidade.Text:='';
    edtEmail.Text:='';
    edtDataCadastro.Date:=Date;
    edtTelefone1.Text:='';
    edtTelefone2.Text:='';
end;

end.

