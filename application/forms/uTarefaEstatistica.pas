unit uTarefaEstatistica;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls, System.JSON;

type
  TfrmTarefaEstatistica = class(TForm)
    edtTotalTarefa: TLabeledEdit;
    edtMediaPendente: TLabeledEdit;
    edtConcluidasUltimos7Dias: TLabeledEdit;
    btnAtualizar: TButton;
    procedure btnAtualizarClick(Sender: TObject);
  private
    { Private declarations }
    function BuscarDadosAPI(out erro: string): TJsonValue;
  public
    { Public declarations }
  end;

var
  frmTarefaEstatistica: TfrmTarefaEstatistica;

implementation

uses
  udmAPI;

{$R *.dfm}

procedure TfrmTarefaEstatistica.btnAtualizarClick(Sender: TObject);
var
    Estatistica : TJSONValue;
    erro : string;
    total, media, concluido : integer;
begin
    Estatistica := BuscarDadosAPI(erro);

    total := Estatistica.GetValue<integer>('totalTarefas', 0);
    media := Estatistica.GetValue<integer>('mediaPendente', 0);
    concluido := Estatistica.GetValue<integer>('concluidasUltimos7Dias', 0);

    Estatistica.DisposeOf;

    edtTotalTarefa.Text := total.ToString;
    edtMediaPendente.Text := media.ToString;
    edtConcluidasUltimos7Dias.Text := concluido.ToString;
end;

function TfrmTarefaEstatistica.BuscarDadosAPI(out erro: string): TJsonValue;
var
    jsonEstatistica : TJsonValue;
    json : string;
begin
    try
        Result := nil;
        erro := '';

        dmAPI.reqTarefaEstatistica.Resource := 'tarefas/estatistica';
        dmAPI.reqTarefaEstatistica.Execute;

        // Tratar retorno...
        if (dmAPI.reqTarefaEstatistica.Response.StatusCode  <> 200) then
        begin
            erro := 'Erro ao buscar dados: ';
            exit;
        end;

        json := dmAPI.reqTarefaEstatistica.Response.JSONValue.ToString;
        jsonEstatistica := TJSONObject.ParseJSONValue(
                          TEncoding.UTF8.GetBytes(json), 0) as TJsonValue;

        Result := jsonEstatistica;

    except on ex:exception do
        erro := 'Ocorreu um erro: ' + ex.Message;
    end;
end;


end.


