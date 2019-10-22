Set-StrictMode -Version Latest

function get-usercounter {
    $uc = get-content -path .\Usercounter.txt
    return $uc
}

function set-usercounter_up {
    $uc = get-content -path .\Usercounter.txt
    #write-host "$uc"
    $nuc = [int]$uc
    #write-host "$nuc"
    $nuc++
    #write-host "$nuc"
    set-Content -Path .\Usercounter.txt -Value "$nuc"
}

function get-allowed {
    param ([string]$userinput, [string]$inputallowed)
    #write-host "$userinput, $inputallowed"

    foreach($c in $userinput.toCharArray()){
        #write-host "c ist $c"
        if($inputallowed.contains("$c")){
            $rtvl = "TRUE"
        }    
        else{
            $rtvl = "FALSE"
            break
        }
    }
    return $rtvl
}

$date=get-date
$inputallowed_Username="abcdefghijklmnopqrstuvwxyz1234567890"
$inputallowed_choice="123"
$checker = "FALSE"


write-host "Hallo heute ist $date"
$usercounter = get-usercounter
write-host "usercounter ist $usercounter"


$input_choice=read-host "1:Register , 2:Login , 3:Exit"


if ($inputallowed_choice.Contains($input_choice)){
    #write-host "in first if"
    if ($input_choice -eq 1) {
        #write-host "in choice 1"
        New-Item d:\${usercounter}User.txt -ItemType file
        
        while ($checker -eq "FALSE") {    
            $input_username=read-host "Username: "
            $doink = get-allowed -userinput $input_username -inputallowed $inputallowed_Username
            #write-host "doink ist $doink"

            if ($doink -eq "TRUE") {
                write-host "Username accepted"
                add-content d:\${usercounter}user.txt "$input_username"
                $checker = "TRUE"    
            }

            else {
                #write-host "im else"
                continue
            } 
        }

        $input_password=read-host "Password: "
        $input_password | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | add-Content d:\${usercounter}user.txt
        set-usercounter_up
            
    }
}
        





