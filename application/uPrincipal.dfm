object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Gerenciador de Tarefas'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu
  WindowState = wsMaximized
  TextHeight = 15
  object MainMenu: TMainMenu
    Left = 192
    Top = 168
    object CadastrodeTarefa: TMenuItem
      Caption = 'Cadastro de Tarefa'
      OnClick = CadastrodeTarefaClick
    end
    object Estatsticas1: TMenuItem
      Caption = 'Estat'#237'sticas'
      OnClick = Estatsticas1Click
    end
  end
end
