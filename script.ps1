$country = Read-Host "Enter country code (e.g., US):"
$state = Read-Host "Enter state or region code (e.g., VA):"
$city = Read-Host "Enter city name:"
$company = Read-Host "Enter company name:"
$division = Read-Host "Enter division name:"
$commonName = Read-Host "Enter Common Name (CN):"

$altNames = @()

Write-Host "Enter alternative names (Up to 3 names):"
for ($i = 1; $i -le 3; $i++) {
    $altName = Read-Host "Alternative Name $i (Leave blank to exit):"
    if ([string]::IsNullOrWhiteSpace($altName)) {
        break
    }
    $altNames += $altName
}

$configContent = @"
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no

[req_distinguished_name]
C = $country
ST = $state
L = $city
O = $company
OU = $division
CN = $commonName

[v3_req]
keyUsage = critical, digitalSignature, keyAgreement
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
"@

for ($i = 1; $i -le $altNames.Count; $i++) {
    $configContent += "DNS.$i = $($altNames[$i - 1])`n"
}

$configContent | Out-File -Encoding UTF8 -FilePath "config.cfg"

Write-Host "config.cfg file created."

# Generate the certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout cert.key -out cert.pem -config config.cfg -sha256

Write-Host "Certificate created: cert.key, cert.pem"
