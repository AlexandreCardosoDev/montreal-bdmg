program backend;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  System.JSON,
  Controller.Tarefa in 'controller\Controller.Tarefa.pas';

begin
  THorse.Use(Jhonson());
  THorse.Listen(9000);
end.
