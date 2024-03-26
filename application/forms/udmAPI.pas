unit udmAPI;

interface

uses
  System.SysUtils, System.Classes, REST.Types, REST.Client,
  REST.Authenticator.Basic, Data.Bind.Components, Data.Bind.ObjectScope;

type
  TdmAPI = class(TDataModule)
    RESTClient: TRESTClient;
    reqTarefasGet: TRESTRequest;
    HTTPBasicAuthenticator: THTTPBasicAuthenticator;
    reqTarefaDelete: TRESTRequest;
    reqTarefaIDGet: TRESTRequest;
    reqTarefaAddEdit: TRESTRequest;
    reqTarefaEstatistica: TRESTRequest;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmAPI: TdmAPI;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
