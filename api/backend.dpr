program backend;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  System.JSON,
  tarefaController in 'controller\tarefaController.pas';

begin
  THorse.Use(Jhonson());
  THorse.Listen(9000);
  tarefaController.Router;
end.
