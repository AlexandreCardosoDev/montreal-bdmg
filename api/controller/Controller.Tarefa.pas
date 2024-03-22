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
  THorse.Get('/tarefas', ListarTarefas);
  //adicionar tarefa
  THorse.Post('/tarefa', AdicionarTarefa);
  //atualizar status da tarefa
  THorse.Put('/tarefa', AtualizarTarefa);
  //remover tarefa
  THorse.Delete('/tarefa', DeletarTarefa);
end;

end.
