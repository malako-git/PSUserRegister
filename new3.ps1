#für richtige parameterübergabe bei funktionen
Set-StrictMode -Version Latest

#Usercount Zahl aus txt datei auslesen
function get-usercounter {
    $uc = get-content -path .\Usercounter.txt
    return $uc
}

function get-user_content {
    param([string]$user_name)
    write-host "in funkton get user content"
    
    $user_content_file = Get-ChildItem -Path .\User\ -Recurse -Filter "$user_name"
    write-host "$user_content_file"
    $user_content = get-content -Path .\User\${user_content_file}
    write-host "$user_content"
}

<#
function get-password {
    param([string]$user_name_input)
    $users = New-Object System.Collections.Generic.List[System.Object]
    get-childitem -Path .\User\ -File | foreach-object {$users.add($_.Name)}
    $users.toarray()
    
    while ($True) {

        if ($users.contains($user_name_input)) {
            [string[]]$user_content_1 = get-user_content -$user_name $user_name_input
            return $user_content_1[1]
            write-host $user_content_1[1]
            break
        }
        else {return $False}

    
    }
    
}
#>

#Usercounter aus txt datei auslesen und +1 hochzählen und wieder speichern
function set-usercounter_up {
    $uc = get-usercounter
    #write-host "$uc"
    $nuc = [int]$uc
    #write-host "$nuc"
    $nuc++
    #write-host "$nuc"
    set-Content -Path .\Usercounter.txt -Value "$nuc"
}

#überprüfen ob Username richtige characters benutzt
function get-allowed {
    param ([string]$userinput)
    #write-host "$userinput, $inputallowed"
    $inputallowed_Username="abcdefghijklmnopqrstuvwxyz1234567890"

    foreach($c in $userinput.toCharArray()){
        #write-host "c ist $c"
        if($inputallowed_Username.contains("$c")){
            $rtvl = "TRUE"
        }    
        else{
            $rtvl = "FALSE"
            break
        }
    }
    return $rtvl
}

#auswahlmenü ausgeben und usercounter abfragen sowie nutzerauswahl abfragen und returnen
function menue {
    $inputallowed_choice="123"
    $date=get-date
    $usercounter = get-usercounter
    write-host "Hallo heute ist $date`n usercounter ist $usercounter`n 1:Register , 2:Login , 3:Exit"

    while ($True) {
        #write-host "start while"
        $input_choice=read-host " " 
        #write-debug "$input_choice"
        if ($inputallowed_choice.Contains($input_choice)){
            return $input_choice
            break

        }
        #elseif ($input_choice -eq "") {continue}
        else {continue}
    }
    

}


<#
function write-to-user {
    param ([])

}
#>

$global:usercounter = get-usercounter
# MAIN
while ($True) {
    
    $checker = "FALSE"
    $choice = menue

        #write-host "in first if"
        if ($choice -eq 1) {
            #write-host "in choice 1"
            
            while ($checker -eq "FALSE") {    
                    
                $input_username=read-host "Username: "
                $doink = get-allowed -userinput $input_username
                #write-host "doink ist $doink"

                if ($doink -eq "TRUE") {
                    $usercounter = get-usercounter
                    write-host "==============Username accepted==================="
                    New-Item -Path .\User\${usercounter}${input_username}User.txt -ItemType file | Out-Null
                    add-content -Path .\User\${usercounter}${input_username}user.txt "$usercounter"
                    add-content -Path .\User\${usercounter}${input_username}user.txt "$input_username"
                    $input_password=read-host "Password: "
                    write-host "************Willkommen Nutzer $input_username*************"
                    #üblicherweise hier ein eigens entwickelter sicherheitsmechanismus bzw eine sha256 verschlüsslung
                    $input_password | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | add-Content -Path .\User\${usercounter}${input_username}user.txt
                    set-usercounter_up
                    $checker = "TRUE"    
                }

                else {
                    #write-host "im else"
                    continue
                } 
            }

            
                
        }
        #login
        if ($choice -eq 2) {
            #pass
            while ($True) {
                $input_username=read-host "Username: "
                $supw = get-user_content -user_name $input_username


                if ($supw.contains($False)) {
                    write-host "$supw"
                    continue
                }
                else {
                    write-host "$supw"
                    $input_password=read-host -prompt "Password: " -AsSecureString

                    $upw = [System.Runtime.InteropServices.marshal]::PtrToStringAuto([System.Runtime.InteropServices.marshal]::SecureStringToBSTR($supw))
                    if ($upw -eq $input_password) {
                        break
                       
                }
                    }
            }
            write-host "willkommen auf deinem Account !"
            



        }

        #exit
        if ($choice -eq 3) {
            break
        }
    
        
}




