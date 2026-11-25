<!--
  ==============================================================================
  PLANTILLA BASE - VISTA DE LISTA (patron List + Form del proyecto ENCAEX)
  ==============================================================================

  QUE HAY QUE HACER:
    1. Copie este archivo a  src/Views/templates/<modulo>/<modulo>List.view.tpl
       (minusculas en la carpeta y en el nombre del archivo).
    2. Reemplace TODOS los textos entre <>
         <modulo>   -> nombre de su modulo   (ej. Servicios)
         <Modulo>   -> nombre de la clase    (ej. Servicios)
         <campo>    -> nombre de la columna  (ej. srvnom)
    3. Reemplace los placeholders {{...}} por los nombres REALES de sus campos.
       {{campoN}} es un ejemplo generico: no existe en ninguna tabla.
    4. Borre los comentarios de este encabezado cuando ya lo haya adaptado.

  CONVENCIONES DE NOMBRES (obligatorias):
    Controlador : src/Controllers/<Modulo>/<Modulo>List.php   (clase <Modulo>List)
    DAO         : src/Dao/<Modulo>/<Modulo>.php
    Vista       : src/Views/templates/<modulo>/<modulo>List.view.tpl
    URL lista   : index.php?page=<Modulo>_<Modulo>List
    URL form    : index.php?page=<Modulo>_<Modulo>Form&mode=INS|DSP|UPD|DEL

  REGLAS DEL RENDERER (src/Views/Renderer.php) - IMPORTANTE:
    - {{variable}}  imprime el valor TAL COMO ES. NO escapa HTML.
                   Todo texto que venga de la BD debe escaparse en el
                   CONTROLADOR con \Utilities\Html::escFilas() / esc().
    - {{~variable}} dentro de un {{foreach}} lee una variable de la RAIZ
                   (fuera del loop). El simbolo ~ es OBLIGATORIO, sin el la
                   variable sale vacia y el boton NO aparece.
    - {{if var}} ... {{endif var}}      muestra el bloque si var es verdadero.
    - {{ifnot var}} ... {{endifnot var}} muestra el bloque si var es falso.
    - {{foreach lista}} ... {{endfor lista}}  repite el bloque.
      El cierre debe usar EXACTAMENTE el mismo nombre que la apertura.
    - Los nombres de variable solo admiten letras, numeros y guion bajo.

  PERMISOS (flags que envia el controlador):
    create  -> permiso Controllers\<Modulo>\INS  (boton Nuevo)
    read    -> permiso Controllers\<Modulo>\DSP  (boton Ver)
    update  -> permiso Controllers\<Modulo>\UPD  (boton Editar)
    delete  -> permiso Controllers\<Modulo>\DEL  (boton Eliminar)
    Si un flag es false, el boton NO se renderiza. No los elimine de la vista.
  ==============================================================================
-->
<section class="grid">
  <div class="col-12 flex flex-end align-center">
    <div class="col-8">
      <h2><Modulo></h2>
      <p class="muted">{{totalRegistros}} registros registrados.</p>
    </div>
    <div class="col-4 flex flex-end">
      {{if create}}
        <a class="btn" href="index.php?page=<Modulo>_<Modulo>List&mode=INS">Nuevo</a>
      {{endif create}}
    </div>
  </div>

  <div class="col-12 WWList">
    {{if hayRegistros}}
    <table>
      <thead>
        <tr>
          <th>Codigo</th>
          <th>Campo 1</th>
          <th>Campo 2</th>
          <th>Estado</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        {{foreach registros}}
        <tr>
          <td>{{codigo}}</td>
          <td>{{campo1}}</td>
          <td>{{campo2}}</td>
          <td><span class="badge badge-{{estado}}">{{estadoTexto}}</span></td>
          <td>
            {{if ~read}}
              <a href="index.php?page=<Modulo>_<Modulo>List&mode=DSP&codigo={{codigo}}">Ver</a>
            {{endif ~read}}
            {{if ~update}}
              <a href="index.php?page=<Modulo>_<Modulo>List&mode=UPD&codigo={{codigo}}">Editar</a>
            {{endif ~update}}
            {{if ~delete}}
              <a href="index.php?page=<Modulo>_<Modulo>List&mode=DEL&codigo={{codigo}}">Eliminar</a>
            {{endif ~delete}}
          </td>
        </tr>
        {{endfor registros}}
      </tbody>
    </table>
    {{endif hayRegistros}}
    {{ifnot hayRegistros}}
    <p>Aun no hay registros.</p>
    {{endifnot hayRegistros}}
  </div>

  <div class="col-12">
    {{paginacion}}
  </div>
</section>
