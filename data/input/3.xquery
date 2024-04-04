declare option output:method "xml";
declare option output:indent "yes";
<tags>{
let $userCounts :=
  for $p in /posts/row
  let $tags := tokenize($p/@Tags, '&lt;|&gt;')
  for $tag in $tags
  group by $tag
  return
    <TagsCount>
      <tag>{$tag}</tag>
      <count>{count($p)}</count>
    </TagsCount>

for $u in $userCounts
order by xs:integer($u/count) descending
return
  <TagsCount>
    <tag>{string($u/tag)}</tag>
    <count>{string($u/count)}</count>
  </TagsCount>
}</tags>