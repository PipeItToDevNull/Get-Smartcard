# Get-Smartcard

This will enumerate smart card certificates on Windows, from 1 or more readers.

The Certificate order number, subject, NotBefore, NotAfter, Reader, Card, Provider, key container and serial number are all added to the certificate object. 

A simple use to view all certs is

```
. .\Get-Smartcard.ps1

Get-Smartcard | Out-GridView
```
