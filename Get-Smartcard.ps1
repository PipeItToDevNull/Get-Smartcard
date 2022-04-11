Function Get-Smartcard {
    $raw = certutil -scinfo -silent | Out-String
    $split = $raw -Split "--------------===========================--------------"

    $count = $split.Length
    $i = 1
    $certs = @()

    While ($i -ne $count) {
        $top = $split[$i] -Split 'Performing AT_KEYEXCHANGE public key matching test...'
        If ($top | Select-String 'Serial Number:') {
            $i = $i+1
            $cleaned = $top[0].split([Environment]::NewLine) -Replace '^\s+','' -Replace '^---\s+',''
            $filtered = $cleaned | Select-String -Pattern ' Certificate ','^Reader:','Card:','Key Container =','Provider =','Serial Number','Subject:','NotBefore','NotAfter'
            $table = $filtered -Replace ': ','=' -Replace ' = ','=' -Replace '================','' -Replace 'cate ','cate=' -Replace ' \[Default Container\]','' | ConvertFrom-StringData
            
            if ($table.Subject.Count -eq 1) {
                $cert = [PSCustomObject]@{
                    Certificate     = $table.Certificate
                    Subject         = $table.Subject
                    Notbefore       = [DateTime]$table.NotBefore
                    NotAfter        = [DateTime]$table.NotAfter
                    Reader          = $table.Reader
                    Card            = $table.Card
                    Provider        = $table.Provider
                    'Key Container' = $table.'Key Container'
                    'Serial Number' = $table.'Serial Number'
                }
                $certs += $cert
            }
        } Else {
            $i = $i+1
        }
    }
    Return $certs
}
