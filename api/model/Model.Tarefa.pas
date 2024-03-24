unit Model.Tarefa;

interface

uses System.SysUtils, Data.DB, FireDAC.Comp.Client, Connection;

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

        function ListarTarefa(out erro: string): TFDQuery;
        function Inserir(out erro: string): Boolean;
        function Excluir(out erro: string): Boolean;
        function EditarStatus(out erro: string): Boolean;
        function RetornarStatistica(out erro: string): TFDQuery;
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

function TTarefa.EditarStatus(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Connection.FConnection;
        //Atualiza Tarefa
        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('UPDATE Tarefas SET Status = :Status ');
            IF STATUS = 'C' then
              SQL.Add(', DataConclusao = GETDATE() ');
            SQL.Add('WHERE IdTarefa = :IdTarefa');
            ParamByName('Status').Value := STATUS;
            ParamByName('IdTarefa').Value := ID_TAREFA;
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
    qry: TFDQuery;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Connection.FConnection;
        //Deleta Tarefa
        with qry do
        begin
            Active := false;
            SQL.Clear;
            SQL.Add('DELETE Tarefas WHERE IdTarefa = :IdTarefa');
            ParamByName('IdTarefa').Value := ID_TAREFA;
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
    qry : TFDQuery;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Connection.FConnection;
        //Adiciona Tarefa
        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('INSERT INTO Tarefas (Descricao, Status, Prioridade, InseridoEm) ');
            SQL.Add('VALUES(:Descricao, :Status, :Prioridade, GETDATE()) ');
            SQL.Add('Select IdTarefa = SCOPE_IDENTITY()');

            ParamByName('Descricao').Value := DESCRICAO;
            ParamByName('Status').Value := STATUS;
            ParamByName('Prioridade').Value := PRIORIDADE;
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

function TTarefa.ListarTarefa(out erro: string): TFDQuery;
var
    qry : TFDQuery;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Connection.FConnection;
        //Lista Tarefa
        with qry do
        begin
            Active := False;
            sql.Clear;
            SQL.Add('SELECT * FROM Tarefas WHERE 1=1');
            if ID_TAREFA > 0 then
            begin
                SQL.Add('AND IdTarefa = :IdTarefa');
                ParamByName('IdTarefa').Value := ID_TAREFA;
            end;
            SQL.Add('ORDER BY Descricao');
            Open;
            Active := True;
        end;

        erro := '';
        result := qry;

    except on ex:exception do
        begin
            erro := 'Erro ao listar tarefa: ' + ex.Message;
            Result := nil;
        end;
    end;
end;

function TTarefa.RetornarStatistica(out erro: string): TFDQuery;
var
    qry : TFDQuery;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Connection.FConnection;
        //Atualiza Tarefa
        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('SELECT '+
                    'ISNULL((SELECT COUNT(*) FROM Tarefas),0) AS Total_Tarefas,'+
                    'ISNULL((SELECT SUM(Prioridade) / COUNT(*) FROM Tarefas WHERE STATUS = ''P''),0) AS Media_Pendente,'+
                    'ISNULL((SELECT COUNT(*) FROM Tarefas WHERE DATEDIFF(DAY, DataConclusao, GETDATE()) < 7),0) AS Concluidas_Ultimos_7_DIAS');
            Open;
            Active := True;
        end;

        erro := '';
        result := qry;

    except on ex:exception do
        begin
            erro := 'Erro ao retornar estatistica das tarefas: ' + ex.Message;
            Result := nil;
        end;
    end;
end;

end.


