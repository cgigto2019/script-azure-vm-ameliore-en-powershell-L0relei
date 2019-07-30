param([int]$nbVM,[string]$resourceGroup)

For ($i = 1; $i -le $nbVM; $i++)
{
    $vmName = "ConferenceDemo" + $i
    Write-Host "Creating VM: " $vmName

    # Définition compte administrateur

    $SecurePassword = ConvertTo-SecureString "AJCFormation2019!" -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PSCredential ($env:USERNAME, $SecurePassword)

    # Création de la VM

    New-AzVm -ResourceGroupName $resourceGroup -Name $vmName -OpenPorts 22, 80, 443 -Image UbuntuLTS -Credential $Credential

    # Ajout de la clé publique SSH

    $sshPublicKey = Get-Content "$HOME\.ssh\id_rsa.pub"
    $vmConfig = Get-AzVM -ResourceGroupName $resourceGroup -Name $vmName
    Add-AzVMSshPublicKey -VM $vmConfig -KeyData $sshPublicKey -Path "/home/$env:USERNAME/.ssh/authorized_keys"

    $ip = Get-AzPublicIpAddress -Name $vmName -ResourceGroupName $resourceGroup | Select IpAddress
}
