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
begin

end;

procedure AtualizarTarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
end;

procedure DeletarTarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
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
  THorse.Put(v1+'/tarefa', AtualizarTarefa);
  //remover tarefa
  THorse.Delete(v1+'/tarefa', DeletarTarefa);
end;

end.
