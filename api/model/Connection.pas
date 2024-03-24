unit Connection;

interface

uses
  FireDAC.DApt, FireDAC.Stan.Option, FireDAC.Stan.Intf, FireDAC.UI.Intf,
  FireDAC.Stan.Error, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, System.Classes, FireDAC.Phys.MSSQL,
  System.IniFiles, System.SysUtils;

var
   FConnection: TFDConnection;

function SetupConnection(FConn: TFDConnection): String;
function Connect : TFDConnection;
procedure Disconect;

implementation

function SetupConnection(FConn: TFDConnection): String;
var
    OSAuthent, Mars, driverId, server, database, user, password, arqIni,
    ApplicationName, Workstation : string;
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
            driverId := ini.ReadString('BD', 'DriverID', EmptyStr);
            server   := ini.ReadString('BD', 'Server', EmptyStr);
            database := ini.ReadString('BD', 'DataBase', EmptyStr);
            user     := ini.ReadString('BD', 'User_Name', EmptyStr);
            password := ini.ReadString('BD', 'Password', EmptyStr);

            // Buscar dados do arquivo fisico...
            FConn.Params.Values['DriverID'] := driverId;
            FConn.Params.Values['Database'] := database;
            FConn.Params.Values['User_Name'] := user;
            FConn.Params.Values['Password'] := password;
            FConn.Params.Values['Server'] := server;

           Result := 'OK';
        except on ex:exception do
            Result := 'Erro ao configurar banco: ' + ex.Message;
        end;

    finally
        if Assigned(ini) then
            ini.DisposeOf;
    end;
end;

function Connect: TFDConnection;
begin
    FConnection := TFDConnection.Create(nil);
    SetupConnection(FConnection);
    FConnection.Connected := true;

    Result := FConnection;
end;

procedure Disconect;
begin
    if Assigned(FConnection) then
    begin
        if FConnection.Connected then
            FConnection.Connected := false;

        FConnection.Free;
    end;
end;

end.
