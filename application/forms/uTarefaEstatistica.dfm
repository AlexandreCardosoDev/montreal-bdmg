object frmTarefaEstatistica: TfrmTarefaEstatistica
  Left = 0
  Top = 0
  Caption = 'Tarefa Estat'#237'sticas'
  ClientHeight = 161
  ClientWidth = 528
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  TextHeight = 15
  object edtTotalTarefa: TLabeledEdit
    Left = 64
    Top = 32
    Width = 129
    Height = 23
    EditLabel.Width = 127
    EditLabel.Height = 15
    EditLabel.Caption = 'N'#250'mero Total de Tarefas'
    ReadOnly = True
    TabOrder = 0
    Text = ''
  end
  object edtMediaPendente: TLabeledEdit
    Left = 64
    Top = 80
    Width = 225
    Height = 23
    EditLabel.Width = 224
    EditLabel.Height = 15
    EditLabel.Caption = 'M'#233'dia de Prioridade das Tarefas Pendentes'
    ReadOnly = True
    TabOrder = 1
    Text = ''
  end
  object edtConcluidasUltimos7Dias: TLabeledEdit
    Left = 64
    Top = 128
    Width = 177
    Height = 23
    EditLabel.Width = 176
    EditLabel.Height = 15
    EditLabel.Caption = 'Tarefas Concluidas '#218'ltimos 7 Dias'
    ReadOnly = True
    TabOrder = 2
    Text = ''
  end
  object btnAtualizar: TButton
    Left = 368
    Top = 79
    Width = 75
    Height = 25
    Caption = 'Atualizar'
    TabOrder = 3
    OnClick = btnAtualizarClick
  end
end
