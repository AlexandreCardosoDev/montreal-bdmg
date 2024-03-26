program Tarefas;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {frmPrincipal},
  uTarefas in 'forms\uTarefas.pas' {frmTarefas},
  udmAPI in 'forms\udmAPI.pas' {dmAPI: TDataModule},
  uTarefaEdit in 'forms\uTarefaEdit.pas' {frmTarefaEdit},
  uTarefaEstatistica in 'forms\uTarefaEstatistica.pas' {frmTarefaEstatistica};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TdmAPI, dmAPI);
  Application.Run;
end.
