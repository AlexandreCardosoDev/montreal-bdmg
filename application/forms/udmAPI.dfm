object dmAPI: TdmAPI
  Height = 480
  Width = 640
  object RESTClient: TRESTClient
    Authenticator = HTTPBasicAuthenticator
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'http://localhost:9000/api/v1'
    Params = <>
    SynchronizedEvents = False
    Left = 32
    Top = 8
  end
  object reqTarefasGet: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient
    Params = <>
    Resource = 'tarefas'
    SynchronizedEvents = False
    Left = 32
    Top = 64
  end
  object HTTPBasicAuthenticator: THTTPBasicAuthenticator
    Username = 'BDMG'
    Password = 'admin'
    Left = 192
    Top = 8
  end
  object reqTarefaDelete: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient
    Method = rmDELETE
    Params = <>
    Resource = 'tarefa/id'
    SynchronizedEvents = False
    Left = 32
    Top = 128
  end
  object reqTarefaIDGet: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient
    Params = <>
    Resource = 'tarefa/id'
    SynchronizedEvents = False
    Left = 32
    Top = 192
  end
  object reqTarefaAddEdit: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient
    Params = <>
    Resource = 'tarefa'
    SynchronizedEvents = False
    Left = 192
    Top = 64
  end
  object reqTarefaEstatistica: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient
    Params = <>
    Resource = 'tarefas/estatistica'
    SynchronizedEvents = False
    Left = 192
    Top = 128
  end
end
