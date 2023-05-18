program Jogo2D;

uses
  System.StartUpCopy,
  FMX.Forms,
  uPrincipal in 'uPrincipal.pas' {Z},
  GameClasses in 'GameClasses.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TZ, Z);
  Application.Run;
end.
