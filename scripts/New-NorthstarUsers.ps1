Import-Module ActiveDirectory

$Users = Import-Csv "C:\NorthstarLab\users.csv"

$Domain = "ad.northstar.test"
$BaseOU = "OU=Users,OU=Northstar,DC=ad,DC=northstar,DC=test"

# Lab-only initial password
$Password = Read-Host "Enter the initial password for the new lab users" -AsSecureString

foreach ($User in $Users) {

    $FirstName = $User.FirstName
    $LastName = $User.LastName
    $Username = $User.Username
    $Department = $User.Department

    $FullName = "$FirstName $LastName"

    $TargetOU = "OU=$Department,$BaseOU"
    $Group = "GG-$Department-Users"

    Write-Host "Processing $FullName ($Username)..."

    # Check whether the account already exists
    $ExistingUser = Get-ADUser -Filter "SamAccountName -eq '$Username'"

    if ($ExistingUser) {
        Write-Warning "$Username already exists. Skipping."
        continue
    }

    New-ADUser `
        -Name $FullName `
        -GivenName $FirstName `
        -Surname $LastName `
        -SamAccountName $Username `
        -UserPrincipalName "$Username@$Domain" `
        -Department $Department `
        -Path $TargetOU `
        -AccountPassword $Password `
        -Enabled $true `
        -PasswordNeverExpires $true

    Add-ADGroupMember `
        -Identity $Group `
        -Members $Username

    Write-Host "Created $FullName and added account to $Group."
}
