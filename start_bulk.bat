:: TS TECHNOLOGY SERVICES AG
:: info@tstechnology.ch
:: 13.05.2020 - 11.27
:: ....................................................................................................
CD %CD%
:: DELETE FILES IN FOLDER
FORFILES /P  %CD%\out /M * /C "cmd /c if @isdir==FALSE del @file"
FORFILES /P  %CD%\trans /M * /C "cmd /c if @isdir==FALSE del @file"
FORFILES /P  %CD%\mig /M * /C "cmd /c if @isdir==FALSE del @file"
:: CREATE FILES IN FOLDER OUT
FORFILES /P %CD%\in /S /M *.pdf /C "cmd /c %CD%\pdftk.exe @path dump_data_fields > %CD%\out\@fname.txt"
:: GENERATE HEADER - LAST PDF INFILE IS RELEVANT FOR HEADER FIELDS
FORFILES /P %CD%\out /S /M *.txt /C "cmd /c %CD%\sed.exe -n \"/^FieldNameAlt: / p\" @path > %CD%\out.txt && echo EOF >> %CD%\out.txt"
:: REPLACE FIELDNAMEALT DESC IN OUT.TXT
%CD%\sed.exe "s/^FieldNameAlt: /;/" %CD%\out.txt > export.txt
:: GENERATE TRANS FILE FROM EVERY EXPORT IN FOLDER OUT
FORFILES /P %CD%\out /S /M *.txt /C "cmd /c %CD%\sed.exe -n \"/^FieldNameAlt: / p;/^FieldValue: / p\" @path > %CD%\mig\@fname.txt
FORFILES /P %CD%\mig /S /M *.txt /C "cmd /c %CD%\sed.exe \"s/^FieldValue://;s/FieldNameAlt:/;/\"  @path > %CD%\trans\@fname.txt
FORFILES /P %CD%\trans /S /M *.txt /C "cmd /c %CD%\sed.exe \"s/^;.*/;/g\" @path >> %CD%\export.txt && echo EOF >> %CD%\export.txt"
:: REMOVE LINEBREAKS FROM THE FILE AND GENERATE TEMP FILE FINAL.CSV
%CD%\sed.exe -e ":a" -e "N" -e "$!ba" -e "s/\n/ /g" %CD%\export.txt > final.csv
:: REPLACE EOF IDENTIFIER IN FILE WITH LINE BREAKS (ONE LINE PER PDF IN THE FOLDER IN)
%CD%\sed.exe "s/EOF/\n/g" final.csv > export.csv
:: DELETE TEMP FILES
DEL %CD%\export.txt
DEL %CD%\final.csv
DEL %CD%\out.txt
DEL %CD%\in.txt
