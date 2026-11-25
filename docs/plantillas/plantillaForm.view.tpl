<!--
  ==============================================================================
  PLANTILLA BASE - VISTA DE FORMULARIO (patron List + Form del proyecto ENCAEX)
  ==============================================================================

  QUE HAY QUE HACER:
    1. Copie este archivo a  src/Views/templates/<modulo>/<modulo>Form.view.tpl
       (minusculas en la carpeta y en el nombre del archivo).
    2. Reemplace TODOS los textos entre <>
         <modulo>   -> nombre de su modulo   (ej. Servicios)
         <Modulo>   -> nombre de la clase    (ej. Servicios)
         <campo>    -> nombre del campo      (ej. srvnom)
    3. Reemplace los placeholders {{...}} por los nombres REALES de sus campos.
       {{campoN}} es un ejemplo generico: no existe en ninguna tabla.
    4. Borre los comentarios de este encabezado cuando ya lo haya adaptado.

  CONVENCIONES DE NOMBRES (obligatorias):
    Controlador : src/Controllers/<Modulo>/<Modulo>Form.php   (clase <Modulo>Form)
    DAO         : src/Dao/<Modulo>/<Modulo>.php
    Vista       : src/Views/templates/<modulo>/<modulo>Form.view.tpl
    URL form    : index.php?page=<Modulo>_<Modulo>Form&mode=INS|DSP|UPD|DEL
    URL lista   : index.php?page=<Modulo>_<Modulo>List

  MODOS (los recibe el controlador por $_GET["mode"]):
    INS  -> alta      (muestra el boton Guardar, campos vacios)
    DSP  -> detalle   (solo lectura, sin boton Guardar)
    UPD  -> edicion   (muestra el boton Guardar, campos precargados)
    DEL  -> baja      (solo lectura, sin boton Guardar)

  VARIABLES QUE DEBE ENVIAR EL CONTROLADOR ({{...}}):
    {{action}}      -> URL a la que se envia el POST
    {{modo}}        -> modo actual (INS / DSP / UPD / DEL)
    {{modoDsc}}     -> texto del encabezado (ej. "Nueva Ruta")
    {{readonly}}    -> atributo HTML para bloquear el campo
                       ("readonly" en DSP/DEL, "" en INS/UPD)
    {{showGuardar}} -> true solo en INS/UPD
    {{xsftoken}}    -> token anti-CSRF (ver abajo)
    {{errorGeneral}}-> mensaje de error general (vacio si no hay)
    {{campoN}}      -> los valores de sus campos

  ANTI-CSRF (XSF) - OBLIGATORIO:
    El formulario DEBE llevar el token oculto y el controlador DEBE validarlo
    ANTES de escribir en la base de datos:
      <input type="hidden" name="xsftoken" value="{{xsftoken}}" />
      en el controlador:
        if (!\Utilities\Security::verifyCsrf($_POST["xsftoken"] ?? "")) { ... error ... }
    Cada modulo usa una semilla PROPIA en su controlador (no copie la misma
    cadena de otro modulo). Ver Controllers/Mnt/Products/ProductForm.php del
    repo de clase como ejemplo.
  ==============================================================================
-->
<section class="depth-1 py-4 px-4">
    <h2>{{modoDsc}}</h2>
</section>
<section class="depth-2 grid">
    {{if errorGeneral}}
    <div class="col-12"><div class="error">{{errorGeneral}}</div></div>
    {{endif errorGeneral}}
    <form class="col-12 col-m-8 offset-m-2 col-l-6 offset-l-3"
        action="{{action}}" method="post">
        <input type="hidden" name="idcampo" value="{{idvalor}}" />
        <input type="hidden" name="modo" value="{{modo}}" />
        <input type="hidden" name="xsftoken" value="{{xsftoken}}" />

        <div class="row my-3">
            <label class="col-12 col-m-5 col-l-4" for="campo1">Campo 1</label>
            <input {{readonly}} class="col-12 col-m-7 col-l-8" type="text" name="campo1"
                value="{{campo1}}" id="campo1" />
        </div>
        <div class="row my-3">
            <label class="col-12 col-m-5 col-l-4" for="campo2">Campo 2</label>
            <input {{readonly}} class="col-12 col-m-7 col-l-8" type="text" name="campo2"
                value="{{campo2}}" id="campo2" />
        </div>
        <div class="row my-3">
            <label class="col-12 col-m-5 col-l-4" for="campo3">Campo 3</label>
            <input {{readonly}} class="col-12 col-m-7 col-l-8" type="text" name="campo3"
                value="{{campo3}}" id="campo3" />
        </div>
        <div class="row my-3">
            <label class="col-12 col-m-5 col-l-4" for="estado">Estado</label>
            <input {{readonly}} class="col-12 col-m-7 col-l-8" type="text" name="estado"
                value="{{estado}}" id="estado" />
        </div>

        <div class="row my-3 flex-end">
            {{if showGuardar}}
            <button class="col-12 col-m-2 primary" type="submit">Guardar</button>&nbsp;
            {{endif showGuardar}}
            <button class="col-12 col-m-2" id="btnCancelar">Cancelar</button>
        </div>
    </form>
    <script>
        document.addEventListener("DOMContentLoaded", ()=>{
            document.querySelector("#btnCancelar").addEventListener("click", (e)=>{
                e.preventDefault();
                e.stopPropagation();
                window.location.assign("index.php?page=<Modulo>_<Modulo>List");
            });
        });
    </script>
</section>
