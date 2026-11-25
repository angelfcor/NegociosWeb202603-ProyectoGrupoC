<!--
  PLANTILLA BASE - VISTA DE FORMULARIO (patron "Work With")
  Copie este archivo a  src/Views/templates/<modulo>/<modulo>Form.view.tpl
  Reemplace <modulo>, <Modulo>, {{campoN}} y los nombres de los campos por los reales.

  El controlador debe enviar:
    mode (INS|DSP|UPD|DEL), modeDsc, action, readonly, showGuardar, xsftoken,
    el valor de cada campo y los errores.

  Modos:
    INS -> alta        readonly=""     showGuardar=true
    DSP -> detalle     readonly="readonly"  showGuardar=false
    UPD -> edicion     readonly=""     showGuardar=true
    DEL -> baja        readonly="readonly"  showGuardar=false

  El token anti-CSRF va en un input oculto y el controlador lo valida ANTES
  de escribir en la base de datos. Cada modulo usa su propia semilla.
-->
<section class="depth-1 py-4 px-4">
    <h2>{{modeDsc}}</h2>
</section>
<section class="depth-2 grid">
    <form class="col-12 col-m-8 offset-m-2 col-l-6 offset-l-3"
        action="{{action}}" method="post">
        <input type="hidden" name="codigo" value="{{codigo}}" />
        <input type="hidden" name="modo" value="{{mode}}" />
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
