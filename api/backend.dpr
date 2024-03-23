program backend;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  System.JSON,
  Controller.Tarefa in 'controller\Controller.Tarefa.pas',
  Connection in 'model\Connection.pas',
  Model.Tarefa in 'model\Model.Tarefa.pas';

begin
  THorse.Use(Jhonson());
  Controller.Tarefa.Router;
  THorse.Listen(9000);
end.
