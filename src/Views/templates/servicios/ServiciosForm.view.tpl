<style>
    .form-servicios {
        padding: 25px;
    }

    .form-servicios input,
    .form-servicios textarea,
    .form-servicios select {
        border: 1px solid #B8C5D3;
        border-radius: 6px;
        padding: 10px;
    }

    .form-servicios textarea {
        min-height: 100px;
        resize: vertical;
    }

    .form-servicios .btn-guardar {
        background: linear-gradient(90deg, #FFD43B, #FFA500);
        color: #102949;
        border: none;
        border-radius: 6px;
        padding: 12px 20px;
        font-weight: bold;
        cursor: pointer;
    }

    .form-servicios .btn-cancelar {
        background-color: #102949;
        color: white;
        border: none;
        border-radius: 6px;
        padding: 12px 20px;
        cursor: pointer;
    }

    .form-servicios .error {
        color: #B91C1C;
    }
</style>

<section class="depth-1 py-4 px-4">
    <h2>{{modeDsc}}</h2>
</section>

<section class="depth-2 grid">

    <form class="form-servicios col-12 col-m-8 offset-m-2 col-l-6 offset-l-3"
        action="{{action}}" method="post">

        <input type="hidden"
            name="srvcod" value="{{srvcod}}" />

        <input type="hidden"
            name="xsftoken" value="{{xsftoken}}" />

        <div class="row my-3">
            <label class="col-12 col-m-5 col-l-4"
                for="srvnom">
                Nombre del servicio
            </label>

            <input {{readonly}}
                class="col-12 col-m-7 col-l-8"
                type="text"
                name="srvnom"
                id="srvnom"
                maxlength="80"
                value="{{srvnom}}"
                required />
        </div>

        <div class="row my-3">
            <label class="col-12 col-m-5 col-l-4"
                for="srvdsc">
                Descripcion
            </label>

            <textarea {{readonly}}
                class="col-12 col-m-7 col-l-8"
                name="srvdsc"
                id="srvdsc"
                maxlength="255">{{srvdsc}}</textarea>
        </div>

        <div class="row my-3">
            <label class="col-12 col-m-5 col-l-4"
                for="srvest">
                Estado
            </label>

            <select {{disabled}}
                class="col-12 col-m-7 col-l-8"
                name="srvest"
                id="srvest">

                <option value="ACT"
                    {{if ACT}}selected{{endif ACT}}>
                    Activo
                </option>

                <option value="INA"
                    {{if INA}}selected{{endif INA}}>
                    Inactivo
                </option>

            </select>
        </div>

        {{if hasError}}
        <div class="row my-3">
            <span class="error">{{error}}</span>
        </div>
        {{endif hasError}}

        <div class="row my-3 flex-end">

            {{if showGuardar}}
            <button class="btn-guardar"
                type="submit">
                {{btnTexto}}
            </button>
            &nbsp;
            {{endif showGuardar}}

            <button class="btn-cancelar"
                type="button"
                id="btnCancelar">
                Cancelar
            </button>

        </div>

    </form>

    <script>
        document.addEventListener("DOMContentLoaded", () => {
            document.querySelector("#btnCancelar")
                .addEventListener("click", () => {
                    window.location.assign(
                        "index.php?page=Servicios_ServiciosList"
                    );
                });
        });
    </script>

</section>