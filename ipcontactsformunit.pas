unit IPContactsFormUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqlite3conn, sqldb, db, BufDataset, FileUtil, Forms,
  Controls, Graphics, Dialogs, DBGrids, StdCtrls;

type

  { TIPContactsForm }

  TIPContactsForm = class(TForm)
    Datasource1: TDatasource;
    DBGrid1: TDBGrid;
    SQLite3Connection1: TSQLite3Connection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure Datasource1DataChange(Sender: TObject; Field: TField);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  IPContactsForm: TIPContactsForm;

implementation

{$R *.lfm}

{ TIPContactsForm }

procedure TIPContactsForm.FormCreate(Sender: TObject);
begin
  sqlquery1.active := true;
end;

procedure TIPContactsForm.DBGrid1DblClick(Sender: TObject);
begin
  writeln (DBGrid1.DataSource.DataSet.Fields.FieldByName('id').AsInteger );
end;

procedure TIPContactsForm.Datasource1DataChange(Sender: TObject; Field: TField);
begin

end;

end.

