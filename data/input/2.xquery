declare option output:method "xml";
declare option output:indent "yes";

<users>{
let $userCounts :=
  for $p in /posts/row
  group by $userId := $p/@OwnerUserId/string()
  return
    <userCount>
      <userId>{$userId}</userId>
      <count>{count($p)}</count>
    </userCount>

for $u in /users/row
let $name := $u/@DisplayName/string()
for $uc in $userCounts
where $uc/userId = $u/@Id
order by xs:integer($uc/count) descending
return
  <userCount>
    <Name>{$name}</Name>
    <count>{$uc/count}</count>
  </userCount>
}</users>