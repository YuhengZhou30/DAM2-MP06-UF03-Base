declare option output:method "xml";
declare option output:indent "yes";
<posts>{
  for $p in /posts/row[@PostTypeId='1']
  order by xs:integer($p/@ViewCount) descending
  return
    <post>
      <title>{string($p/@Title)}</title>
      <viewCount>{string($p/@ViewCount)}</viewCount>
    </post>
}</posts>
