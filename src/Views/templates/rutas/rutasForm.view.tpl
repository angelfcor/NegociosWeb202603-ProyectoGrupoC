<h1>{{FormTitle}}</h1>

{{if errorGeneral}}
<p class="error">{{errorGeneral}}</p>
{{endif errorGeneral}}

<section class="grid">
  <form class="col-12 col-m-8" action="index.php?page=Rutas_RutasForm&mode={{mode}}&rutacod={{rutacod}}" method="post">
    <input type="hidden" name="csrf_token" value="{{csrf_token}}" />

    {{with ruta}}
    <div class="row my-2 align-center">
      <label class="col-12 col-m-3" for="rutacod">Código</label>
      <input class="col-12 col-m-9" type="text" id="rutacod" value="{{rutacod}}" readonly />
    </div>

    <div class="row my-2 align-center">
      <label class="col-12 col-m-3" for="rutaorigen">Origen</label>
      <input class="col-12 col-m-9" type="text" name="rutaorigen" id="rutaorigen" maxlength="80" value="{{rutaorigen}}" {{~readonly}} />
      {{if rutaorigen_error}}
      <div class="col-12 col-m-9 error">{{rutaorigen_error}}</div>
      {{endif rutaorigen_error}}
    </div>

    <div class="row my-2 align-center">
      <label class="col-12 col-m-3" for="rutadestino">Destino</label>
      <input class="col-12 col-m-9" type="text" name="rutadestino" id="rutadestino" maxlength="80" value="{{rutadestino}}" {{~readonly}} />
      {{if rutadestino_error}}
      <div class="col-12 col-m-9 error">{{rutadestino_error}}</div>
      {{endif rutadestino_error}}
    </div>

    <div class="row my-2 align-center">
      <label class="col-12 col-m-3" for="rutaest">Estado</label>
      <select class="col-12 col-m-9" name="rutaest" id="rutaest" {{if ~readonly}}disabled{{endif ~readonly}}>
        <option value="ACT" {{rutaest_act}}>Activa</option>
        <option value="INA" {{rutaest_ina}}>Inactiva</option>
      </select>
      {{if rutaest_error}}
      <div class="col-12 col-m-9 error">{{rutaest_error}}</div>
      {{endif rutaest_error}}
    </div>
    {{endwith ruta}}

    <div class="row my-4 align-center flex-end">
      {{if showCommitBtn}}
      <button class="primary col-12 col-m-3" type="submit">{{confirmText}}</button>
      {{endif showCommitBtn}}
      <a class="col-12 col-m-3" href="index.php?page=Rutas_RutasList">Regresar</a>
    </div>
  </form>
</section>
