program KeybHook;

uses
  Forms,
  frmMain in 'frmMain.pas' {Form1},
  Prog_hook_dll in 'Prog_hook_dll.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
