unit frmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Prog_hook_dll, ComCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
     hLib2: THandle;
     DllStr1: string;
     procedure DllMessage(var Msg: TMessage); message WM_USER + 1678;
  public
    { Public declarations }
  end;

type
 TStartHook=function(MemoHandle, AppHandle: HWND): Byte;

type
 TStopHook=function: Boolean;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.DllMessage(var Msg: TMessage);
begin
 if (Msg.wParam=8) or (Msg.wParam=13)
 then
  begin
   DllStr1:='';  
   Exit;
  end;
 // 8 - "Backspace", 13 - "Enter"
 DllStr1:=DllStr1+Chr(Msg.wParam);
 Label1.Caption:='Text: '+DllStr1;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
 StartHook1: TStartHook;
 SHresult: Byte;
begin
 Button1.Enabled:=false;
 Button2.Enabled:=true;
 hLib2:=LoadLibrary('Prog_hook_dll.dll');
 @StartHook1:=GetProcAddress(hLib2, 'StartHook');
 if @StartHook1=nil
 then Exit;
 SHresult:=StartHook1(Memo1.Handle, Handle);
 if SHresult=0 then Memo1.Lines.Add('Hook Started');
 if SHresult=1 then Memo1.Lines.Add('Hook was already Started');
 if SHresult=2 then Memo1.Lines.Add('Hook NOT Started');
 if SHresult=4 then Memo1.Lines.Add('MemoHandle is incorrect');
 Memo1.Lines.Add('--------------------');
end;

procedure TForm1.Button2Click(Sender: TObject);
var
 StopHook1: TStopHook;
 hLib21: THandle;
begin
 @StopHook1:=GetProcAddress(hLib2, 'Hook is Stoped');
 if @StopHook1=nil
 then
  begin
   Memo1.Lines.Add('Hook not Stoped');
   Memo1.Lines.Add('--------------------------');
   Exit;
  end;
 if StopHook1
 then
  begin
   Memo1.Lines.Add('Hook was Stoped');
   Memo1.Lines.Add('--------------------');
   Button1.Enabled:=true;
   Button2.Enabled:=false;
  end;
 FreeLibrary(hLib2);
 // for some reason in Win XP you need to call FreeLibrary twice
 // maybe because you get 2 functions from the DLL
 FreeLibrary(hLib2);
end;

end.
