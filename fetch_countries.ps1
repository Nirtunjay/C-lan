$countries = Invoke-RestMethod -Uri "https://restcountries.com/v3.1/all?fields=name,capital,cca2,currencies,unMember"

$unMembers = $($countries | Where-Object { $_.unMember -eq $true } | Sort-Object -Property { $_.name.common })
$palestine = $($countries | Where-Object { $_.cca2 -eq "PS" })
$holySee = $($countries | Where-Object { $_.cca2 -eq "VA" })
$taiwan = $($countries | Where-Object { $_.cca2 -eq "TW" })

$all195 = @()
$all195 += $unMembers
$all195 += $palestine
$all195 += $holySee
$all195 += $taiwan
$all195 = $all195 | Sort-Object -Property { $_.name.common }

Write-Host "Total countries fetched: $($all195.Count)"

$html = "
<!DOCTYPE html>
<html lang=""en"">
<head>
    <meta charset=""UTF-8"">
    <meta name=""viewport"" content=""width=device-width, initial-scale=1.0"">
    <title>Countries, Capitals, Flags, and Currencies</title>
</head>
<body>
    <h1>World Countries</h1>
    <p>A comprehensive list of 195 countries with their capital city, flag, and currency.</p>
    
    <table border=""1"" cellpadding=""8"" cellspacing=""0"">
        <thead>
            <tr>
                <th>Country</th>
                <th>Capital</th>
                <th>Flag</th>
                <th>Currency</th>
            </tr>
        </thead>
        <tbody>
"
foreach ($c in $all195) {
    if ($c.name.common) {
        $name = $c.name.common
        $cca2 = $c.cca2.ToLower()
        $cap = if ($c.capital) { $c.capital[0] } else { "N/A" }
        $currObj = $c.currencies
        $curr = if ($currObj) { 
            $prop = $currObj.psobject.properties | Select-Object -First 1
            $prop.Value.name 
        } else { "N/A" }
        
        $html += "            <tr>`n"
        $html += "                <td>$name</td>`n"
        $html += "                <td>$cap</td>`n"
        $html += "                <td><img src=""https://flagcdn.com/w40/$cca2.png"" alt=""Flag of $name"" width=""40""></td>`n"
        $html += "                <td>$curr</td>`n"
        $html += "            </tr>`n"
    }
}

$html += "        </tbody>
    </table>
</body>
</html>
"

Out-File -FilePath "c:\Users\Asus\Desktop\C lan\country.html" -InputObject $html -Encoding utf8
Write-Host "File saved to country.html"
