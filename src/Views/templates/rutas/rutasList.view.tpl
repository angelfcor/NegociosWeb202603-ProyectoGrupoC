<h1>Trabajar con Rutas</h1>
<p class="muted">{{rutasCount}} rutas registradas.</p>
<section class="grid">
  <div class="row">
    <form class="col-12 col-m-8" action="index.php" method="get">
      <div class="flex align-center">
        <div class="col-8 row">
          <input type="hidden" name="page" value="Rutas_RutasList">
          <label class="col-3" for="partialName">Origen o destino</label>
          <input class="col-9" type="text" name="partialName" id="partialName" value="{{partialName}}" />
          <label class="col-3" for="status">Estado</label>
          <select class="col-9" name="status" id="status">
            <option value="EMP" {{status_EMP}}>Todos</option>
            <option value="ACT" {{status_ACT}}>Activa</option>
            <option value="INA" {{status_INA}}>Inactiva</option>
          </select>
        </div>
        <div class="col-4 align-end">
          <button type="submit">Filtrar</button>
        </div>
      </div>
    </form>
  </div>
</section>
<section class="WWList">
  <table>
    <thead>
      <tr>
        <th>
          {{ifnot OrderByRutacod}}
          <a href="index.php?page=Rutas_RutasList&orderBy=rutacod&orderDescending=0">Código <i class="fas fa-sort"></i></a>
          {{endifnot OrderByRutacod}}
          {{if OrderRutacodDesc}}
          <a href="index.php?page=Rutas_RutasList&orderBy=clear&orderDescending=0">Código <i class="fas fa-sort-down"></i></a>
          {{endif OrderRutacodDesc}}
          {{if OrderRutacod}}
          <a href="index.php?page=Rutas_RutasList&orderBy=rutacod&orderDescending=1">Código <i class="fas fa-sort-up"></i></a>
          {{endif OrderRutacod}}
        </th>
        <th>
          {{ifnot OrderByRutaorigen}}
          <a href="index.php?page=Rutas_RutasList&orderBy=rutaorigen&orderDescending=0">Origen <i class="fas fa-sort"></i></a>
          {{endifnot OrderByRutaorigen}}
          {{if OrderRutaorigenDesc}}
          <a href="index.php?page=Rutas_RutasList&orderBy=clear&orderDescending=0">Origen <i class="fas fa-sort-down"></i></a>
          {{endif OrderRutaorigenDesc}}
          {{if OrderRutaorigen}}
          <a href="index.php?page=Rutas_RutasList&orderBy=rutaorigen&orderDescending=1">Origen <i class="fas fa-sort-up"></i></a>
          {{endif OrderRutaorigen}}
        </th>
        <th>
          {{ifnot OrderByRutadestino}}
          <a href="index.php?page=Rutas_RutasList&orderBy=rutadestino&orderDescending=0">Destino <i class="fas fa-sort"></i></a>
          {{endifnot OrderByRutadestino}}
          {{if OrderRutadestinoDesc}}
          <a href="index.php?page=Rutas_RutasList&orderBy=clear&orderDescending=0">Destino <i class="fas fa-sort-down"></i></a>
          {{endif OrderRutadestinoDesc}}
          {{if OrderRutadestino}}
          <a href="index.php?page=Rutas_RutasList&orderBy=rutadestino&orderDescending=1">Destino <i class="fas fa-sort-up"></i></a>
          {{endif OrderRutadestino}}
        </th>
        <th>Estado</th>
        <th>
          {{if create}}
          <a href="index.php?page=Rutas_RutasForm&mode=INS">Nuevo</a>
          {{endif create}}
        </th>
      </tr>
    </thead>
    <tbody>
      {{foreach rutas}}
      <tr>
        <td>{{rutacod}}</td>
        <td><a class="link" href="index.php?page=Rutas_RutasForm&mode=DSP&rutacod={{rutacod}}">{{rutaorigen}}</a></td>
        <td>{{rutadestino}}</td>
        <td class="center">{{rutaestDsc}}</td>
        <td class="center">
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
  {{pagination}}
</section>
