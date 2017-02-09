SELECT vpn_user, tunneltype, start_time, remote_ip
FROM 
 ###(SELECT 
  coalesce(nullifna(`xauthuser`), `user`) AS vpn_user, 
  tunneltype,
  from_dtime(dtime) AS start_time,
  ipstr(`remip`) AS remote_ip
 FROM $log 
 WHERE $filter 
  AND subtype='vpn' 
  AND (tunneltype='ipsec' OR left(tunneltype, 3)='ssl') 
  AND action IN ('ssl-login-fail', 'ipsec-login-fail') 
  AND coalesce(nullifna(`xauthuser`), nullifna(`user`)) IS NOT NULL 
 GROUP BY vpn_user, tunneltype, start_time, remote_ip)### t 
GROUP BY vpn_user, tunneltype, start_time, remote_ip ORDER BY start_time DESC
