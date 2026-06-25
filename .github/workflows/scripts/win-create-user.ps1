# 1. 硬编码密码（纯大小写+数字，彻底避开特殊字符解析问题）
# 满足 Windows 复杂度策略，且不会触发任何字符编码异常
$password = "RdpUser2026Pass" 
$username = "vum"

# 2. 使用底层 net user 命令创建用户
# 这比 New-LocalUser 更稳定，完全不需要 ConvertTo-SecureString 转换
net user $username $password /add /y
if ($LASTEXITCODE -ne 0) { 
    throw "Failed to create user via net user" 
}

# 3. 添加到管理员组
net localgroup Administrators $username /add

# 4. 添加到远程桌面组
net localgroup "Remote Desktop Users" $username /add

# 5. 将账号密码写入环境变量，供后续步骤打印
echo "RDP_CREDS=User: $username | Password: $password" >> $env:GITHUB_ENV

# 6. 验证用户是否创建成功
if (-not (Get-LocalUser -Name $username -ErrorAction SilentlyContinue)) { 
    throw "User creation failed verification" 
}

Write-Host "User '$username' created successfully."
