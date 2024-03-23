unit Model.Tarefa;

interface

uses System.SysUtils, Data.DB, Data.Win.ADODB, Connection;

type
    TTarefa = class
    private
        FID_TAREFA: Integer;
        FDESCRICAO: string;
        FSTATUS: string;
        FPRIORIDADE: Integer;
        FINSERIDO_EM: TDateTime;
        FDATA_CONCLUSAO: TDateTime;
    public
        constructor Create;
        destructor Destroy; override;
        property ID_TAREFA : Integer read FID_TAREFA write FID_TAREFA;
        property DESCRICAO : string read FDESCRICAO write FDESCRICAO;
        property STATUS : string read FSTATUS write FSTATUS;
        property PRIORIDADE : Integer read FPRIORIDADE write FPRIORIDADE;
        property INSERIDO_EM : TDateTime read FINSERIDO_EM write FINSERIDO_EM;
        property DATA_CONCLUSAO : TDateTime read FDATA_CONCLUSAO write FDATA_CONCLUSAO;

        function ListarTarefa(out erro: string): TADOQuery;
        function Inserir(out erro: string): Boolean;
        function Excluir(out erro: string): Boolean;
        function Editar(out erro: string): Boolean;
end;

implementation

{ TTarefa }

constructor TTarefa.Create;
begin
    Connection.Connect;
end;

destructor TTarefa.Destroy;
begin
    Connection.Disconect;
end;

function TTarefa.Editar(out erro: string): Boolean;
var
    qry : TADOQuery;
begin
    try
        qry := TADOQuery.Create(nil);
        qry.Connection := Connection.ConexaoADO;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('UPDATE Tarefas SET       '+
                    'Descricao = :Descricao,  '+
                    'Status = :Status,        '+
                    'Prioridade = :Prioridade '+
                    'DataConclusao = :DataConclusao ');
            SQL.Add('WHERE IdTarefa = :IdTarefa');
            Parameters.ParamByName('Descricao').Value := DESCRICAO;
            Parameters.ParamByName('Status').Value := STATUS;
            Parameters.ParamByName('Prioridade').Value := PRIORIDADE;
            Parameters.ParamByName('DataConclusao').Value := DATA_CONCLUSAO;
            Parameters.ParamByName('IdTarefa').Value := ID_TAREFA;
            ExecSQL;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao alterar tarefa: ' + ex.Message;
            Result := false;
        end;
    end;
end;

function TTarefa.Excluir(out erro: string): Boolean;
var
    qry: TADOQuery;
begin
    try
        qry := TADOQuery.Create(nil);
        qry.Connection := Connection.ConexaoADO;

        with qry do
        begin
            Active := false;
            SQL.Clear;
            SQL.Add('DELETE Tarefas WHERE IdTarefa = :IdTarefa');
            Parameters.ParamByName('IdTarefa').Value := ID_TAREFA;
            ExecSQL;
        end;

        qry.Free;
        erro := '';
        result := True;

    except on ex:exception do
      begin
          erro := 'Erro ao excluir tarefa: ' + ex.Message;
          Result := False;
      end;
    end;
end;

function TTarefa.Inserir(out erro: string): Boolean;
var
    qry : TADOQuery;
begin
    try
        qry := TADOQuery.Create(nil);
        qry.Connection := Connection.ConexaoADO;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('INSERT INTO Tarefas (Descricao, Status, Prioridade, InseridoEm) ');
            SQL.Add('VALUES(:Descricao, :Status, :Prioridade, GETDATE()) ');
            SQL.Add('Select IdTarefa = SCOPE_IDENTITY()');

            Parameters.ParamByName('Descricao').Value := DESCRICAO;
            Parameters.ParamByName('Status').Value := STATUS;
            Parameters.ParamByName('Prioridade').Value := PRIORIDADE;
            Open;
        end;

        ID_TAREFA := qry.FieldByName('IdTarefa').AsInteger;
        qry.Active := True;
        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao cadastrar tarefa: ' + ex.Message;
            Result := false;
        end;
    end;
end;

function TTarefa.ListarTarefa(out erro: string): TADOQuery;
var
    qry : TADOQuery;
begin
    try
        qry := TADOQuery.Create(nil);
        qry.Connection := Connection.ConexaoADO;

        with qry do
        begin
            Active := False;
            sql.Clear;
            SQL.Add('SELECT * FROM Tarefas WHERE 1=1');
            if ID_TAREFA > 0 then
            begin
                SQL.Add('AND IdTarefa = :IdTarefa');
                Parameters.ParamByName('IdTarefa').Value := ID_TAREFA;
            end;
            SQL.Add('ORDER BY Descricao');
            Open;
            Active := True;
        end;

        erro := '';
        result := qry;

    except on ex:exception do
        begin
            erro := 'Erro ao liestar tarefa: ' + ex.Message;
            Result := nil;
        end;
    end;
end;

end.


