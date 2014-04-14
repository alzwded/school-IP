unit IPContactsFormUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqlite3conn, sqldb, db, BufDataset, FileUtil, Forms,
  Controls, Graphics, Dialogs, DBGrids, StdCtrls, IPEditFormUnit;

type

  { TIPContactsForm }

  TIPContactsForm = class(TForm)
    Button1: TButton;
    Datasource1: TDatasource;
    DBGrid1: TDBGrid;
    SQLite3Connection1: TSQLite3Connection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure Button1Click(Sender: TObject);
    procedure Datasource1DataChange(Sender: TObject; Field: TField);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    procedure EditCurrentRecord;
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

procedure TIPContactsForm.EditCurrentRecord;
var
  q: TSQLQuery;
  ef: TEditForm;
  id: integer;
  aname, surname: string;
  dob: TDate;
  ds: TDataSet;
  list: array of TKeyValuePair;
  deletedEntries: TStringArray;
  newEntries, modifiedEntries: TKeyValueArray;
  i: integer;
  s: string;
  param: TParam;
begin
  ds := DBGrid1.DataSource.DataSet;
  id := ds.FieldByName('ID').AsInteger;
  aname := ds.FieldByName('First Name').AsString;
  surname := ds.FieldByName('Last Name').AsString;
  dob := ds.FieldByName('Birthday').AsDateTime;

  q := TSQLQuery.Create(Self);
  q.DataBase := SQLite3Connection1;
  q.Transaction := SQLTransaction1;
  q.SQL.Clear;
  q.SQL.Add('select * from metadata where id = :id');
  q.ParamByName('id').AsInteger := id;
  q.Active := True;
  q.ExecSQL;

  writeln(id);
  writeln(q.RecordCount);

  q.First;
  while not q.EOF do begin
    SetLength(list, Length(list) + 1);
    list[Length(list) - 1].key :=  q.FieldByName('metadata_type').AsString;
    list[Length(list) - 1].value :=  q.FieldByName('data').AsString;
    writeln(list[Length(list) - 1].key + ':' + list[Length(list) - 1].value);
    q.Next;
  end;

  q.Active := false;

  ef := TEditForm.Create(Self);
  ef.SetData(aname, surname, dob, list);
  if ef.ShowModal = mrOK then begin
    deletedEntries := ef.GetDeletedKeys;
    newEntries := ef.GetNewDetails;
    modifiedEntries := ef.GetModifiedDetails;
    for i := 0 to Length(deletedEntries) - 1 do begin
      q.SQL.Clear;
      q.SQL.Add('delete from metadata where id = :id and metadata_type = :type ;');
      q.ParamByName('id').AsInteger := id;
      q.ParamByName('type').AsString := deletedEntries[i];
      writeln('before exec');
      q.ExecSQL;
      writeln('after exec');
    end;
    for i := 0 to Length(newEntries) - 1 do begin
      q.SQL.Clear;
      q.SQL.Add('insert into metadata (id, metadata_type, data) values (:id, :type, :data) ;');
      q.ParamByName('id').AsInteger := id;
      q.ParamByName('type').AsString := newEntries[i].Key;
      q.ParamByName('data').AsString := newEntries[i].Value;
      writeln('before exec');
      q.ExecSQL;
      writeln('after exec');
    end;
    for i := 0 to Length(modifiedEntries) - 1 do begin
      q.SQL.Clear;
      q.SQL.Add('update metadata set data = :data where id = :id and metadata_type = :type ;');
      q.ParamByName('id').AsInteger := id;
      q.ParamByName('type').AsString := modifiedEntries[i].Key;
      q.ParamByName('data').AsString := modifiedEntries[i].Value;
      writeln('before exec');
      q.ExecSQL;
      writeln('after exec');
    end;
    SetLength(deletedEntries, 0);
    SetLength(newEntries, 0);
    SetLength(modifiedEntries, 0);
  end;


  ef.Free;
  q.Free;
end;

procedure TIPContactsForm.DBGrid1DblClick(Sender: TObject);
begin
  writeln (DBGrid1.DataSource.DataSet.Fields.FieldByName('id').AsInteger );
  EditCurrentRecord;
end;

procedure TIPContactsForm.Datasource1DataChange(Sender: TObject; Field: TField);
begin

end;

procedure TIPContactsForm.Button1Click(Sender: TObject);
begin
  EditCurrentRecord;
end;

end.

