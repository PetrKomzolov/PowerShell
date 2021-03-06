<#
Скрипт для генерации датапула url.dat
#>

#Параметр protocol
$protocol = 'https://'

#Параметр domain
$serverName =
"test1.com",
"test2.com",
"test3.com",
"test4.com",
"test5.com",
"test6.com",
"test7.com",
"test8.com",
"test9.com"

#Параметр port
$ports =
':443',
':444',
':446',
':447',
':448'
# ':449',
# ':450',
# ':451',
# ':452',
# ':453'

#Требуемое кол-во строк
$lines = 25000

#Счетчик для цикла
$i = 0

#Путь к файлу
$path = '.\url.dat'

#Открываем поток для записи
$stream = [System.IO.StreamWriter] $path

#Первая строка пула
$stream.WriteLine("protocol,domain,port")

while ($i -lt $lines)
{
    foreach ($server in $serverName)
    {
        foreach ($port in $ports)
        {
            $stream.WriteLine("$protocol,$server,$port")
            $i++
        }
    }
}

#Закрываем поток
$stream.close()

#Конвертируем созданный файл в UTF-8 без BOM
$MyFile = Get-Content $path
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)
[System.IO.File]::WriteAllLines($path, $MyFile, $Utf8NoBomEncoding)

Write-Host "Пул url.dat создан! Нажмите любую клавишу для выхода...`n" -ForegroundColor Green
$key = $host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
