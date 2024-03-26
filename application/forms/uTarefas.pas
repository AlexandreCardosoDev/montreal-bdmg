unit uTarefas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ToolWin, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, System.ImageList, Vcl.ImgList, System.JSON, DateUtils;

type
  TfrmTarefas = class(TForm)
    lvTarefas: TListView;
    BitBtnEditar: TBitBtn;
    Panel: TPanel;
    BitBtnAdicionar: TBitBtn;
    BitBtnExcluir: TBitBtn;
    ImageList: TImageList;
    procedure FormShow(Sender: TObject);
    procedure BitBtnEditarClick(Sender: TObject);
    procedure BitBtnExcluirClick(Sender: TObject);
    function ISO8601ToDateTime(const ISO8601DateTime: string): TDateTime;
    procedure BitBtnAdicionarClick(Sender: TObject);
    procedure GetTarefas;
  private
    { Private declarations }
    procedure AdicionarTarefaListView(id_tarefa: integer; descricao, status: string; prioridade: integer; inserido_em, data_conclusao: string);
    procedure ProcessarGET;
    procedure ProcessarGETErro(Sender: TObject);
    function DeletarTarefa(id_tarefa: integer; out erro: string): boolean;
    function VerificaItemSelecionado(listview: TListView): Integer;
  public
    { Public declarations }
  end;

var
  frmTarefas: TfrmTarefas;

implementation

{$R *.dfm}

uses udmAPI, uTarefaEdit;

{ TfrmTarefas }

procedure TfrmTarefas.AdicionarTarefaListView(id_tarefa: integer; descricao,
  status: string; prioridade: integer; inserido_em, data_conclusao: string);
var
   Item: TListItem;
begin
    Item := lvTarefas.Items.Add;
    Item.Caption := id_tarefa.ToString;
    Item.SubItems.Add(descricao);
    Item.SubItems.Add(status);
    Item.SubItems.Add(prioridade.ToString);
    Item.SubItems.Add(ISO8601ToDateTime(inserido_em).ToString);
    if NOT data_conclusao.IsEmpty then
        Item.SubItems.Add(ISO8601ToDateTime(data_conclusao).ToString);
end;

procedure TfrmTarefas.BitBtnAdicionarClick(Sender: TObject);
begin
    frmTarefaEdit := TfrmTarefaEdit.Create(nil);
    frmTarefaEdit.LimparCampos;
    frmTarefaEdit.Adicionar;
    frmTarefaEdit.ShowModal;
end;

procedure TfrmTarefas.BitBtnEditarClick(Sender: TObject);
var
  itemSelecionado : integer;
begin
    itemSelecionado := VerificaItemSelecionado(lvTarefas);
    if itemSelecionado > 0 then
    begin
        frmTarefaEdit := TfrmTarefaEdit.Create(nil);
        frmTarefaEdit.LimparCampos;
        frmTarefaEdit.Editar;
        //Carregar Dados API
        frmTarefaEdit.CarregarDados(itemSelecionado);
        frmTarefaEdit.ShowModal;
    end
    else
      ShowMessage('Selecione um registro')
end;

procedure TfrmTarefas.BitBtnExcluirClick(Sender: TObject);
var
    itemSelecionado : integer;
    erro : string;
begin
    itemSelecionado := VerificaItemSelecionado(lvTarefas);
    if itemSelecionado > 0 then
    begin
        if MessageDlg('Confirma exlusão do item: ' + IntToStr(itemSelecionado), mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
        begin
          //chamar api de exclusao
          if NOT DeletarTarefa(itemSelecionado, erro) then
              showmessage(erro)
          else
            GetTarefas;
        end;
    end
    else
      ShowMessage('Selecione um registro para ser deletado')
end;

function TfrmTarefas.DeletarTarefa(id_tarefa: integer;
  out erro: string): boolean;
begin
    try
        Result := false;
        erro := '';

        dmAPI.reqTarefaDelete.Resource := 'tarefa/' + id_tarefa.ToString;
        dmAPI.reqTarefaDelete.Execute;

        // Tratar retorno...
        if (dmAPI.reqTarefaDelete.Response.StatusCode  <> 200) then
        begin
            erro := 'Erro ao excluir dados: ';
            exit;
        end;

        Result := true;

    except on ex:exception do
        erro := 'Ocorreu um erro: ' + ex.Message;
    end;
end;

procedure TfrmTarefas.FormShow(Sender: TObject);
begin
  GetTarefas;
end;

procedure TfrmTarefas.GetTarefas;
begin
    lvTarefas.Items.Clear;

    try
        dmAPI.reqTarefasGet.ExecuteAsync(ProcessarGET, true, true, ProcessarGETErro);
    except on ex:exception do
        showmessage('Erro ao acessar o servidor: ' + ex.Message);
    end;
end;

procedure TfrmTarefas.ProcessarGET;
var
    json : string;
    arrayTarefas : TJsonArray;
    i : integer;
    Item: TListItem;

begin
    if dmAPI.reqTarefasGet.Response.StatusCode  <> 200 then
    begin
        showmessage('Ocorreu um erro na consulta: ' +
        dmAPI.reqTarefasGet.Response.StatusCode.ToString);
    end;

    try
        lvTarefas.Items.BeginUpdate;

        json := dmAPI.reqTarefasGet.Response.JSONValue.ToString;
        arrayTarefas := TJSONObject.ParseJSONValue(
                          TEncoding.UTF8.GetBytes(json), 0) as TJSONArray;

        for i := 0 to arrayTarefas.Size - 1 do
          AdicionarTarefaListView(
                          arrayTarefas.Get(i).GetValue<integer>('idtarefa', 0),
                          arrayTarefas.Get(i).GetValue<string>('descricao', ''),
                          arrayTarefas.Get(i).GetValue<string>('status', ''),
                          arrayTarefas.Get(i).GetValue<integer>('prioridade', 0),
                          arrayTarefas.Get(i).GetValue<string>('inseridoem', ''),
                          arrayTarefas.Get(i).GetValue<string>('dataconclusao', '')
                          );
        arrayTarefas.DisposeOf;

    finally
        lvTarefas.Items.EndUpdate;
    end;
end;

procedure TfrmTarefas.ProcessarGETErro(Sender: TObject);
begin
    if Assigned(Sender) and (Sender is Exception) then
        showmessage(Exception(Sender).Message);
end;

function TfrmTarefas.VerificaItemSelecionado(listview: TListView): Integer;
var
    SelectedItem: TListItem;
begin
    Result := 0;
    SelectedItem := listview.Selected;
    if Assigned(SelectedItem) then
    begin
      Result := StrToInt(SelectedItem.Caption);
    end;
end;

function TfrmTarefas.ISO8601ToDateTime(const ISO8601DateTime: string): TDateTime;
var
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
  // Extrair os componentes da data e hora da string ISO8601
  if Length(ISO8601DateTime) < 19 then
    raise Exception.Create('String de data e hora inválida');

  Year := StrToInt(Copy(ISO8601DateTime, 1, 4));
  Month := StrToInt(Copy(ISO8601DateTime, 6, 2));
  Day := StrToInt(Copy(ISO8601DateTime, 9, 2));
  Hour := StrToInt(Copy(ISO8601DateTime, 12, 2));
  Min := StrToInt(Copy(ISO8601DateTime, 15, 2));
  Sec := StrToInt(Copy(ISO8601DateTime, 18, 2));

  // Extrair os milissegundos, se presente
  MSec := 0;
  if Length(ISO8601DateTime) >= 23 then
    MSec := StrToInt(Copy(ISO8601DateTime, 21, 3));

  // Construir o TDateTime
  Result := EncodeDateTime(Year, Month, Day, Hour, Min, Sec, MSec);

  // Ajuste para fuso horário UTC
  Result := Result - TTimeZone.Local.UtcOffset;
end;


end.
