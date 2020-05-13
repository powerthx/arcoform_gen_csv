"# arcoform_gen_csv" 
:: 13.05.2020 - 11.27
:: ....................................................................................................
:: This Script extracts ARCO PDF Form Field Values and converts the output to a CSV File. 
:: The Script uses the Software pdftk.exe to extract and the Tool sed.exe to Stream the content into a CSV Valid format.
:: Alot of optimization could be done but as a POC is it not necessary at the moment.

pdftk.exe "arcopdfform_filled.pdf" dump_data_fields > data.file
sed.exe -n \"/^FieldValue: ./ p\" data.file >> out.txt && echo EOF >> out.txt
sed.exe "s/^FieldValue: /;/" out.txt > export.csv
sed.exe -e ":a" -e "N" -e "$!ba" -e "s/\n/ /g" export.csv > final.csv
sed.exe "s/EOF/\n/g" final.csv > export.txt
DEL export.csv

Usage
1. Place your PDF's into the In Folder
2. Execute the start_bulk.bat File
3. Open the export.csv file in the directory of this Readme.MD