declare option output:method "xml";
declare option output:indent "yes";

<posts>{
let $userCounts :=
  for $p in /posts/row
  let $tags := tokenize($p/@Tags, '&lt;|&gt;')
  for $tag in $tags
  group by $tag
  return
    <TagsCount>
      <tag>{$tag}</tag>
      <count>{count($tags)}</count>
    </TagsCount>

let $top10Tags :=
  for $u in subsequence($userCounts, 1, 10)
  order by xs:integer($u/count) descending
  return
    $u/tag

let $posts :=
  for $p in subsequence(/posts/row[@PostTypeId='1'], 1)
  order by xs:integer($p/@ViewCount) descending
  return
    <post>
      <title>{data($p/@Title)}</title>
      <viewCount>{data($p/@ViewCount)}</viewCount>
      <tags>{tokenize($p/@Tags/string(), '&lt;|&gt;')}</tags>
    </post>

let $filteredPosts :=
  for $post in $posts
  where some $topTag in $top10Tags satisfies
    some $tag in $post/tags satisfies
      normalize-space($tag) = normalize-space($topTag)
  where position() le 100
  return $post

return $filteredPosts
}</posts>