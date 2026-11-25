<section class="grid">
  <div class="col-12 flex flex-end align-center">
    <div class="col-8">
      <h2>Rutas</h2>
      <p class="muted">{{totalRutas}} rutas registradas.</p>
    </div>
    <div class="col-4 flex flex-end">
      {{if create}}
        <a class="btn" href="index.php?page=Rutas_RutasForm&mode=INS">Nueva Ruta</a>
      {{endif create}}
    </div>
  </div>
  <div class="col-12 WWList">
    {{if hayRutas}}
    <table>
      <thead>
        <tr>
          <th>Código</th>
          <th>Origen</th>
          <th>Destino</th>
          <th>Estado</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        {{foreach rutas}}
        <tr>
          <td>{{rutacod}}</td>
          <td>{{rutaorigen}}</td>
          <td>{{rutadestino}}</td>
          <td><span class="badge badge-{{rutaest}}">{{estadoTexto}}</span></td>
          <td>
            {{if ~read}}
              <a href="index.php?page=Rutas_RutasForm&mode=DSP&rutacod={{rutacod}}">Ver</a>
            {{endif ~read}}
            {{if ~update}}
              <a href="index.php?page=Rutas_RutasForm&mode=UPD&rutacod={{rutacod}}">Editar</a>
            {{endif ~update}}
            {{if ~delete}}
              <a href="index.php?page=Rutas_RutasForm&mode=DEL&rutacod={{rutacod}}">Eliminar</a>
            {{endif ~delete}}
          </td>
        </tr>
        {{endfor rutas}}
      </tbody>
    </table>
    {{endif hayRutas}}
    {{ifnot hayRutas}}
    <p>Aún no hay rutas registradas.</p>
    {{endifnot hayRutas}}
  </div>
  <div class="col-12">
    {{paginacion}}
  </div>
</section>
