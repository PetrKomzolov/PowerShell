<#
Скрипт для выполнения команд ping, pathping, tracert, а также для проверки портов

Версия 1.0
2016 г.
#>

# Проверяемые сайты
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

# Проверяемые порты
$ports =
'443',
'444',
'446',
'447',
'448',
'449',
'450',
'451',
'452',
'453'

# Функция Exec-Command - это общий блок кода для нескольких команд
function Exec-Command
{
    Clear-Host
    $counter = 0
    foreach ($server in $serverName)
    {
        $counter++
        $datetime = Get-Date -Format "dd.MM.yyyy HH:mm:ss"
        Write-Progress -Activity "$command" -Status "$command $server" -PercentComplete ($counter / $serverName.Count*100)
        Out-File -FilePath $command_path -InputObject "`n[$datetime]" -Append -NoClobber
        Invoke-Expression -Command "$command.EXE $server" >> $command_path
    }
    Write-Progress -Activity "$command" -Status "$command completed!" -Completed
    Clear-Host
    Write-Host "$command - done! `n" -ForegroundColor Green
    Write-Host "Start PING - 1; Start PATHPING - 2; Start TRACERT - 3;"
    Write-Host "Check ports - 4; Quit - 5: `n"
}

Write-Host "Start PING - 1; Start PATHPING - 2; Start TRACERT - 3;"
Write-Host "Check ports - 4; Quit - 5: `n"

while (1)
{
    $key = $host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
	if ($key.Character -eq '1')
	{
        $command = 'PING'
        $command_path = '.\ping_log.txt'
        Exec-Command
	}

    if ($key.Character -eq '2')
    {
        $command = 'PATHPING'
        $command_path = '.\pathping_log.txt'
        Exec-Command
    }

    if ($key.Character -eq '3')
    {
        $command = 'TRACERT'
        $command_path = '.\tracert_log.txt'
        Exec-Command
    }

    if ($key.Character -eq '4')
    {
        Clear-Host
        foreach ($server in $serverName)
        {
            foreach ($port in $ports)
            {
                Write-Host "Connection to the server $server, port $port ..."

                try
                {
                    $socket = New-Object System.Net.Sockets.TcpClient($server, $port)
                    Write-Host "Server is available" -ForegroundColor Green
					$datetime = Get-Date -Format "dd.MM.yyyy HH:mm:ss"
                    Out-File -FilePath '.\test_ports_log.txt' -InputObject "`n[$datetime] Server is available, server $server : $port`n" -Append -NoClobber
                }

                catch [Exception]
                {
					Write-Host "Server unavailable" -ForegroundColor Red
					$datetime = Get-Date -Format "dd.MM.yyyy HH:mm:ss"
					Out-File -FilePath '.\test_ports_log.txt' -InputObject "`n[$datetime] Server unavailable $server : $port`n" -Append -NoClobber
                    $_.Exception.Message >> ".\test_ports_log.txt"
                }
            }
        }
        Clear-Host
        Write-Host "Check ports - done! `n" -ForegroundColor Green
        Write-Host "Start PING - 1; Start PATHPING - 2; Start TRACERT - 3;"
        Write-Host "Check ports - 4; Quit - 5: `n"
    }

	if ($key.Character -eq '5')
	{
		Exit
	}
}