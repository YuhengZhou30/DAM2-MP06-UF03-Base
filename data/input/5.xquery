declare option output:method "xml";
declare option output:indent "yes";
<Pregunta>{
let $preguntas :=
  for $pregunta in /posts/row[@PostTypeId='1']
  order by xs:integer($pregunta/@Score) descending
  return
    <Pregunta>
      <title>{data($pregunta/@Title)}</title>
      <body>{tokenize(data($pregunta/@Body), '&lt;|&gt;')[normalize-space(.)]}</body>
      <tag>{tokenize(data($pregunta/@Tags), '&lt;|&gt;')[normalize-space(.)]}</tag>
      <score>{data($pregunta/@Score)}</score>
      <id>{data($pregunta/@Id)}</id>
    </Pregunta>

let $respuestas :=
  for $respuesta in /posts/row[@PostTypeId='2']
  where matches($respuesta/@Score, '^\\d+$') (: Verifica que el score sea un número :)
  order by xs:integer($respuesta/@Score) descending
  return
    <respuesta>
      <Parentid>{data($respuesta/@ParentId)}</Parentid>
      <score>{max(xs:integer($respuesta/@Score))}</score>
      <body>{tokenize(data($respuesta/@Body), '&lt;|&gt;')[normalize-space(.)]}</body>
    </respuesta>

for $pregunta in $preguntas
let $mejorRespuesta :=
  $respuestas[$respuestas/Parentid = $pregunta/id]
return
  <PreguntaConRespuesta>
    <title>{$pregunta/title/string()}</title>
    <pregunta>{$pregunta/body/string()}</pregunta>
    <tag>{$pregunta/tag/string()}</tag>
    <respuesta>{$mejorRespuesta/body/string()}</respuesta>
  </PreguntaConRespuesta>
}</Pregunta>
