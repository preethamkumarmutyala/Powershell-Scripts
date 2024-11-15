# Define the usernames using User Principal Name
$user1 = "pavankumarvs@commvault.com"
$user2 = "rjahagirdar@commvault.com"

# Get AD user objects
$user1Object = Get-ADUser -Filter {UserPrincipalName -eq $user1} -Properties MemberOf
$user2Object = Get-ADUser -Filter {UserPrincipalName -eq $user2} -Properties MemberOf

# Extract group DNs
$user1GroupsDN = $user1Object.MemberOf
$user2GroupsDN = $user2Object.MemberOf

# Convert group DNs to group names
$user1Groups = $user1GroupsDN | ForEach-Object { (Get-ADGroup -Identity $_).Name }
$user2Groups = $user2GroupsDN | ForEach-Object { (Get-ADGroup -Identity $_).Name }

# Find groups where user1 is a member and user2 is not
$uniqueUser1Groups = $user1Groups | Where-Object { $_ -notin $user2Groups }

# Output the results
$uniqueUser1Groups
