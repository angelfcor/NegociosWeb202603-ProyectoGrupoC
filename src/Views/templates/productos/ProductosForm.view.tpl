
<style>
    .form-productos {
        padding: 25px;
        background: #fff;
        border-radius: 8px;
    }

    .form-productos h3 {
        color: #102949;
        font-size: 17px;
        margin: 20px 0 15px;
        padding-bottom: 8px;
        border-bottom: 1px solid #e2e8f0;
    }

    .form-productos .campos-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 18px;
    }

    .form-productos .campo {
        display: flex;
        flex-direction: column;
        gap: 7px;
        min-width: 0;
    }

    .form-productos .campo-completo {
        grid-column: 1 / -1;
    }

    .form-productos label {
        color: #263b53;
        font-weight: 600;
        font-size: 14px;
    }

    .form-productos input,
    .form-productos textarea,
    .form-productos select {
        width: 100%;
        box-sizing: border-box;
        border: 1px solid #cbd5e1;
        border-radius: 5px;
        padding: 10px;
        background: #fff;
        font-size: 14px;
    }

    .form-productos input:focus,
    .form-productos textarea:focus,
    .form-productos select:focus {
        outline: none;
        border-color: #102949;
        box-shadow: 0 0 0 2px rgba(16, 41, 73, .08);
    }

    .form-productos textarea {
        min-height: 85px;
        resize: vertical;
    }

    .form-productos .acciones {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        margin-top: 25px;
        padding-top: 18px;
        border-top: 1px solid #e2e8f0;
    }

    .form-productos .btn-guardar {
        background: #FFD43B;
        color: #102949;
        border: none;
        border-radius: 5px;
        padding: 10px 20px;
        font-weight: bold;
        cursor: pointer;
    }

    .form-productos .btn-cancelar {
        background: #102949;
        color: white;
        border: none;
        border-radius: 5px;
        padding: 10px 20px;
        cursor: pointer;
    }

    .form-productos .btn-guardar:hover {
        background: #f0c329;
    }

    .form-productos .btn-cancelar:hover {
        background: #1d416b;
    }

    .form-productos .error {
        color: #B91C1C;
        margin-top: 15px;
    }

    @media (max-width: 650px) {
        .form-productos .campos-grid {
            grid-template-columns: 1fr;
        }

        .form-productos .campo-completo {
            grid-column: auto;
        }

        .form-productos .acciones {
            flex-direction: column;
        }
    }
</style>

<section class="depth-1 py-4 px-4">
    <h2>{{modeDsc}}</h2>
</section>

<section class="depth-2 grid">

<form class="form-productos col-12 col-m-10 offset-m-1"
    action="{{action}}" method="post">

    <input type="hidden" name="productId" value="{{productId}}">
    <input type="hidden" name="xsftoken" value="{{xsftoken}}">

    <h3>Información de la salida</h3>

    <div class="campos-grid">

        <div class="campo campo-completo">
            <label>Nombre de salida</label>
            <input type="text" name="productName"
                maxlength="255" value="{{productName}}"
                {{readonly}} required>
        </div>

        <div class="campo campo-completo">
            <label>Descripción</label>
            <textarea name="productDescription"
                {{readonly}}>{{productDescription}}</textarea>
        </div>

        <div class="campo">
            <label>Precio por libra (L)</label>
            <input type="number" name="productPrice"
                min="0.01" step="0.01"
                value="{{productPrice}}" {{readonly}} required>
        </div>

        <div class="campo">
            <label>Imagen (ruta)</label>
            <input type="text" name="productImgUrl"
                value="{{productImgUrl}}" {{readonly}}>
        </div>

        <div class="campo">
            <label>Capacidad total (lb)</label>
            <input type="number" name="productCapacidad"
                min="1" value="{{productCapacidad}}"
                {{readonly}} required>
        </div>

        <div class="campo">
            <label>Libras disponibles</label>
            <input type="number" name="productStock"
                min="0" value="{{productStock}}"
                {{readonly}} required>
        </div>

        <div class="campo campo-completo">
            <label>Fecha y hora de salida</label>
            <input type="datetime-local" name="productSalida"
                value="{{productSalida}}" {{readonly}} required>
        </div>

    </div>

    <h3>Ruta y servicio</h3>

    <div class="campos-grid">

        <div class="campo">
            <label>Ruta</label>
            <select name="rutacod" {{disabled}} required>
                <option value="">Seleccione una ruta</option>
                {{foreach rutas}}
                <option value="{{rutacod}}"
                    {{if selected}}selected{{endif selected}}>
                    {{rutaorigen}} → {{rutadestino}}
                </option>
                {{endfor rutas}}
            </select>
        </div>

        <div class="campo">
            <label>Servicio</label>
            <select name="srvcod" {{disabled}} required>
                <option value="">Seleccione un servicio</option>
                {{foreach servicios}}
                <option value="{{srvcod}}"
                    {{if selected}}selected{{endif selected}}>
                    {{srvnom}}
                </option>
                {{endfor servicios}}
            </select>
        </div>

        <div class="campo">
            <label>Estado</label>
            <select name="productStatus" {{disabled}}>
                <option value="ACT" {{if ACT}}selected{{endif ACT}}>Activo</option>
                <option value="INA" {{if INA}}selected{{endif INA}}>Inactivo</option>
            </select>
        </div>

    </div>

    {{if hasError}}
    <div class="error">
        {{error}}
    </div>
    {{endif hasError}}

    <div class="acciones">
        {{if showGuardar}}
        <button class="btn-guardar" type="submit">
            {{btnTexto}}
        </button>
        {{endif showGuardar}}

        <button class="btn-cancelar" type="button"
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
                    "index.php?page=Productos_ProductosList"
                );
            });
    });
</script>

</section>
