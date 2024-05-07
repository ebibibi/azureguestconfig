https://learn.microsoft.com/ja-jp/azure/governance/machine-configuration/how-to/develop-custom-package/1-set-up-authoring-environment

https://cloudbrothers.info/azure-persistence-azure-policy-guest-configuration/


#PowerShell 7で実行


Install-Module -Name 'GuestConfiguration','PSDesiredStateConfiguration','PSDscResources'

cd c:\tmp

Configuration EnableIIS
{
    param()

    Import-DscResource -ModuleName 'PSDscResources'
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'


    Node "localhost"
    {
        WindowsFeature WebServer {
            Ensure = "Present"
            Name   = "Web-Server"
        }

        File WebsiteContent1 {
            Ensure = 'Present'
            SourcePath = '\\arc-iisdemo-wac\webcontents\index.htm'
            DestinationPath = 'c:\inetpub\wwwroot\index.htm'
        }

        File WebsiteContent2 {
            Ensure = 'Present'
            SourcePath = '\\arc-iisdemo-wac\webcontents\logo.png'
            DestinationPath = 'c:\inetpub\wwwroot\logo.png'
        }

    }
}

EnableIIS


# Create a guest configuration package for Azure Policy GCS
New-GuestConfigurationPackage `
  -Name 'EnableIIS' `
  -Configuration './EnableIIS/localhost.mof' `
  -Type AuditAndSet  `
  -Force