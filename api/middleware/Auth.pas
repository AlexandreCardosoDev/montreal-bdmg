unit Auth;

interface

uses
  Horse,
  Horse.BasicAuthentication,
  System.JSON,
  System.IniFiles,
  System.SysUtils;

var
  BasicLogin, BasicPassword, arqIni : string;
  ini : TIniFile;

procedure Autenticacao;

implementation

procedure Autenticacao;
Begin
    //Adicionando Autenticação Básica
    try
        try
            arqIni := GetCurrentDir + '\config.ini';

            // Verifica se INI existe
            if NOT FileExists(arqIni) then
            begin
                Writeln('Arquivo INI não encontrado: ' + arqIni);
                exit;
            end;

            // Instanciar arquivo INI
            ini := TIniFile.Create(arqIni);

            // Buscar dados do arquivo fisico...
            BasicLogin     := ini.ReadString('LOGIN', 'User', EmptyStr);
            BasicPassword := ini.ReadString('LOGIN', 'Password', EmptyStr);

        except on ex:exception do
            Writeln('Erro ao configurar banco: ' + ex.Message);
        end;

    finally
        if Assigned(ini) then
            ini.DisposeOf;
    end;


    THorse.Use(HorseBasicAuthentication(
    function(const AUsername, APassword: string): Boolean
    begin
      Result := AUsername.Equals(BasicLogin) and APassword.Equals(BasicPassword);
    end));
End;


end.
