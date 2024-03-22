unit Connection;

interface

uses Data.Win.ADODB, System.IniFiles, System.SysUtils;

var
   ConexaoADO: TADOConnection;

function SetupConnection(ADOConn: TADOConnection): String;
function Connect : TADOConnection;
procedure Disconect;

implementation

function SetupConnection(ADOConn: TADOConnection): String;
var
    server, database, user, password, arqIni : string;
    ini : TIniFile;
begin
    try
        try
            arqIni := GetCurrentDir + '\config.ini';

            // Verifica se INI existe
            if NOT FileExists(arqIni) then
            begin
                Result := 'Arquivo INI não encontrado: ' + arqIni;
                exit;
            end;

            // Instanciar arquivo INI
            ini := TIniFile.Create(arqIni);

            // Buscar dados do arquivo fisico...
           server   := ini.ReadString('BD', 'Server', EmptyStr);
           database := ini.ReadString('BD', 'DataBase', EmptyStr);
           user     := ini.ReadString('BD', 'User', EmptyStr);
           password := ini.ReadString('BD', 'Password', EmptyStr);

           ADOConn.ConnectionString := 'Provider=SQLNCLI11.1;Persist Security Info=False; '
                                     + 'User ID=' + user + ';'
                                     + 'Password=' + password + ';'
                                     + 'Initial Catalog=' + database + ';'
                                     + 'Data Source=' + server + ';'
                                     + 'Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;'
                                     + 'Workstation ID=RYZEN-7;Initial File Name="";Use Encryption for Data=False;Tag with column collation when possible=False;MARS Connection=False;DataTypeCompatibility=0;Trust Server Certificate=False;Server SPN="";Application Intent=READWRITE;';
           Result := 'OK';
        except on ex:exception do
            Result := 'Erro ao configurar banco: ' + ex.Message;
        end;

    finally
        if Assigned(ini) then
            ini.DisposeOf;
    end;
end;

function Connect: TADOConnection;
begin
    ConexaoADO := TADOConnection.Create(nil);
    SetupConnection(ConexaoADO);
    ConexaoADO.Connected := true;

    Result := ConexaoADO;
end;

procedure Disconect;
begin
    if Assigned(ConexaoADO) then
    begin
        if ConexaoADO.Connected then
            ConexaoADO.Connected := false;

        ConexaoADO.Free;
    end;
end;

end.
