$data = Invoke-RestMethod -Uri 'https://restcountries.com/v3.1/name/japan?fields=currencies'
$curr = $data.currencies
$keys = $curr.psobject.properties.value
Write-Host "Keys count: $($keys.Count)"
foreach ($prop in $curr.psobject.properties) {
    Write-Host "Name: $($prop.Name), Value.name: $($prop.Value.name)"
}
