<style>
    .WWList .btn-accion {
        display: inline-block;
        padding: 8px 12px;
        margin: 3px;
        border-radius: 6px;
        text-decoration: none;
    }

    .WWList .btn-nuevo {
        background: linear-gradient(90deg, #FFD43B, #FFA500);
        color: #102949 !important;
        font-weight: bold;
    }

    .WWList .btn-ver {
        background-color: #102949;
        color: white !important;
    }

    .WWList .btn-editar {
        background-color: #2166B5;
        color: white !important;
    }

    .WWList .btn-eliminar {
        background-color: #FFA500;
        color: #102949 !important;
    }

    .WWList table thead th {
        background-color: #102949;
        color: white;
    }

    .WWList table tbody tr:nth-child(even) {
        background-color: #EAF1F8;
    }
</style>

<h1>Administrar Salidas</h1>

<p>{{productosCount}} salidas registradas.</p>

<section class="WWList">

    <table>
        <thead>
            <tr>
                <th>Código</th>
                <th>Salida</th>
                <th>Ruta</th>
                <th>Servicio</th>
                <th>Precio / Libra</th>
                <th>Disponibles</th>
                <th>Capacidad</th>
                <th>Estado</th>
                <th>
                    {{if create}}
                    <a class="btn-accion btn-nuevo"
                        href="index.php?page=Productos_ProductosForm&mode=INS">
                        + Nueva salida
                    </a>
                    {{endif create}}
                </th>
            </tr>
        </thead>

        <tbody>
            {{foreach productos}}
            <tr>
                <td>{{productId}}</td>

                <td>
                    {{productName}}
                    <br>
                    <small>{{productSalida}}</small>
                </td>

                <td>
                    {{rutaorigen}} → {{rutadestino}}
                </td>

                <td>{{srvnom}}</td>

                <td>L {{productPrice}}</td>

                <td>{{productStock}} lb</td>

                <td>{{productCapacidad}} lb</td>

                <td>{{productStatusDsc}}</td>

                <td class="center">

                    {{if ~read}}
                    <a class="btn-accion btn-ver"
                        href="index.php?page=Productos_ProductosForm&mode=DSP&productId={{productId}}">
                        Ver
                    </a>
                    {{endif ~read}}

                    {{if ~update}}
                    <a class="btn-accion btn-editar"
                        href="index.php?page=Productos_ProductosForm&mode=UPD&productId={{productId}}">
                        Editar
                    </a>
                    {{endif ~update}}

                    {{if ~delete}}
                    <a class="btn-accion btn-eliminar"
                        href="index.php?page=Productos_ProductosForm&mode=DEL&productId={{productId}}">
                        Eliminar
                    </a>
                    {{endif ~delete}}

                </td>
            </tr>
            {{endfor productos}}
        </tbody>
    </table>

</section>
