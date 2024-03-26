unit uTarefaEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask,
  Vcl.Buttons, System.ImageList, Vcl.ImgList, System.JSON, DateUtils, REST.Types;

type
  TfrmTarefaEdit = class(TForm)
    edtDescricao: TLabeledEdit;
    edtPrioridade: TLabeledEdit;
    edtInseridoEm: TLabeledEdit;
    edtDataConclusao: TLabeledEdit;
    rgStatus: TRadioGroup;
    Panel: TPanel;
    btnCancelar: TBitBtn;
    ImageList: TImageList;
    btnSalvar: TBitBtn;
    edtID: TLabeledEdit;
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    { Private declarations }
    function Tarefa_Add_Edit(verbo: TRestRequestMethod; idTarefa, descricao, prioridade, status :string; out erro: string): boolean;
  public
    { Public declarations }
    procedure LimparCampos();
    procedure ValidarCampos();
    procedure Adicionar();
    procedure Editar();
    procedure CarregarDados(id: integer);
    function BuscarIdAPI(id_tarefa: integer; out erro: string): TJsonValue;
  end;

var
  frmTarefaEdit: TfrmTarefaEdit;

implementation

uses udmAPI, uTarefas;

{$R *.dfm}

{ TfrmTarefaEdit }

procedure TfrmTarefaEdit.Adicionar;
begin
    edtDescricao.ReadOnly := False;
    edtPrioridade.ReadOnly := False;
end;

procedure TfrmTarefaEdit.btnCancelarClick(Sender: TObject);
begin
    close;
end;

procedure TfrmTarefaEdit.btnSalvarClick(Sender: TObject);
var
    erro : string;
    verbo : TRESTRequestMethod;
    idTarefa, status : string;
begin
    // Inclusao
    if edtID.Text = '' then
    begin
        verbo := rmPOST;
         //Validar Campos
        ValidarCampos();
    end
    // Alteracao
    else
    begin
        verbo := rmPUT;
        idTarefa := edtID.Text;
    end;

    if rgStatus.ItemIndex = 0 then
      status := 'A'
    else if rgStatus.ItemIndex = 1 then
        status := 'E'
    else if rgStatus.ItemIndex = 2 then
        status := 'C'
    else
        status := 'X';

    if NOT Tarefa_Add_Edit(verbo,
                  idTarefa,
                  edtDescricao.Text,
                  edtPrioridade.Text,
                  status,
                  erro) then
        ShowMessage(erro)
    else
    begin
        frmTarefas.GetTarefas;
    end;
end;

procedure TfrmTarefaEdit.CarregarDados(id: integer);
var
    Tarefa : TJSONValue;
    erro : string;
    idtarefa, prioridade : integer;
    descricao, status,  inseridoem, dataconclusao : string;
begin
    Tarefa := BuscarIdAPI(id, erro);

    idtarefa := Tarefa.GetValue<integer>('idtarefa', 0);
    descricao := Tarefa.GetValue<string>('descricao', '');
    status := Tarefa.GetValue<string>('status', '');
    prioridade := Tarefa.GetValue<integer>('prioridade', 0);
    inseridoem := Tarefa.GetValue<string>('inseridoem', '');
    dataconclusao := Tarefa.GetValue<string>('dataconclusao', '');

    Tarefa.DisposeOf;

    edtID.Text := idtarefa.ToString;
    edtDescricao.Text := descricao;
    edtPrioridade.Text := prioridade.ToString;
    edtInseridoEm.Text := frmTarefas.ISO8601ToDateTime(inseridoem).ToString;
    if NOT dataconclusao.IsEmpty then
        edtDataConclusao.Text := frmTarefas.ISO8601ToDateTime(dataconclusao).ToString;

    if status = 'A' then
        rgStatus.ItemIndex := 0
    else if status = 'E' then
        rgStatus.ItemIndex := 1
    else if status = 'C' then
        rgStatus.ItemIndex := 2
    else
        rgStatus.ItemIndex := 3;
end;


procedure TfrmTarefaEdit.Editar;
begin
    edtDescricao.ReadOnly := True;
    edtPrioridade.ReadOnly := True;
end;

function TfrmTarefaEdit.BuscarIdAPI(id_tarefa: integer;
  out erro: string): TJsonValue;
var
    jsonTarefa : TJsonValue;
    json : string;
begin
    try
        Result := nil;
        erro := '';

        dmAPI.reqTarefaIDGet.Resource := 'tarefa/' + id_tarefa.ToString;
        dmAPI.reqTarefaIDGet.Execute;

        // Tratar retorno...
        if (dmAPI.reqTarefaIDGet.Response.StatusCode  <> 200) then
        begin
            erro := 'Erro ao buscar dados: ';
            exit;
        end;

        json := dmAPI.reqTarefaIDGet.Response.JSONValue.ToString;
        jsonTarefa := TJSONObject.ParseJSONValue(
                          TEncoding.UTF8.GetBytes(json), 0) as TJsonValue;

        Result := jsonTarefa;

    except on ex:exception do
        erro := 'Ocorreu um erro: ' + ex.Message;
    end;
end;


procedure TfrmTarefaEdit.LimparCampos;
begin
    edtID.Text := '';
    edtDescricao.Text := '';
    edtPrioridade.Text := '';
    edtInseridoEm.Text := '';
    edtDataConclusao.Text := '';
    edtInseridoEm.Text := '';
    rgStatus.ItemIndex := -1;
end;

function TfrmTarefaEdit.Tarefa_Add_Edit(verbo: TRestRequestMethod;
  idTarefa, descricao, prioridade, status :string; out erro: string): boolean;
var
    jsonBody : TJSONObject;
begin
    try
        try
            Result := false;
            erro := '';

            jsonBody := TJSONObject.Create;
            jsonBody.AddPair('status', status);

            if verbo = rmPOST then
            begin
                jsonBody.AddPair('descricao', descricao);
                jsonBody.AddPair('prioridade', prioridade);
                dmAPI.reqTarefaAddEdit.Resource := 'tarefa';
            end
            else
                dmAPI.reqTarefaAddEdit.Resource := 'tarefa/' + idTarefa;

            dmAPI.reqTarefaAddEdit.Params.Clear;
            dmAPI.reqTarefaAddEdit.Body.ClearBody;
            dmAPI.reqTarefaAddEdit.Method := verbo; // POST ou PUT
            dmAPI.reqTarefaAddEdit.Body.Add(jsonBody.ToString,
                                          ContentTypeFromString('application/json'));
            dmAPI.reqTarefaAddEdit.Execute;

            // Tratar retorno
            if (dmAPI.reqTarefaAddEdit.Response.StatusCode  <> 200) and
               (dmAPI.reqTarefaAddEdit.Response.StatusCode  <> 201) then
            begin
                erro := 'Erro ao salvar dados: ';
                exit;
            end;

            Result := true;

        except on ex:exception do
                erro := 'Ocorreu um erro: ' + ex.Message;
        end;
    finally
        jsonBody.DisposeOf;
    end;
end;

procedure TfrmTarefaEdit.ValidarCampos();
var
  prioridade : integer;
begin
    if TryStrToInt(edtPrioridade.Text, prioridade) then
    begin
        if prioridade <= 0 then
        begin
            ShowMessage('Campo Prioridade não pode menor que 0');
            abort;
        end;
    end
    else
    begin
        ShowMessage('Campo Prioridade não pode ser vazio');
        abort;
    end;

    if edtDescricao.Text = '' then
    begin
      ShowMessage('Campo Descrição não pode ser vazio');
      abort;
    end
    else if rgStatus.ItemIndex = -1 then
    begin
        ShowMessage('Campo Status não pode ser vazio');
        abort;
    end;
end;

end.
