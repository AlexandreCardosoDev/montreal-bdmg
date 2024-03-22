unit Controller.Tarefa;

interface

uses
  Horse,
  Horse.Jhonson,
  System.JSON,
  System.SysUtils;

procedure Router;

implementation

procedure ListarTarefas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin

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

procedure Router;
var
  v1: string;
begin
  v1 := '/api/v1';
  //listar todas as tarefas
  THorse.Get(v1+'/tarefas', ListarTarefas);
  //adicionar tarefa
  THorse.Post(v1+'/tarefa', AdicionarTarefa);
  //atualizar status da tarefa
  THorse.Put(v1+'/tarefa', AtualizarTarefa);
  //remover tarefa
  THorse.Delete(v1+'/tarefa', DeletarTarefa);
end;

end.
