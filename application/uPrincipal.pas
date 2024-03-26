unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus;

type
  TfrmPrincipal = class(TForm)
    MainMenu: TMainMenu;
    CadastrodeTarefa: TMenuItem;
    Estatsticas1: TMenuItem;
    procedure CadastrodeTarefaClick(Sender: TObject);
    procedure Estatsticas1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  uTarefas, uTarefaEstatistica;

{$R *.dfm}

procedure TfrmPrincipal.CadastrodeTarefaClick(Sender: TObject);
begin
  frmTarefas := TfrmTarefas.Create(nil);
  frmTarefas.ShowModal;
end;

procedure TfrmPrincipal.Estatsticas1Click(Sender: TObject);
begin
    frmTarefaEstatistica := TfrmTarefaEstatistica.Create(nil);
    frmTarefaEstatistica.btnAtualizarClick(nil);
    frmTarefaEstatistica.ShowModal;
end;

end.
