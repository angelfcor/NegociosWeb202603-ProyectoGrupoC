<style>
    .WWList .btn-accion {
        display: inline-block;
        padding: 8px 14px;
        margin: 4px;
        border-radius: 6px;
        text-decoration: none;
        font-weight: normal;
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

    .WWList .btn-accion:hover {
        opacity: 0.8;
    }

    .WWList table thead th {
        background-color: #102949;
        color: white;
    }

    .WWList table tbody tr:nth-child(even) {
        background-color: #EAF1F8;
    }
</style>

<h1>Trabajar con Servicios</h1>

<p>{{serviciosCount}} servicios registrados.</p>

<section class="WWList">
    <table>
        <thead>
            <tr>
                <th>Codigo</th>
                <th>Nombre</th>
                <th>Descripcion</th>
                <th>Estado</th>
                <th>
                    {{if create}}
                    <a class="btn-accion btn-nuevo"
                        href="index.php?page=Servicios_ServiciosForm&mode=INS">
                        + Nuevo
                    </a>
                    {{endif create}}
                </th>
            </tr>
        </thead>

        <tbody>
            {{foreach servicios}}
            <tr>
                <td>{{srvcod}}</td>
                <td>{{srvnom}}</td>
                <td>{{srvdsc}}</td>
                <td class="center">{{srvestDsc}}</td>

                <td class="center">
                    {{if ~read}}
                    <a class="btn-accion btn-ver"
                        href="index.php?page=Servicios_ServiciosForm&mode=DSP&srvcod={{srvcod}}">
                        Ver
                    </a>
                    {{endif ~read}}

                    {{if ~update}}
                    <a class="btn-accion btn-editar"
                        href="index.php?page=Servicios_ServiciosForm&mode=UPD&srvcod={{srvcod}}">
                        Editar
                    </a>
                    {{endif ~update}}

                    {{if ~delete}}
                    <a class="btn-accion btn-eliminar"
                        href="index.php?page=Servicios_ServiciosForm&mode=DEL&srvcod={{srvcod}}">
                        Eliminar
                    </a>
                    {{endif ~delete}}
                </td>
            </tr>
            {{endfor servicios}}
        </tbody>
    </table>
</section>