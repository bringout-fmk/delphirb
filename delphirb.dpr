{* This file is part of the bring.out FMK, a free and open source        *} 
{* accounting software suite,                                            *}
{* Copyright (c) 1996-2011 by bring.out doo Sarajevo.                    *} 
{* It is licensed to you under the Common Public Attribution License     *}
{* version 1.0, the full text of which (including FMK specific Exhibits) *}
{* is available in the file LICENSE_CPAL_bring.out_FMK.md located at the *}
{* root directory of this source code archive.                           *}
{* By using this software, you agree to be bound by its terms.           *}

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
