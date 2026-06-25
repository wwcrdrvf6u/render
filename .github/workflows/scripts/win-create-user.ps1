# 1. 硬编码密码
# 注意：使用单引号 '' 防止特殊字符被 PowerShell 解析
# 密码以字母开头，包含大小写、数字和 ! 符号，长度16位，绝对符合所有Windows策略
$password = 'MyRDP2026!Secure' 

# 2. 将明文密码转换为安全字符串
$securePass = ConvertTo-SecureString $password -AsPlainText -Force

# 3. 创建用户并分配权限
New-LocalUser -Name "vum" -Password $securePass -AccountNeverExpires
Add-LocalGroupMember -Group "Administrators" -Member "vum"
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "vum"

# 4. 将账号密码写入环境变量，供后续步骤打印
echo "RDP_CREDS=User: vum | Password: $password" >> $env:GITHUB_ENV

# 5. 验证用户是否创建成功
if (-not (Get-LocalUser -Name "vum")) { throw "User creation failed" }
