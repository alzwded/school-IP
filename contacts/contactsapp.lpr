program contactsapp;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, IPContactsFormUnit, IPEditFormUnit
  { you can add units after this };

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TIPContactsForm, IPContactsForm);
  Application.CreateForm(TEditForm, EditForm1);
  Application.Run;
end.

