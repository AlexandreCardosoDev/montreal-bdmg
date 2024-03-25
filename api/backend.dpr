program backend;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  System.JSON,
  Controller.Tarefa in 'controller\Controller.Tarefa.pas',
  Connection in 'model\Connection.pas',
  Model.Tarefa in 'model\Model.Tarefa.pas',
  Auth in 'middleware\Auth.pas';

begin
    THorse.Use(Jhonson());

    //Adicionando middleware Autenticacao
    Auth.Autenticacao;

    //Adicionando Rotas
    Controller.Tarefa.Router;

    ///Rodando API
    Writeln('Servidor Rodando na porta 9000');
    THorse.Listen(9000);
end.
