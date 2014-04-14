school-IP
=========

IP homework thingy

this project lives at http://github.com/alzwded/school-IP

Building
========

You will need: sqlite3, libsqlite3/sqlite3.dll, lazarus.

1. do

   ```sh
   sqlite3 contacts.sqlite3
   .read schema.sql
   .quit
   ```

2. open the project in lazarus and click run / build all
3. copy sqlite3.dll in the working directory if it's not in LIBPATH
4. run contactsapp
