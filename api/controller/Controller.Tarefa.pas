unit Controller.Tarefa;

interface

uses
  Horse, Horse.Jhonson, System.JSON, System.SysUtils, Model.Tarefa,
  FireDAC.Comp.Client, Data.DB, DataSet.Serialize;

procedure Router;
function ParamRequired(nome, tipo: string) : string;

implementation

procedure ListarTarefas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
    tarefa : TTarefa;
    qry : TFDQuery;
    erro : string;
    arrayTarefas: TJSONArray;
begin
    try
        tarefa := TTarefa.Create;
    except
        res.Send('Erro ao conectar com o banco').Status(500);
        exit;
    end;

    try
      qry := tarefa.ListarTarefa(erro);
      arrayTarefas := qry.ToJSONArray();
      res.Send<TJSONArray>(arrayTarefas);
    finally
      qry.Free;
      tarefa.Free;
    end;
end;

procedure ListarTarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
    tarefa : TTarefa;
    qry : TFDQuery;
    erro : string;
    ojbTarefa: TJSONObject;
    id : integer;
begin
    //Valida ID Parametro
    try
        id := Req.Params['id'].ToInteger;
        if id <= 0 then
        begin
          res.Send('Parametro id deve ser maior que 0').Status(400);
          exit;
        end;
    except
        res.Send(ParamRequired('id','queryParameter')).Status(400);
        exit;
    end;                                                             

    //Busca Tarefa
    try
        tarefa := TTarefa.Create;
        tarefa.ID_TAREFA := id;
    except
        res.Send('Erro ao conectar com o banco').Status(500);
        exit;
    end;
  
    try
        qry := tarefa.ListarTarefa(erro);
        //Valida se achou algum registro
        if qry.RecordCount > 0 then
        begin
            ojbTarefa := qry.ToJSONObject();
            res.Send<TJSONObject>(ojbTarefa);
        end
        else 
            res.Send('Tarefa não encontrada').Status(404);         

    finally
        qry.Free;
        tarefa.Free;
    end;
end;

procedure AdicionarTarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
    tarefa : TTarefa;
    erro : string;
    objTarefa: TJSONObject;
    body  : TJsonValue;
begin
    //Criar Tarefa
    try
        tarefa := TTarefa.Create;
    except
        res.Send('Erro ao conectar com o banco').Status(500);
        exit;
    end;


    try
        try
            //Receber Campos
            body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;

            tarefa.DESCRICAO := body.GetValue<string>('descricao', '');
            tarefa.STATUS := body.GetValue<string>('status', '');
            tarefa.PRIORIDADE := body.GetValue<string>('prioridade', '').ToInteger;

            //Validar Campos
            if (tarefa.DESCRICAO.IsEmpty) and
                (tarefa.STATUS.IsEmpty) and
                (tarefa.PRIORIDADE <= 0) then
            begin
                res.Send('Corpo da mensagem deve ter: descricao, status, prioridade').Status(400);
                exit;
            end;

            if (tarefa.DESCRICAO.IsEmpty) then
            begin
                res.Send(ParamRequired('Descricao', 'string')).Status(400);
                exit;
            end;

            if (tarefa.STATUS.IsEmpty) then
            begin
                res.Send(ParamRequired('Status', 'string')).Status(400);
                exit;
            end;

            if (tarefa.PRIORIDADE <= 0) then
            begin
                res.Send('Parametro: Prioridade deve ser maior que zero').Status(400);
                exit;
            end;

            //Inserir Registro
            tarefa.Inserir(erro);

            body.Free;

            if erro <> '' then
                raise Exception.Create(erro);

        except on ex:exception do
            begin
                res.Send(ex.Message).Status(400);
                exit;
            end;
        end;


        objTarefa := TJSONObject.Create;
        objTarefa.AddPair('IdTarefa', tarefa.ID_TAREFA.ToString);

        res.Send<TJSONObject>(objTarefa).Status(201);
    finally
        tarefa.Free;
    end;

end;

procedure AtualizarStatusTarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
    tarefa : TTarefa;
    qry : TFDQuery;
    erro : string;
    novoStatus: string;
    id : integer;
    body  : TJsonValue;
    ojbTarefa : TJSONObject;
begin
    //Valida ID Parametro
    try
        id := Req.Params['id'].ToInteger;
        if id <= 0 then
        begin
          res.Send('Parametro id deve ser maior que 0').Status(400);
          exit;
        end;
    except
        res.Send(ParamRequired('id','queryParameter')).Status(400);
        exit;
    end;

    //Valida Status
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;
    novoStatus := body.GetValue<string>('status', '');

    if novoStatus.IsEmpty then
    begin
        res.Send(ParamRequired('status','string')).Status(400);
        exit;
    end;


    //Busca Tarefa
    try
        tarefa := TTarefa.Create;
        tarefa.ID_TAREFA := id;
    except
        res.Send('Erro ao conectar com o banco').Status(500);
        exit;
    end;

    try
        qry := tarefa.ListarTarefa(erro);
        //Valida se achou algum registro
        if qry.RecordCount > 0 then
        begin
            tarefa.STATUS := novoStatus;
            tarefa.EditarStatus(erro);
            qry := tarefa.ListarTarefa(erro);
            ojbTarefa := qry.ToJSONObject();
            res.Send<TJSONObject>(ojbTarefa);
        end
        else
            res.Send('Tarefa não encontrada').Status(404);

    finally
        qry.Free;
        tarefa.Free;
    end;
end;

procedure DeletarTarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
    tarefa : TTarefa;
    qry : TFDQuery;
    erro : string;
    ojbTarefa: TJSONObject;
    id : integer;
begin
    //Valida ID Parametro
    try
        id := Req.Params['id'].ToInteger;
        if id <= 0 then
        begin
          res.Send('Parametro id deve ser maior que 0').Status(400);
          exit;
        end;
    except
        res.Send(ParamRequired('id','queryParameter')).Status(400);
        exit;
    end;

    //Busca Tarefa
    try
        tarefa := TTarefa.Create;
        tarefa.ID_TAREFA := id;
    except
        res.Send('Erro ao conectar com o banco').Status(500);
        exit;
    end;

    try
        qry := tarefa.ListarTarefa(erro);
        //Valida se achou algum registro
        if qry.RecordCount > 0 then
        begin
            tarefa.Excluir(erro);
            res.Send('Tarefa excluída');
        end
        else
            res.Send('Tarefa não encontrada').Status(404);

    finally
        qry.Free;
        tarefa.Free;
    end;
end;

procedure EstatisticaTarefas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
    tarefa : TTarefa;
    qry : TFDQuery;
    erro : string;
    ojbTarefa: TJSONObject;
begin
    try
        tarefa := TTarefa.Create;
    except
        res.Send('Erro ao conectar com o banco').Status(500);
        exit;
    end;

    try
      qry := tarefa.RetornarStatistica(erro);
      ojbTarefa := qry.ToJSONObject();
      res.Send<TJSONObject>(ojbTarefa);
    finally
      qry.Free;
      tarefa.Free;
    end;
end;

function ParamRequired(nome, tipo: string) : string;
begin
  Result := 'Parametro: '+ nome + ' (type: ' +tipo+ ') é obrigatório'
end;

procedure Router;
var
  v1: string;
begin
  v1 := '/api/v1';
  //listar todas as tarefas
  THorse.Get(v1+'/tarefas', ListarTarefas);
  //listar tarefa
  THorse.Get(v1+'/tarefa/:id', ListarTarefa);
  //adicionar tarefa
  THorse.Post(v1+'/tarefa', AdicionarTarefa);
  //atualizar status da tarefa
  THorse.Put(v1+'/tarefa/:id', AtualizarStatusTarefa);
  //remover tarefa
  THorse.Delete(v1+'/tarefa/:id', DeletarTarefa);
  //listar todas as tarefas
  THorse.Get(v1+'/tarefas/estatistica', EstatisticaTarefas);
end;

end.
