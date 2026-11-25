<!--
  PLANTILLA BASE - VISTA DE LISTA (patron "Work With")
  Copie este archivo a  src/Views/templates/<modulo>/<modulo>List.view.tpl
  Reemplace <modulo>, <Modulo>, {{campoN}} y los nombres de los campos por los reales.

  El controlador debe enviar ademas:
    partialName, status, orderBy, orderDescending, pageNum, itemsPerPage,
    <registros>Count, pages, <registros>, pagination
    status_EMP / status_ACT / status_INA  -> "selected"
    OrderBy<Campo>, Order<Campo>, Order<Campo>Desc  -> true
    create, read, update, delete  -> permisos del usuario
-->
<h1>Trabajar con <Modulo></h1>
<section class="grid">
  <div class="row">
    <form class="col-12 col-m-8" action="index.php" method="get">
      <div class="flex align-center">
        <div class="col-8 row">
          <input type="hidden" name="page" value="<Modulo>_<Modulo>List">
          <label class="col-3" for="partialName">Buscar</label>
          <input class="col-9" type="text" name="partialName" id="partialName" value="{{partialName}}" />
          <label class="col-3" for="status">Estado</label>
          <select class="col-9" name="status" id="status">
            <option value="EMP" {{status_EMP}}>Todos</option>
            <option value="ACT" {{status_ACT}}>Activo</option>
            <option value="INA" {{status_INA}}>Inactivo</option>
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
          {{ifnot OrderBy<Campo>}}
          <a href="index.php?page=<Modulo>_<Modulo>List&orderBy=<campo>&orderDescending=0">Columna 1 <i class="fas fa-sort"></i></a>
          {{endifnot OrderBy<Campo>}}
          {{if Order<Campo>Desc}}
          <a href="index.php?page=<Modulo>_<Modulo>List&orderBy=clear&orderDescending=0">Columna 1 <i class="fas fa-sort-down"></i></a>
          {{endif Order<Campo>Desc}}
          {{if Order<Campo>}}
          <a href="index.php?page=<Modulo>_<Modulo>List&orderBy=<campo>&orderDescending=1">Columna 1 <i class="fas fa-sort-up"></i></a>
          {{endif Order<Campo>}}
        </th>
        <th>Columna 2</th>
        <th>Estado</th>
        <th>
          {{if create}}
          <a href="index.php?page=<Modulo>_<Modulo>Form&mode=INS">Nuevo</a>
          {{endif create}}
        </th>
      </tr>
    </thead>
    <tbody>
      {{foreach registros}}
      <tr>
        <td>{{codigo}}</td>
        <td><a class="link" href="index.php?page=<Modulo>_<Modulo>Form&mode=DSP&codigo={{codigo}}">{{campo1}}</a></td>
        <td>{{campo2}}</td>
        <td class="center">{{estadoDsc}}</td>
        <td class="center">
          {{if ~read}}
          <a href="index.php?page=<Modulo>_<Modulo>Form&mode=DSP&codigo={{codigo}}">Ver</a>
          {{endif ~read}}
          {{if ~update}}
          <a href="index.php?page=<Modulo>_<Modulo>Form&mode=UPD&codigo={{codigo}}">Editar</a>
          {{endif ~update}}
          {{if ~delete}}
          <a href="index.php?page=<Modulo>_<Modulo>Form&mode=DEL&codigo={{codigo}}">Eliminar</a>
          {{endif ~delete}}
        </td>
      </tr>
      {{endfor registros}}
    </tbody>
  </table>
  {{pagination}}
</section>
