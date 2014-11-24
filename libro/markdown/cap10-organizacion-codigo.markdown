# Organización del Código



## Introducción

Cuando se emprende la tarea de realizar aplicaciones complejas del lado del cliente, es necesario considerar la forma en que se organizará el código. Este capitulo está dedicado a analizar algunos patrones de organización de código para utilizar en una aplicación realizada con jQuery. Además se explorará el sistema de gestión de dependencias de RequireJS.



### Conceptos Clave

Antes de comenzar con los patrones de organización de código, es importante entender algunos conceptos clave:

-   el código debe estar divido en unidades funcionales — módulos, servicios, etc. Y se debe evitar la tentación de tener todo en un único bloque `$(document).ready()`. Este concepto se conoce como encapsulación;

-   no repetir código. Identificar piezas similares y utilizar técnicas de herencia;

-   a pesar de la naturaleza de jQuery, no todas las aplicaciones JavaScript trabajan (o tienen la necesidad de poseer una representación) en el DOM;

-   las unidades de funcionalidad deben tener una articulación flexible (en inglés [loosely coupled](http://en.wikipedia.org/wiki/Loose_coupling)) — es decir, una unidad de funcionalidad debe ser capaz de existir por si misma y la comunicación con otras unidades debe ser a través de un sistema de mensajes como los eventos personalizados o pub/sub. Por otro lado, siempre que sea posible, de debe mantener alejada la comunicación directa entre unidades funcionales.

El concepto de articulación flexible puede ser especialmente problemático para desarrolladores que hacen su primera incursión en aplicaciones complejas. Por lo tanto, si usted esta empezando a crear aplicaciones, solamente sea consciente de este concepto.



## Encapsulación

El primer paso para la organización del código es separar la aplicación en distintas piezas.

Muchas veces, este esfuerzo suele ser suficiente para mantener al código en orden.



### El Objeto Literal

Un objeto literal es tal vez la manera más simple de encapsular código relacionado. Este no ofrece ninguna privacidad para propiedades o métodos, pero es útil para eliminar funciones anónimas, centralizar opciones de configuración, y facilitar el camino para la reutilización y refactorización.


**Un objeto literal**

```javascript
var myFeature = {
    myProperty : 'hello',

    myMethod : function() {
        console.log(myFeature.myProperty);
    },

    init : function(settings) {
        myFeature.settings = settings;
    },

    readSettings : function() {
        console.log(myFeature.settings);
    }
};

myFeature.myProperty; // 'hello'
myFeature.myMethod(); // registra 'hello'
myFeature.init({ foo : 'bar' });
myFeature.readSettings(); // registra { foo : 'bar' }
```

El objeto posee una propiedad y varios métodos, los cuales son públicos (es decir, cualquier parte de la aplicación puede verlos).  ¿Cómo se puede aplicar este patrón con jQuery? Por ejemplo, en el siguiente código escrito en el estilo tradicional:

```javascript
// haciendo click en un item de la lista se carga cierto contenido,
// luego utilizando el ID de dicho item se ocultan
// los items aledaños
$(document).ready(function() {
  $('#myFeature li')
    .append('<div/>')
    .click(function() {
      var $this = $(this);
      var $div = $this.find('div');
      $div.load('foo.php?item=' +
        $this.attr('id'),
        function() {
          $div.show();
          $this.siblings()
            .find('div').hide();
        }
      );
    });
});
```

Si el ejemplo mostrado representa el 100% de la aplicación, es conveniente dejarlo como esta, ya que no amerita hacer una reestructuración. En cambio, si la pieza es parte de una aplicación más grande, estaría bien separar dicha funcionalidad de otras no relacionadas. Por ejemplo, es conveniente mover la URL a la cual se hace la petición fuera del código y pasarla al área de configuración. También romper la cadena de métodos para hacer luego más fácil la modificación.


**Utilizar un objeto literal para una funcionalidad jQuery**

```javascript
var myFeature = {
    init : function(settings) {
        myFeature.config = {
            $items : $('#myFeature li'),
            $container : $('<div class="container"></div>'),
            urlBase : '/foo.php?item='
        };

        // permite sobrescribir la configuración predeterminada
        $.extend(myFeature.config, settings);

        myFeature.setup();
    },

    setup : function() {
        myFeature.config.$items
            .each(myFeature.createContainer)
            .click(myFeature.showItem);
    },

    createContainer : function() {
        var $i = $(this),
            $c = myFeature.config.$container.clone()
                     .appendTo($i);

        $i.data('container', $c);
    },

    buildUrl : function() {
        return myFeature.config.urlBase +
               myFeature.$currentItem.attr('id');
    },

    showItem : function() {
        var myFeature.$currentItem = $(this);
        myFeature.getContent(myFeature.showContent);
    },

    getContent : function(callback) {
        var url = myFeature.buildUrl();
        myFeature.$currentItem
            .data('container').load(url, callback);
    },

    showContent : function() {
        myFeature.$currentItem
            .data('container').show();
        myFeature.hideContent();
    },

    hideContent : function() {
        myFeature.$currentItem.siblings()
            .each(function() {
                $(this).data('container').hide();
            });
    }
};

$(document).ready(myFeature.init);
```

La primera característica a notar es que el código es más largo que el original — como se dijo anteriormente, si este fuera el alcance de la aplicación, utilizar un objeto literal seria probablemente una exageración.

Con la nueva organización, las ventajas obtenidas son:

-   separación de cada funcionalidad en pequeños métodos. En un futuro, si se quiere cambiar la forma en que el contenido se muestra, será claro en donde habrá que hacerlo. En el código original, este paso es mucho más difícil de localizar;

-   se eliminaron los usos de funciones anónimas;

-   las opciones de configuración se movieron a una ubicación central;

-   se eliminaron las limitaciones que poseen las cadenas de métodos, haciendo que el código sea más fácil para refactorizar, mezclar y reorganizar.

Por sus características, la utilización de objetos literales permiten una clara mejora para tramos largos de código insertados en un bloque `$(document).ready()`. Sin embargo, no son más avanzados que tener varias declaraciones de funciones dentro de un bloque `$(document).ready()`.



### El Patrón Modular

El patrón modular supera algunas limitaciones del objeto literal, ofreciendo privacidad para variables y funciones, exponiendo a su vez (si se lo desea) una API pública.


**El patrón modular**

```javascript
var feature =(function() {

    // variables y funciones privadas
    var privateThing = 'secret',
        publicThing = 'not secret',

        changePrivateThing = function() {
            privateThing = 'super secret';
        },

        sayPrivateThing = function() {
            console.log(privateThing);
            changePrivateThing();
        };

    // API publica
    return {
        publicThing : publicThing,
        sayPrivateThing : sayPrivateThing
    }

})();

feature.publicThing; // registra 'not secret'

feature.sayPrivateThing();
// registra 'secret' y cambia el valor
// de privateThing
```

En el ejemplo, se autoejecuta una función anónima la cual devuelve un objeto. Dentro de la función, se definen algunas variables. Debido a que ellas son definidas dentro de la función, desde afuera no se tiene acceso a menos que se pongan dentro del objeto que se devuelve. Esto implica que ningún código fuera de la función tiene acceso a la variable `privateThing` o a la función `sayPrivateThing`. Sin embargo, `sayPrivateThing` posee acceso a `privateThing` y `changePrivateThing` debido a estar definidos en el mismo alcance.

El patrón es poderoso debido a que permite tener variables y funciones privadas, exponiendo una API limitada consistente en devolver propiedades y métodos de un objeto.

A continuación se muestra una revisión del ejemplo visto anteriormente, con las mismas características, pero exponiendo un único método público del modulo, `showItemByIndex()`.


**Utilizar el patrón modular para una funcionalidad jQuery**

```javascript
$(document).ready(function() {
    var feature = (function() {

        var $items = $('#myFeature li'),
            $container = $('<div class="container"></div>'),
            $currentItem,

            urlBase = '/foo.php?item=',

            createContainer = function() {
                var $i = $(this),
                    $c = $container.clone().appendTo($i);

                $i.data('container', $c);
            },

            buildUrl = function() {
                return urlBase + $currentItem.attr('id');
            },

            showItem = function() {
                var $currentItem = $(this);
                getContent(showContent);
            },

            showItemByIndex = function(idx) {
                $.proxy(showItem, $items.get(idx));
            },

            getContent = function(callback) {
                $currentItem.data('container').load(buildUrl(), callback);
            },

            showContent = function() {
                $currentItem.data('container').show();
                hideContent();
            },

            hideContent = function() {
                $currentItem.siblings()
                    .each(function() {
                        $(this).data('container').hide();
                });
            };

        $items
            .each(createContainer)
            .click(showItem);

        return { showItemByIndex : showItemByIndex };
    })();

    feature.showItemByIndex(0);
});
```



## Gestión de Dependencias


> **Nota**
>
> Esta sección esta basada en la excelente [ documentación de RequireJS](http://requirejs.org/docs/jquery.html) y es utilizada con el permiso de James Burke, autor de RequireJS.


Cuando un proyecto alcanza cierto tamaño, comienza a ser difícil el manejo de los módulos de una aplicación, ya que es necesario saber ordenarlos de forma correcta, y comenzar a combinarlos en un único archivo para lograr la menor cantidad de peticiones. También es posible que se quiera cargar código "al vuelo" luego de la carga de la página.

RequireJS es una herramienta de gestión de dependencias creada por James Burke, la cual ayuda a manejar los módulos, cargarlos en un orden correcto y combinarlos de forma fácil sin tener que realizar ningún cambio. A su vez, otorga una manera fácil de cargar código una vez cargada la página, permitiendo minimizar el tiempo de descarga.

RequireJS posee un sistema modular, que sin embargo, no es necesario seguirlo para obtener sus beneficios. El formato modular de RequireJS permite la escritura de código encapsulado, incorporación de internacionalización (i18n) a los paquetes (para permitir utilizarlos en diferentes lenguajes) e incluso la utilización de servicios JSONP como dependencias.



### Obtener RequireJS

La manera más fácil de utilizar RequireJS con jQuery es descargando [el paquete de jQuery con RequireJS](http://requirejs.org/docs/download.html) ya incorporado en él. Este paquete excluye porciones de código que duplican funciones de jQuery. También es útil descargar [un ejemplo de proyecto jQuery que utiliza RequireJS](http://requirejs.org/docs/release/0.11.0/jquery-require-sample.zip).



### Utilizar RequireJS con jQuery

Utilizar RequireJS es simple, tan solo es necesario incorporar en la página la versión de jQuery que posee RequireJS incorporado y a continuación solicitar los archivos de la aplicación. El siguiente ejemplo asume que tanto jQuery como los otros archivos están dentro de la carpeta `scripts/`.


**Utilizar RequireJS: Un ejemplo simple**

```javascript
<!DOCTYPE html>
<html>
    <head>
        <title>jQuery+RequireJS Sample Page</title>
        <script src="scripts/require-jquery.js"></script>
        <script>require(["app"]);</script>
    </head>
    <body>
        <h1>jQuery+RequireJS Sample Page</h1>
    </body>
</html>
```

La llamada a `require(["app"])` le dice a RequireJS que cargue el archivo `scripts/app.js`. RequireJS cargará cualquier dependencia pasada a `require()` sin la extensión `.js` desde el mismo directorio que en que se encuentra el archivo `require-jquery.js`, aunque también es posible especificar la ruta de la siguiente forma:

```javascript
<script>require(["scripts/app.js"]);</script>
```

El archivo `app.js` es otra llamada a `require.js` para cargar todos los archivos necesarios para la aplicación. En el siguiente ejemplo, `app.js` solicita dos extensiones `jquery.alpha.js` y `jquery.beta.js` (no son extensiones reales, solo ejemplos). Estas extensiones están en la misma carpeta que `require-jquery.js`:


**Un simple archivo JavaScript con dependencias**

```javascript
require(["jquery.alpha", "jquery.beta"], function() {
    //las extensiones jquery.alpha.js y jquery.beta.js han sido cargadas.
    $(function() {
        $('body').alpha().beta();
    });
});
```



### Crear Módulos Reusables con RequireJS

RequireJS hace que sea fácil definir módulos reusables a través de `require.def()`. Un modulo RequireJS puede tener dependencias que pueden ser utilizadas para definir un módulo, además de poder devolver un valor — un objeto, una función, u otra cosa — que puede ser incluso utilizado otros módulos.

Si el módulo no posee ninguna dependencia, tan solo se debe especificar el nombre como primer argumento de `require.def()`. El segundo argumento es un objeto literal que define las propiedades del módulo. Por ejemplo:

**Definición de un módulo RequireJS que no posee dependencias**

```javascript
require.def("my/simpleshirt",
    {
        color: "black",
        size: "unisize"
    }
);
```

El ejemplo debe ser guardado en el archivo `my/simpleshirt.js`.

Si el modulo posee dependencias, es posible especificarlas en el segundo argumento de `require.def()` a través de un vector) y luego pasar una función como tercer argumento. Esta función será llamada para definir el módulo una vez cargadas todos las dependencias. Dicha función recibe los valores devueltos por las dependencias como un argumento (en el mismo orden en que son requeridas en el vector) y luego la misma debe devolver un objeto que defina el módulo.


**Definición de un módulo RequireJS con dependencias**

```javascript
require.def("my/shirt",
    ["my/cart", "my/inventory"],
    function(cart, inventory) {
        //devuelve un objeto que define a "my/shirt"
        return {
            color: "blue",
            size: "large"
            addToCart: function() {
                inventory.decrement(this);
                cart.add(this);
            }
        }
    }
);
```

En este ejemplo, el modulo `my/shirt` es creado. Este depende de `my/cart` y `my/inventory`. En el disco, los archivos están estructurados de la siguiente forma:

```javascript
my/cart.js
my/inventory.js
my/shirt.js
```

La función que define `my/shirt` no es llamada hasta que `my/cart` y `my/inventory` hayan sido cargadas, y dicha función recibe como argumentos a los módulos como `cart` y `inventory`. El orden de los argumentos de la función debe coincidir con el orden en que las dependencias se requieren en el vector. El objeto devuelto define el módulo `my/shirt`. Definiendo los módulos de esta forma, `my/shirt` no existe como un objeto global, ya que múltiples módulos pueden existir en la página al mismo tiempo.

Los módulos no tienen que devolver un objeto; cualquier tipo de valor es permitido.


**Definición de un módulo RequireJS que devuelve una función**

```javascript
require.def("my/title",
    ["my/dependency1", "my/dependency2"],
    function(dep1, dep2) {
        // devuelve una función para definir "my/title".
        // Este devuelve o establece
        // el titulo de la ventana
        return function(title) {
            return title ? (window.title = title) : window.title;
        }
    }
);
```

Solo un módulo debe ser requerido por archivo JavaScript.



### Optimizar el Código con las Herramientas de RequireJS

Una vez incorporado RequireJS para el manejo de dependencias, la optimización del código es muy fácil. Descargue el paquete de RequireJS y colóquelo en cualquier lugar, preferentemente fuera del área de desarrollo web. Para los propósitos de este ejemplo, el paquete de RequireJS esta ubicado en una carpeta paralela al directorio `webapp` (la cual contiene la página HTML y todos los archivos JavaScript de la aplicación). La estructura de directorios es:

```javascript
requirejs/ (utilizado para ejecutar las herramientas)
webapp/app.html
webapp/scripts/app.js
webapp/scripts/require-jquery.js
webapp/scripts/jquery.alpha.js
webapp/scripts/jquery.beta.js
```

Luego, en la carpeta en donde se encuentran `require-jquery.js` y `app.js`, crear un archivo llamado `app.build.js` con el siguiente contenido:


**Archivo de configuración para las herramientas de optimización de RequireJS**

```javascript
{
    appDir: "../",
    baseUrl: "scripts/",
    dir: "../../webapp-build",
    //Comentar la siguiente línea si se desea
    //minificar el código por el compilador
    //en su modo "simple"
    optimize: "none",

    modules: [
        {
            name: "app"
        }
    ]
}
```

Para utilizar la herramienta, es necesario tener instalado Java 6. [Closure Compiler](http://code.google.com/closure/compiler/) es utilizado para la minificación del código (en caso que `optimize: "none"` esté comentado).

Para comenzar a procesar los archivos, abrir una ventana de comandos, dirigirse al directorio `webapp/scripts` y ejecutar:

```javascript
# para sistemas que no son windows
../../requirejs/build/build.sh app.build.js

# para sistemas windows
..\..\requirejs\build\build.bat app.build.js
```

Una vez ejecutado, el archivo `app.js` de la carpeta `webapp-build` contendrá todo el código de `app.js` más el de `jquery.alpha.js` y `jquery.beta.js`. Si se abre el archivo `app.html` (también en la carpeta `webapp-build`) podrá notar que ninguna petición se realiza para cargar `jquery.alpha.js` y `jquery.beta.js`.



## Ejercicios



### Crear un Módulo Portlet

Abra el archivo `/ejercicios/portlets.html` en el navegador. Realice el ejercicio utilizando el archivo `/ejercicios/js/portlets.js`. El ejercicio consiste en crear una función creadora de portlet que utilice el patrón modular, de tal manera que el siguiente código funcione:

```javascript
var myPortlet = Portlet({
    title : 'Curry',
    source : 'data/html/curry.html',
    initialState : 'open' // or 'closed'
});

myPortlet.$element.appendTo('body');
```

Cada portlet deberá ser un `div` con un título, un área de contenido, un botón para abrir/cerrar el portlet, un botón para removerlo y otro para actualizarlo. El portlet devuelto por la función deberá tener la siguiente API pública:

```javascript
myPortlet.open(); // fuerza a abrir
myPortlet.close(); // fuerza a cerrar
myPortlet.toggle(); // alterna entre los estados abierto y cerrado
myPortlet.refresh(); // actualiza el contenido
myPortlet.destroy(); // remueve el portlet de la página
myPortlet.setSource('data/html/onions.html'); // cambia el código
```



