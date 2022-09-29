This is how to use this script , this scripts require 3 things before executing it .



**EnrollmentToken** : this token you can find it in  **Fleet → Enrollment tokens** ,after creating the policy you will find it there.

**fleetUrl = 'https://@IP:8220** the @IP is your public ip of your cluster .

**$b64** is a base64 encoded CA . 

You can use this online tool to generate it: copy your ca.crt file and replace the value in the script.

[base64 encode](https://www.base64encode.net/)


```
curl -fsSL https://raw.githubusercontent.com/jlim0930/scripts/master/scripts/installagent.ps1 -o installagent.ps1
```


Change the restriction policy , in the administrator's powershell session :

```
Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope CurrentUser
```

And execute the script **./installagent.ps1** ,The script will download sysmon, the swiftsecurity configuration, elasticagent and install everything.





