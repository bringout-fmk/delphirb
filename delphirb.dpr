program DelphiRB;

uses
  Forms,
  delrb in 'delrb.pas' {frmLabel},
  dmutils in 'dmutils.pas';

//{$R *.RES}


begin

  Application.Initialize;
  Application.CreateForm(TfrmLabel, frmLabel);
  Application.Run;
end.
